//
//  SignupVC.swift
//  LiveIt
//
//  Created by Qahtan on 9/27/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import Alamofire

class SignupVC: UIViewController {
    var theRootTBVC:TheRootBarButtonController?
    var user: User?
    let email: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Example@gmail.com"
        tf.borderStyle = .roundedRect
        return tf
    }()
    let userName: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter your name"
        return tf
    }()
    let passward: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Create a password"
        tf.isSecureTextEntry = true
        return tf
    }()
    let signupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.setAttributedTitle(NSMutableAttributedString(string: "Sign up", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)]), for: .normal)
        btn.backgroundColor = UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)
        btn.addTarget(self, action: #selector(hanldeSignUp), for: .touchUpInside)
        return btn
    }()
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "You alrady hava an account...  ", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)])
        attributedTitle.append(NSMutableAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0),NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 19)]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(hanldeAlreadyHaveAccount), for: .touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        setupURLRequest()
        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        setupViews()
    }
    func setupViews() {
        view.addSubview(email)
        email.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 30, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        view.addSubview(userName)
        userName.anchor(top: email.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        view.addSubview(passward)
        passward.anchor(top: userName.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        view.addSubview(signupButton)
        signupButton.anchor(top: passward.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 10, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        
        view.addSubview(loginButton)
        loginButton.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, paddingBottom: 30, width: 0, height: 44)
    }
    @objc func hanldeAlreadyHaveAccount() {
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    @objc func hanldeSignUp() {
        guard let emailString = email.text, !emailString.isEmpty else { return}
        guard let userNameString = userName.text, !userNameString.isEmpty else { return }
        guard let passwordString = passward.text, !passwordString.isEmpty else { return }
        if let location = theRootTBVC?.locationMangere.location {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            let location = [lat,lng]
            
            let dict = ["name":userNameString, "email": emailString,"password":passwordString,"location":location] as [String : Any]
            setupURLRequest(dict: dict)
        }else {
            let dict = ["name":userNameString, "email": emailString,"password":passwordString,"location":[0.0,0.0]] as [String : Any]
            setupURLRequest(dict: dict)
        }
        
        print(emailString,passwordString,userNameString)
        
        print("hanldeSignUp")
        
    }
    func setupURLRequest (dict:[String:Any]) {
        Alamofire.request("http://178.128.158.129/user", method: .post, parameters: dict, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print(err)
            case .success(let value):
                guard let va = value as? [String:Any] else { return }
                self.self.user = User(name: dict["name"] as! String, email: dict["email"] as! String, id: va["user_id"] as! String, location: dict["location"] as! [Double],imageURL:"f")
                UserDefaults.standard.set(va["user_id"], forKey: "USERID")
                print(self.user)
                self.dismiss(animated: true, completion: nil)
                print(value)
            }
        }
    }
}
