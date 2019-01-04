//
//  InitialViewController.swift
//
//  Created by John Bowllan on 7/14/17. All rights reserved.
// This file either allows for a segue to the login screen or to the home screen.

import UIKit

class InitialViewController: UIViewController {
    @IBOutlet var addItemView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Core.shared.checkDictionaryOfRequestsTimer()

    }
    @IBAction func dismissPopUp(_ sender: Any) {
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
    @IBAction func retryRequest(_ sender: Any) {
        Core.shared.coreResendRequest()
        animateOut()

    }

    override func viewDidAppear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.Initial, newController: self)
        if Core.shared.sUsername == ""{
            performSegue(withIdentifier: "segueToLogin", sender: self)
        } else {

            let loginURL = URL(string: Core.shared.IP+"/regLogin.php?user="+Core.shared.sUsername+"&gend="+Core.shared.userGender)
            Core.shared.sendServerRequest(url: loginURL!)
        }

    }
    func segueToHome(){
        performSegue(withIdentifier: "segueToHome", sender: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}
