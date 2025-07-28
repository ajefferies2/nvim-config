#!/usr/bin/env bash
set -euo pipefail

default_packer_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/packer/"
default_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/"

read -rp "Enter packer install directory [${default_packer_dir}]: " input
packer_dir="${input:-$default_packer_dir}"
read -rp "Enter Neovim config directory [${default_config_dir}]: " input
config_dir="${input:-$default_config_dir}"

echo "Using packer directory: $packer_dir"
echo "Using config directory: $config_dir"

if [ ! -d "$packer_dir" ]; then
  echo "Installing packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_dir"
else
  echo "packer.nvim is already present."
fi

if [ -d "$config_dir" ] && [ "$(ls -A "$config_dir")" ]; then
  read -rp "Directory $config_dir contains existing files. Delete and continue? [y/N] " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Removing existing files in $config_dir..."
    rm -rf "${config_dir:?}/"*
  else
    echo "Aborted. Existing configuration left intact."
    exit 1
  fi
fi

echo "Creating config directory at $config_dir"
mkdir -p "$config_dir"

script_name="$(basename "$0")"
echo "Copying configuration files..."
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude='.git' --exclude="$script_name" ./ "$config_dir"
else
  echo "rsync not found, falling back to cp..."
  for item in .* *; do
    [ "$item" = "." ] && continue
    [ "$item" = ".." ] && continue
    [ "$item" = ".git" ] && continue
    [ "$item" = "$script_name" ] && continue
    cp -a "$item" "$config_dir"
  done
fi

echo "Neovim setup is ready."

