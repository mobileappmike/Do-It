//
//  Category.swift
//  Do It
//
//  Created by Michael Miles on 11/27/18.
//  Copyright © 2018 Michael Miles. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
