//
//  Hobbie.swift
//  LiveIt
//
//  Created by Qahtan on 9/27/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit

class Hobbie: NSObject {
    let name: String
    let diffeclty: Int
    let goal:String
    let id: String
    let unit:String
    var userID: String?
    
    init(name: String,diffeclty:Int,goal:String,id:String,unit:String) {
        self.name = name
        self.diffeclty = diffeclty
        self.id = id
        self.unit = unit
        self.goal = goal
    }
    init(id:String,dict:[String:Any]) {
        self.id = id
        self.name = dict["name"] as? String ?? ""
        self.diffeclty = dict["difficulty"] as? Int ?? 0
//        self.id = dict[""]
        self.unit = dict["unit"] as? String ?? ""
        self.goal = dict["goal"] as? String ?? ""
    }
}
