#!/bin/bash

# Neko
neko_download="$(curl -s https://api.github.com/repos/nosignals/neko/releases/latest | jq -r '.assets[] | select(.name | endswith("_23_05.ipk")) | .browser_download_url')"

# Nikki
nikki_api="https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/install.sh"
nikki_file="luci-app-nikki"
nikki_file_download="https://github.com/nikkinikki-org/OpenWrt-nikki/releases/latest/download/nikki_aarch64_generic-openwrt-24.10.tar.gz"

# Openclash
openclash_api="https://api.github.com/repos/vernesong/OpenClash/releases"
openclash_file="luci-app-openclash"
openclash_download="$(curl -s ${openclash_api} | grep "browser_download_url" | grep -oE "https.*${openclash_file}.*.ipk" | head -n 1)"

# Passwall
passwall_api="https://api.github.com/repos/xiaorouji/openwrt-passwall/releases"
passwall_file="luci-app-passwall"
passwall_download="$(curl -s ${openclash_api} | grep "browser_download_url" | grep -oE "https.*${passwall_file}.*.ipk" | head -n 1)"

if [ "$1" == "neko" ]; then
    echo "Downloading Neko packages"
    wget ${neko_download} -nv -P packages
elif [ "$1" == "nikki" ]; then
    echo "Downloading Nikki packages"
    wget ${nikki_file_download} -nv -P packages
    tar -xf packages/nikki_aarch64_generic-openwrt-24.10.tar.gz --wildcards '*.ipk'
elif [ "$1" == "openclash" ]; then
    echo "Downloading Openclash packages"
    wget ${openclash_download} -nv -P packages
elif [ "$1" == "passwall" ]; then
    echo "Downloading Passwall packages"
    wget "${passwall_download}" -nv -P packages
elif [ "$1" == "neko-nikki-openclash-passwall" ]; then
    echo "Downloading Neko packages"
    wget ${neko_download} -nv -P packages
    echo "Downloading Nikki packages"
    wget ${nikki_file_download} -nv -P packages
    tar -xf packages/nikki_aarch64_generic-openwrt-24.10.tar.gz --wildcards '*.ipk'
    echo "Downloading Openclash packages"
    wget ${openclash_download} -nv -P packages
    echo "Downloading Passwall packages"
    wget "${passwall_download}" -nv -P packages 
fi
if [ "$?" -ne 0 ]; then
    echo "Error: Download or extraction failed."
    exit 1
else
    echo "Download complete."
fi
