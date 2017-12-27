//
//  ViewController.swift
//  Watermelon Scanner
//
//  Created by Gaby Nahum on 7/22/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate{

    @IBOutlet weak var ripenessLabel: UILabel!
    @IBOutlet weak var previewView: UIView!

   
    @IBOutlet var screenView: UIView!
    
    
    let cameraController = CameraController()
//    var captureSession = AVCaptureSession()
//    var currentDevice: AVCaptureDevice?
//
//    var photoOutput: AVCapturePhotoOutput?
//
//    var flashMode = AVCaptureDevice.FlashMode.off
//
//    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
//
//    var image: UIImage?
    
//    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
//    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
//    var toggleFlashGestureRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        setupCaptureSession()
//        setupDevice()
//        setupInputOutput()
//        setupPreviewLayer()
//        captureSession.startRunning()
        
        
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.previewView, with: self.screenView)
            }
        }
        configureCameraController()
        
//        toggleFlashGestureRecognizer.direction = .up
//        toggleFlashGestureRecognizer.addTarget(self, action: #selector(cameraController.toggleFlash))
//        screenView.addGestureRecognizer(toggleFlashGestureRecognizer)
//
//        // Zoom In recognizer
//        zoomInGestureRecognizer.direction = .right
//        zoomInGestureRecognizer.addTarget(self, action: #selector(cameraController.zoomIn))
//        screenView.addGestureRecognizer(zoomInGestureRecognizer)
//
//        // Zoom Out recognizer
//        zoomOutGestureRecognizer.direction = .left
//        zoomOutGestureRecognizer.addTarget(self, action: #selector(cameraController.zoomOut))
//        screenView.addGestureRecognizer(zoomOutGestureRecognizer)
    }
    
//    func setupCaptureSession() {
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//    }
//
//    func setupDevice() {
//        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
//        let devices = session.devices
//
//        for device in devices {
//
//            if device.position == AVCaptureDevice.Position.back {
//                currentDevice = device
//                do {
//                    try device.lockForConfiguration()
//                    device.focusMode = .continuousAutoFocus
//                    device.unlockForConfiguration()
//
//                } catch {
//                    print(error)
//                }
//            }
//
//        }
//
//    }
//
//    func setupInputOutput(){
//
//        do {
//            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
//            captureSession.addInput(captureDeviceInput)
//            photoOutput = AVCapturePhotoOutput()
//
//            if #available(iOS 11.0, *) {
//                photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
//            } else {
//                //CRASH
//            }
//
//            captureSession.addOutput(photoOutput!)
//
//        } catch {
//            print(error)
//        }
//
//    }
//    func setupPreviewLayer() {
//
//        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//        self.cameraPreviewLayer?.frame = previewView.frame
//
//        self.previewView.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
//    }
//
//
//
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func captureImage(_ sender: Any) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            print("captured")
            print(image)
            print(image.description)
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        
       
        
//        let settings = AVCapturePhotoSettings()
//        settings.flashMode = self.flashMode
//
//        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
//    @available(iOS 11.0, *)
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let imageData = photo.fileDataRepresentation() {
//            self.image = UIImage(data: imageData)
//            performSegue(withIdentifier: "Preview_Segue", sender: nil)
//        }
//
//    }
    
  
}


