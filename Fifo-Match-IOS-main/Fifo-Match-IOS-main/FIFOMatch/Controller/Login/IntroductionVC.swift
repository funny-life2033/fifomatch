//
//  ViewController.swift
//  FIFOMatch
//
//  Created by Subhash Sharma on 01/03/22.
//

import UIKit

class IntroductionVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        
    }
    
    @IBAction func btn_SignIn(_ sender: UIButton) {
        openViewController(controller: VCLogin.self, storyBoard: .mainStoryBoard) { (vc) in
        }}
        
        @IBAction func btn_Register(_ sender: UIButton) {
            openViewController(controller: SignupVC.self, storyBoard: .mainStoryBoard) { (vc) in
              vc.fromIntro = true
            }
        }
        
    }
