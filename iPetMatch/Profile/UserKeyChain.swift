//
//  UserKeyChain.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 26/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

struct UserKeyChain {
    
    struct Schema {
        
        static let loginEmail = "loginEmail"
        
        static let password = "password"
        
        static let QBLogin = "QBLogin"
        
    }
    
    let loginEmail: String
    
    let password: String
    
    let QBLogin: String

}
