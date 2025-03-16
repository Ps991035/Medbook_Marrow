//
//  MBLoginViewController.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation
import UIKit

class MBLoginViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var uvLogin: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    
    private var userData = UserDetail()
    
    private lazy var viewModel: LoginViewModel? = {
        let viewModel = LoginViewModel()
        return viewModel
    }()
    
    /**
     *  This class is responsible for Login for the users.User can enter the email and password and if both gets saified then user will be redirected to Home View.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordTextField.isSecureTextEntry = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        
        self.contentView.backgroundColor = MBUtility.hexStringToUIColor(hex: "#EEEEEE")
        self.setupLabelUI()
        self.setupButtonUI()
        self.uvLogin.layer.borderWidth = 1
        self.uvLogin.layer.borderColor = UIColor.black.cgColor
        self.uvLogin.layer.cornerRadius = 12
        self.uvLogin.backgroundColor = MBUtility.hexStringToUIColor(hex: "#FFFFFF")
    }
    
    private func setupLabelUI(){
        self.lblWelcome.text = MBConstants().Welcome + ","
        self.lblLogin.text = MBConstants().Login_To_Continue
        self.lblLogin.textColor = UIColor.black.withAlphaComponent(0.7)
        self.lblWelcome.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        self.lblLogin.font = UIFont.systemFont(ofSize: 32, weight: .regular)
    }
    
    private func setupButtonUI() {
        self.uvLogin.layer.borderWidth = 2
        self.uvLogin.layer.cornerRadius = 12
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if viewModel?.isValidUser(userData: self.userData) ?? false {
            
            if let vc = UIStoryboard(name: MBConstants().Main, bundle: nil).instantiateViewController(withIdentifier: MBConstants().MBHomeViewController) as? MBHomeViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            self.showToast(message: MBConstants().Please_Enter_Correct_Email_Password)
        }
    }
    
    @IBAction func showHidePassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    
}

extension MBLoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            
        case emailTextField:
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            self.userData.email = updatedText
            
        case passwordTextField:
            
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            self.userData.password = updatedText
            
        default:
            break
        }
        return true
    }
}
