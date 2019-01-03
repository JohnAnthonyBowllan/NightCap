//
//  Core.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import Foundation
import CoreLocation
import SystemConfiguration.CaptiveNetwork

final class Core{
    
    enum helpStates {
        case OK,needHelp,helpRequested,helpAcknowledged,helperFound
    }
    enum viewStates {
        case None,DrunkList,DrunkMessaging,SoberMessaging,logIn,Preferences,Home,Loading,Initial,SSID,ErrorView
    }
    
    var malePreference:Bool
    var femalePreference:Bool
    var other:Bool
    var viewController:UIViewController?
    var viewState:viewStates
    var helpState:helpStates
    var userLatitude: Double
    var userLongitude: Double
    var userAltitude:Double
    var sUsername:String
    let soberStandByUpdate:Double
    let fastUpdate:Double
    var userTimer:Timer
    var dictTimer:Timer
    var CoordinatePair:String
    var loadingToMapDrunk:Bool
    var needHelp:Bool
    var offerHelp:Bool
    var helpLoc:String
    var helpName:String
    var IP:String
    var messageFrom:String
    var messageTo:String
    var userGender:String
    var lastRequestTime:Double
    var lastReceivedTime:Double
    var cannotSendMessage:Bool
    var conn:String
    var dictOfReq:[Int:(URL,Date,Int)]
    var urlReqNo:Int
    var currentBSSID:String
    var emerDoneDrunkBool:Bool
    var emerDoneSoberBool:Bool
    var lastError:String
    // var holdTraffic:Bool
    
    
    
    private init() {
        sUsername = ""
        userLatitude = -1.0
        userLongitude = -1.0
        userAltitude = -1.0
        helpState = helpStates.OK
        soberStandByUpdate = 10.0
        fastUpdate = 3.0
        userTimer = Timer()
        dictTimer = Timer()
        CoordinatePair = ""
        loadingToMapDrunk = false
        needHelp = false
        offerHelp = false
        helpLoc = ""
        helpName = ""
        //IP = "https://custom-7ufa.frb.io"
        IP = "http://140.233.199.168"
        viewState = viewStates.None
        viewController = nil
        malePreference = false
        femalePreference = false
        other = false
        messageTo = ""
        messageFrom = ""
        userGender = ""
        lastRequestTime = 0.0
        lastReceivedTime = 0.0
        cannotSendMessage = false
        conn = "yes"
        dictOfReq = [Int:(URL,Date,Int)]()
        urlReqNo = 0
        currentBSSID = ""
        emerDoneDrunkBool = true
        emerDoneSoberBool = true
        lastError = ""
    }
    
    
    // Separate Home view controller into 2 home screens!
    // Read in tag
    
    
    static let shared = Core()
    
    func gotLocation(latitude:Double,longitude:Double,altitude:Double){
        userLatitude = latitude
        userLongitude = longitude
        userAltitude = altitude
    }
    
    
    func periodicLocUpdate(time:Double){
        userTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(serverUpdateLocation), userInfo: nil, repeats: true)
        userTimer.fire()
    }
    
    func stopTimer(timer:Timer){
        if timer.isValid{
            timer.invalidate()
        }
    }
    
    @objc func serverUpdateLocation(){
        CoordinatePair = getCoordinatePair(latitude: userLatitude, longitude: userLongitude, altitude: userAltitude)
        
        let dictBSSID:[String:String] = getWIFIInformation()
        if dictBSSID["BSSID"] != nil{
            let BSSID = dictBSSID["BSSID"]?.replacingOccurrences(of: ":", with: "-")
            let hyphenPos = BSSID?.range(of: "-", options: String.CompareOptions.backwards, range: nil, locale: nil)
            currentBSSID = (BSSID?.substring(to: (hyphenPos?.lowerBound)!))!
        }
        print(currentBSSID)
        let userLocURL = URL(string: IP+"/update.php?user="+sUsername+"&loc="+CoordinatePair+"&conn="+conn+"&bssid="+currentBSSID)
        sendServerRequest(url:userLocURL!)
    }
    
    func getWIFIInformation() -> [String:String]{
        var informationDictionary = [String:String]()
        let informationArray:NSArray? = CNCopySupportedInterfaces()
        if let information = informationArray {
            let dict:NSDictionary? = CNCopyCurrentNetworkInfo(information[0] as! CFString)
            if let temp = dict {
                informationDictionary["SSID"] = String(describing: temp["SSID"]!)
                informationDictionary["BSSID"] = String(describing: temp["BSSID"]!)
                return informationDictionary
            }
        }
        
        return informationDictionary
    }
    
    func getCoordinatePair(latitude:Double , longitude:Double,altitude:Double) -> String{
        // helper function that creates string of coordinates for server
        let strlatitude = String(latitude)
        let strlongitude = String(longitude)
        let straltitude = String(altitude)
        return strlatitude+"_"+strlongitude+"_"+straltitude
    }
    
    func setViewState(newState:viewStates,newController:UIViewController? = nil){
        viewState = newState
        viewController = newController
    }
    
    
    func coreResendRequest() {
        for key in dictOfReq.keys{
            dictOfReq[key]?.2 = 0
        }
        checkDictionaryOfRequestsTimer()
            
    }
    
    func coreDeleteDict(){
        for key in dictOfReq.keys{
            dictOfReq.removeValue(forKey: key)
        }
    }
    
    // disable button after pressed
    // enable on viewDidAppear
    
    
    // try to connect BOOL (TRUE)
    // before popup set to false
    // send server connect -> if false, return
    // have multiple options on pop up view, try again, or done (kick out)
    // dont send requests while windows up
    // set true right after popup
    
    func sendServerRequest(url:URL,requestNum:Int? = -1) {
        // URLSession background sessions for downloads while app is not in use?
        // URLSession.default... to obtain data incrementally
        
        var newURL = url
        var thisReqNo:Int //= requestNum
        if url.absoluteString.range(of: "update.php") == nil && requestNum == -1{
            urlReqNo+=1
            thisReqNo = urlReqNo
            let startTime = Date()
            dictOfReq[thisReqNo] = (url,startTime,1)
        } else {
            thisReqNo = requestNum!
        }
        newURL = URL(string: url.absoluteString+"&rqno="+String(thisReqNo))!
        let task = URLSession.shared.dataTask(with: newURL)
        { (data,response,error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.serverError(error: error!)
                }
            } else {
                // where webpage content is stored, sent to server receive to deal with it
                let htmlContent = NSString(data: data!,encoding: String.Encoding.utf8.rawValue)!
                DispatchQueue.main.async
                    {
                        self.serverReceive(receivedInfo: String(htmlContent))
                }
            }
        }
        task.resume()
    }

    func serverError(error:Error){
        print("An error has occured")
    }

    func serverReceive(receivedInfo:String){
        helpList.removeAll()
        if receivedInfo.hasPrefix("<"){
            lastError = receivedInfo
            
            if viewState == viewStates.logIn {
                (self.viewController as! ViewController).performSegue(withIdentifier: "loginSegueToError", sender: self)
            } else if viewState == viewStates.Initial {
                (self.viewController as! InitialViewController).performSegue(withIdentifier: "initialSegueToError", sender: self)
            } else if viewState == viewStates.Home {
                (self.viewController as! HomeViewController).performSegue(withIdentifier: "homeSegueToError", sender: self)
            } else if viewState == viewStates.Loading {
                (self.viewController as! LoadingViewController).performSegue(withIdentifier: "loadingSegueToError", sender: self)
            } else if viewState == viewStates.DrunkMessaging {
                (self.viewController as! DrunkMapViewController).performSegue(withIdentifier: "drunkSegueToError", sender: self)
            } else if viewState == viewStates.SoberMessaging {
                (self.viewController as! SoberMapViewController).performSegue(withIdentifier: "soberSegueToError", sender: self)
            } else if viewState == viewStates.DrunkList {
                (self.viewController as! DisplayList).performSegue(withIdentifier: "displayListSegueToError", sender: self)
            }
        }
        let lines = receivedInfo.components(separatedBy: "|")
        for line in lines{
            print(line)
            if line == ""{
                continue
            }
            let tokens = line.components(separatedBy: " ")
            let command:String = tokens[0]
            switch command {
            case "HR": // help request - helpee making help request (appears on helper list)
            
                if helpList.contains(tokens[1]){
                    break
                }
                helpList.append(tokens[1]) // helpee
            case "HP": // helping - who helper is helping (appears on helper's map)
                helpName = tokens[1] // helpee
                helpLoc = tokens[2].replacingOccurrences(of: "%", with: " ")
                break
            case "HB": // helped by - who is helping helpee (appears on helpee's map)
                //helpState = helpStates.helperFound
                if Core.shared.viewState == Core.viewStates.Loading{
                    (self.viewController as! LoadingViewController).loadingToMapSegue()
                }
                helpName = tokens[1]
                helpLoc = tokens[2].replacingOccurrences(of: "%", with: " ")
                
                break
            case "DN":
                if self.viewState == viewStates.DrunkMessaging{
                    if tokens[1] == "Fin"{
                        (self.viewController as! DrunkMapViewController).messagingDisplay.text.append("HELPER ENDED SESSION") // HEREEEEE
                        emerDoneDrunkBool = false
                        let finishHelpedURL = URL(string: IP+"/helpFinish.php?user="+Core.shared.sUsername)
                        sendServerRequest(url: finishHelpedURL!)
                        cannotSendMessage = true
                        let when = DispatchTime.now() + 2
                        if viewState == viewStates.Home {break}
                        let dwi = DispatchWorkItem {
                            (self.viewController as! DrunkMapViewController).autoSegueHomeDrunk()
                        }
                        if viewState == viewStates.DrunkMessaging{
                        DispatchQueue.main.asyncAfter(deadline: when, execute: dwi)
                        }
                    }
                    else {
                        (self.viewController as! DrunkMapViewController).messagingDisplay.text.append("HELPER'S CONNECTION TO SERVER WAS LOST ")
                        cannotSendMessage = true
                        conn = "no"
                    }
                } 
                if self.viewState == viewStates.SoberMessaging{
                    if tokens[1] == "Fin"{ // HEREEEE
                        (self.viewController as! SoberMapViewController).messageViewSob.text.append("HELPEE ENDED SESSION")
                        emerDoneSoberBool = false
                        let finishHelpedURL = URL(string: IP+"/helpFinish.php?user="+Core.shared.sUsername)
                        sendServerRequest(url: finishHelpedURL!)
                        cannotSendMessage = true
                        let when = DispatchTime.now() + 2
                        if viewState == viewStates.DrunkList {break}
                        let dwi = DispatchWorkItem {
                            (self.viewController as! SoberMapViewController).autoSegueHomeSober()
                        }
                        if viewState == viewStates.SoberMessaging{
                        DispatchQueue.main.asyncAfter(deadline: when, execute: dwi)
                        }
                    }
                    else {
                        (self.viewController as! SoberMapViewController).messageViewSob.text.append("HELPEE'S CONNECTION TO SERVER WAS LOST")
                        cannotSendMessage = true
                        conn = "no"
                    }
                }
                break
            case "AK": // &rqno=
                // CHANGE SEGUE STRUCTURE TO HERE
                print(dictOfReq)
                print(urlReqNo)
                print("\n")
                print(Int(tokens[1])!)
                let urlTupleInQuestion:(URL,Date,Int)? = dictOfReq[Int(tokens[1])!]
                dictOfReq.removeValue(forKey: Int(tokens[1])!)
                if urlTupleInQuestion == nil {break}
                print(urlTupleInQuestion!)
                if urlTupleInQuestion!.0.absoluteString.range(of: "regLogin.php") != nil{
                    if viewState == viewStates.logIn{
                        (self.viewController as! ViewController).performSegue(withIdentifier: "regLoginSegue", sender: self) }
                    else if viewState == viewStates.Initial{
                        (self.viewController as! InitialViewController).performSegue(withIdentifier: "segueToHome", sender: self)
                    }
                } else if urlTupleInQuestion!.0.absoluteString.range(of: "help.php") != nil {
                    if viewState == viewStates.Home{
                    (self.viewController as! HomeViewController).performSegue(withIdentifier: "helpSegue", sender: self) }
                } else if urlTupleInQuestion!.0.absoluteString.range(of: "soberLogin.php") != nil {
                    if viewState == viewStates.Home{
                        (self.viewController as! HomeViewController).helperSegue()}
                } else if urlTupleInQuestion!.0.absoluteString.range(of: "soberLogout.php") != nil {
                    if viewState == viewStates.DrunkList{
                        (self.viewController as! DisplayList).performSegue(withIdentifier: "soberLogoutSegue", sender: self) }
                } else if urlTupleInQuestion!.0.absoluteString.range(of: "accept.php") != nil {
                    if viewState == viewStates.DrunkList{
                        (self.viewController as! DisplayList).performSegue(withIdentifier: "selectSegue", sender: self) }
                } else if urlTupleInQuestion!.0.absoluteString.range(of: "soberEmerDone.php") != nil {
                    if viewState == viewStates.SoberMessaging{
                        (self.viewController as! SoberMapViewController).performSegue(withIdentifier: "soberSegueTable", sender: self) }
                } else if urlTupleInQuestion!.0.absoluteString.range(of: "drunkEmerDone.php") != nil {
                    if viewState == viewStates.DrunkMessaging{
                        (self.viewController as! DrunkMapViewController).performSegue(withIdentifier: "drunkSegueHome", sender: self) }
                } else if urlTupleInQuestion!.0.absoluteString.range(of: "cancelHelp.php") != nil {
                    if viewState == viewStates.Loading{
                        (self.viewController as! LoadingViewController).performSegue(withIdentifier: "cancelHelpSegue", sender: self) }
                }
                
                
                // DISABLE BUTTON
                break
            case "CA":
                dictOfReq.removeValue(forKey: Int(tokens[1])!)
                print("action cancelled by server")
            case "MG":
                let index = line.index(line.startIndex, offsetBy: 5+tokens[1].characters.count+tokens[2].characters.count)
                let message:String = line.substring(from: index)
                if self.viewState == viewStates.DrunkMessaging && tokens[2] != Core.shared.sUsername{
                    (self.viewController as! DrunkMapViewController).messagingDisplay.text.append(helpName + " (" + helpLoc + ")" +  " : " + message + "\n")
                }
                if self.viewState == viewStates.SoberMessaging && tokens[2] != Core.shared.sUsername{
                    (self.viewController as! SoberMapViewController).messageViewSob.text.append(helpName + " (" + helpLoc + ")" +  " : " + message + "\n")
                }
                break
            case "BS":
                print(tokens[1])
            case "ER":
                let index = line.index(line.startIndex, offsetBy: 3)
                let message:String = line.substring(from: index)
                print(message)
            default: // "HRack" - request reached server (print on loading page)
                print("tag not recognized"+tokens[0])
                break
            }
        }
            if self.viewState == viewStates.DrunkList {
                    (self.viewController as! DisplayList).updateTableView()
            }
        }
    
    func checkDictionaryOfRequestsTimer(){
        dictTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkDictionaryOfRequests), userInfo: nil, repeats: true)
        dictTimer.fire()
    }
    
    
    @objc func checkDictionaryOfRequests(){
        if dictOfReq.capacity != 0 {
            for key in dictOfReq.keys{
                let endTime = Date()
                let timeInterval:Double = endTime.timeIntervalSince(dictOfReq[key]!.1)
                if timeInterval > 3.0 {
                    print(dictOfReq)
                    dictOfReq[key]!.2 += 1
                    dictOfReq[key]!.1 = endTime
                    sendServerRequest(url: dictOfReq[key]!.0,requestNum: dictOfReq[key]!.2)
                } else {
                    continue
                }
                if dictOfReq[key]!.2 > 3 {
                    if viewState == viewStates.Home{
                        (self.viewController as! HomeViewController).animateIn()
                    } else if viewState == viewStates.logIn {
                        (self.viewController as! ViewController).animateIn()
                    } else if viewState == viewStates.DrunkMessaging {
                        (self.viewController as! DrunkMapViewController).animateIn()
                    } else if viewState == viewStates.SoberMessaging {
                        (self.viewController as! SoberMapViewController).animateIn()
                    } else if viewState == viewStates.DrunkList {
                        (self.viewController as! DisplayList).animateIn()
                    } else if viewState == viewStates.Loading {
                        (self.viewController as! LoadingViewController).animateIn()
                    } else if viewState == viewStates.Initial {
                        (self.viewController as! InitialViewController).animateIn()
                    }
                    dictOfReq[key]!.2 = 0
                    dictTimer.invalidate()
                }
            }
                    
                    // remove from dictionary BUT CHECK RESET FIRST
                    // IT KEEPS RESENDING POPUP
                    // LOADING ANIMATION WHILE WAITING FOR SERVER 
                    // print("NOW REMOVING")
                    //MAYBE DONT CLEAR AND DO SOMETHING ELSE!!!!
                    //dictOfReq[key]
                    //dictOfReq.removeValue(forKey: key)
                    
                    //INCORPORATE RSSI for accurate loc
                    
                
        }
    }
}



