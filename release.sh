#!/bin/bash

# Current Version: 1.0.5

## How to get and use?
# git clone "https://github.com/hezhijie0327/AdGuardHomeSCBuilder.git" && bash ./AdGuardHomeSCBuilder/release.sh

## Function
# Get Data
function GetData() {
    rm -rf ./Temp && mkdir ./Temp && cd ./Temp
    git clone -b master --depth=1 "https://github.com/AdguardTeam/AdGuardHome.git"
    git clone -b source --depth=1 "https://github.com/hezhijie0327/AdGuardHomeSCBuilder.git"
}
# Generate Static Info
function GenerateStaticInfo() {
    AGHSCB_SHA=$(cd ./AdGuardHomeSCBuilder && git rev-parse --short HEAD | rev | cut -c 1-4 | rev)
    AGH_SHA=$(cd ./AdGuardHome && git rev-parse --short HEAD | cut -c 1-4)
    AGH_VERSION=$(wget -qO- "https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest" | grep "tag\_name" | tr -cd ".[:digit:]\nv")
    CPU_CORE_NUM=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)
    ZHIJIE_CHANNEL="development"
    ZHIJIE_VERSION="${AGH_VERSION}-ZHIJIE-${AGH_SHA}${AGHSCB_SHA}"
}
# Merge Data
function MergeData() {
    cp -r ./AdGuardHomeSCBuilder/zh-cn.json ./AdGuardHome/client/src/__locales/zh-cn.json
}
# Modify Code
function ModifyCode() {
    cat ./AdGuardHome/client/src/components/Settings/Dns/Upstream/Examples.js | sed "s/94\.140\.14\.140/\[223\.5\.5\.5\]\:53/g;s/\[\/example\.local\/\]\[223\.5\.5\.5\]\:53/\[\/example\.local\/\]https\:\/\/dns\.alidns\.com\:443\/dns\-query/g;s/comment<\/code>/在此处添加注释<\/code>/g;s/https\:\/\/dns\-unfiltered\.adguard\.com/https\:\/\/dns\.alidns\.com\:443/g;s/quic\:\/\/dns\-unfiltered\.adguard\.com\:784/quic\:\/\/dns\.alidns\.com\:784/g;s/tcp\:\/\/\[223\.5\.5\.5\]\:53/tcp\:\/\/dns\.alidns\.com\:53/g;s/tls\:\/\/dns\-unfiltered\.adguard\.com/tls\:\/\/dns\.alidns\.com\:853/g" > ./AdGuardHome/client/src/components/Settings/Dns/Upstream/Examples.js.tmp && mv ./AdGuardHome/client/src/components/Settings/Dns/Upstream/Examples.js.tmp ./AdGuardHome/client/src/components/Settings/Dns/Upstream/Examples.js
    cat ./AdGuardHome/client/src/components/ui/Checkbox.js | sed "s/checkbox\_\_label\-text/checkbox\_\_label\-text\ checkbox\_\_label\-text\-\-long/g" > ./AdGuardHome/client/src/components/ui/Checkbox.js.tmp && mv ./AdGuardHome/client/src/components/ui/Checkbox.js.tmp ./AdGuardHome/client/src/components/ui/Checkbox.js
    cat ./AdGuardHome/client/src/components/ui/Footer.js | sed "s/AdGuard/AdGuard\｜治杰\ Online/g" > ./AdGuardHome/client/src/components/ui/Footer.js.tmp && mv ./AdGuardHome/client/src/components/ui/Footer.js.tmp ./AdGuardHome/client/src/components/ui/Footer.js
    cat ./AdGuardHome/internal/updater/updater.go | sed "s/\"adguardhome\"\,\ conf\.Channel\,\ \"version\.json\"/\"AdGuardHomeSCBuilder\"\,\ \"main\"\,\ conf\.Channel\,\ \"version\.json\"/g;s/static\.adguard\.com/source\.zhijie\.online/g" > ./AdGuardHome/internal/updater/updater.go.tmp && mv ./AdGuardHome/internal/updater/updater.go.tmp ./AdGuardHome/internal/updater/updater.go
    cat ./AdGuardHome/scripts/make/build-release.sh | sed "s/https\:\/\/github\.com\/AdguardTeam\/AdGuardHome\/releases/https\:\/\/github\.com\/AdguardTeam\/AdGuardHome\/commits\/master/g;s/https\:\/\/static\.adguard.com\/adguardhome/https\:\/\/source\.zhijie\.online\/AdGuardHomeSCBuilder\/main/g" > ./AdGuardHome/scripts/make/build-release.sh.tmp && mv ./AdGuardHome/scripts/make/build-release.sh.tmp ./AdGuardHome/scripts/make/build-release.sh
}
# Modify Setting
function ModifySetting() {
    cat ./AdGuardHome/internal/dnsforward/dnsforward.go | sed "s/\"9\.9\.9\.10\"\,\ \"149\.112\.112\.10\"\,\ \"2620\:fe\:\:10\"\,\ \"2620\:fe\:\:fe\:10\"/\"\[223\.5\.5\.5\]\:53\"\,\ \"\[223\.6\.6\.6\]\:53\"\,\ \"\[2400\:3200\:\:1\]\:53\"\,\ \"\[2400\:3200\:baba\:\:1\]\:53\"/g;s/\"version\.bind\"\,\ \"id\.server\"\,\ \"hostname\.bind\"/\"\|hostname\.bind\^\"\,\ \"\|id\.server\^\"\,\ \"\|version\.bind\^\"\,\ \"\|version\.server\^\"/g;s/https\:\/\/dns10\.quad9\.net/https\:\/\/dns\.alidns\.com\:443/g" > ./AdGuardHome/internal/dnsforward/dnsforward.go.tmp && mv ./AdGuardHome/internal/dnsforward/dnsforward.go.tmp ./AdGuardHome/internal/dnsforward/dnsforward.go
    cat ./AdGuardHome/internal/home/config.go | sed "s/BlockedResponseTTL\:\ 10/BlockedResponseTTL\:\ 3600/g;s/BlockingMode\:\ \ \ \ \ \ \ \"default\"/BlockingMode\:\ \ \ \ \ \ \ \"refused\"/g;s/DNS\.CacheSize\ \=\ 4\ \*\ 1024\ \*\ 1024/DNS\.CacheSize\ \=\ 64\ \*\ 1024\ \*\ 1024/g;s/DNS\.DnsfilterConf\.CacheTime\ \=\ 30/DNS\.DnsfilterConf\.CacheTime\ \=\ 3600/g;s/DNS\.DnsfilterConf\.ParentalCacheSize\ \=\ 1\ \*\ 1024\ \*\ 1024/DNS\.DnsfilterConf\.ParentalCacheSize\ \=\ 64\ \*\ 1024\ \*\ 1024/g;s/DNS\.DnsfilterConf\.SafeBrowsingCacheSize\ \=\ 1\ \*\ 1024\ \*\ 1024/DNS\.DnsfilterConf\.SafeBrowsingCacheSize\ \=\ 64\ \*\ 1024\ \*\ 1024/g;s/DNS\.DnsfilterConf\.SafeSearchCacheSize\ \=\ 1\ \*\ 1024\ \*\ 1024/DNS\.DnsfilterConf\.SafeSearchCacheSize\ \=\ 64\ \*\ 1024\ \*\ 1024/g;s/DNS\.QueryLogInterval\ \=\ 90/DNS\.QueryLogInterval\ \=\ 7/g;s/DNS\.QueryLogMemSize\ \=\ 1000/DNS\.QueryLogMemSize\ \=\ 500/g;s/FiltersUpdateIntervalHours\:\ 24/FiltersUpdateIntervalHours\:\ 1/g;s/DHCP\.Conf4\.LeaseDuration\ \=\ 86400/DHCP\.Conf4\.LeaseDuration\ \=\ 3600/g;s/DHCP\.Conf6\.LeaseDuration\ \=\ 86400/DHCP\.Conf6\.LeaseDuration\ \=\ 3600/g;s/LogCompress\:\ \ \ false/LogCompress\:\ \ \ true/g;s/LogLocalTime\:\ \ false/LogLocalTime\:\ \ true/g;s/LogMaxAge\:\ \ \ \ \ 3/LogMaxAge\:\ \ \ \ \ 7/g;s/LogMaxBackups\:\ 0/LogMaxBackups\:\ 3/g;s/LogMaxSize\:\ \ \ \ 100/LogMaxSize\:\ \ \ \ 64/g;s/MaxGoroutines\:\ 300/MaxGoroutines\:\ 500/g;s/Ratelimit\:\ \ \ \ \ \ \ \ \ \ 20/Ratelimit\:\ \ \ \ \ \ \ \ \ \ 500/g;s/StatsInterval\:\ 1/StatsInterval\:\ 1/g;s/WebSessionTTLHours\ \=\ 30\ \*\ 24/WebSessionTTLHours\ \=\ 1/g" > ./AdGuardHome/internal/home/config.go.tmp && mv ./AdGuardHome/internal/home/config.go.tmp ./AdGuardHome/internal/home/config.go
    echo "$(cat ./AdGuardHome/internal/home/filter.go | head -n $(cat -n ./AdGuardHome/internal/home/filter.go | grep "return \[\]filter{" | awk '{print $1}') | tail -n +1)" > ./AdGuardHome/internal/home/filter.go.tmp && echo '        {Filter: dnsfilter.Filter{ID: 1001}, Enabled: true, URL: "https://source.zhijie.online/AdFilter/main/adfilter_adguardhome.txt", Name: "治杰的广告过滤器"},' >> ./AdGuardHome/internal/home/filter.go.tmp && echo "$(cat ./AdGuardHome/internal/home/filter.go | head -n $(sed -n '$=' ./AdGuardHome/internal/home/filter.go) | tail -n +$((($(cat -n ./AdGuardHome/internal/home/filter.go | grep "return \[\]filter{" | awk '{print $1}') + 4))))" >> ./AdGuardHome/internal/home/filter.go.tmp && mv ./AdGuardHome/internal/home/filter.go.tmp ./AdGuardHome/internal/home/filter.go
}
# Build Code
function BuildCode() {
    cd ./AdGuardHome && make -j $(( ${CPU_CORE_NUM} * 2 )) ARCH="amd64 arm64" CHANNEL="${ZHIJIE_CHANNEL}" DIST_DIR="dist" GO="go" GPG_KEY="" GPG_KEY_PASSPHRASE="" OS="darwin freebsd linux windows" SIGN="0" SNAP="0" VERBOSE="3" VERSION="${ZHIJIE_VERSION}" build-release && cd ..
}
# Publish Release
function PublishRelease() {
    cd .. && cat ./Temp/AdGuardHome/dist/version.json | grep -v "386\|mips\|mips64\|mips64le\|mipsle\|softfloat" | jq -Sr "." > ./Temp/version.json && cat ./Temp/version.json
    if [ -d "./development" ] && [ -f "./development/version.json" ] && [ "$(diff ./Temp/version.json ./development/version.json)" == "" ]; then
        rm -rf ./Temp && exit 0
    else
        rm -rf ./development && mkdir ./development && mv ./Temp/AdGuardHome/dist/*.tar.gz ./development && mv ./Temp/AdGuardHome/dist/*.zip ./development && mv ./Temp/version.json ./development && rm -rf ./Temp && exit 0
    fi
}

## Process
# Call GetData
GetData
# Call GenerateStaticInfo
GenerateStaticInfo
# Call MergeData
MergeData
# Call ModifyCode
ModifyCode
# Call ModifySetting
ModifySetting
# Call BuildCode
BuildCode
# Call PublishRelease
PublishRelease
