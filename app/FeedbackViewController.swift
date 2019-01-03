//
//  FeedbackViewController.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var insertFeedback: UITextField!
    
    @IBAction func submitFeedback(_ sender: Any) {
        let feedback:String = insertFeedback.text!
        // feed to the server however
        insertFeedback.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
