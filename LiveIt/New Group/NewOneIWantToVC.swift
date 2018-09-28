//
//  NewOne.swift
//  LiveIt
//
//  Created by Qahtan on 9/28/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import Alamofire
class NewOneIWantToVC: UIViewController {
    
    var theRootBarVC: TheRootBarButtonController?
    var user:User?
    var habit: Hobbie?
    let iWantToLbl : UILabel = {
        let lab = UILabel()
        lab.text = "I Want To.."
        lab.textAlignment = .center
        lab.font = UIFont.boldSystemFont(ofSize: 30)
        lab.textColor = UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)
        return lab
    }()
    let iWantToLblMention : UILabel = {
        let lab = UILabel()
        lab.text = "I Want To.."
        lab.textAlignment = .center
        lab.font = UIFont.boldSystemFont(ofSize: 30)
        lab.textColor = UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)
        return lab
    }()
    let iWantExplein: UILabel = {
       let lab = UILabel()
        lab.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        return lab
    }()
    let mentionExplein: UILabel = {
        let lab = UILabel()
        lab.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        return lab
    }()
    let mentionFreind : UILabel = {
        let lab = UILabel()
        lab.text = "Mention a frinde"
        lab.textAlignment = .center
        lab.font = UIFont.boldSystemFont(ofSize: 30)
        lab.textColor = UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)
        return lab
    }()
    let mentionTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "@frend_name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(searchForFrinds), for: .editingChanged)
        tf.borderStyle = .roundedRect
        tf.tag = 2
        return tf
    }()
    let textField : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder =  "Enter your hobbie"
        tf.backgroundColor = .white
        tf.tag = 1
        tf.addTarget(self, action: #selector(searchWorkersAsPerText), for: .editingChanged)
        return tf
    }()
    lazy var tableView: UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = .black
        
        tableV.delegate = self
        return tableV
    }()
    let target:UILabel = {
        let label  = UILabel()
        label.text = "Target"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)
        return label
    }()
    let targetExplein: UILabel = {
        let lab = UILabel()
        lab.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        return lab
    }()
    let targetTf : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder =  "Enter Target"
        tf.backgroundColor = .white
        tf.tag = 3
//        tf.addTarget(self, action: #selector(searchTarget), for: .editingChanged)
        return tf
    }()
    let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        let att = NSMutableAttributedString(string: "Send", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        btn.setAttributedTitle(att, for: .normal)
        btn.backgroundColor = UIColor(red:0.95, green:0.29, blue:0.04, alpha:1.0)
        btn.addTarget(self, action: #selector(handleSendToDb), for: .touchUpInside)
        return btn
    }()
    let cellId = "cellId"
    var arrayOfHobbiesName : [String]?
    var arrayOfUsersNames: [String]?
    var users:[User]?
    var service: ServiceClass?
    var filterArray : [String] = []
    var isExpand = false
    var tableViewBottomAnchor: NSLayoutConstraint?
    var tag: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(theRootBarVC?.locationMangere.location)
        service = ServiceClass()
        
        self.navigationItem.title = "I Want To"
        
        guard let user = user else { return }
        print(user.id)
        setupViews()
    }
    var frindTableViewBottomAnchor:NSLayoutConstraint?
    var tableViewTopConstrint: NSLayoutConstraint?
    func setupViews() {
//        guard let service = theRoot?.service else { return }
        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        service?.createHobbieArray()
        service?.createUsers()
        arrayOfHobbiesName = service?.felterHobbies()
        users = service?.arrayOfUsers
        
        arrayOfUsersNames = service?.filterUserName()
        print(arrayOfHobbiesName)
        
        textField.delegate = self
        mentionTF.delegate = self
        targetTf.delegate = self
        // Setup TableView
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // Habite
        view.addSubview(iWantToLbl)
        iWantToLbl.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 10, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 40)
        view.addSubview(iWantExplein)
        iWantExplein.anchor(top: iWantToLbl.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        view.addSubview(textField)
        textField.anchor(top: iWantExplein.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 30, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        // Frinds mention
        view.addSubview(mentionFreind)
        mentionFreind.anchor(top: textField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        view.addSubview(mentionExplein)
        mentionExplein.anchor(top: mentionFreind.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        view.addSubview(mentionTF)
        mentionTF.anchor(top: mentionExplein.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        /// add target
        
        view.addSubview(target)
        target.anchor(top: mentionTF.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        view.addSubview(targetExplein)
        targetExplein.anchor(top: target.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
//
        view.addSubview(targetTf)
        targetTf.anchor(top: targetExplein.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
//
        view.addSubview(sendButton)
        sendButton.anchor(top: targetTf.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
    }
    let frindsTableView: UITableView = {
        let tableView = UITableView()
        tableView.tag = 1
        return tableView
    }()
    @objc func searchForFrinds() {
        tag = mentionTF.tag
        filterArray = arrayOfUsersNames!
        expand(tf: mentionTF)
        if mentionTF.text?.count != 0 {
            //            expandeTableView()
            for name in self.arrayOfUsersNames! {
                let range = name.lowercased().range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    filterArray.append(name)
                }
            }
        } else {
            self.filterArray = self.arrayOfUsersNames!
        }
        self.tableView.reloadData()
    }
    @objc func handleSendToDb() {
//        guard let habite = habit else { return}
        guard let target = targetTf.text else { return }
        guard let habbiteName = textField.text else { return }
        guard let goal = mentionTF.text else { return }
//        guard let frindID = "" else { return }
        // creat a randum
        let dice1 = arc4random_uniform(5) + 1;
        let habiteDict:[String:Any] = ["name":habbiteName,"goal":target,"difficulty":dice1,"unit":target,"date":"\((Date().timeIntervalSince1970*1000))"]
        print(habiteDict)
        guard let user = user else { return}
        Alamofire.request("http://178.128.158.129/user/\(user.id)/habits", method: .post, parameters: habiteDict, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .failure(let err):
                print(err)
            case .success(let value):
                print("gg",value)
                guard let va = value as? [String:Any] else { return }
                print(va)
                print(value)
            }
        }
        print("Send to DB")
    }
    @objc func searchTarget() {
        self.tableView.reloadData()
        tag = targetTf.tag
        filterArray = ["KG","Days","Week"]
        expand(tf: targetTf)
    }
    @objc func searchWorkersAsPerText() {
        tag = textField.tag
        filterArray = arrayOfHobbiesName!
        expand(tf: textField)
        if textField.text?.count != 0 {
            //            expandeTableView()
            for dicData in self.arrayOfHobbiesName! {
                let name = dicData
                let range = name.lowercased().range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    filterArray.append(name)
                }
            }
        } else {
            self.filterArray = self.arrayOfHobbiesName!
            //            tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
            //            tableViewBottomAnchor?.isActive = true
        }
        self.tableView.reloadData()
    }
    func expand(tf:UITextField) {
        tableView.alpha = 1
        view.bringSubview(toFront: tableView)
        if !isExpand {
            tableView.alpha = 1
            
            tableView.frame = CGRect(x: textField.frame.height - 20 , y: tf.frame.maxY , width: textField.frame.width, height: 100)
            isExpand = !isExpand
        }else {
            isExpand = !isExpand
            tableView.alpha = 0
        }
    }
}
extension NewOneIWantToVC:UITextFieldDelegate,UITableViewDataSource {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag)
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        print("textFieldDidEndEditing",textField.tag)
        textField.resignFirstResponder()
    }
}
extension NewOneIWantToVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filterArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.alpha = 0
        if let tag = tag {
            if tag == 1 {
                let habiteName = filterArray[indexPath.row]
                textField.text = filterArray[indexPath.row]
                for (index,habite) in (service?.hobbies.enumerated())! {
                    if habiteName == habite.name {
                        habit = service?.hobbies[index]
                    }
                }
            }else if tag == 2 {
                mentionTF.text = filterArray[indexPath.row]
            }else if tag == 3 {
                targetTf.text = filterArray[indexPath.row]
            }
        }
        tableViewBottomAnchor?.constant = 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = filterArray[indexPath.row]
        return cell
    }
}
