
echo "linux env..."
export PATH=/usr/local/bin:$PATH

export MAKEFLAGS="-j $(grep -c ^processor /proc/cpuinfo)"
