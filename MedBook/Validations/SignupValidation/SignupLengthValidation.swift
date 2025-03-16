//
//  SignupLengthValidation.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

class SignupLengthValidation: SignupValidation {
    
    private var text: String?
    
    init(text: String?){
        self.text = text
    }
    
    func isValidationPassed() -> Bool {
        
        guard let text = self.text, text.count > 0 else {
            return false
        }
        
        if text.count >= 8 {
            return true
        }
        
        return false
    }
}
