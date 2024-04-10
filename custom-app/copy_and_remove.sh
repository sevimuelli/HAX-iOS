#!/bin/bash

mkdir -p tmp

# remove alternate icons
rm -rf ../Sources/App/Resources/Assets.xcassets/AlternateIcons

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
