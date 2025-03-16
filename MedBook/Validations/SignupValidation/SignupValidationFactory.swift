//
//  SignupValidationFactory.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

enum SignupValidationTypes {
    case Length
    case SpecialCharacter
    case UpperCase
    case Email
}

class SignupValidationFactory {
    
    func checkValidation(type: SignupValidationTypes, user: UserDetail?) -> SignupValidation {
        
        switch type {
            
        case .Length:
            return SignupLengthValidation(text: user?.password)
        case .Email:
            return SignupEmailValidation(userEmail: user?.email)
        case .SpecialCharacter:
            return SignupSpecialCharacterValidation(text: user?.password)
        case .UpperCase:
            return SignupUppercaseValidation(text: user?.password)
        }
    }
}
