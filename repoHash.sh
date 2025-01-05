#!/bin/bash

nix-shell -p nix-prefetch-git jq --run "nix hash convert sha256:\$(nix-prefetch-git --url https://github.com/$1 --quiet | jq -r '.sha256')"
