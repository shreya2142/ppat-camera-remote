//
//  ViewController.swift
//  PPATCamera
//
//  Created by Shreya Gupta on 11/29/22.
//

import UIKit
import Rocc

var notifier: NotifierDelegate?
var camDelegate: CamDelegate?
var currentDevice: Rocc.Camera?

// TODO: get available values and current values from device messages

let available_iso = ["50","64","80","100","125","160","200","250","320","400","500","640","800","1000","1250","1600","2000","2500","3200","4000","5000","6400","8000","10000","12800","16000","20000","25600","32000","40000","51200","64000","80000","102400","12800","160000","204800"]
let available_shutter_speed = ["30\"","25\"","20\"","15\"","13\"","10\"","8\"","6\"","5\"","4\"","3.2\"","2.5\"","2\"","1.6\"","1.3\"","1\"","0.8\"","0.6\"","0.5\"","0.4\"","1/3","1/4","1/5","1/6","1/8","1/10","1/13","1/15","1/20","1/25","1/30","1/40","1/50","1/60","1/80","1/100","1/125","1/160","1/200","1/250","1/320","1/400","1/500","1/640","1/800","1/1000","1/1250","1/1600","1/2000","1/2500","1/3200","1/4000","1/5000","1/6400","1/8000"]
let available_apertures = ["2.8","3.2","3.5","4.0","4.5","5.0","5.6","6.3","7.1","8.0","9.0","10","11","13","14","16","18","20","22"]

var current_iso = "50"
var current_shutter_speed = "30\""
var current_aperture = "2.8"


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var ISOPicker: UIPickerView!
    @IBOutlet weak var ShutterSpeedPicker: UIPickerView!
    @IBOutlet weak var ISOButton: UIButton!
    @IBOutlet weak var ISOView: UIView!
    @IBOutlet weak var ShutterSpeedview: UIView!
    @IBOutlet weak var ShutterSpeedButton: UIButton!
    @IBOutlet weak var ApertureButton: UIButton!
    @IBOutlet weak var APicker: UIPickerView!
    @IBOutlet weak var AView: UIView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView == ISOPicker {
            return available_iso.count
        } else if pickerView == ShutterSpeedPicker{
             return available_shutter_speed.count
        } else if pickerView == APicker{
            return available_apertures.count
        }
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == ISOPicker {
            return available_iso[row]
        } else if pickerView == ShutterSpeedPicker{
             return available_shutter_speed[row]
        } else if pickerView == APicker{
            return available_apertures[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == ISOPicker {
            current_iso = available_iso[row]
            ISOButton.configuration?.subtitle = current_iso
            let current_iso_int = Int(current_iso) ?? 50
            currentDevice?.performFunction(ISO.set, payload: ISO.Value.multiFrameNR(current_iso_int), callback: { (error, _) in
                // Update UI (You can rely on eventing if you want to update or do it
                // manually here)
            })
            self.view.endEditing(false)
        } else if pickerView == ShutterSpeedPicker{
            current_shutter_speed = available_shutter_speed[row]
            ShutterSpeedButton.configuration?.subtitle = current_shutter_speed
            let current_shutter_speed_array = shutterSpeedParser(shutterSpeedString: current_shutter_speed)
            let parsed_numerator = current_shutter_speed_array[0]
            let parsed_denominator = current_shutter_speed_array[1]
            currentDevice?.performFunction(Shutter.Speed.set, payload: ShutterSpeed(numerator: parsed_numerator, denominator: parsed_denominator), callback: { (error, _) in
                // Update UI (You can rely on eventing if you want to update or do it
                // manually here)
            })
            self.view.endEditing(false)
        } else if pickerView == APicker{
            current_aperture = available_apertures[row]
            ApertureButton.configuration?.subtitle = "F"+current_aperture
            let current_aperture_double = Double(current_aperture) ?? 2.8
            currentDevice?.performFunction(Aperture.set, payload: Aperture.Value(value: current_aperture_double, decimalSeperator: "."), callback: { (error, _) in
                // Update UI (You can rely on eventing if you want to update or do it
                // manually here)
            })
            self.view.endEditing(false)
        }

    }
    
    func shutterSpeedParser(shutterSpeedString: String) -> Array<Double> {
        /**
         Parses a shutter speed string and makes it into a list consisting of a numerator and denominator that can be sent to the camera as a command
         */
        if shutterSpeedString.last == Optional("\""){
            let shutterNumerator = Double(shutterSpeedString.dropLast()) ?? 1
            let shutterArray = [shutterNumerator, 1]
            return shutterArray
        }
        else{
            let shutterDenominator = Double(shutterSpeedString.dropFirst(2)) ?? 1
            let shutterArray = [1, shutterDenominator]
            return shutterArray
        }
    }
    
    
    @IBAction func ISObutton(_ sender: UIButton) {
        ISOView.isHidden = !ISOView.isHidden
        ShutterSpeedview.isHidden = true
        AView.isHidden = true
        
    }
    @IBAction func ShutterSpeedButton(_ sender: UIButton) {
        ShutterSpeedview.isHidden = !ShutterSpeedview.isHidden
        ISOView.isHidden = true
        AView.isHidden = true
    }
    
    @IBAction func AButton(_ sender: UIButton) {
        AView.isHidden = !AView.isHidden
        ShutterSpeedview.isHidden = true
        ISOView.isHidden = true
    }
    
    @IBAction func connect(_ sender: UIButton) {
        camDelegate = CamDelegate()
    }
    
    @IBAction func takePicture(_ sender: Any) {
        currentDevice?.performFunction(StillCapture.take, payload: nil) { (_, url) in
        }
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        ISOPicker.delegate = self
        ShutterSpeedPicker.delegate = self
        APicker.delegate = self
        
        ISOButton.configuration?.subtitle = current_iso
        ShutterSpeedButton.configuration?.subtitle = current_shutter_speed
        ApertureButton.configuration?.subtitle = "F"+current_aperture
        
        ISOView.isHidden = true
        ShutterSpeedview.isHidden = true
        AView.isHidden = true
    }
}

class CamDelegate: CameraDiscovererDelegate{
    var mainCamera: Camera?
    
    init () {
        let cameraDiscoverer = CameraDiscoverer()
        cameraDiscoverer.delegate = self
        cameraDiscoverer.start()
    }
    
    func cameraDiscoverer(_ discoverer: Rocc.CameraDiscoverer, didError error: Error) {
        print("error!")
    }
    
    func cameraDiscoverer(_ discoverer: Rocc.CameraDiscoverer, discovered device: Rocc.Camera, isCached: Bool) {
        print("_________you've discovered a camera___________")
        print(isCached)
        print(device.name)
        print("_______________________________________________")
        connect(to: device)
        currentDevice = device
        
        notifier = NotifierDelegate(camera: device)
        
        // set ISO, Shutter Speed, and Aperture to default values (min values)
        device.performFunction(ISO.set, payload: ISO.Value.multiFrameNR(50), callback: { (error, _) in
            // Update UI (You can rely on eventing if you want to update or do it
            // manually here)
        })
        
        device.performFunction(Shutter.Speed.set, payload: ShutterSpeed(numerator: 1.0, denominator: 1250), callback: { (error, _) in
            // Update UI (You can rely on eventing if you want to update or do it
            // manually here)
        })

        device.performFunction(Aperture.set, payload: Aperture.Value(value: 2.8, decimalSeperator: "."), callback: { (error, _) in
            // Update UI (You can rely on eventing if you want to update or do it
            // manually here)
        })
    }
    
    func connect(to camera: Camera) {
        camera.connect { (error, isInTransferMode) in
            // isInTransferMode reflects whether the camera was already connected
            // to and has been re-connected to whilst in "Contents Transfer" mode.
        }
        mainCamera = camera
        print("camera connection mode:")
        print(camera.connectionMode)
    }
}

// TODO: get notifier delegatw working!
class NotifierDelegate: CameraEventNotifierDelegate {
    init(camera: Camera) {
        print(camera.eventPollingMode)
        let camEventNotifier = CameraEventNotifier(camera: camera, delegate: self)
        camEventNotifier.startNotifying()
        
        camera.supportsFunction(Focus.Mode.set, callback: { (isSupported, error, supportedValues) in
            // Disable/enable features using the returned value
            print(supportedValues)
        })

    }

    func eventNotifier(_ notifier: CameraEventNotifier, didError error: Error) {
        // If it's important to, show the user an Error
    }

    func eventNotifier(_ notifier: CameraEventNotifier, receivedEvent event: CameraEvent) {
        print(event)
        // Handle the event and update UI! CameraEvent includes all exposure
        // info as well as changes to shooting mode, camera status, e.t.c.
    }
}

//class LiveDelegate: LiveViewStreamDelegate{
//    init(camera: Camera) {
//        let liveViewStream = LiveViewStream(camera: camera, delegate: self)
//        liveViewStream.start()
//
//    }
//
//    func liveViewStream(_ stream: LiveViewStream, didReceive image: UIImage) {
//        glob_image = image
//        OperationQueue.main.addOperation {
//            // Show the next image
//        }
//    }
//
//    func liveViewStream(_ stream: LiveViewStream, didReceive frames: [FrameInfo]) {
//        OperationQueue.main.addOperation {
//            // Show frame information (Focus info)
//        }
//    }
//
//    func liveViewStreamDidStop(_ stream: LiveViewStream) {
//        // Live view stopped!
//    }
//
//    func liveViewStream(_ stream: LiveViewStream, didError error: Error) {
//        // Stream errored, you can try and restart it in this method if
//        // you want, but be careful not to recurse too much!
//    }
//}
//
//
//
//
