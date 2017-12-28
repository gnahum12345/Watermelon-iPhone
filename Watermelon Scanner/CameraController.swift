//
//  CameraController.swift
//  Watermelon Scanner
//
//  Created by Gabriel Nahum on 12/25/17.
//  Copyright © 2017 Gabriel. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


    



class CameraController: NSObject, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession?

    var currentCameraPosition: CameraPosition?

    var photoOutput: AVCapturePhotoOutput?

    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?

    var previewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    
    var flashMode = AVCaptureDevice.FlashMode.on
    
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    var toggleFlashGestureRecognizer = UISwipeGestureRecognizer()
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }

    public enum CameraPosition {
        case rear
    }

    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }

        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            let devices = session.devices


            for camera in devices {
                if camera.position == .back {
                    self.rearCamera = camera
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }

        }

        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }

            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)

                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }

                self.currentCameraPosition = .rear
            }



            else { throw CameraControllerError.noCamerasAvailable }
        }

        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }

            self.photoOutput = AVCapturePhotoOutput()
            if #available(iOS 11.0, *) {
                self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }

            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
            captureSession.startRunning()
        }
       
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }

            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }

                return
            }

            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }

    @objc func zoomIn() {
        if let zoomFactor = rearCamera?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try rearCamera?.lockForConfiguration()
                    rearCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    rearCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = rearCamera?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try rearCamera?.lockForConfiguration()
                    rearCamera?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    rearCamera?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    @objc func toggleFlash(){
        if flashMode == AVCaptureDevice.FlashMode.off {
            flashMode = AVCaptureDevice.FlashMode.on
            do {
                try rearCamera?.lockForConfiguration()
                rearCamera?.torchMode = .on
                
                rearCamera?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }else{
            do {
                try rearCamera?.lockForConfiguration()
                rearCamera?.torchMode = .off
                rearCamera?.unlockForConfiguration()
            } catch {
                print(error)
            }
            flashMode = AVCaptureDevice.FlashMode.off
        }
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        
    }
    func displayPreview(on view: UIView, with screenLayer: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }

        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait

        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
        
        //Flash Gesture
        toggleFlashGestureRecognizer.direction = .up
        toggleFlashGestureRecognizer.addTarget(self, action: #selector(self.toggleFlash))
        screenLayer.addGestureRecognizer(toggleFlashGestureRecognizer)
        
        //Zoom In Gesture
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(self.zoomIn))
        screenLayer.addGestureRecognizer(zoomInGestureRecognizer)
        
        //Zoom Out Gesture
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(self.zoomOut))
        screenLayer.addGestureRecognizer(zoomOutGestureRecognizer)
        
    }


    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }

        let settings = AVCapturePhotoSettings()
//        settings.flashMode = self.flashMode

        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }

    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }

        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
        }

        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}


