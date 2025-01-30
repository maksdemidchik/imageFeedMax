//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Maxim on 30.01.2025.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var loginNameLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func logout_button_action(_ sender: Any) {
    }
    

}
