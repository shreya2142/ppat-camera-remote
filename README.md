# Zocus iOS

## Summary

ppat-camera-remote allows for remote control of ISO, Shutter Speed, and Aperture of a Sony DSLR Camera. The app uses Wi-Fi to "talk to" the Sony DSLR camera and send event commands that let you change ISO, Shutter Speed, and Aperture. This app uses another repo called ROCC to send these commands (https://github.com/simonmitchell/rocc) ppat-camera-remote is specifically designed with accessibility in mind, with all the buttons being close to the bottom and aligned to one side of the phone. This allows a user to operate the app without having to make large movements. 

ppat-camera-remote was written as part of a class at MIT called Principle and Practices of Assistive Technology (PPAT). 

Features include:
- Changing ISO, Shutter Speed, and Aperture on from your device
- Being able to trigger the shutter from your device
- Viewing current camera settings

## Screenshot

![](https://github.com/zocusapp/zocus-ios/blob/master/screenshot.png?raw=true)

## Requirements

* [Xcode](https://developer.apple.com/xcode/download/)

## Installation Instructions

1. Download the [source code](https://github.com/zocusapp/zocus-ios)

  `$ git clone git@github.com:zocusapp/zocus-ios.git`

2. Install [cocoapods](https://cocoapods.org/)
	
  `$ cd ./Zocus/zocus-ios && pod install`

3. Open "Zocus.xcworkspace" in Xcode

4. Open Xcode's Preferences > Accounts and add your Apple ID

5. In Xcode's sidebar select "Zocus" and go to Targets > Zocus > General > Identity and add a word to the end of the Bundle Identifier to make it unique. Also select your Apple ID in Signing > Team

6. Connect your iPad or iPhone and select it in Xcode's Product menu > Destination

7. Press CMD+R or Product > Run to install Zocus

## License

zocus-ios is available under the GPLv3 License
