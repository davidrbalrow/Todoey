//
//  Item.swift
//  Todoey
//
//  Created by DAVID BARLOW on 12/14/18.
//  Copyright © 2018 DAVID BARLOW. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
