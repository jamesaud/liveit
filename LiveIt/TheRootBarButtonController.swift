//
//  TheRootBarButtonController.swift
//  LiveIt
//
//  Created by Qahtan on 9/28/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
class TheRootBarButtonController: UITabBarController {
    
    var user: User?
    // check User Status
//    var login = true
    var service: ServiceClass?
    let locationMangere = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        service = ServiceClass()
        
        service?.fetchTheUsers()
        view.backgroundColor = .white
        locationMangere.requestWhenInUseAuthorization()
        locationMangere.startUpdatingLocation()
    }
    var userID: String?
    override func viewWillAppear(_ animated: Bool) {
        checkUserStatus()
    }
    func checkUserStatus() {
        if UserDefaults.standard.string(forKey: "USERID") == nil{
            let signupVC = SignupVC()
            signupVC.theRootTBVC = self
            let nav = UINavigationController(rootViewController: signupVC)
            self.present(nav, animated: true, completion: nil)
        }
        guard let userId = UserDefaults.standard.string(forKey: "USERID") else { return}
        userID = userId
        print(userId)
        fetchUser()
    }
    func fetchUser() {
        print(userID)
        Alamofire.request("http://178.128.158.129/user/\(userID!)", method: .get, parameters: "" as? [String : Any], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print(err)
            case .success(let value):
                print(value)
                guard let value = value as? [String:Any] else{return}
                guard let id = self.userID else { return}
                self.user = User(uid: id, dictionary: value)
                print(self.user?.name)
                self.setupViewControllers()
                print(value)
            }
        }
    }
    func setupViewControllers() {
        // Home
        //Feed,I Want to..,My Hobbies,A Awards
        let viewCV = NewOneFeed(collectionViewLayout: UICollectionViewFlowLayout())
        viewCV.view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
//        viewCV.user = user
        viewCV.theRootBarButton = self
        let feedVC = templetNavController(selected: #imageLiteral(resourceName: "Selected"), unselected: #imageLiteral(resourceName: "UnSelected"),rootViewController: viewCV)
        
        let iWantToVC = NewOneIWantToVC()
        iWantToVC.theRootBarVC = self
        iWantToVC.user = user
        let iWantTo = templetNavController(selected: #imageLiteral(resourceName: "Selected"), unselected: #imageLiteral(resourceName: "UnSelected"), rootViewController: iWantToVC)
        let myHobbiesVC = NewOneMyHobbies()
        let myHobbies = templetNavController(selected: #imageLiteral(resourceName: "Selected"), unselected: #imageLiteral(resourceName: "UnSelected"), rootViewController: myHobbiesVC)
        let awardVC  = NewOneAwards()
        let awards = templetNavController(selected: #imageLiteral(resourceName: "Selected"), unselected: #imageLiteral(resourceName: "UnSelected"), rootViewController: awardVC)
        
        tabBar.tintColor = .black
        // Feed,I Want to..,My Hobbies,A Awards
        self.viewControllers = [feedVC,
                           iWantTo,
                           myHobbies,
                           awards]
        
        // modify items tab bar insets
        guard let items = tabBar.items else { return }
        for item in  items {
            item.imageInsets = UIEdgeInsets(top: 4 , left:0, bottom: -4, right: 0 )
        }
    }
    fileprivate func templetNavController(selected: UIImage,unselected: UIImage,rootViewController: UIViewController) -> UINavigationController {
        let tempNavController = UINavigationController(rootViewController: rootViewController)
        tempNavController.tabBarItem.image = unselected
        tempNavController.tabBarItem.selectedImage = selected
        return tempNavController
    }
    
}
