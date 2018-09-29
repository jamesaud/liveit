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
    var blackViewRightConstraint:NSLayoutConstraint?
    let locationMangere = CLLocationManager()
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.99, green:0.87, blue:0.80, alpha:1.0)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        service = ServiceClass()
        
        service?.fetchTheUsers()
        view.backgroundColor = .white
        locationMangere.requestWhenInUseAuthorization()
        locationMangere.startUpdatingLocation()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menue", style: .plain, target: self, action: #selector(handleExpandView))
        view.addSubview(blackView)
        
        blackView.anchor(top: view.topAnchor, left: nil, right: nil, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 49, width: 350, height: 0)
        blackViewRightConstraint = blackView.rightAnchor.constraint(equalTo: view.leftAnchor)
        blackViewRightConstraint?.isActive = true
        
    }
    var expand = false
    @objc func handleExpandView() {
        if expand == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.blackViewRightConstraint?.constant = 300
            }) { (complete) in
            }
            expand = true
        }else {
            expand = false
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.blackViewRightConstraint?.constant = 0
            }) { (complete) in
            }
        }
        
    }
    let userTitleLab : UILabel = {
        let lab = UILabel()
        lab.text = "Hello "
        lab.textAlignment = .center
        return lab
    }()
    let userImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let progressBar: UIProgressView = {
        let pv = UIProgressView()
        return pv
    }()
    let pointsLab: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.text = "\(853) / \(1000) points" as String
        lab.textColor = UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)
        return lab
    }()
    func setupBlackViewContent() {
        blackView.addSubview(userTitleLab)
        userTitleLab.anchor(top: blackView.topAnchor, left: nil, right: nil, bottom: nil, paddingTop: 80, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 280, height: 44)
        userTitleLab.centerXAnchor.constraint(equalTo: blackView.centerXAnchor).isActive = true
        
        let att = NSMutableAttributedString(string: "welcom ", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red:0.68, green:0.70, blue:0.72, alpha:1.0)])
        if let user = user {
            att.append(NSAttributedString(string: "\(user.name)", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),NSAttributedStringKey.foregroundColor: UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)]))
            userTitleLab.attributedText = att
            userImageView.loadImage(urlString: user.imageURL)
        }
        blackView.addSubview(userImageView)
        userImageView.anchor(top: userTitleLab.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 8, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 100, height: 100)
        userImageView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor).isActive = true
        userImageView.layer.cornerRadius = 50
        userImageView.layer.borderColor = UIColor.red.cgColor
        userImageView.layer.borderWidth = 1
        
        blackView.addSubview(progressBar)
        progressBar.anchor(top: userImageView.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 40, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 180, height: 5)
        progressBar.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor).isActive = true
        
        progressBar.progressTintColor = UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)
//        progressBar.progressTintColor =
        let ratio: Float = 800.0 / 1000.0
        progressBar.progress = ratio
        
        blackView.addSubview(pointsLab)
        pointsLab.anchor(top: progressBar.bottomAnchor, left: nil, right: nil, bottom: nil, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 150, height: 44)
        pointsLab.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor).isActive = true
        
        
        // label name
        
        // image
        
        // 
    }
    var userID: String?
    override func viewWillAppear(_ animated: Bool) {
        checkUserStatus()
    }
    func checkUserStatus() {
//        UserDefaults.standard.removeObject(forKey: "USERID")
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
                self.setupBlackViewContent()
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
