//
//  ErrorViewController.swift
//
//  Created by John Bowllan on 7/28/17.

// This file is associated to the ErrorViewController 

import UIKit

class ErrorViewController: UIViewController {

    @IBOutlet weak var errorLog: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Core.shared.setViewState(newState: Core.viewStates.ErrorView, newController: self)
        do {
            let attrStr = try NSAttributedString(
                data: Core.shared.lastError.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            errorLog.attributedText = attrStr
        } catch let error {
            print(error)
        }

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        Core.shared.setViewState(newState: Core.viewStates.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissError(_ sender: Any) {
        dismiss(animated:true,completion: nil)
    }
}
