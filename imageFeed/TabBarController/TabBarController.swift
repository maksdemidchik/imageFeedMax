//
//  TabBarController.swift
//  imageFeed
//
//  Created by Maxim on 04.03.2025.
//

import UIKit

final class TabBarController:UITabBarController{
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageListViewController = storyboard.instantiateViewController(identifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        self.viewControllers = [imageListViewController, profileViewController]
        
    }
}
