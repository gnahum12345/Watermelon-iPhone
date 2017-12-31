//
//  ViewController.swift
//  Watermelon Scanner
//
//  Created by Gaby Nahum on 7/22/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox.AudioServices


extension UIColor {
    var redValue: Int{ return Int(CIColor(color: self).red) }
    var greenValue: Int{ return Int(CIColor(color: self).green) }
    var blueValue: Int{ return Int(CIColor(color: self).blue) }
    var alphaValue: Int{ return Int(CIColor(color: self).alpha) }
}

extension UIImage {
    /// Get the pixel color at a point in the image
    func getPixelColor(atLocation location: CGPoint, withFrameSize size: CGSize) -> UIColor {
        let x: CGFloat = (self.size.width) * location.x / size.width
        let y: CGFloat = (self.size.height) * location.y / size.height
        
        let pixelPoint: CGPoint = CGPoint(x: x, y: y)
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelIndex: Int = ((Int(self.size.width) * Int(pixelPoint.y)) + Int(pixelPoint.x)) * 4
        
        let r = CGFloat(data[pixelIndex]) / CGFloat(255.0)
        let g = CGFloat(data[pixelIndex+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelIndex+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelIndex+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


class ViewController: UIViewController, AVCapturePhotoCaptureDelegate{

    @IBOutlet weak var ripenessLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
   
    @IBOutlet var screenView: UIView!
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let cameraController = CameraController()
    var changeViewsGestureRecognizer = UIScreenEdgePanGestureRecognizer()
    let ideal_red = 210
    let ideal_green = 190
    let ideal_blue = 130
    let min_yellow = 10

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        changeViewsGestureRecognizer.edges = .left
        changeViewsGestureRecognizer.addTarget(self, action: #selector(self.changeViews))
        view.addGestureRecognizer(changeViewsGestureRecognizer)
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
    @objc func changeViews(){
        print("I did an edge pan gesture")
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
            
            
            let percent = self.analyze(img: image)
            self.updatePercentage(percent: percent)
            print(image)
            print(image.description)
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }
        }
        self.alertUser()
    }
    
    func alertUser(){
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = true
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        
        view.addSubview(myActivityIndicator)
        
        //Vibrating Feedback
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    func distanceFromPerfect(_ color: UIColor) -> Double{
        let square = {(num: Int) -> Double in return pow(Double(num),2)}
      
        let disRed = color.redValue - ideal_red
        let disGreen = color.blueValue - ideal_green
        let disBlue = color.greenValue - ideal_blue
        
        return pow(square(disRed) + square(disGreen) + square(disBlue), 0.5)
        
    }

    func checkYellow(color: UIColor) -> UIColor {
        let red = color.redValue
        let blue = color.blueValue
        let green = color.greenValue
        
        if(((red<=(ideal_red+40)) && (red>=(ideal_red-40))) && ((green<=(ideal_green+40))&&(green>=(ideal_green-40))) && ((blue<=(ideal_blue+40))&&(blue>=(ideal_blue-40)))){
            return color;
        }
        
        return UIColor.black
    }
    func analyze(img: UIImage) -> Double {
        //
        let height = Int(img.size.height)
        let width = Int(img.size.width)
        var avg_red = 0
        var avg_green = 0
        var avg_blue = 0
    
        var count = 0
        for row in 0...height {
            for col in 0...width {
                let pixelColor = img.getPixelColor(atLocation: CGPoint(x: row, y: col), withFrameSize: img.size)
                let color = checkYellow(color: pixelColor)
                
                if color != UIColor.black {
                    avg_red += color.redValue
                    avg_blue += color.blueValue
                    avg_green += color.greenValue
                    count += 1
                }
            }
        }
        avg_green = avg_green/count
        avg_blue = avg_blue/count
        avg_red = avg_red/count
        let avg_color = UIColor(red: CGFloat(avg_red), green: CGFloat(avg_green), blue: CGFloat(avg_blue), alpha: CGFloat(1))
        let accounted = (count*100)/(height*width)
        if accounted >= min_yellow {
            return distanceFromPerfect(avg_color)
        }else {
            return 0.00
        }
        
    }
  
    func updatePercentage(percent: Double){
        self.ripenessLabel.text = String(percent * 100) + " %"
        if percent < 0.3 {
            self.progressBar.progressTintColor = UIColor.red
        }else if percent < 0.6 {
            self.progressBar.progressTintColor = UIColor.yellow
        }else{
            self.progressBar.progressTintColor = UIColor.green
        }
        self.progressBar.setProgress(Float(percent), animated: true)
        self.myActivityIndicator.stopAnimating()

    }
    
    
}


