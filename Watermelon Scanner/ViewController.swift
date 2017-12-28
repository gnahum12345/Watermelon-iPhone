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
    
  
}


