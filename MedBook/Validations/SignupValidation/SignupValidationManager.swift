//
//  SignupValidationManager.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation

final class SignupValidationManager {
    
    static let shared = SignupValidationManager()
    
    private init() {}
    
    /**
     *  Check All the validations that are required during Signup
     */
    
    func checkEmailValidation(user: UserDetail?) -> Bool {
        return SignupValidationFactory().checkValidation(type: .Email, user: user).isValidationPassed()
    }
    
    func checkLenghtValidation(user: UserDetail?) -> Bool {
        return SignupValidationFactory().checkValidation(type: .Length, user: user).isValidationPassed()
    }
    
    func checkUpperCaseValidation(user: UserDetail?) -> Bool {
        return SignupValidationFactory().checkValidation(type: .UpperCase, user: user).isValidationPassed()
    }
    
    func checkSpecialCharacterValidation(user: UserDetail?) -> Bool {
        return SignupValidationFactory().checkValidation(type: .SpecialCharacter, user: user).isValidationPassed()
    }
    
}
