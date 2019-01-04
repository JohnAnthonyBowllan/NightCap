//
//  SoberMapViewController.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.

// This file allows the helper to message the at-risk student and see
// their location on a map

import UIKit
import MapKit

class SoberMapViewController: UIViewController {



    @IBOutlet weak var messageViewSob: UITextView!
    @IBOutlet weak var enterTextSob: UITextField!
    //var timerMapSober:Timer = Timer()

    @IBOutlet var addItemView: UIView!

    @IBAction func sendTextSob(_ sender: Any) {
        if Core.shared.cannotSendMessage == false{
            if enterTextSob.text == "" {return}
            let originalString = enterTextSob.text?.replacingOccurrences(of: "|", with: " ")
            messageViewSob.text.append("Me: "+originalString!+"\n")
            let escapedString = originalString!.addingPercentEncoding(withAllowedCharacters: .letters)
            let sendTextURL = URL(string: Core.shared.IP+"/message.php?user="+Core.shared.messageFrom+"&msg="+escapedString!+"&dest="+Core.shared.helpName)
            Core.shared.sendServerRequest(url: sendTextURL!)
            enterTextSob.text = ""
        }
    }
    func autoSegueHomeSober(){
        performSegue(withIdentifier: "soberSegueTable", sender: self)
    }

    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        Core.shared.emerDoneSoberBool = true
        performSegue(withIdentifier: "kickBackSoberToLogin", sender: self)
        Core.shared.coreDeleteDict()
    }

    @IBAction func retryRequestSober(_ sender: Any) {
        Core.shared.coreResendRequest()
        animateOut()
    }
    // COMMENT CODE!
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
        enterTextSob.autocorrectionType = .no
        Core.shared.emerDoneSoberBool = true
        /*timerMapSober = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(soberMap), userInfo: nil, repeats: true)
        timerMapSober.fire()*/
        // Do any additional setup after loading the view.
    }


    override func viewDidAppear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.SoberMessaging,newController: self)

        // self.prayerView.scrollRangeToVisible(NSMakeRange(0, 0))
        self.messageViewSob.scrollRangeToVisible(NSMakeRange(0, 0))
    }

    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
        Core.shared.cannotSendMessage = false
        Core.shared.conn = "yes"

        print("!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func EmerDoneSoberButton(_ sender: Any) {
        if Core.shared.emerDoneSoberBool == true {
            emergencyConcludedSoberPressed()
        }
        Core.shared.emerDoneSoberBool = false
    }

    func emergencyConcludedSoberPressed(){
        print("emergency sober done")
        //Core.shared.stopTimer(timer: Core.shared.userTimer)
        Core.shared.periodicLocUpdate(time: Core.shared.soberStandByUpdate)
        let emergencyDoneSoberURL = URL(string: Core.shared.IP+"/soberEmerDone.php?user="+Core.shared.sUsername)
        Core.shared.sendServerRequest(url: emergencyDoneSoberURL!)
        //timerMapSober.invalidate()
    }
    /*
    func soberMap(){
        let riskUserCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Core.shared.helpLat,Core.shared.helpLong)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05,0.05)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Core.shared.userLatitude, Core.shared.userLongitude)

        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation,span)
        SoberMap.setRegion(region, animated: true)
        SoberMap.tintColor = UIColor.cyan
        self.SoberMap.showsUserLocation = true
        let riskUserAnnotation = MKPointAnnotation()
        riskUserAnnotation.coordinate = riskUserCoord
        riskUserAnnotation.title = Core.shared.helpName
        SoberMap.addAnnotation(riskUserAnnotation)
    }
    */
}
