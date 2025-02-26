#!/bin/bash

# Neko
neko_download="$(curl -s https://api.github.com/repos/nosignals/neko/releases/latest | jq -r '.assets[] | select(.name | endswith("_23_05.ipk")) | .browser_download_url')"

# Nikki
nikki_file="luci-app-nikki"
nikki_download="https://github.com/nikkinikki-org/OpenWrt-nikki/releases/latest/download/nikki_aarch64_generic-openwrt-24.10.tar.gz"

# Openclash
openclash_api="https://api.github.com/repos/vernesong/OpenClash/releases"
openclash_file="luci-app-openclash"
openclash_download="$(curl -s ${openclash_api} | grep "browser_download_url" | grep -oE "https.*${openclash_file}.*.ipk" | head -n 1)"

# Passwall
passwall_file="luci-app-passwall"
passwall_download="https://github.com/xiaorouji/openwrt-passwall/releases/latest/download/luci-23.05_luci-app-passwall_25.2.12_all.ipk"
passwall_package_file="passwall_packages_ipk_aarch64_generic.zip"
passwall_package_download="https://github.com/xiaorouji/openwrt-passwall/releases/latest/download/passwall_packages_ipk_aarch64_generic.zip"

if [ "$1" == "neko" ]; then
    echo "Downloading Neko packages"
    wget ${neko_download} -nv -P packages
elif [ "$1" == "nikki" ]; then
    echo "Downloading Nikki packages"
    wget ${nikki_download} -nv -P packages
    tar -xf packages/nikki_aarch64_generic-openwrt-24.10.tar.gz --wildcards '*.ipk'
elif [ "$1" == "openclash" ]; then
    echo "Downloading Openclash packages"
    wget ${openclash_download} -nv -P packages
elif [ "$1" == "passwall" ]; then
    echo "Downloading Passwall packages"
    wget "${passwall_download}" -nv -P packages
    wget "${passwall_package_download}" -nv -P packages
    unzip -qq "packages/${passwall_package_file}" -d packages
elif [ "$1" == "neko-nikki-openclash-passwall" ]; then
    echo "Downloading Neko packages"
    wget ${neko_download} -nv -P packages
    echo "Downloading Nikki packages"
    wget ${nikki_download} -nv -P packages
    tar -xf packages/nikki_aarch64_generic-openwrt-24.10.tar.gz --wildcards '*.ipk'
    echo "Downloading Openclash packages"
    wget ${openclash_download} -nv -P packages
    echo "Downloading Passwall packages"
    wget "${passwall_download}" -nv -P packages
    wget "${passwall_package_download}" -nv -P packages
    unzip -qq "packages/${passwall_package_file}" -d packages
fi
if [ "$?" -ne 0 ]; then
    echo "Error: Download or extraction failed."
    exit 1
else
    echo "Download complete."
fi
