//
//  NewOneIWantTo.swift
//  LiveIt
//
//  Created by Qahtan on 9/28/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import Alamofire
class NewOneFeed: UICollectionViewController {
    var user:User?
    var users:[User]?
    var arrayOfHobbites : [Hobbie] = []
    var theRootBarButton: TheRootBarButtonController?
    // ftchUsers based on the location
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "I Want to.."
        collectionView?.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    @objc func handleExpandView() {
        UIView.animate(withDuration: 0.5) {
            self.blackViewRightConstraint?.constant = 100
        }
    }
    var blackViewRightConstraint:NSLayoutConstraint?
    func createSidMenu() {
        let blackView = UIView()
        view.addSubview(blackView)
        blackView.anchor(top: view.topAnchor, left: nil, right: nil, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 49, width: 100, height: 0)
        blackViewRightConstraint = blackView.rightAnchor.constraint(equalTo: view.leftAnchor)
        blackViewRightConstraint?.isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserHabbites()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(theRootBarButton?.service?.users.count)
//        return (theRootBarButton?.service?.users.count)!
        return arrayOfHobbites.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCollectionViewCell
        cell.happets = arrayOfHobbites[indexPath.row]
//        guard let users =  else { return }
        if let users = theRootBarButton?.service?.users {
            for (index,user) in users.enumerated() {
                if cell.happets?.userID == user.id {
                    cell.user = users[index]
                    print(user.imageURL)
                }
            }
        }
        
        return cell
    }
    func fetchUserHabbites() {
        for ii in (theRootBarButton?.service?.users)! {
                Alamofire.request("http://178.128.158.129/user/\(ii.id)/habits", method: .get, parameters: "" as? [String : Any], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                    switch response.result {
                    case .failure(let err):
                        print(err)
                    case .success(let value):
                        print(value)
                        guard let va = value as? [Any] else { return}
                        print(va)
                        for ho in va {
                            guard let hob = ho as? [String:Any] else { return}
                            guard let id = hob["id"] as? String else { return }
                            
                            let hobiet = Hobbie(id:id , dict: hob)
                            self.arrayOfHobbites.append(hobiet)
                            hobiet.userID = ii.id
                            print(hobiet)
                            self.collectionView?.reloadData()
                        }
                        
                    }
                }
            }
        }
}
extension NewOneFeed: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }
}
