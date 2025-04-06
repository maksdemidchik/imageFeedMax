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
        guard let imageListViewController = imageListViewController as? ImagesListViewController else { return }
        let ImageListPresenter = ImageListPresenter()
        ImageListPresenter.view = imageListViewController
        imageListViewController.presenter = ImageListPresenter
        let profilePresenter = ProfilePresenter()
        let profileViewController = ProfileViewController()
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        self.viewControllers = [imageListViewController, profileViewController]
        
    }
}
