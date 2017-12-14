//
//  ViewController.swift
//  Watermelon Scanner
//
//  Created by Gaby Nahum on 7/22/16.
//  Copyright © 2016 Gabriel. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    @IBOutlet weak var ripenessLabel: UILabel!
    @IBOutlet weak var previewView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func captureImage(_ sender: Any) {
    }
  
}

