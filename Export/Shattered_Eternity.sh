#!/bin/sh
echo -ne '\033c\033]0;Shattered_Eternity\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Shattered_Eternity.x86_64" "$@"
