//
//  FollowersFollowingListVC.swift
//  JioTask
//
//  Created by Jignesh kasundra on 18/08/20.
//  Copyright © 2020 Jignesh kasundra. All rights reserved.
//

import UIKit
import Alamofire

class FollowersFollowingListVC: UIViewController {
    
    //    MARK:-=========================   VARIABLE    ==================================
    
    var tableView = UITableView()
    let cellId = "cellId"
    var Followers : [followers]  = [followers]()
    var Following : [following]  = [following]()
    var user_name_FF = String()
    var type = String()
    var isStopPagination = false
    var pages = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backItem?.title = "Back"
        self.navigationItem.title = user_name_FF
        setUpView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = false
    }
    
    
    //    MARK:- ================================ ALL FUNCATION  ===========================
    
    func setUpView()
    {
        tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView.contentInset.top = 10
        tableView.frame = CGRect(x: 0, y: 60, width: displayWidth, height: displayHeight - 60)
        view.addSubview(tableView)
        
        tableView.register(userListCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        
        getuserList()
    }
    @objc func backAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}



//MARK:- ===================    TABLEVIEW METHOD ==========================================

extension FollowersFollowingListVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "followers"
        {
            return Followers.count
        }
        else
        {
            return Following.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! userListCell
        cell.selectionStyle = .none
        
        if type == "followers"
        {
            let currentuser = Followers[indexPath.row]
            cell.followers = currentuser
        }
        else
        {
            let currentuser = Following[indexPath.row]
            cell.following = currentuser
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if type == "followers"
        {
            if indexPath.row + 1 == Followers.count && !isStopPagination {
                pages += pages
                getuserList()
            }
        }
        else
        {
            if indexPath.row + 1 == Following.count && !isStopPagination {
                pages += pages
                getuserList()
            }
        }
    }
    
}


//MARK:- ===================    API CALL  ==========================================


extension FollowersFollowingListVC
{
    func getuserList() {
        
        var urlString = String()
        
        if type == "followers"
        {
            urlString = "https://api.github.com/users/\(user_name_FF)/followers?per_page=50&page=\(pages)"
        }
        else
        {
            urlString = "https://api.github.com/users/\(user_name_FF)/following?per_page=50&page=\(pages)"
        }
        
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded)
        {
            AF.request(url, method: .get,  parameters: nil, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let result = value as! NSArray
                        print(result)
                        
                        if result.count == 0 || result.count < 50 {
                            self.isStopPagination = true
                        }
                        if self.type == "followers"
                        {

                            for object in result
                            {
                                let temp_dic = object as! NSDictionary
                                self.Followers.append(followers(follower_name: temp_dic.value(forKey: "login") as! String, follower_image_url: temp_dic.value(forKey: "avatar_url") as! String))
                            }
                            if self.Followers.count != 0
                            {
                                self.tableView.restore()
                                self.tableView.reloadData()
                            }
                            else
                            {
                                self.tableView.setEmptyMessage("Opps! No data found!")
                                self.tableView.reloadData()
                            }
                        }
                        else
                        {
 
                            for object in result
                            {
                                let temp_dic = object as! NSDictionary
                                self.Following.append(following(following_name: temp_dic.value(forKey: "login") as! String, following_image_url: temp_dic.value(forKey: "avatar_url") as! String))
                            }
                            if self.Following.count != 0
                            {
                                self.tableView.restore()
                                self.tableView.reloadData()
                            }
                            else
                            {
                                self.tableView.setEmptyMessage("Opps! No data found!")
                                self.tableView.reloadData()
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                        self.isStopPagination = true
                        
                    }
            }
        }
    }
}

