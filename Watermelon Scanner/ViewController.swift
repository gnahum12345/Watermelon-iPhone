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
    @IBOutlet weak var progressBar: UIProgressView!
    
   
    @IBOutlet var screenView: UIView!
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let cameraController = CameraController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.previewView, with: self.screenView)
            }
        }
        configureCameraController()
        
    }
    
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
            
            self.alertUser()
            let percent = self.analyze(img: image)
            self.updatePercentage(percent: percent)
            print(image)
            print(image.description)
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }
        }
    }
    
    func alertUser(){
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        
        view.addSubview(myActivityIndicator)
    }
    
    func analyze(img: UIImage) -> Double {
        
        return 0.2
    }
    func updatePercentage(percent: Double){
        self.myActivityIndicator.stopAnimating()
        self.ripenessLabel.text = String(percent * 100) + " %"
        if percent < 0.3 {
            self.progressBar.progressTintColor = UIColor.red
        }else if percent < 0.6 {
            self.progressBar.progressTintColor = UIColor.yellow
        }else{
            self.progressBar.progressTintColor = UIColor.green
        }
        self.progressBar.setProgress(Float(percent), animated: true)
    }
    
    
}


