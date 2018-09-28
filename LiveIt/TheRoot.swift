//
//  ViewController.swift
//  LiveIt
//
//  Created by Qahtan on 9/27/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
import CoreLocation

class TheRoot: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var login = true
    let cellId = "cellId"
    var service: ServiceClass?
    let locationMangere = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        service = ServiceClass()
        service?.createHobbieArray()
        locationMangere.requestWhenInUseAuthorization()
        locationMangere.startUpdatingLocation()
        print(locationMangere.location)
        print("----",locationMangere.location?.coordinate)
        view.backgroundColor = .gray
        setupCollectionView()
        checkUserStatus()
    }
    func setupCollectionView(){
//        collectionView?.adjustedContentInset.top = 8
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .green
    }
    func checkUserStatus() {
        if login == false {
            let nav = UINavigationController(rootViewController: SignupVC())
            present(nav, animated: true, completion: nil)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            // Feed
            let feedVC = FeedVC()
            feedVC.theRoot = self
            navigationController?.pushViewController(feedVC, animated: true)
        }else if indexPath.row == 1 {
             // I Want to..
            let iWantToVC = IWantToVC()
            navigationController?.pushViewController(iWantToVC, animated: true)
        }else if indexPath.row == 2 {
            // My Hobbies
            let myHobbies = MyHobbies()
            navigationController?.pushViewController(myHobbies, animated: true)
        }else if indexPath.row == 3 {
            // // My Hobbies,A Awards
            let awards = Awards()
            navigationController?.pushViewController(awards, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .brown
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = view.frame.width - 16
        return CGSize(width: width , height: 50)
    }
}

