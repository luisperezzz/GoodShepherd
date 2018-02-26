//
//  UIViewExtension.swift
//  GoodShepherd
//
//  Created by Luis Arturo Perez Ramirez on 2/22/18.
//  Copyright © 2018 Term. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static func reuseIdentifier() -> String {
        return NSStringFromClass(classForCoder()).components(separatedBy: ".").last!
    }
    
    static func UINibForClass(_ bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: reuseIdentifier(), bundle: bundle)
    }
    
    static func nibForClass() -> Self {
        return loadNib(self)
    }
    
    static func loadNib<A>(_ owner: AnyObject, bundle: Bundle = Bundle.main) -> A {
        let nibName = NSStringFromClass(classForCoder()).components(separatedBy: ".").last!
        let nib = bundle.loadNibNamed(nibName, owner: owner, options: nil)!
        for item in nib {
            if let item = item as? A {
                return item
            }
        }
        return nib.last as! A
    }
    
    func applyShadow() {
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    
}
