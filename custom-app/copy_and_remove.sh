#!/bin/bash

# ignore changed files on git
./git_ignore_changes.sh

# apply all patches
cd ..
#git am --stat custom-app/patchfiles/*
git apply --check custom-app/patchfiles/*
git apply custom-app/patchfiles/AboutViewController.patch
git apply custom-app/patchfiles/App-catalyst.entitlements
git apply custom-app/patchfiles/App-ios.entitlements.patch
git apply custom-app/patchfiles/Extension-catalyst.entitlements.patch
git apply custom-app/patchfiles/Extension-ios.entitlements.patch
git apply custom-app/patchfiles/Extensions_Watch_Info_plist.patch
git apply custom-app/patchfiles/Podfile.patch
git apply custom-app/patchfiles/SettingsDetailViewController.patch
git apply custom-app/patchfiles/WatchApp_Info_plist.patch
git apply custom-app/patchfiles/Launcher_Info_plist.patch
git apply custom-app/patchfiles/MacBridge_Info_plist.patch
git apply custom-app/patchfiles/HomeAssistant_beta_xcconfig.patch
git apply custom-app/patchfiles/HAAPI.patch
git apply custom-app/patchfiles/NotificationRateLimitsAPI.patch
git apply custom-app/patchfiles/LaunchScreen_Storyboard.patch
cd -

# copy HomeAssistant.overrides.xcconfig
yes | cp -rf ../custom-app/HomeAssistant.overrides.xcconfig ../Configuration/HomeAssistant.overrides.xcconfig

# create tmp directory if it not exists
mkdir -p tmp

# remove alternate icons
rm -rf ../Sources/App/Resources/Assets.xcassets/AlternateIcons/*

# remove icons folder
rm -rf ../icons

# replace apple watch comlications icons
yes | cp -rf ../custom-app/icons/complication/*  ../Sources/App/Resources/gallery.ckcomplication/

# replace fastlane icons
yes | cp -rf ../custom-app/icons/base_logos/square_1024.png ../fastlane/metadata/app_icon.png
yes | cp -rf ../custom-app/icons/base_logos/square_1024.jpg ../fastlane/metadata/app_icon.jpg
yes | cp -rf ../custom-app/icons/base_logos/square_1024.jpg ../fastlane/metadata/watch_icon.jpg

# replace watch icons
# release
rm -rf ./tmp/*
cp -rf ./icons/watch_icons/* ./tmp
cd ./tmp/
rename 's/(.*)\.png/release-$1.png/' *.png
cd -
yes | cp -rf ./tmp/* ../WatchApp/Assets.xcassets/WatchIcon.appiconset/

# beta
rm -rf ./tmp/*
cp -rf ./icons/watch_icons/* ./tmp
cd ./tmp/
rename 's/(.*)\.png/beta-$1.png/' *.png
cd -
yes | cp -rf ./tmp/* ../WatchApp/Assets.xcassets/WatchIcon.beta.appiconset/

# debug
rm -rf ./tmp/*
cp -rf ./icons/watch_icons/* ./tmp
cd ./tmp/
rename 's/(.*)\.png/dev-$1.png/' *.png
cd -
yes | cp -rf ./tmp/* ../WatchApp/Assets.xcassets/WatchIcon.dev.appiconset/

yes | cp -rf "../custom-app/icons/watch_pdf/ha-logo-black (2).pdf" "../Sources/Extensions/Watch/Resources/Assets.xcassets/TemplateLogo.imageset/ha-logo-black (2).pdf"
yes | cp -rf ../custom-app/icons/watch_pdf/ha-logo-round.pdf ../Sources/Extensions/Watch/Resources/Assets.xcassets/RoundLogo.imageset/ha-logo-round.pdf


# replace app icons
yes | cp -rf ../custom-app/icons/base_logos/square_1024.jpg ../Sources/App/Resources/Assets.xcassets/AppIcon.appiconset/release-1024x1024.png
yes | cp -rf ../custom-app/icons/base_logos/square_1024.jpg ../Sources/App/Resources/Assets.xcassets/AppIcon.beta.appiconset/beta-1024x1024.png
yes | cp -rf ../custom-app/icons/base_logos/square_1024.jpg ../Sources/App/Resources/Assets.xcassets/AppIcon.dev.appiconset/dev-1024x1024.png

rm -rf ./tmp/*
cp -rf ./icons/base_logos/round* ./tmp
cd ./tmp/
rename 's/round_(.*)\.png/$1-mac.png/' *.png
cd -
yes | cp -rf ./tmp/* ../Sources/App/Resources/Assets.xcassets/AppIcon.appiconset/
yes | cp -rf ./tmp/* ../Sources/App/Resources/Assets.xcassets/AppIcon.beta.appiconset/
yes | cp -rf ./tmp/* ../Sources/App/Resources/Assets.xcassets/AppIcon.dev.appiconset/

# replace launch screen
yes | cp -rf ../custom-app/icons/launch_screen/* ../Sources/App/Resources/Assets.xcassets/LaunchScreen/launchScreen-logo.imageset/

# replace shared assets
yes | cp -rf ../custom-app/icons/shared_assets/home-assistant-logomark-color-on-light.pdf ../Sources/Shared/Assets/SharedAssets.xcassets/Logo.imageset/home-assistant-logomark-color-on-light.pdf
yes | cp -rf ../custom-app/icons/shared_assets/home-assistant-logomark-monochrome-on-light-small.pdf ../Sources/Shared/Assets/SharedAssets.xcassets/statusItemIcon.imageset/home-assistant-logomark-monochrome-on-light-small.pdf

# copy empty entitlements file so there are no errors
yes | cp -rf ../custom-app/custom-files/activate_special_entitlements.sh ../Configuration/Entitlements/activate_special_entitlements.sh

# replace Firebase settings
yes | cp -rf ../custom-app/custom-files/GoogleService-Info-Release.plist ../Sources/App/Resources/GoogleService-Info-Release.plist
yes | cp -rf ../custom-app/custom-files/GoogleService-Info-Beta.plist ../Sources/App/Resources/GoogleService-Info-Beta.plist
yes | cp -rf ../custom-app/custom-files/GoogleService-Info-Debug.plist ../Sources/App/Resources/GoogleService-Info-Debug.plist
