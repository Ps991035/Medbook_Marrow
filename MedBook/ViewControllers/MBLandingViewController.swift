//
//  ViewController.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import UIKit

class MBLandingViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLanding: UIImageView!
    
    
    /**
     *  This class is the main entry point for the new user. From here they can Signup or Login.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        
        self.contentView.backgroundColor = MBUtility.hexStringToUIColor(hex: "#EEEEEE")
        self.lblTitle.text = MBConstants().MedBook
        self.lblTitle.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        self.btnSignup.setTitle(MBConstants().Signup, for: .normal)
        self.btnSignup.backgroundColor = MBUtility.hexStringToUIColor(hex: "FFFFFF")
        self.btnSignup.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        self.btnSignup.layer.borderColor = UIColor.black.cgColor
        self.btnSignup.titleLabel?.tintColor = UIColor.black
        self.btnSignup.layer.borderWidth = 2
        self.btnSignup.layer.cornerRadius = 12
        
        self.btnContinue.setTitle(MBConstants().Login, for: .normal)
        self.btnContinue.backgroundColor = MBUtility.hexStringToUIColor(hex: "FFFFFF")
        self.btnContinue.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        self.btnContinue.layer.borderColor = UIColor.black.cgColor
        self.btnContinue.titleLabel?.tintColor = UIColor.black
        self.btnContinue.layer.borderWidth = 2
        self.btnContinue.layer.cornerRadius = 12
        
    }
    
    
    @IBAction func btnSignup(_ sender: Any) {
        
        if let vc = UIStoryboard(name: MBConstants().Main, bundle: nil).instantiateViewController(withIdentifier: MBConstants().MBSignupViewController) as? MBSignupViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnLogin(_ sender: Any) {
        
        if let vc = UIStoryboard(name: MBConstants().Main, bundle: nil).instantiateViewController(withIdentifier: MBConstants().MBLoginViewController) as? MBLoginViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

