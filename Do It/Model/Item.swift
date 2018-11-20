//
//  Item.swift
//  Do It
//
//  Created by Michael Miles on 11/19/18.
//  Copyright © 2018 Michael Miles. All rights reserved.
//

import Foundation

//must make class codable (which means encodable and decodable) to use nscoder
class Item: Codable {
    var title : String = ""
    var done : Bool = false
}
