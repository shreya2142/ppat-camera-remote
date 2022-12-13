# ppat-camera-remote

## Summary

ppat-camera-remote allows for remote control of ISO, Shutter Speed, and Aperture of a Sony DSLR Camera. The app uses Wi-Fi to "talk to" the Sony DSLR camera and send event commands that let you change ISO, Shutter Speed, and Aperture. This app uses another repo called ROCC to send these commands (https://github.com/simonmitchell/rocc) ppat-camera-remote is specifically designed with accessibility in mind, with all the buttons being close to the bottom and aligned to one side of the phone. This allows a user to operate the app without having to make large movements. 

ppat-camera-remote was written as part of a class at MIT called Principles and Practices of Assistive Technology (PPAT). 

Features include:
- Changing ISO, Shutter Speed, and Aperture on from your device
- Being able to trigger the shutter from your device
- Viewing current camera settings 

## Requirements

* [Xcode](https://developer.apple.com/xcode/download/)
* [ROCC] (https://github.com/simonmitchell/rocc)

## Running App on XCode Simulator

1. Download the [source code](https://github.com/shreya2142/ppat-camera-remote/)

  `$ git clone git@github.com:shreya2142/ppat-camera-remote.git`

2. Open PPATCamera in Xcode

3. Select iPhone 11 to use with the iPhone model this app has been tested in. The app was designed to work with other iPhone models as well, so selecting iPhone 11 in the simulator is not necessary.

4. Hit the play button at the top left corner of XCode

5. Now that you know the app is working in XCode, we will try to connect it to your camera (see section below)

## Connect App to Camera (Instructions for Sony Alpha 7iii)

1. Turn on the camera and press the menu button at the top left of the viewfinder. Also turn the top dial to M for manual mode. 

2. Navigate to the icon that looks like a globe and press "Ctrl w/ Smartphone"

3. Make sure Ctrl w/ Smartphone is on and so is Always Connected

4. Press the Connection button, a screen that says Connection Info at the top should pop up

5. On your laptop, disconnect from your local wifi and connect to the wifi printed out on the camera. If it is your first time connecting, you will have to connect with a password, which is done by pressing the trash can button on the camera

6. From there, close any simulator instances you already had running and click play. Then click the camera icon on the bottom left of the screen. If an error message shows up, wait for a few seconds and attempt connecting again. More drastic actions include closing and reopening the simulator or turning off the camera and repeating this process again.

7. Now you're connected and ready to go! Click on ISO / SS / A, which stand for ISO, shutter speed, and aperture respectivey and a scrolling wheel pops up that allows you to change the value. No confirmation is necessary, the values on the camera update in real time. Once you are satisfied, click the capture button in the middle of the screen to take a picture. 

## ROCC Information

The initial strategy for connecting with the camera was using the Sony native API/SDK. After struggling with that for a while, I went in search of alternate ways to connect to my Sony camera. I came across ROCC (https://github.com/simonmitchell/rocc) which has the same functionality as the Sony native API/SDK but with a signficantly more straightforward interface. The documentation for adding ROCC as a dependancy in Swift did not work for me; I suspect this is the case because the documentation is slightly outdated. I will walk through the steps required to add ROCC as a dependency in XCode (I am using XCode 14.0.1). 

- Open PPATCamera.xcodeproj in XCode
- On the right, there should be a panel with PROJECT and TARGETS as headers. Click the PPATCamera below the PROJECT header. 
- Click on the package dependencies tab
- Click on the + icon at the bottom of the list
- Add Rocc using the github link and follow instructions about version rules
- Check to make sure Rocc shows up under Package Dependencies when you click on the PPATCamera.xcodeproj icon
- From there, just put import Rocc at the top of your file and you should be good to go!

## Development Process

The first step in the development process was to talk to our codesigner and gain an understanding of what sorts of UI element they like / do not like. Based on this, we made several Figma mockups to test with out codesigner. From there, we made modifications to the Figma files based on their input and continued iterating on the design of the frontend. See the section Frontend Design Considerations to see what we learned from this experience. Given the frontend of this app, it is incredibly easy to do things such as change the size and placmenent of buttons or increase/change fonts. Things that may be slightly more difficult would be changing the type of UI element, such as going from a scrolling wheel to a manual input.

Once the Figma was iterated upon to a degree we were satisfied with, the next step is to create this frontend in XCode. For the development of this app, we used StoryBoard, so the creation of the frontend was quite intuitive. Due to a Github mishap, we lost the complete fronend and hand to start over. Due to time constraints, we decided to go with the functionality that we deemed the highest priority, which was ISO, shutter speed, and aperture. When building out the UI, frquently press play to see your code on the simulated phone. There were many instances where we had "floating" buttons or buttons in the wrong place due to misplaced constraints. Furthermore, check to see how your app functions on devices that are different from what you are planning on running it on.

After completing the UI, we moved to working on the backend. The ROCC repository has several examples of how to get started. One point of confusion for me was that many of these examples had to be contained within delegates. These delegates have certain functions that they are required to have. The first step to the backend is writing the function that connects to the camera. To do this, you make a CameraDiscovererDelegate that is called somewhere within your ViewController. This delegate should have a function called connect that allows you to connect to your Sony camera. I suggest testing that connection works before proceeding with coding any of the other backend elements. In order to test connection, you follow the same steps in 'Connect App to Camera'. I found it exceptionally helpful to print information about the camera such as its name and connection mode to help with the debugging process. After that, most of the other backend functionality is just sending commands to the camera by using ROCC's performFunction. One limitation of this app is that it CAN NOT recieve information from the camera. I will discuss this further in the Missing Functionality section. 

Due to the fact that the app can not recieve information from the camera, one important development note is to manually input possible states and also keep track of the current state. The possible states just the values that ISO / SS / A can possibly be given a particular camera and lens. A lot of this information is contained within the ROCC repo or online, so there is no need to manually scroll through the camera. In order to make sure you are keeping track of the current state properly, immediately upon connection send a command to the camera setting ISO / SS / A to known values and save those values in your code. After that, when sending any command to update values in the camera, make sure you update the respective variable in your code. 

## Frontend Design Considerations
See 'Figma Design' at the bottom of the page to see what this app is working towards!

- All the buttons are at the bottom and left aligned. This makes it easy to operate the app without lifting your elbow, which can be tiring for some users. Feel free to modify the placement of the buttons to suit your own needs. The placement of the buttons significantly affects the user experience as it determines how taxing it is to do any one operation.
- Displaying current camera settings in app. This app was designed with the intention that the user would not be looking at the camera or the settings display at all. Therefore, it is critical to make sure that all values are easily displayed on the screen.
- Our codesigner wanted to ensure that this app would work even if she upgraded her phone. With this in mind, make sure that constraints placed are not dependent on exact distances from points on the screen in a way that would cause the app to change appearance and/or functionality with a phone switch.

## Missing Functionality

One large piece of missing functionality is the inability to get information from the camera. Based on the documentation provided in the ROCC repo, this is definitely possible to do from the ROCC repo, I was just unable to figure it out due to time constraints. The addition of this functionality would allow the app to know the actual values of the camera without manually updating them. It would also allow the user to see what 'the camera sees' on their phone, which was an important critera for our codesigner that we were unfortunately unable to achieve. The code currently has a CameraEventNotifierDelegate that is supposed to call the eventNotifier function whenever it gets information from the camera. Dispite hours of debugging, eventNotifier was never called and therefore we were unable to recieve information from the camera.

Another easy to add functionality is to add more options to toggle other than ISO / SS / A. Examples include white balance, flash, and timer. Another feature to be added is to give the capture button more built in functionality. We want it so that a light press to the button will correspond to the light press of the shutter button on the camera and a long press will correspond to burst mode. Looking that the ROCC documentation, this is also a possibility.

The final piece of missing functionality is for the app to successfully operate on a phone. For our final user prototype testing, we were successfully able to upload the app on to our codesigner's phone by connecting it to the laptop via USB, and then installing as a device in XCODE, and then running the simulation on it. Although the frontend of the app was working, our codesigner was unable to communicate with the camera. We tested the app again using the laptop simulator and it was successfully able to do so. This is a critical part of getting the app in the hands of people who actually want to use it, since it is unreasonable to expect them to be running it on a development environment. 



## App Screenshot

<img width="286" alt="image" src="https://user-images.githubusercontent.com/66264325/207300495-a02f4111-0978-4820-9785-bee3494b8714.png">

## Figma Design
<img width="286" alt="image" src="https://user-images.githubusercontent.com/66264325/207296922-341ef316-0387-495b-9daf-91fd3d67bd32.png">

