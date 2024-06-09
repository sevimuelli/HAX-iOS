#!/bin/bash

# ignore changed files on git
# this is only for coninience and has no functional effect
cd ..
echo "Ignoring changed git files"

git update-index --assume-unchanged WatchApp/Assets.xcassets/WatchIcon.dev.appiconset/*
git update-index --assume-unchanged WatchApp/Assets.xcassets/WatchIcon.beta.appiconset/*
git update-index --assume-unchanged WatchApp/Assets.xcassets/WatchIcon.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/gallery.ckcomplication/*
git update-index --assume-unchanged icons/*.png
git update-index --assume-unchanged icons/Alternates/*
git update-index --assume-unchanged icons/LaunchScreen\ assets/*
git update-index --assume-unchanged icons/OldIcons/*
git update-index --assume-unchanged icons/PSDs/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/Contents.json
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/beta.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/bi_pride.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/black.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/blue.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/caribbean-green.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/classic.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/cornflower-blue.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/crimson.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/dev.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/electric-violet.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/fire-orange.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/green.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/non-binary.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/old-beta.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/old-dev.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/old-release.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/orange.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/pink.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/POC_pride.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/purple.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/rainbow.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/red.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/release.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/trans.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AlternateIcons/white.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AppIcon.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AppIcon.beta.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/AppIcon.dev.appiconset/*
git update-index --assume-unchanged Sources/App/Resources/Assets.xcassets/LaunchScreen/launchScreen-logo.imageset/*
git update-index --assume-unchanged fastlane/metadata/*png
git update-index --assume-unchanged fastlane/metadata/*jpg
git update-index --assume-unchanged Sources/Extensions/Watch/Resources/Assets.xcassets/RoundLogo.imageset/*
git update-index --assume-unchanged Sources/Extensions/Watch/Resources/Assets.xcassets/TemplateLogo.imageset/*
git update-index --assume-unchanged Sources/Shared/Assets/SharedAssets.xcassets/Logo.imageset/*
git update-index --assume-unchanged Sources/Shared/Assets/SharedAssets.xcassets/statusItemIcon.imageset/*
git update-index --assume-unchanged Sources/WatchApp/Assets.xcassets/WatchIcon.appiconset/*
git update-index --assume-unchanged Sources/WatchApp/Assets.xcassets/WatchIcon.beta.appiconset/*
git update-index --assume-unchanged Sources/WatchApp/Assets.xcassets/WatchIcon.dev.appiconset/*
git update-index --assume-unchanged Configuration/Entitlements/*
git update-index --assume-unchanged Sources/App/Resources/GoogleService-Info-*
git update-index --assume-unchanged Sources/Launcher/Info.plist
git update-index --assume-unchanged Sources/WatchApp/Info.plist
git update-index --assume-unchanged Sources/MacBridge/Resources/Info.plist
git update-index --assume-unchanged Sources/Extensions/Watch/Resources/Info.plist
git update-index --assume-unchanged Podfile
git update-index --assume-unchanged Podfile.lock
git update-index --assume-unchanged Configuration/HomeAssistant.beta.xcconfig
git update-index --assume-unchanged Sources/App/Settings/Notifications/NotificationRateLimitsAPI.swift
git update-index --assume-unchanged Sources/WatchApp/Assets.xcassets/Contents.json
git update-index --assume-unchanged Sources/App/Settings/SettingsDetailViewController.swift
git update-index --assume-unchanged Sources/App/Settings/AboutViewController.swift
git update-index --assume-unchanged Sources/PushServer/Package.resolved
git update-index --assume-unchanged Sources/App/Resources/Base.lproj/LaunchScreen.storyboard
cd custom-app


