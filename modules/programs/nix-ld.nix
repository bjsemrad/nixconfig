{config, pkgs, ...}:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
        zlib                                                                                                                                                                      
        zstd                                                                                                                                                                      
        stdenv.cc.cc                                                                                                                                                              
        stdenv.cc.cc.lib                                                                                                                                                          
        udev                                                                                                                                                                      
        dbus                                                                                                                                                                      
        mesa                                                                                                                                                                      
        libglvnd                                                                                                                                                                  
        curl                                                                                                                                                                      
        openssl                                                                                                                                                                   
        attr                                                                                                                                                                      
        libssh                                                                                                                                                                    
        bzip2                                                                                                                                                                     
        libxml2                                                                                                                                                                   
        acl                                                                                                                                                                       
        libsodium
        util-linux
        xz
        systemd
    ];
  };
}
