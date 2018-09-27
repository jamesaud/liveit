//
//  Service.swift
//  LiveIt
//
//  Created by Qahtan on 9/27/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
class ServiceClass: NSObject {
    var hobbies :[Hobbie] = []
    
    func createHobbieArray() {
        let hobbiesString = ["Photography","Drawing",
                             "Origami","Writing",
                             "Cooking","",
                             "","",
                             "",""]
        for i in 1...5{
            let hobbie = Hobbie(name: hobbiesString[i], diffeclty: i)
            hobbies.append(hobbie)
        }
    }
    func felterHobbies()-> [String]{
        var arrayOfHobbiesName : [String] = []
        for i in hobbies {
            let name = i.name
            arrayOfHobbiesName.append(name)
        }
        return arrayOfHobbiesName
    }
}
