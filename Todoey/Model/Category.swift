//
//  Category.swift
//  Todoey
//
//  Created by DAVID BARLOW on 12/14/18.
//  Copyright © 2018 DAVID BARLOW. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
}
