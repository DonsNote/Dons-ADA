//
//  KeychainItem.swift
//  MacroC-ClientPart
//
//  Created by Kimjaekyeong on 2023/10/13.
//

import Foundation

struct KeychainItem {
    // MARK: -Types
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
    
    // MARK: -Properties
    
    let service: String
    
    private(set) var account: String
    
    let accessGroup: String?
    
    // MARK: -Intialization
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: -Keychain access
    
    func readItem() throws -> String {
      
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        guard let existingItem = queryResult as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func saveItem(_ password: String) throws {
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            try _ = readItem()
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
           
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    func deleteItem() throws {
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
    
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
    
    //MARK: - CURRENT TOKENS
    static var currentUserIdentifier: String {
        do {
            let storedIdentifier = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").readItem()
            return storedIdentifier
        } catch {
            return "currentUserIdentifier error!"
        }
    }
    
    static var currentAuthorizationCode: String {
        do {
            let storedauthorizationCode = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "authorizationCode").readItem()
            return storedauthorizationCode
        } catch {
            return "currentauthorizationCode error!"
        }
    }
    
    static var currentTokenResponse: String {
        do {
            let storedTokenResponse = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").readItem()
            return storedTokenResponse
        } catch {
            return "currentTokenResponse error!"
        }
    }
    
    static var currentEmail: String {
        do {
            let storedEmail = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "email").readItem()
            return storedEmail
        } catch {
            return "currentEmail error!"
        }
    }
    
    static var currentAppleRefreashToken: String {
        do {
            let storedIdentifier = try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "AppleRefreashToken").readItem()
            return storedIdentifier
        } catch {
            return "currentAppleRefreashToken error!"
        }
    }

    
    
    //MARK: - DELETE TOKEN FUNCTION
    static func deleteUserIdentifierFromKeychain() {
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "userIdentifier").deleteItem()
        } catch {
            print("Keychain.deleteUserIdentifierFromKeychain.error : Unable to delete userIdentifier from keychain")
        }
    }
    
    static func deleteAuthorizationCodeFromKeychain() {
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "authorizationCode").deleteItem()
        } catch {
            print("Keychain.deleteUserIdentifierFromKeychain.error : Unable to delete authorizationCode from keychain")
        }
    }
    
    static func deleteTokenResponseFromKeychain() {
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "tokenResponse").deleteItem()
        } catch {
            print("Keychain.deleteTokenResponseFromKeychain.error : Unable to delete tokenResponse from keychain")
        }
    }
    
    static func deleteEmailFromKeychain() { 
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "email").deleteItem()
        } catch {
            print("Keychain.emailFromKeychain.error : Unable to delete email from keychain")
        }
    }
    
    static func deleteAppleRefreashToken() {
        do {
            try KeychainItem(service: "com.DonsNote.MacroC-ClientPart", account: "AppleRefreashToken").deleteItem()
        } catch {
            print("Keychain.deleteAppleRefreashTokenFromKeychain.error : Unable to delete AppleRefreashToken from keychain")
        }
    }
}
