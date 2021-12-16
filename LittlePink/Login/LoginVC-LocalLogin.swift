//
//  LoginVC-LocalLogin.swift
//  LittlePink
//
//  Created by mac on 2021/12/10.
//

import Foundation

extension LoginVC{
    
    @objc func localLogin(){
        
        let config = JVAuthConfig()
        config.appKey = kJAppKey
        config.authBlock = { _ in
            if JVERIFICATIONService.isSetupClient(){
                JVERIFICATIONService.preLogin(5000) { (result) in
                    print(result)
                        if let result = result {
                           if let code = result["code"], let message = result["message"] {
                               print("preLogin result: code = \(code), message = \(message)")
                           }
                        }
                     }
            }
        }
        JVERIFICATIONService.setup(with: config)
        
    }
}
