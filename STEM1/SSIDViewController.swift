

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork

class SSIDViewController: UIViewController {
    
    @IBOutlet weak var SSID: UITextField!
    var timerFunc:Timer = Timer()
    var lastBSSID:String = ""
    
    @IBOutlet weak var descriptionOfWIFI: UITextField!
    
    func seenBSSID(bssid:String,locationDescription:String){
        if bssid == lastBSSID {
            descriptionOfWIFI.text = locationDescription
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        timerFunc = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dealWithBSSID), userInfo: nil, repeats: true)
        timerFunc.fire()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.SSID, newController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
    }
    
    
    func dealWithBSSID(){
        
        
        let dictBSSID:[String:String] = getWIFIInformation()
        lastBSSID = SSID.text!
        var newBSSID = dictBSSID["BSSID"]
        newBSSID = newBSSID?.replacingOccurrences(of: ":", with: "-")
        let hyphenPos = newBSSID?.range(of: "-", options: String.CompareOptions.backwards, range: nil, locale: nil)
        newBSSID = newBSSID?.substring(to: (hyphenPos?.lowerBound)!)
        SSID.text = newBSSID
        if lastBSSID != newBSSID{
            descriptionOfWIFI.text = ""
        }
        print(newBSSID!)
        
        
        //let originalString = enterText.text?.replacingOccurrences(of: "|", with: " ")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getSSID(_ sender: Any) {
        let encodeLoc:String = descriptionOfWIFI.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let ssidURL = URL(string: Core.shared.IP+"/BSSID.php?bssid=" + lastBSSID + "&loc=" + encodeLoc)
        Core.shared.sendServerRequest(url:ssidURL!)
        
    }
    func getWIFIInformation() -> [String:String]{
        var informationDictionary = [String:String]()
        let informationArray:NSArray? = CNCopySupportedInterfaces()
        if let information = informationArray {
        
            // loop through information
            let dict:NSDictionary? = CNCopyCurrentNetworkInfo(information[0] as! CFString)
            print(information.count)
            print(information[0])
            if let temp = dict {
                informationDictionary["SSID"] = String(describing: temp["SSID"]!)
                informationDictionary["BSSID"] = String(describing: temp["BSSID"]!)
                return informationDictionary
            }
        }
        
        return informationDictionary
    }
}
