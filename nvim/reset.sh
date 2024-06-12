#!/bin/bash

echo "removing nvim configs..."
rm -rvf ~/.config/nvim
rm -rvf ~/.local/share/nvim
rm -rvf ~/.local/state/nvim
rm -rvf ~/.cache/nvim
echo "nvim configuration removed"
