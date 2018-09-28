//
//  User.swift
//  LiveIt
//
//  Created by Qahtan on 9/28/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import Alamofire
class User: NSObject {
    let name: String
    let email: String
    let id: String
    var location:[Double]?
    let imageURL: String
    var habits :[Hobbie]? 
    init(name:String,email:String,id:String,location:[Double]?,imageURL:String) {
        self.name = name
        self.email = email
        self.id = id
        self.location = location
        self.imageURL = imageURL
//        self.location = location
    }
    init(uid:String,dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.imageURL = dictionary["image"] as? String ?? ""
        
//        self.location = dictionary["location"] as? [Double] ?? [0,0]
    }
    func fetchTheHabbites() {
        print(id)
        let url = "http://178.128.158.129/user/habits\(id)"
        print(url)
        Alamofire.request("http://178.128.158.129/user/\(id)/habits", method: .get, parameters: "" as? [String : Any], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print(err)
            case .success(let value):
                print(value)
            }
        }
    }
}
