//
//  UserListVC.swift
//  JioTask
//
//  Created by Jignesh kasundra on 17/08/20.
//  Copyright © 2020 Jignesh kasundra. All rights reserved.
//

import UIKit
import Alamofire

class UserListVC: UIViewController {
    
    
    //    MARK:-=========================   VARIABLE    ==================================
    
    var tableView = UITableView()
    var up_button = UIButton()
    
    
    
    let cellId = "cellId"
    var userList : [User]  = [User]()
    var search_user_name = String()
    var isStopPagination = false
    var offset = 0
    
    
    let encoder = JSONEncoder()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backItem?.title = search_user_name
        self.navigationItem.title = search_user_name
        setUpView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = false
    }
    
    //    MARK:- ================================ ALL FUNCATION  ===========================
    
    func setUpView()
    {
        let margineGuide = view.layoutMarginsGuide
        
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
        
        
        self.view.addSubview(up_button)
        up_button.translatesAutoresizingMaskIntoConstraints = false
        up_button.layer.cornerRadius = 25
        up_button.clipsToBounds = true
        up_button.contentMode = .scaleAspectFill
        up_button.backgroundColor = UIColor.red
        up_button.setImage(UIImage(named: "upload"), for: .normal)
        up_button.addTarget(self, action: #selector(back_to_top(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            up_button.bottomAnchor.constraint(equalTo: margineGuide.bottomAnchor, constant: -15),
            up_button.heightAnchor.constraint(equalToConstant: 50),
            up_button.widthAnchor.constraint(equalToConstant: 50),
            up_button.rightAnchor.constraint(equalTo: margineGuide.rightAnchor, constant: -15),
        ])
        
        up_button.isHidden = true
        
        
        if appDelegate.isReachable()
        {
            getuserList()
        }
        else
        {
            if let userlist = UserDefaults.standard.array(forKey: "saveUser") as? [[String:String]] {
                self.userList = userlist.compactMap{ User(dictionary: $0) }
            }
            
            print(userList.count)
            tableView.reloadData()
        }
    }
    
    
    @objc func back_to_top(sender:UIButton)
    {
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        tableView.reloadData()
    }
}



//MARK:- ===================    TABLEVIEW METHOD ==========================================

extension UserListVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! userListCell
        cell.selectionStyle = .none
        let currentuser = userList[indexPath.row]
        cell.User = currentuser
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == userList.count && !isStopPagination {
            offset += offset
            getuserList()
        }
        
        if indexPath.row > 15
        {
            up_button.isHidden = false
        }
        else
        {
            up_button.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let push = UserDetailsVC()
        let currentuser = userList[indexPath.row]
        push.user_name = currentuser.UserName
        push.image_url = currentuser.UserImage
        tableView.isHidden = true
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    
    
}


//MARK:- ===================    API CALL  ==========================================


extension UserListVC
{
    func getuserList() {
        
        let urlString = "https://api.github.com/search/users?q=\(search_user_name)&page=\(offset)"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded)
        {
            AF.request(url, method: .get,  parameters: nil, encoding: JSONEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let result = (value as! NSDictionary).value(forKey: "items") as! NSArray
                        print(result)
                        if result.count == 0 || result.count < 20 {
                            self.isStopPagination = true
                        }
                        for object in result
                        {
                            let temp_dic = object as! NSDictionary
                            self.userList.append(User(UserName: temp_dic.value(forKey: "login") as! String, UserImage: temp_dic.value(forKey: "avatar_url") as! String))
                        }
                        
                        
                        let saveUserlist = self.userList.map{ $0.userListRepresentation }
                        UserDefaults.standard.set(saveUserlist, forKey: "saveUser")
                        
    
                        if self.userList.count != 0
                        {
                            self.tableView.restore()
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.tableView.setEmptyMessage("Opps! No data found!")
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                        self.isStopPagination = true
                    }
            }
        }
    }
    
    
    
}



