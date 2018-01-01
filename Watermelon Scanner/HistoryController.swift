//
//  HistoryController.swift
//  Watermelon Scanner
//
//  Created by Gabriel Nahum on 12/31/17.
//  Copyright © 2017 Gabriel. All rights reserved.
//

import Foundation
import UIKit

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
 
    @IBOutlet weak var tableView: UITableView!
    var scans = [String:Any]()
    var changeViewsGestureRecognizer = UIScreenEdgePanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadScans()
        changeViewsGestureRecognizer.edges = .right
        changeViewsGestureRecognizer.addTarget(self, action: #selector(self.changeViews))
        view.addGestureRecognizer(changeViewsGestureRecognizer)
    }
    @objc func changeViews(){
        print("I did another edge pan gesture")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "scanScreen") as! ViewController
        
        self.present(resultViewController, animated:true, completion:nil)
    }
    func loadScans(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if !scans.isEmpty {
            scans.removeAll()
        }
        
        let count = appDelegate.count.integer(forKey: "count")
        print("Count: \(count)")
        
        for i in 0..<count {
            if appDelegate.dataScan.dictionary(forKey: "Scan \(i+1)") != nil {
                scans["Scan \(i+1)"] = appDelegate.dataScan.dictionary(forKey: "Scan \(i+1)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scans.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return []
    }
    
    func changeStarRating(_ cosmosView: CosmosView){
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.updateOnTouch = true
    }
    
    func updateDefaults(rating: Double, cell scan:[String:Any?], count:Int ){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let data = ["image \(count)": scan["image \(count)"] as! UIImage, "percentage \(count)": scan["percentage \(count)"] as! Double, "User rating \(count)": rating] as [String : Any]
        
        appDelegate.dataScan.set(data, forKey: "Scan \(count)")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        
        changeStarRating(cell.rating)
        cell.rating.didFinishTouchingCosmos = {(d:Double) in self.updateDefaults(rating:d, cell: self.scans["Scan \(indexPath.count+1)"] as! [String : Any?], count: indexPath.count)}
        cell.rating.text = String(format: "%.2f", cell.rating.rating)
        let percent = scans["percentage \(indexPath.count + 1)"] as! Double
        cell.algorithmRating.text = String(format: "%.2f", percent)
        cell.imageView?.image = scans["image \(indexPath.count)"] as? UIImage
        return cell
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "scanScreen") as! ViewController
        
        self.present(resultViewController, animated:true, completion:nil)
    }
}
