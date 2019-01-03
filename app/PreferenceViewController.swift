//
//  PreferenceViewController.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController, BEMCheckBoxDelegate {
    @IBOutlet weak var male: BEMCheckBox!
    
    @IBOutlet weak var female: BEMCheckBox!
    
    @IBOutlet weak var other: BEMCheckBox!
    
    @IBAction func toHome(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        male.delegate = self
        female.delegate = self
        other.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Core.shared.malePreference == true {
            male.setOn(true, animated: false)
        }
        if Core.shared.femalePreference == true {
            female.setOn(true, animated: false)
        }
        if Core.shared.other == true {
            other.setOn(true, animated: false)
        }
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        
        if checkBox.tag == 1{
            Core.shared.malePreference = !Core.shared.malePreference
            UserDefaults.standard.set(Core.shared.malePreference, forKey: "malePreference")
        }
        else if checkBox.tag == 2 {
            Core.shared.femalePreference = !Core.shared.femalePreference
            UserDefaults.standard.set(Core.shared.femalePreference, forKey: "femalePreference")
        }
        else {
            Core.shared.other = !Core.shared.other
            UserDefaults.standard.set(Core.shared.other, forKey: "other")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
