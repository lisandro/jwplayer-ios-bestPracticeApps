# JW Player iOS 4.0.0 Best Practice Apps

This repository contains samples relating to the JW Player SDK 4.0.0 for iOS.


## BestPracticeApps

This BestPractice project is composed of several targets which can be run as separate iOS applications.
Showcasing functionality for the JWPlayerKit 4.0.0 SDK in each project.

* BasicPlayer, sets up a player with a single playlist item.

## Setup

Before compiling, this uses some pod dependencies so you will require [cocoapods](https://guides.cocoapods.org/using/getting-started.html) in you machine.

Steps to compile:
* Make sure your Xcode is closed.
* In the terminal.app, in the project directory root.
* Run:
```console
pod install
```
* This should update the dependencies in your Pods
* Now open the `.xcworkspace`


Add your JWPlayer license key to the AppDelegate for the target project.

Here:
```swift 
JWPlayerKitLicense.setLicenseKey(<#Your License Key#>)
```

And run and build the project.

**Note**: The demo apps in this repository are intended to be used with **version 4.0.0** of the JW Player iOS SDK.

