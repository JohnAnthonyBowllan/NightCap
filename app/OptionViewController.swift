//
//  OptionViewController.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {

    @IBAction func toFeedback(_ sender: Any) {
        performSegue(withIdentifier: "toFeedback", sender: self)
    }


    @IBAction func toFAQs(_ sender: Any) {
        performSegue(withIdentifier: "toFAQs", sender: self)
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
