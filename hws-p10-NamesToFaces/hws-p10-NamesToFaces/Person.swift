//
//  Person.swift
//  hws-p10-NamesToFaces
//
//  Created by Terry Kuo on 2021/9/10.
//

import UIKit

//NSObject is universal base class
class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        
        self.name = name
        self.image = image
        
        
    }
    
    
}
