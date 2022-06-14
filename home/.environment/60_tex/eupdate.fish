#!/usr/bin/env fish

if command --query tlmgr
    tlmgr update --self --all --reinstall-forcibly-removed
end

if command --query cjk-gs-integrate-macos
    if ! test -d /usr/local/texlive/texmf-local/fonts/opentype/Yu
        # 游フォントの設定
        mkdir -p /usr/local/texlive/texmf-local/fonts/opentype/Yu
        pushd /usr/local/texlive/texmf-local/fonts/opentype/Yu
        ln -s /System/Library/AssetsV2/com_apple_MobileAsset_Font7/*/AssetData/YuGothic-Medium.otf .
        ln -s /System/Library/AssetsV2/com_apple_MobileAsset_Font7/*/AssetData/YuGothic-Bold.otf .
        ln -s /System/Library/AssetsV2/com_apple_MobileAsset_Font7/*/AssetData/YuMincho.ttc .
        ln -s /System/Library/AssetsV2/com_apple_MobileAsset_Font7/*/AssetData/Kyokasho.ttc .
        popd
        cjk-gs-integrate-macos --cleanup --link-texmf
    end
end
