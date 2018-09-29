//
//  Service.swift
//  LiveIt
//
//  Created by Qahtan on 9/27/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import Alamofire
class ServiceClass: NSObject {
    var hobbies :[Hobbie] = []
    var arrayOfUsers:[User] = []
    func createHobbieArray() {
        let hobbiesString = ["Photography","Drawing",
                             "Origami","Writing",
                             "Cooking","",
                             "","",
                             "",""]
        for i in 1...5{
//            let hobbie = Hobbie(name: hobbiesString[i], diffeclty: i)
//            hobbies.append(hobbie)
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
    func createUsers() {
        let names = ["A","B","C","D","E","F"]
        let emails = ["@A","@B","@C","@D","@E","@F"]
        for i in 1...5 {
//            let user  = User(name: names[i], email: emails[i], id: <#String#>)
//            arrayOfUsers.append(user)
        }
    }
    func filterUserName() -> [String] {
        var names:[String] = []
        for i in arrayOfUsers {
            let name = i.name
            names.append(name)
        }
        return names
    }
    var users : [User] = []
    func fetchTheUsers(){
        Alamofire.request("http://178.128.158.129/users", method: .get, parameters: "" as? [String : Any], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print(err)
            case .success(let value):
                
                guard let value = value as? [Any] else {return}
                print(value.count)
                for i in value {
                    guard let dict = i as? [String:Any] else {return}
                    guard let id = dict["id"] as? String else { return}
                    let user = User(uid: id, dictionary: dict)
                    self.users.append(user)
                    self.fetchPosts()
                }
            }
        }
    }
    func fetchUserHabbies() {
        for ii in users {
            Alamofire.request("http://178.128.158.129/user/\(ii.id)/habits", method: .get, parameters: "" as? [String : Any], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .failure(let err):
                    print(err)
                case .success(let value):
                    print(value)
                }
            }
        }
    }
    func fetchUserHabbite() {
        for ii in users {
            ii.fetchTheHabbites()
            print(ii.habits?.count)
        }
    }
    func fetchPosts() {
        for user in users {
            print(user.id)
        }
    }
}
