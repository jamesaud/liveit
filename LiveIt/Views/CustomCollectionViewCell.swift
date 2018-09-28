//
//  CustomCollectionViewCell.swift
//  LiveIt
//
//  Created by Qahtan on 9/28/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
class CustomCollectionViewCell: UICollectionViewCell{
    var user: User? {
        didSet {
            guard let userImage = user?.imageURL else { return}
            print("USER IMAGE")
            imageView.loadImage(urlString: userImage)
        }
    }
    var happets: Hobbie? {
        didSet{
            guard let ha = happets else { return }
            let attt = NSMutableAttributedString(string: "\(ha.name) ", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red:0.95, green:0.31, blue:0.00, alpha:1.0)
                ,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 19)])
            attt.append(NSMutableAttributedString(string: "for \(ha.goal)\(ha.unit) ", attributes: [NSAttributedStringKey.foregroundColor : UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)]))
            userName.attributedText = attt
            print(happets?.userID)
        }
    }
    let userName:UILabel = {
        let lab = UILabel()
        lab.text = "HHHH"
        lab.adjustsFontForContentSizeCategory = true
        lab.textAlignment = .center
        return lab
    }()
    let habbite:UILabel = {
        let lab = UILabel()
        lab.text = "Habbite"
        return lab
    }()
    let progrssBar: UIProgressView = {
        let progg = UIProgressView()
        return progg
    }()
    let pluseButton : UISegmentedControl = {
        let array = ["+","-"]
        let plus = UISegmentedControl(items: array)
        plus.addTarget(self, action: #selector(handleSegmentedC), for: .valueChanged)
        return plus
    }()
    let contenerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    let imageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        return iv
    }()
    let smallView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.99, green:0.87, blue:0.80, alpha:1.0)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    let distLab : UILabel = {
        let lab = UILabel()
        lab.text = "2km"
        lab.textColor = UIColor(red:0.68, green:0.70, blue:0.72, alpha:1.0)
        lab.font = UIFont.boldSystemFont(ofSize: 17)
        return lab
    }()
    let plusButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "269-happyface")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        btn.setTitle("+", for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.tintColor = UIColor(red:0.03, green:0.77, blue:0.35, alpha:1.0)
        btn.imageView?.clipsToBounds = true
        return btn
    }()
    let mainsButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "270-unhappyface")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.red
        btn.imageView?.contentMode = .scaleAspectFill
        btn.imageView?.clipsToBounds = true
        btn.setTitle("-", for: .normal)
        return btn
    }()
    func setupStackView() {
    }
    func setupViews() {
        addSubview(contenerView)
        backgroundColor = .clear
        contenerView.backgroundColor = .white
        
        contenerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 44, paddingLeft: 44, paddingRight: 44, paddingBottom: 0, width: 0, height: 0)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 80, height: 80)
        imageView.layer.cornerRadius = 40
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        
        contenerView.addSubview(smallView)
        smallView.anchor(top: nil, left: contenerView.leftAnchor, right: contenerView.rightAnchor, bottom: contenerView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 44)
        
        smallView.addSubview(distLab)
        distLab.anchor(top: smallView.topAnchor, left: nil, right: smallView.rightAnchor, bottom: smallView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 44, height: 0)
        smallView.layer.borderWidth = 1
        smallView.layer.borderColor = UIColor.white.cgColor
        smallView.addSubview(plusButton)
        plusButton.anchor(top: smallView.topAnchor, left: smallView.leftAnchor, right: nil, bottom: smallView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 50, height: 0)
        
        smallView.addSubview(mainsButton)
        mainsButton.anchor(top: smallView.topAnchor, left: plusButton.rightAnchor, right: nil, bottom: smallView.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 8, paddingBottom: 0, width: 40, height: 0)
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor.white.cgColor
        
        mainsButton.layer.borderWidth = 1
        mainsButton.layer.borderColor = UIColor.white.cgColor
        
        contenerView.addSubview(userName)
        userName.anchor(top: contenerView.topAnchor, left: contenerView.leftAnchor, right: contenerView.rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 40, paddingRight: 8, paddingBottom: 0, width: 0, height: 35)
//
//        contenerView.addSubview(habbite)
//        habbite.anchor(top: userName.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 35)
//
//        contenerView.addSubview(progrssBar)
//        progrssBar.anchor(top: habbite.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 200, height: 4)

        contenerView.layer.cornerRadius = 10
        contenerView.layer.masksToBounds  = true
        setupStackView()
//        let pluseButton = UIButton(type: .system)
//        pluseButton.setTitle("+", for: .normal)
//        let minesButton = UIButton(type: .system)
//        pluseButton.setTitle("-", for: .normal)
//
//        let stackView = UIStackView(arrangedSubviews: [pluseButton,minesButton])
//
//        addSubview(stackView)
//        stackView.backgroundColor = .gray
//        stackView.distribution = .fillEqually
////        stackView.axis = .horizontal
//        stackView.anchor(top: habbite.bottomAnchor, left: progrssBar.rightAnchor, right: rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 50)
        
//        addSubview(pluseButton)
//        pluseButton.anchor(top: habbite.bottomAnchor, left: progrssBar.rightAnchor, right: rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 44)
//        pluseButton.setTitle("+", forSegmentAt: 0)
//        pluseButton.setTitle("-", forSegmentAt: 1)
    }
    @objc func  handleSegmentedC(sender: UISegmentedControl){
        print(sender.selectedSegmentIndex)
    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 2
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(row,component)
//    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return " Hello"
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
