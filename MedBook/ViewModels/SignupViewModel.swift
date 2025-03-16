//
//  SignupViewModel.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

protocol SignupViewModelDelegate: AnyObject {
    func onDataFetched(countries: [MBCountryListModel]?)
}

class SignupViewModel {
    
    /**
     *  The structure of Signup view is created here. Here all the information of validations are decided, Here We get the details of Country List through Factory,adapter and repository.
     */
    
    private var isLenghtValidationPassed: Bool = false
    private var isEmailValidationPassed: Bool = false
    private var isUpperCaseValidationPassed: Bool = false
    private var isSpecialCharacterValidationPassed: Bool = false
    
    weak var delegate: SignupViewModelDelegate?
    private var repository: MBDataRepository?
    private var adapter: MBAdapter?
    
    init(repository: MBDataRepository?,adapter: MBAdapter?){
        self.repository = repository
        self.adapter = adapter
    }
    
    /**
     *  Check all the password validations that are required for the user to signup.
     */
    
    func getUserPasswordValidationStatusModel(password: String?) -> SignupValidationModel {
        
        let userDetail = UserDetail(password: password)
        
        self.isLenghtValidationPassed = SignupValidationManager.shared.checkLenghtValidation(user: userDetail)
        self.isSpecialCharacterValidationPassed = SignupValidationManager.shared.checkSpecialCharacterValidation(user: userDetail)
        self.isUpperCaseValidationPassed = SignupValidationManager.shared.checkUpperCaseValidation(user: userDetail)
        
        return SignupValidationModel(isLenghtValidationPassed: self.isLenghtValidationPassed, isUpperCaseValidationPassed: self.isUpperCaseValidationPassed, isSpecialCharacterValidationPassed: self.isSpecialCharacterValidationPassed)
        
    }
    
    func getUserEmailValidationStatusModel(email: String?) {
        let userDetail = UserDetail(email: email)
        self.isEmailValidationPassed = SignupValidationManager.shared.checkEmailValidation(user: userDetail)
    }
    
    func isAllPasswordValidationPassed() -> Bool {
        
        if isLenghtValidationPassed,isUpperCaseValidationPassed,isSpecialCharacterValidationPassed,isEmailValidationPassed {
            return true
        }
        return false
    }
    
    /**
     *  Get the list of countries.
     */
    
    func fetchData() {
        
        self.repository?.fetch({ result, error in
            if let _result = result {
                self.setData(result: _result)
            }
        })
    }
    
    func setData(result: [AnyHashable:Any]) {
        
        let countries = self.adapter?.getData(result: result) ?? []
        self.delegate?.onDataFetched(countries: countries)
    }
    
    func isAllCondtionMetForNewUser(email: String?) -> Bool {
        
        self.getUserEmailValidationStatusModel(email: email)
        
        if isAllPasswordValidationPassed() && isUniqueEmail(email: email) {
            return true
        }
        return false
    }
    
    /**
     *  Check whether the email which the user enters is already being used or not
     */
    
    func isUniqueEmail(email: String?) -> Bool {
        
        if let data = MBDBHelper.shared.getUserDetailDBModel(primaryKey: email),data.email?.count ?? 0 > 0 {
            return false
        }
        return true
    }
    
    func saveUserData(userData: UserDetail?) {
        MBDBHelper.shared.saveUserDetail(userDetail: userData)
    }
    
}
