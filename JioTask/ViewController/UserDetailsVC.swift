//
//  UserDetailsVC.swift
//  JioTask
//
//  Created by Jignesh kasundra on 18/08/20.
//  Copyright © 2020 Jignesh kasundra. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class UserDetailsVC: UIViewController
{

    //    MARK:- ================================= VARIABLE
    
    
    let userImageView = UIImageView()
    let UserName = UILabel()
    let followers_btn = UIButton()
    let following_btn = UIButton()
    
    
    
    var user_name = String()
    var image_url = String()
    var followers_count:NSNumber = 0
    var following_count:NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backItem?.title = "Back"
        self.navigationItem.title = user_name
        setUpView()
        userDetailsAPI()
        // Do any additional setup after loading the view.
    }
    
    //    MARK:- ================================ ALL FUNCATION  ===========================
    
    func setUpView() {
        
        let margineGuide = view.layoutMarginsGuide
        
        self.view.addSubview(userImageView)
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.layer.cornerRadius = 60
        userImageView.clipsToBounds = true
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: image_url))
        userImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: margineGuide.topAnchor, constant: 30),
            userImageView.heightAnchor.constraint(equalToConstant: 120),
            userImageView.widthAnchor.constraint(equalToConstant: 120),
            userImageView.centerXAnchor.constraint(equalTo: margineGuide.centerXAnchor)
        ])
        
        self.view.addSubview(UserName)
        UserName.translatesAutoresizingMaskIntoConstraints = false
        UserName.textAlignment = .center
        UserName.font = UIFont.boldSystemFont(ofSize: 20)
        UserName.text = user_name
        
        NSLayoutConstraint.activate([
            UserName.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            UserName.leftAnchor.constraint(equalTo: margineGuide.leftAnchor),
            UserName.rightAnchor.constraint(equalTo: margineGuide.rightAnchor),
            UserName.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        
        self.view.addSubview(followers_btn)
        followers_btn.translatesAutoresizingMaskIntoConstraints = false
        followers_btn.backgroundColor = .blue
        followers_btn.setTitleColor(.white, for: .normal)
        followers_btn.setTitle("Followers (\(self.followers_count))", for: .normal)
        followers_btn.layer.cornerRadius = 10
        followers_btn.addTarget(self, action: #selector(click_on_followers(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            followers_btn.topAnchor.constraint(equalTo: UserName.bottomAnchor, constant: 20),
            followers_btn.widthAnchor.constraint(equalToConstant: 150),
            followers_btn.heightAnchor.constraint(equalToConstant: 40),
            followers_btn.centerXAnchor.constraint(equalTo: margineGuide.centerXAnchor)
        ])
        
        self.view.addSubview(following_btn)
        following_btn.translatesAutoresizingMaskIntoConstraints = false
        following_btn.backgroundColor = .blue
        following_btn.setTitleColor(.white, for: .normal)
        following_btn.setTitle("Following (\(self.following_count))", for: .normal)
        following_btn.layer.cornerRadius = 10
        following_btn.addTarget(self, action: #selector(click_on_following(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            following_btn.topAnchor.constraint(equalTo: followers_btn.bottomAnchor, constant: 20),
            following_btn.widthAnchor.constraint(equalToConstant: 150),
            following_btn.heightAnchor.constraint(equalToConstant: 40),
            following_btn.centerXAnchor.constraint(equalTo: margineGuide.centerXAnchor)
        ])
        
    }
    
    
    @objc func click_on_followers(sender:UIButton)
    {
        if followers_count == 0
        {
            return
        }
        
        let push = FollowersFollowingListVC()
        push.type = "followers"
        push.user_name_FF = user_name
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func click_on_following(sender:UIButton)
    {
        if following_count == 0
        {
            return
        }
        let push = FollowersFollowingListVC()
        push.type = "following"
        push.user_name_FF = user_name
        self.navigationController?.pushViewController(push, animated: true)
    }


}

extension UserDetailsVC
{
     func userDetailsAPI() {
            
    //        let url:String = "https://api.github.com/search/users?q=\(search_user_name)&page=\(offset)"
            
            let urlString = "https://api.github.com/users/\(user_name)"
            if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded)
             {
                 AF.request(url, method: .get,  parameters: nil, encoding: JSONEncoding.default)
                     .responseJSON { response in
                         switch response.result {
                         case .success(let value):
                             let result = (value as! NSDictionary)
                             print(result)
                             self.followers_count = result.value(forKey: "followers") as! NSNumber
                             self.following_count = result.value(forKey: "following") as! NSNumber
                             self.followers_btn.setTitle("Followers (\(self.followers_count))", for: .normal)
                             self.following_btn.setTitle("Following (\(self.following_count))", for: .normal)
                         case .failure(let error):
                             print(error)
                         }
                 }
            }
        }
}
