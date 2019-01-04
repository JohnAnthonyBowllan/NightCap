//
//  ViewController.swift
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.

// First time login screen to register and set preferences.

import UIKit
import Foundation


class ViewController: UIViewController, BEMCheckBoxDelegate {

    @IBOutlet var addItemView: UIView!

    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var iAmMale: BEMCheckBox!

    @IBOutlet weak var iAmFemale: BEMCheckBox!

    @IBOutlet weak var iAmOther: BEMCheckBox!


    var goButton:Bool = true


    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox == iAmMale{
            if iAmFemale.on{
                iAmFemale.setOn(false, animated: true)
            }
            if iAmOther.on{
                iAmOther.setOn(false, animated: true)
            }
        } else if checkBox == iAmFemale {
            if iAmMale.on{
                iAmMale.setOn(false, animated: true)
            }
            if iAmOther.on{
                iAmOther.setOn(false, animated: true)
            }
        }else if checkBox == iAmOther {
            if iAmMale.on{
                iAmMale.setOn(false, animated: true)
            }
            if iAmFemale.on{
                iAmFemale.setOn(false, animated: true)
            }
        }
        checkGender()
    }

    func checkGender(){
        if iAmMale.on {
            Core.shared.userGender = "Male"
        } else if iAmFemale.on {
            Core.shared.userGender = "Female"
        } else if iAmOther.on {
            Core.shared.userGender = "Other"
        }
    }

    @IBAction func setPreference(_ sender: Any) {
        if goButton == true{
            if password.text != nil && (iAmMale.on || iAmFemale.on||iAmOther.on){
                Core.shared.sUsername = password.text!
                // userGender
                UserDefaults.standard.set(Core.shared.sUsername, forKey: "sUsername")
                UserDefaults.standard.set(Core.shared.userGender, forKey: "userGender")
                serverfirsttimeLogin()
            }
        }
        goButton = false
    }

    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        goButton = true
        Core.shared.coreDeleteDict()
    }

    @IBAction func retryRequestView(_ sender: Any) {
        Core.shared.coreResendRequest()
        animateOut()
    }

    func animateIn(){
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        addItemView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
        UIView.animate(withDuration:0.4){
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
    }

    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
            self.addItemView.alpha = 0

        }) { (success:Bool) in
            self.addItemView.removeFromSuperview()
        }
    }

    func serverfirsttimeLogin(){
        /*
         creates a user folder on server side for anyone who has app
         on the login page
         */

        if let logininfo = UserDefaults.standard.object(forKey: "sUsername")as? String {
            Core.shared.sUsername = logininfo
        }
        let loginURL = URL(string: Core.shared.IP+"/regLogin.php?user="+Core.shared.sUsername+"&gend="+Core.shared.userGender)
        Core.shared.sendServerRequest(url: loginURL!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        goButton = true
        iAmMale.delegate = self
        iAmFemale.delegate = self
        iAmOther.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.logIn,newController: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
    }


}
