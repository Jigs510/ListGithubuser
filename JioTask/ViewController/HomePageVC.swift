//
//  HomePageVC.swift
//  JioTask
//
//  Created by Jignesh kasundra on 17/08/20.
//  Copyright © 2020 Jignesh kasundra. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController {
    
    
    //    MARK:- ================================= VARIABLE  =============================
    
    let myLabel = UILabel()
    let searchButton = UIButton()
    let searchTextField = UITextField()
    let searchUserLabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    //    MARK:- ================================ ALL FUNCATION  ===========================
    
    func setUpView() {
        
        self.view.addSubview(myLabel)
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.text = "WelCome to jignesh Task"
        myLabel.textAlignment = .center
        myLabel.backgroundColor = .lightGray
        myLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        let margineGuide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            myLabel.topAnchor.constraint(equalTo: margineGuide.topAnchor, constant: 80),
            myLabel.leadingAnchor.constraint(equalTo: margineGuide.leadingAnchor),
            myLabel.heightAnchor.constraint(equalToConstant: 40),
            myLabel.trailingAnchor.constraint(equalTo: margineGuide.trailingAnchor)
        ])
        
        
        self.view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Enter user name"
        searchTextField.textAlignment = .center
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = self
        searchTextField.returnKeyType = .go
        
        NSLayoutConstraint.activate([
            searchTextField.centerYAnchor.constraint(equalTo: margineGuide.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: margineGuide.leadingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 35),
            searchTextField.trailingAnchor.constraint(equalTo: margineGuide.trailingAnchor)
        ])
        
        
        self.view.addSubview(searchUserLabel)
        searchUserLabel.translatesAutoresizingMaskIntoConstraints = false
        searchUserLabel.text = "Please enter github user name"
        searchUserLabel.textAlignment = .center
        
        
        
        NSLayoutConstraint.activate([
            searchUserLabel.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -10),
            searchUserLabel.leadingAnchor.constraint(equalTo: margineGuide.leadingAnchor),
            searchUserLabel.heightAnchor.constraint(equalToConstant: 40),
            searchUserLabel.trailingAnchor.constraint(equalTo: margineGuide.trailingAnchor)
        ])
        
        
        self.view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.backgroundColor = .blue
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.setTitle("Search", for: .normal)
        searchButton.layer.cornerRadius = 10
        searchButton.addTarget(self, action: #selector(searchResult(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 30),
            searchButton.leftAnchor.constraint(equalTo: margineGuide.leftAnchor, constant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.rightAnchor.constraint(equalTo: margineGuide.rightAnchor, constant: -40)
            
        ])
    }
    
    @objc func searchResult(sender:UIButton)
    {
        if searchTextField.text!.isEmpty
        {
            self.showMessageToUser(title: "Alert", msg: "Please enter user name")
            return
        }
        go_search_view()
    }
    
    func go_search_view() {
        
        self.view.endEditing(true)
        
        if !appDelegate.isReachable()
        {
            let alert = UIAlertController(title: "Alert", message: "Internet Connection Lost! Go with last Search", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                let userVC = UserListVC()
                userVC.search_user_name = self.searchTextField.text!.trimmingCharacters(in: .whitespaces)
                self.navigationController?.pushViewController(userVC, animated: true)
                
            })
            alert.addAction(ok)
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: { action in
                
            })
            alert.addAction(cancel)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        }
        else
        {
            
            let userVC = UserListVC()
            userVC.search_user_name = searchTextField.text!.trimmingCharacters(in: .whitespaces)
            self.navigationController?.pushViewController(userVC, animated: true)
        }
    }
    
}


//MARK:- ================================== DELEGATE METHOD  ===============================

extension HomePageVC:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if searchTextField.text!.isEmpty
        {
            return false
        }
        go_search_view()
        return true
    }
}





