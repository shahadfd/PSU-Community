//
//  Api.swift
//  PSU Community
//
//  Created by MacBookPro on 27/03/1441 AH.
//  Copyright © 1441 Lamis. All rights reserved.
//

import Foundation
 struct Api {
     static var User = UserApi()
     static var Post = PostApi()
     static var Comment = CommentApi()
     static var Post_Comment = Post_CommentApi()
     static var MyPosts = MyPostsApi()
     static var Follow = FollowApi()
     static var Feed = FeedApi()
     static var HashTag = HashTagApi()
     static var Notification = NotificationApi()
 }

