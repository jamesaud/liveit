//
//  SignupVC.swift
//  LiveIt
//
//  Created by Qahtan on 9/27/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
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
        btn.setTitle("Sign", for: .normal)
        btn.backgroundColor = .brown
        btn.addTarget(self, action: #selector(hanldeSignUp), for: .touchUpInside)
        return btn
    }()
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "You alrady hava an account...", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor : UIColor.blue]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.backgroundColor = .brown
        btn.addTarget(self, action: #selector(hanldeAlreadyHaveAccount), for: .touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        print(emailString,passwordString,userNameString)
        print("hanldeSignUp")
    }
}
