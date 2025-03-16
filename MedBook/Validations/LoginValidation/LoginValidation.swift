//
//  LoginValidation.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

struct LoginValidationResult {
    var success: Bool = false
    var error: String?
}

struct LoginValidation {
    
    func validateUserInput(userEmail: String?, userPassword: String?) -> LoginValidationResult {
        
        if((userEmail?.isEmpty) ?? false || (userPassword?.isEmpty) ?? false){
            return LoginValidationResult(success: false, error: MBConstants().User_Email_Password_Not_Empty)
        }
        
        if !(userEmail?.isValidEmail() ?? false) {
            return LoginValidationResult(success: false, error: MBConstants().User_Email_Wrong_Format)
        }
        
        return LoginValidationResult(success: true,error: nil)
        
    }
    
}
