//
//  DrunkMapViewController.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import UIKit
import MapKit
import Foundation


class DrunkMapViewController: UIViewController {
    
    //var timerMapDrunk:Timer = Timer()
    @IBOutlet weak var messagingDisplay: UITextView!
    @IBOutlet weak var enterText: UITextField!
    
    @IBOutlet var addItemView: UIView!
    
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        Core.shared.emerDoneDrunkBool = true
        performSegue(withIdentifier: "kickBackDrunkToLogin", sender: self)
        Core.shared.coreDeleteDict()
    }
    
    @IBAction func retryRequestDrunk(_ sender: Any) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterText.autocorrectionType = .no
        Core.shared.emerDoneDrunkBool = true
        //messagingDisplay.text = "hi\n"
        /*
        timerMapDrunk = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(drunkMap), userInfo: nil, repeats: true)
        timerMapDrunk.fire()
        // Do any additional setup after loading the view.*/
    }

    @IBAction func sendTextButton(_ sender: Any) {
        if Core.shared.cannotSendMessage == false{
            if enterText.text == "" {return}
            let originalString = enterText.text?.replacingOccurrences(of: "|", with: " ")
            messagingDisplay.text.append("Me: "+originalString!+"\n")
            let escapedString = originalString!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let sendTextURL = URL(string: Core.shared.IP+"/message.php?user="+Core.shared.messageFrom+"&msg="+escapedString!+"&dest="+Core.shared.helpName)
            Core.shared.sendServerRequest(url: sendTextURL!)
            enterText.text = ""
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func EmerDoneDrunkButton(_ sender: Any) {
        if Core.shared.emerDoneDrunkBool == true{
            emergencyConcludedDrunkPressed()
        }
        Core.shared.emerDoneDrunkBool = false
    }
    
    func emergencyConcludedDrunkPressed(){
        print("emergency drunk done")
        //Core.shared.stopTimer(timer: Core.shared.userTimer)
        let emergencyDoneDrunkURL = URL(string: Core.shared.IP+"/drunkEmerDone.php?user="+Core.shared.sUsername)
        Core.shared.sendServerRequest(url: emergencyDoneDrunkURL!)
        Core.shared.loadingToMapDrunk = false
        //timerMapDrunk.invalidate()
    }
    
    func autoSegueHomeDrunk(){
        performSegue(withIdentifier: "drunkSegueHome", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
        Core.shared.cannotSendMessage = false
        Core.shared.conn = "yes"
        print("!")
    }
    override func viewDidLayoutSubviews() {
        messagingDisplay.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.DrunkMessaging,newController: self)
        
        self.messagingDisplay.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    /*
    func drunkMap(){
        
        let soberCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Core.shared.helpLat,Core.shared.helpLong)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05,0.05)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Core.shared.userLatitude, Core.shared.userLongitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation,span)
        DrunkMap.setRegion(region, animated: true)
        DrunkMap.tintColor = UIColor.cyan
        self.DrunkMap.showsUserLocation = true
        let soberAnnotation = MKPointAnnotation()
        soberAnnotation.coordinate = soberCoord
        soberAnnotation.title = Core.shared.helpName
        DrunkMap.addAnnotation(soberAnnotation)
        
    }*/
}
