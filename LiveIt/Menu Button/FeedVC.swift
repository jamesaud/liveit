//
//  FeedVC.swift
//  LiveIt
//
//  Created by Qahtan on 9/27/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    var theRoot: TheRoot?
    var arrayOfHobbiesName : [String]?
//    let searchBar: UISearchBar = {
//        let sb = UISearchBar()
//        sb.placeholder = "Enter user name"
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.black
//        return sb
//    }()
    let cellId = "cellId"
    let textField : UITextField = {
        let tf = UITextField()
        tf.placeholder =  "Enter your hobbie"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(searchWorkersAsPerText), for: .editingChanged)
        return tf
    }()
    lazy var tableView: UITableView = {
       let tableV = UITableView()
        tableV.backgroundColor = .white
        tableV.delegate = self
        return tableV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    var tableViewBottomAnchor: NSLayoutConstraint?
    func setupViews() {
        guard let service = theRoot?.service else { return }
        arrayOfHobbiesName = service.felterHobbies()
        view.backgroundColor = .yellow
        
        textField.delegate = self
        view.addSubview(textField)
        textField.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 30, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 44)
        
        // Setup TableView
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.anchor(top: textField.bottomAnchor, left: textField.leftAnchor, right: textField.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
        tableViewBottomAnchor?.isActive = true
    }
    var filterArray : [String] = []
    var isExpand = false
    @objc func searchWorkersAsPerText() {
        
        expand()
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
    func expand() {
        if !isExpand {
            print(isExpand)
            isExpand = !isExpand
            tableViewBottomAnchor?.constant = 100
//            tableViewBottomAnchor =  tableView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 100)
//            tableViewBottomAnchor?.isActive = true
        }else {
            isExpand = !isExpand
            tableViewBottomAnchor?.constant = 0
//            tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
//            tableViewBottomAnchor?.isActive = true
        }
    }
    func expandeTableView() {
        tableViewBottomAnchor =  tableView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 100)
        tableViewBottomAnchor?.isActive = true
    }
}
extension FeedVC:UITextFieldDelegate,UITableViewDataSource {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        expandeTableView()
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        print("textFieldDidEndEditing")
        textField.resignFirstResponder()
    }
}
extension FeedVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.text = arrayOfHobbiesName![indexPath.row]
        tableViewBottomAnchor?.constant = 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = arrayOfHobbiesName?[indexPath.row]
        return cell
    }
}
