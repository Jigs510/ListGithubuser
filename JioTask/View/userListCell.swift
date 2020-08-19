//
//  userListCell.swift
//  JioTask
//
//  Created by Jignesh kasundra on 17/08/20.
//  Copyright © 2020 Jignesh kasundra. All rights reserved.
//

import UIKit
import Kingfisher

class userListCell: UITableViewCell {
    
    var User : User? {
        didSet {

            let url = User?.UserImage
            UserImage.kf.indicatorType = .activity
            UserImage.kf.setImage(with: URL(string: url!))
            UserNameLabel.text = User?.UserName
        }
    }
    
    var followers : followers? {
        
        didSet {
            let url = followers?.follower_image_url
            UserImage.kf.indicatorType = .activity
            UserImage.kf.setImage(with: URL(string: url!))
            UserNameLabel.text = followers?.follower_name
        }
    }
    
    var following : following? {
        
        didSet {
            let url = following?.following_image_url
            UserImage.kf.indicatorType = .activity
            UserImage.kf.setImage(with: URL(string: url!))
            UserNameLabel.text = following?.following_name
        }
    }
    
    
    private let mainView : UIView =
    {
        let view = ShadowView()
        view.shadowColor = UIColor.darkGray
        view.shadowRadius = 2
        view.shadowOffset = CGSize(width: 2, height: 2)
        view.shadowOpacity = 0.2
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    
    private let UserNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let line_labal : UILabel = {
        let line = UILabel()
        line.textColor = .black
        line.backgroundColor = .darkGray
        line.textAlignment = .left
        return line
    }()
    
    
    private let UserImage : UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "user"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(mainView)
        
        mainView.addSubview(UserImage)
        mainView.addSubview(UserNameLabel)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        UserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        UserImage.translatesAutoresizingMaskIntoConstraints = false

        
        
        
        UserNameLabel.textAlignment = .left
        NSLayoutConstraint.activate([

            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            mainView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            mainView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)

        ])
        
        NSLayoutConstraint.activate([
            
            UserImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5),
            UserImage.heightAnchor.constraint(equalToConstant: 50),
            UserImage.widthAnchor.constraint(equalToConstant: 50),
            UserImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20)
            
        ])
        
        NSLayoutConstraint.activate([
            UserNameLabel.leftAnchor.constraint(equalTo: UserImage.rightAnchor, constant: 10),
            UserNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            UserNameLabel.heightAnchor.constraint(equalToConstant: 18),
            UserNameLabel.rightAnchor.constraint(equalTo:rightAnchor, constant: 10),
        ])
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
