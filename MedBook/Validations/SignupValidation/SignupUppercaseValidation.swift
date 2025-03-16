//
//  SignupUppercaseValidation.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

class SignupUppercaseValidation: SignupValidation {
    
    private var text: String?
    
    init(text: String?){
        self.text = text
    }
    
    func isValidationPassed() -> Bool {
        return self.text?.contains { $0.isUppercase} ?? false
    }
}
