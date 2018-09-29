//
//  NewOneMyHobbies.swift
//  LiveIt
//
//  Created by Qahtan on 9/28/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
class NewOneMyHobbies: UIViewController {
    
    let cellId = "cellId"
    let tf : UITextField = {
       let tf = UITextField()
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.placeholder = "... new Post"
        return tf
    }()
    let collection: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        navigationItem.title = "My Hobbies"
//        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        
        collection.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(tf)
        tf.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 70, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 44)
        
        view.addSubview(collection)
        collection.anchor(top: tf.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        collection.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8 )
        
        collection.delegate = self
        collection.dataSource = self
    }
}
extension NewOneMyHobbies : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
//        cell.backgroundColor = .red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
