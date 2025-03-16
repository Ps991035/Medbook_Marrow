//
//  LoginViewModel.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func onUserDetailFetched(userDetail: UserDetail?)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    /**
     *  Check whether the email is valid and also verify that the entered password is correct or not
     */
    
    func isValidUser(userData: UserDetail?) -> Bool {
        
        let isValidEmail = LoginValidation().validateUserInput(userEmail: userData?.email, userPassword: userData?.password)
        
        guard let user = MBDBHelper.shared.getUserDetailDBModel(primaryKey: userData?.email) else  {
            return false
        }
        if isValidEmail.success,user.password?.lowercased() == userData?.password?.lowercased() {
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            return true
        }
        return false
    }
    
}
