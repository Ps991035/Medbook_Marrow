//
//  SignupEmailValidation.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

class SignupEmailValidation: SignupValidation {
    
    private var email: String?
    
    init(userEmail: String?){
        self.email = userEmail
    }
    
    func isValidationPassed() -> Bool {
        return email?.isValidEmail() ?? false
    } 
}
