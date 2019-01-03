//
//  DisplayList.swift
//  STEM1.0
//
//  Copyright © 2017 John Anthony Bowllan. All rights reserved.
//

import UIKit

//List of people that need help
var helpList = [String]()
var doneHelping:Bool = true

class DisplayList: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var mytableview: UITableView!
     var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet var addItemView: UIView!
    
    // Define how many rows we want in our table view
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (helpList.count)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        if mytableview != nil {
        mytableview.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    @IBAction func retryRequestDisplay(_ sender: Any) {
        Core.shared.coreResendRequest()
        animateOut()
    }
    
    
    @IBAction func dismissPopUp(_ sender: Any) {
        animateOut()
        doneHelping = true
        performSegue(withIdentifier: "kickBackDisplayToLogin", sender: self)
        Core.shared.coreDeleteDict()
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
    
    
    //Populate Table View with some text
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {   /*
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell") as! CustomCell
        */
        
        let cell = self.mytableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.name.text = helpList[indexPath.row]
        
        //go through all the items in the array
        //cell.textLabel?.text = helpList[indexPath.row]
        return(cell)
    }
    
    //Allows you to delte an item by swipping left
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let deleted:String = helpList.remove(at: indexPath.row)
            declineButtonPressed(removed: deleted)
            mytableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    //COMMENT CODE !!!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        let selectedIndex = self.mytableview.indexPathForSelectedRow
        let acceptedHelpee:String = helpList[selectedIndex!.row]
        acceptButtonPressed(accepted: acceptedHelpee)
    }
    
    
    
    func declineButtonPressed(removed:String){
        let deniedRequest = URL(string: Core.shared.IP+"/decline.php?user="+Core.shared.sUsername+"&rqst="+removed)
        // read from textfield
        Core.shared.sendServerRequest(url:deniedRequest!)
    }
    
     func acceptButtonPressed(accepted:String){
         Core.shared.messageTo = accepted
         Core.shared.messageFrom = Core.shared.sUsername
         let acceptedRequest = URL(string: Core.shared.IP+"/accept.php?user="+Core.shared.sUsername+"&rqst="+accepted)
         // read from textfield
         Core.shared.sendServerRequest(url:acceptedRequest!)
         //Core.shared.stopTimer(timer: Core.shared.userTimer)
         Core.shared.periodicLocUpdate(time: Core.shared.fastUpdate)
     }
    
    @IBAction func doneHelpingButton(_ sender: Any) {
        if doneHelping == true {
            doneHelpingPressed()
        }
        doneHelping = false
    }
    
    func doneHelpingPressed(){
        //Core.shared.stopTimer(timer: Core.shared.userTimer)
        let checkingOutURL = URL(string: Core.shared.IP+"/soberLogout.php?user="+Core.shared.sUsername)
        Core.shared.sendServerRequest(url: checkingOutURL!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        mytableview.reloadData()
        Core.shared.setViewState(newState: Core.viewStates.DrunkList,newController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytableview.addSubview(self.refreshControl)
        doneHelping = true
    }
    
    func updateTableView(){
        self.refreshControl.beginRefreshing()
        handleRefresh(refreshControl: self.refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
