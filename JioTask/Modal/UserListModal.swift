//
//  UserListModal.swift
//  JioTask
//
//  Created by Jignesh kasundra on 17/08/20.
//  Copyright © 2020 Jignesh kasundra. All rights reserved.
//

import UIKit

struct User {
    
    var UserName : String
    var UserImage : String
    
    init(UserName : String, UserImage : String) {
        self.UserName = UserName
        self.UserImage = UserImage
    }

    init?(dictionary : [String:String]) {
        guard let UserName = dictionary["UserName"],
            let UserImage = dictionary["UserImage"] else { return nil }
        self.init(UserName: UserName, UserImage: UserImage)
    }

    var userListRepresentation : [String:String] {
        return ["UserName" : UserName, "UserImage" : UserImage]
    }
    
    
}


struct followers {
    
    var follower_name : String
    var follower_image_url : String
}

struct following {
    
    var following_name : String
    var following_image_url : String
}
