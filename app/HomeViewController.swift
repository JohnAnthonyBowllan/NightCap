//
//  HomeViewController.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import UIKit
import Foundation


class HomeViewController: UIViewController {

    @IBOutlet var addItemView: UIView!
    @IBOutlet weak var Name: UILabel!
    var helpButtonEnabled:Bool = true
    var helperButtonEnabled:Bool = true
    
    @IBAction func toMain(_ sender: Any) {
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    @IBAction func toOption(_ sender: Any) {
        performSegue(withIdentifier: "toOption", sender: self)
    }
    @IBAction func resendRequestHome(_ sender: Any) {
        Core.shared.coreResendRequest()
        animateOut()
    }
    
    @IBAction func helpButton(_ sender: Any) {
        if helpButtonEnabled == true {
            Core.shared.helpState = Core.helpStates.needHelp
            requestHelp()
        }
        helpButtonEnabled = false
        helperButtonEnabled = false
    }
    
    @IBAction func soberButton(_ sender: Any) {
        if helperButtonEnabled == true {
            helperButtonPressed()
        }
        helperButtonEnabled = false
        helpButtonEnabled = false
    }
    
    
    
    
    func requestHelp(){
        // should transition to a waiting page (waiting for helper to accept request)
        Core.shared.periodicLocUpdate(time: Core.shared.fastUpdate)
        Core.shared.helpState = Core.helpStates.helpRequested
        
        //let helpeeNeedHelpURL = URL(string:Core.shared.IP + "/error.php")
       let helpeeNeedHelpURL = URL(string: Core.shared.IP+"/help.php?user="+Core.shared.sUsername+"&loc="+Core.shared.CoordinatePair+"&pref="+String(typeOfHelp()))
        Core.shared.sendServerRequest(url:helpeeNeedHelpURL!)
    }
    
    func helperSegue(){
        performSegue(withIdentifier: "soberLoginSegue", sender: self)
    }
    
    func typeOfHelp()->Int{
        
        var type:Int = 0
        
        if Core.shared.malePreference {type|=1}
        if Core.shared.femalePreference {type|=2}
        if Core.shared.other {type|=4}
        if type == 0 {type = 7}
        print(type)
        return type
    }
// CORE REVISION OF SEND SERVER REQUEST
// COMMENT CODE
// REDO USER INTERFACE
// CANNOT CONNECT TO SERVER VIEW CONTROLLER WITH DISMISS
// RSSI 
    
    func helperButtonPressed(){
        // should go to screen with people who need help
        soberLogin()
        Core.shared.periodicLocUpdate(time: Core.shared.soberStandByUpdate)
    }
    
    func soberLogin(){
        let soberLoginURL = URL(string: Core.shared.IP+"/soberLogin.php?user="+Core.shared.sUsername)
        Core.shared.sendServerRequest(url: soberLoginURL!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loadingthe view.
        addItemView.layer.cornerRadius = 5
        helpButtonEnabled = true
        helperButtonEnabled = true
    }
    
    func animateIn(){ // pass in optional string (if string is there, PHP)
        // change title to PHP error
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        addItemView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
        UIView.animate(withDuration:0.4){
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func callPubSafe(_ sender: Any) {
        /*
        if let url = URL(string: "tel://\(6466407703)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }*/
        let url:NSURL = URL(string: "TEL://123456789")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
            self.addItemView.alpha = 0
            
        }) { (success:Bool) in
            self.addItemView.removeFromSuperview()
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.Home, newController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
    }
    
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        helperButtonEnabled = true
        helpButtonEnabled = true
        performSegue(withIdentifier: "kickBackHomeToLogin", sender: self)
        Core.shared.coreDeleteDict()
        }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
