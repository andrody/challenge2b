//
//  InfoViewController.swift
//  Ninja Goo
//
//  Created by Bruno Rolim on 29/05/15.
//  Copyright (c) 2015 Koruja. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import StoreKit


class InfoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var dismissview: UIView!
    
    var URLs = [
        "fb://profile/930030573727200", // App
        "https://www.facebook.com/ninjagoogame?ref=aymt_homepage_panel" // Website if app fails
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        var dismissV = UITapGestureRecognizer(target: self, action: Selector("dismiss"))
        dismissview.addGestureRecognizer(dismissV)
        
    }
    
    func dismiss(){
    
    
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.vidro.hidden = true
        
        println("BACK TO MEnu")
        
    }
    
    @IBAction func contactLink(sender: UIButton) {
    
        // Email Subject
        var emailTitle: String = "Feedback"
        // Email Content
        var messageBody: String = "Feature request or bug report?";
        // To address
        var toRecipents = ["koruja.ninjagoo@gmail.com"]
        
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self;
        mc.setSubject(emailTitle)
        mc.setMessageBody("Contact Koruja", isHTML: false)
        mc.setToRecipients(toRecipents)
        //[mc setSubject:emailTitle];
        //[mc setMessageBody:messageBody isHTML:NO];
        //[mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        self.presentViewController(mc, animated: true, completion: nil)
        //[self presentViewController:mc animated:YES completion:NULL];
        
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
    
    
    @IBAction func faceLink(sender: UIButton) {
    
        self.tryURL(URLs)
    }
    
   
}
