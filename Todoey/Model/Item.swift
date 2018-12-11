//
//  Item.swift
//  Todoey
//
//  Created by DAVID BARLOW on 12/11/18.
//  Copyright © 2018 DAVID BARLOW. All rights reserved.
//

import Foundation

//to be encodable class must contain standard data types

class Item: Codable {
    
    var title : String = ""
    var done : Bool = false
    
}
