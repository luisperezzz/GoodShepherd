//
//  ContactManager.swift
//  GoodShepherd
//
//  Created by Luis Perez on 8/15/17.
//  Copyright © 2017 Term. All rights reserved.
//

import Foundation
import Contacts
import UIKit

enum ErrorCode : Int {
    case contactAccessDenied        = 1906171414
    case contactAccessRestricted    = 1906171415
    case contactAccessCancel        = 1906171416
}


class ContactManager {
    
    static let shared = ContactManager()
    private var contactStore = CNContactStore()
    private init() {}
    
    class func requestContacts(completionHandler: @escaping ([Contact], NSError?) -> Void) {
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
                    
        case .notDetermined:
            self.shared.contactStore.requestAccess(for: .contacts, completionHandler: { (success, error) in
                if success {
                    completionHandler(self.shared.retrieveContacts(), nil)
                }
                else {
                    let error = NSError(domain: "", code: ErrorCode.contactAccessCancel.rawValue, userInfo: [NSLocalizedDescriptionKey:"Contacts use has been cancel"])
                    completionHandler([Contact](), error)
                }
            })
            
        case .authorized:
            completionHandler(self.shared.retrieveContacts(), nil)
        
        case .denied:
            let error = NSError(domain: "", code: ErrorCode.contactAccessDenied.rawValue, userInfo: [NSLocalizedDescriptionKey:"Contacts Access Denied"])
            completionHandler([Contact](), error)
        
        case .restricted:
            let error = NSError(domain: "", code: ErrorCode.contactAccessRestricted.rawValue, userInfo: [NSLocalizedDescriptionKey:"Contacts Access Restricted"])
            completionHandler([Contact](), error)
        }
        
        
        
    }
    
    private func retrieveContacts() -> [Contact] {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        var contacts = [Contact]()
        
        try? self.contactStore.enumerateContacts(with: request, usingBlock: { (contact, error) in
           
            contacts.append(Contact(firstGivenName: contact.givenName, firstSurname: contact.familyName))
        })
        return contacts
    }
    
}
