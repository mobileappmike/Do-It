//
//  Item.swift
//  Do It
//
//  Created by Michael Miles on 11/27/18.
//  Copyright © 2018 Michael Miles. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //in Realm, parent categories aren't assumed and inheritance must be set up manually
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
