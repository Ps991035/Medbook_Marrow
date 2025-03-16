//
//  MBSignupViewController.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation
import UIKit

class MBSignupViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblSignup: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imgLengthValidation: UIImageView!
    @IBOutlet weak var imgUpperCaseValidation: UIImageView!
    @IBOutlet weak var imgSpecialCharacterValidation: UIImageView!
    @IBOutlet weak var lblLengthValidation: UILabel!
    @IBOutlet weak var lblUpperCaseValidation: UILabel!
    @IBOutlet weak var lblSpecialCharacterValidation: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var uvSignup: UIView!
    
    private var repository: MBDataRepository?
    private var factory: MBFactory?
    private var adapter: MBAdapter?
    private var countries: [MBCountryListModel]?
    private var userData = UserDetail()
    
    private lazy var viewModel: SignupViewModel? = {
        let viewModel = SignupViewModel(repository: getRepository(), adapter: getMBAdapter())
        viewModel.delegate = self
        return viewModel
    }()
    
    
    /**
     *  This class is responsible for signup for the new users.User can enter the email and password and select the country, afterthat if all the validations will satify for the user then the user will get signup and redirected to Login Page
     */
    
    private var validationModel: SignupValidationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.initializeFactoryWithParam()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.passwordTextField.isSecureTextEntry = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        
        self.contentView.backgroundColor = MBUtility.hexStringToUIColor(hex: "#EEEEEE")
        self.setupImageUI()
        self.setupLabelUI()
        self.setupButtonUI()
        self.uvSignup.layer.borderWidth = 1
        self.uvSignup.layer.borderColor = UIColor.black.cgColor
        self.uvSignup.layer.cornerRadius = 12
        self.uvSignup.backgroundColor = MBUtility.hexStringToUIColor(hex: "#FFFFFF")
        
    }
    
    private func setupImageUI(){
        
        DispatchQueue.main.async {
            
            if self.validationModel?.isLenghtValidationPassed ?? false {
                self.imgLengthValidation.tintColor = .blue
                self.imgLengthValidation.image = UIImage(systemName: "checkmark.square.fill")
            }else{
                self.imgLengthValidation.tintColor = .black
                self.imgLengthValidation.image = UIImage(systemName: "square")
            }
            
            if self.validationModel?.isUpperCaseValidationPassed ?? false {
                self.imgUpperCaseValidation.tintColor = .blue
                self.imgUpperCaseValidation.image = UIImage(systemName: "checkmark.square.fill")
            }else{
                self.imgUpperCaseValidation.tintColor = .black
                self.imgUpperCaseValidation.image = UIImage(systemName: "square")
            }
            
            if self.validationModel?.isSpecialCharacterValidationPassed ?? false {
                self.imgSpecialCharacterValidation.tintColor = .blue
                self.imgSpecialCharacterValidation.image = UIImage(systemName: "checkmark.square.fill")
            }else{
                self.imgSpecialCharacterValidation.tintColor = .black
                self.imgSpecialCharacterValidation.image = UIImage(systemName: "square")
            }
        }
    }
    
    private func setupLabelUI(){
        self.lblWelcome.text = MBConstants().Welcome
        self.lblSignup.text = MBConstants().Sign_Up_To_Continue
        self.lblSignup.textColor = UIColor.black.withAlphaComponent(0.7)
        self.lblLengthValidation.text = MBConstants().At_Least_8_Characters
        self.lblUpperCaseValidation.text = MBConstants().Must_Contain_An_Upper_Case_Letter
        self.lblSpecialCharacterValidation.text = MBConstants().Contains_A_Special_Character
        self.lblWelcome.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        self.lblSignup.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        self.lblLengthValidation.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.lblUpperCaseValidation.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.lblSpecialCharacterValidation.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    private func setupButtonUI() {
        self.uvSignup.layer.borderWidth = 2
        self.uvSignup.layer.cornerRadius = 12
    }
    
    private func initializeFactoryWithParam() {
        
        self.factory = MBFactory(params: nil)
        self.refreshData()
    }
    
    private func refreshData() {
        self.viewModel?.fetchData()
    }
    
    private func getRepository() -> MBDataRepository? {
        return self.factory?.getRepository(apiType: .CountryList)
    }
    
    private func getMBAdapter() -> MBAdapter {
        return MBDataAdapter()
    }
    
    @IBAction func showHidePassword(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnSignup(_ sender: Any) {
        
        if viewModel?.isAllCondtionMetForNewUser(email: userData.email) ?? false {
            if let vc = UIStoryboard(name: MBConstants().Main, bundle: nil).instantiateViewController(withIdentifier: MBConstants().MBLoginViewController) as? MBLoginViewController {
                
                let userData = UserDetail(email: userData.email,password: userData.password, country: userData.country)
                self.viewModel?.saveUserData(userData: userData)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            self.showToast(message: MBConstants().Email_Password_Wrong_Format)
        }
        
    }
    
}

extension MBSignupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            
        case emailTextField:
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            self.userData.email = updatedText
            
        case passwordTextField:
            
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            self.userData.password = updatedText
            self.validationModel = viewModel?.getUserPasswordValidationStatusModel(password: updatedText)
            self.setupImageUI()
            
        default:
            break
        }
        return true
    }
}

extension MBSignupViewController: SignupViewModelDelegate {
    
    func onDataFetched(countries: [MBCountryListModel]?) {
        self.countries = countries
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
}

extension MBSignupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries?[row].country
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = countries?[row].country
        self.userData.country = selectedCountry
        
        debugPrint("Selected country: \(selectedCountry ?? "")")
    }
    
}
