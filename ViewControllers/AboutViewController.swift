//
//  AboutViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 19/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit

//About tabView containing a brief guide and third party references / copyright information
class AboutViewController: UIViewController,UIScrollViewDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    //Navigates to website about SleepSmart
    @IBAction func NavigateToWebsite(_ sender: UIButton) {
        if let url = URL(string: "https://gidirubin.com/Work/SleepSmart") {
            UIApplication.shared.open(url)
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate=self
        
        //Sets imageView for scrolling (guide)
        self.imageView.sizeThatFits( CGSize( width: 3127.9, height: 500))
    
        self.scrollView.contentSize = CGSize( width: 3127.9, height: 500)
    }
    
 
}
