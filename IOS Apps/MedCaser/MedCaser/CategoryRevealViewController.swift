//
//  CategoryRevealViewController.swift
//  MedCaser
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

class CategoryRevealViewController: SWRevealViewController {

    var caseName:String = "Categories"
    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = caseName
        // Do any additional setup after loading the view.
        
        //temp fix for changing Q&A label to Question #
        var questionCounter = 1
        for cat in categoryList {
            if cat.type == "qa" {
                cat.title = "Question \(questionCounter)"
                questionCounter++
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func clickHelp(sender: UIButton) {
        var alert = UIAlertController(title: "Help", message: "Swipe left from edge or click ☰ to open menu", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
