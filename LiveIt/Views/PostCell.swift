//
//  PostCell.swift
//  LiveIt
//
//  Created by Qahtan on 9/29/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
class PostCell: UICollectionViewCell {
    let habbite: UILabel = {
        let lab = UILabel()
        lab.text = "GGGGGGGGGGG"
        lab.textAlignment = .right
//        lab.backgroundColor = .gray
        return lab
    }()
    let textLab : UILabel = {
        let lab = UILabel()
        lab.text = "dummy text "
        lab.textAlignment = .center
//        lab.backgroundColor = .blue
        return lab
    }()
    let smallView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.99, green:0.87, blue:0.80, alpha:1.0)
        return view
    }()
    let userLab:  UILabel = {
        let lab = UILabel()
        lab.text = "Ahmed"
        lab.textAlignment = .left
//        lab.backgroundColor = .orange
        return lab
    }()
    let contenerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        addSubview(contenerView)
        contenerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 8, width: 0, height: 0)
        
    }
    func setupViews() {
        
        backgroundColor = .clear
        contenerView.layer.cornerRadius = 20
        contenerView.layer.masksToBounds = true
        contenerView.addSubview(habbite)
        habbite.anchor(top: contenerView.topAnchor, left: contenerView.leftAnchor, right: contenerView.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 40)
        
        contenerView.addSubview(textLab)
        textLab.anchor(top: habbite.bottomAnchor, left: contenerView.leftAnchor, right: contenerView.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 80)
        
        contenerView.addSubview(smallView)
        smallView.anchor(top: nil, left: contenerView.leftAnchor, right: contenerView.rightAnchor, bottom: contenerView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 40)
        
        smallView.addSubview(userLab)
        userLab.anchor(top: smallView.topAnchor, left: smallView.leftAnchor, right: smallView.rightAnchor, bottom: smallView.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 8, width: 8, height: 40)
        userLab.centerXAnchor.constraint(equalTo: smallView.centerXAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
