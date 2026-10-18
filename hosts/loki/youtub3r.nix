# youtub3r.nix
# youtub3r (maddox/youtub3r): applies titles, air dates and thumbnails to the
# Pinchflat downloads in Channels DVR (on baldr), from the .info.json files
# Pinchflat writes beside each video. It touches Video Groups labelled `youtube`
# or with the genre `YouTube`, plus (patched in below) every video group imported
# from the /shares/YouTube Video Source.
#
# Upstream ships a Docker image that loops scan.rb; loki has no Docker, so the
# same script runs from a systemd timer instead. scan.rb reads the videos from
# the hardcoded /youtube_videos, which is bound read-only onto Pinchflat's
# download share (the root of the Channels Video Source).
#
# Pinchflat media profile must have `Download Metadata` on and an output path
# template of /{{ source_custom_name }}/{{ upload_yyyy_mm_dd }}-{{ title }}.{{ ext }}

{
  config,
  pkgs,
  inputs,
  ...
}:
let
  channelsServer = "10.0.10.6:8089"; # baldr
  # Channels' Video Source for the Pinchflat share (baldr's channelsdvr.nix).
  channelsImportPath = "/shares/YouTube";

  # Upstream only processes groups labelled `youtube` / genre `YouTube`. Also take
  # any video group imported from the YouTube Video Source, so new Pinchflat
  # channels need no tagging. Channels reports that per file as ImportPath.
  scan = pkgs.runCommand "youtub3r-scan.rb" { } ''
    cp ${inputs.youtub3r}/scan.rb $out
    substituteInPlace $out --replace-fail \
      "youtube_groups = groups.select { |g| (g['Labels'] && g['Labels'].include?('youtube')) || (g['Genres'] && g['Genres'].include?('YouTube')) }" \
      "youtube_groups = groups.select { |g| (g['Labels'] && g['Labels'].include?('youtube')) || (g['Genres'] && g['Genres'].include?('YouTube')) || (g['ID'].to_s.start_with?('videos-') && ((HTTParty.get(\"#{SERVER_URL}/dvr/groups/#{g['ID']}/files\").parsed_response || []).first || {})['ImportPath'] == ENV['IMPORT_PATH']) }"
  '';

  # Group art and sort order, which youtub3r leaves alone. For each YouTube group
  # without its own art, use the channel's YouTube avatar (from the source
  # metadata Pinchflat saves locally, matched to the group by Pinchflat's folder
  # name); for each group without a sort, sort by original air date (oldest
  # first). Anything already set in Channels is kept.
  #
  # DRY_RUN=1 only logs; ONLY_GROUP=<group name> limits it to one group.
  art = pkgs.writeText "youtub3r-art.rb" ''
    require 'httparty'
    require 'json'
    require 'zlib'
    require 'open3'

    SERVER_URL = "http://#{ENV['SERVER_HOST']}"
    IMPORT_PATH = ENV['IMPORT_PATH']
    DRY_RUN = ENV['DRY_RUN'] == '1'
    ONLY_GROUP = ENV['ONLY_GROUP'].to_s
    DB = ENV['PINCHFLAT_DB']
    METADATA_DIR = ENV['PINCHFLAT_METADATA_DIR']

    def normalize(name)
      name.to_s.downcase.gsub(/[^a-z0-9]/, "")
    end

    # Pinchflat names each folder after the source's custom name.
    out, status = Open3.capture2(ENV['SQLITE3'], '-readonly', '-json', DB,
                                 'SELECT id, custom_name FROM sources')
    abort "Could not read Pinchflat sources from #{DB}" unless status.success?
    sources = out.strip.empty? ? [] : JSON.parse(out)

    def avatar_url(source_id)
      path = File.join(METADATA_DIR, 'sources', source_id.to_s, 'metadata.json.gz')
      return nil unless File.exist?(path)
      thumbs = JSON.parse(Zlib::GzipReader.open(path, &:read))['thumbnails'] || []
      avatar = thumbs.find { |t| t['id'] == 'avatar_uncropped' }
      avatar ||= thumbs.select { |t| t['width'] && t['height'] }.max_by { |t| t['width'] * t['height'] }
      avatar && avatar['url']
    end

    def update(group, body)
      if DRY_RUN
        puts "[dry run] would PUT /dvr/groups/#{group['ID']} #{body.to_json}"
        return
      end
      res = HTTParty.put("#{SERVER_URL}/dvr/groups/#{group['ID']}", body: body.to_json)
      puts "#{res.code} - #{group['Name']}: #{body.keys.join(', ')}"
    end

    groups = HTTParty.get("#{SERVER_URL}/dvr/groups").parsed_response || []
    groups.each do |group|
      next unless group['ID'].to_s.start_with?('videos-')
      next unless ONLY_GROUP.empty? || group['Name'] == ONLY_GROUP

      files = HTTParty.get("#{SERVER_URL}/dvr/groups/#{group['ID']}/files").parsed_response || []
      next unless (files.first || {})['ImportPath'] == IMPORT_PATH

      changes = {}

      if group['Image'].to_s.empty?
        source = sources.find { |s| normalize(s['custom_name']) == normalize(group['Name']) }
        url = source && avatar_url(source['id'])
        if url
          changes['Image'] = url
        else
          puts "No Pinchflat art found for #{group['Name']}, skipping art."
        end
      end

      changes['FileSort'] = 'originalAirDate' if group['FileSort'].to_s.empty?

      update(group, changes) unless changes.empty?
    end
  '';

  # httparty isn't in nixpkgs; scan.rb only uses get/put/post and
  # .parsed_response/.code, so stand in for it with net/http.
  httpartyShim = pkgs.writeTextDir "httparty.rb" ''
    require 'net/http'
    require 'json'

    module HTTParty
      class Response
        def initialize(res)
          @res = res
        end

        def code
          @res.code.to_i
        end

        def parsed_response
          JSON.parse(@res.body)
        rescue JSON::ParserError
          @res.body
        end
      end

      # Follows redirects like httparty: Channels redirects /dvr/groups/ to /dvr/groups.
      def self.request(klass, url, body, redirects = 5)
        uri = URI(url)
        req = klass.new(uri)
        if body
          req['Content-Type'] = 'application/json'
          req.body = body
        end
        res = Net::HTTP.start(uri.host, uri.port) { |http| http.request(req) }
        if res.is_a?(Net::HTTPRedirection) && redirects > 0
          return request(klass, URI.join(url, res['location']).to_s, body, redirects - 1)
        end
        Response.new(res)
      end

      def self.get(url, opts = {})
        request(Net::HTTP::Get, url, opts[:body])
      end

      def self.put(url, opts = {})
        request(Net::HTTP::Put, url, opts[:body])
      end

      def self.post(url, opts = {})
        request(Net::HTTP::Post, url, opts[:body])
      end
    end
  '';
in
{
  systemd.services.youtub3r = {
    description = "Apply Pinchflat metadata to Channels DVR";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    unitConfig.RequiresMountsFor = [ config.services.pinchflat.mediaDir ];

    environment = {
      SERVER_HOST = channelsServer;
      IMPORT_PATH = channelsImportPath;
      PINCHFLAT_DB = "/var/lib/pinchflat/db/pinchflat.db";
      PINCHFLAT_METADATA_DIR = "/var/lib/pinchflat/metadata";
      SQLITE3 = "${pkgs.sqlite}/bin/sqlite3";
      RUBYLIB = "${httpartyShim}";
    };

    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.ruby}/bin/ruby ${scan}"
        "${pkgs.ruby}/bin/ruby ${art}"
      ];
      # Reading Pinchflat's SQLite db (WAL mode) needs its -shm file writable.
      ReadWritePaths = [ "/var/lib/pinchflat/db" ];
      # Pinchflat's user owns the downloads; only read access is needed.
      User = config.services.pinchflat.user;
      Group = config.services.pinchflat.group;
      BindReadOnlyPaths = [ "${config.services.pinchflat.mediaDir}:/youtube_videos" ];
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };

  # Upstream's container rescans every 60 seconds.
  systemd.timers.youtub3r = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitInactiveSec = "60s";
    };
  };
}
