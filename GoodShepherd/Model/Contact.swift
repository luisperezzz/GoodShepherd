//
//  Contact.swift
//  GoodShepherd
//
//  Created by Luis Perez on 8/19/17.
//  Copyright © 2017 Term. All rights reserved.
//

import UIKit

class Contact: NSObject {
    
    var firstGivenName      : String = ""
    var secondGivenName     : String?
    var firstSurname        : String = ""
    var secondSurname       : String?
    var birthDate           : Date = Date()
    
    
    var firstName: String {
        if let _secondGivenName = secondGivenName {
            return firstGivenName+" "+_secondGivenName
        }
        return firstGivenName
    }
    
    var lastName: String {
        if let _secondSurname = secondSurname {
            return firstSurname+" "+_secondSurname
        }
        return firstSurname
    }
    
    var age: String {
        return "99" // calculate age using birthDate
    }
    
    override init() {
        super.init()
    }
    
    init(firstGivenName: String, secondGivenName: String? = nil, firstSurname: String, secondSurname: String? = nil) {
        self.firstGivenName = firstGivenName
        self.secondGivenName = secondGivenName
        self.firstSurname = firstSurname
        self.secondSurname = secondSurname
    }
    
    
    override var description : String {
        get {
            var descriptionString = "\n {"
            for object in Mirror(reflecting: self).children.flatMap({ $0 }) {
                descriptionString.append("\n  "+object.label!+" : "+"\(object.value)")
            }
            return descriptionString+"\n }"
        }
    }
 

}
