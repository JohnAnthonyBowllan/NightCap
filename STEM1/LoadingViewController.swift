//
//  LoadingViewController.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import UIKit
import Foundation

class LoadingViewController: UIViewController  {
    //var timerFunc:Timer = Timer()
    @IBOutlet var addItemView: UIView!
    var cancelHelpButton = true
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        cancelHelpButton = true
        performSegue(withIdentifier: "kickBackLoadingToLogin", sender: self)
        Core.shared.coreDeleteDict()
    }
    
    
    @IBAction func retryRequestLoading(_ sender: Any) {
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
        cancelHelpButton = true
        // Do any additional setup after loading the view.
        //timerFunc = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(loadingToMapSegue), userInfo: nil, repeats: true)
        //timerFunc.fire()
    }

    @IBAction func cancelHelpButton(_ sender: Any) {
        cancelHelpPressed()
    }
    
    func cancelHelpPressed(){
        if cancelHelpButton == true{
            let cancelHelpURL = URL(string: Core.shared.IP+"/cancelHelp.php?user="+Core.shared.sUsername)
            Core.shared.sendServerRequest(url: cancelHelpURL!)
        }
        cancelHelpButton = false
    }
    
    
    func loadingToMapSegue(){
        
            Core.shared.messageFrom = Core.shared.sUsername
            Core.shared.messageTo = Core.shared.helpName
            performSegue(withIdentifier: "loadingSegue", sender: self)
            Core.shared.loadingToMapDrunk = false
            //timerFunc.invalidate()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.Loading, newController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
    }
}
