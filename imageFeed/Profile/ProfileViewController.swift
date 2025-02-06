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
        
        let avatarImage=UIImageView(image:UIImage(named:"avatar"))
        
        imageSettings(UIImage: avatarImage)
        
        self.avatarImage=avatarImage
        
        let nameLabel=UILabel()
        
        labelSettings(UIlabel: nameLabel, choiseBefore: "ImageView", Before1: avatarImage, Before2: nameLabel, text: "Екатерина Новикова", font: .systemFont(ofSize: 23, weight: .semibold) , textColor: .yPwhite)
        
        self.nameLabel=nameLabel
        
        let loginNameLabel=UILabel()
        
        labelSettings(UIlabel: loginNameLabel, choiseBefore: "label", Before1: avatarImage,Before2: nameLabel, text: "@ekaterina_nov", font: .systemFont(ofSize: 13, weight: .regular), textColor: .yPgrey)
        
        self.loginNameLabel=loginNameLabel
        
        let descriptionLabel=UILabel()
        
        labelSettings(UIlabel: descriptionLabel, choiseBefore: "label", Before1: avatarImage,Before2: loginNameLabel, text: "Hello, world!", font: .systemFont(ofSize: 13, weight: .regular), textColor: .yPwhite)
        self.descriptionLabel=descriptionLabel
        
        let logOutButton = UIButton.systemButton(with: UIImage(named: "logout_button")!, target: self, action: #selector(self.logout_button_action))
        
        buttonSettings(UIButton: logOutButton, textColor: .redYP, UiImage: avatarImage)
        
        self.logOutButton=logOutButton
       
    }
    
    private func labelSettings(UIlabel: UILabel,choiseBefore:String,Before1: UIImageView,Before2: UILabel,text: String,font: UIFont,textColor: UIColor)
    {
        
        UIlabel.text = text
        
        UIlabel.font = font
        
        UIlabel.textColor = textColor
        
        UIlabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(UIlabel)
        
        if choiseBefore == "label"{
            
            UIlabel.topAnchor.constraint(equalTo: Before2.bottomAnchor, constant: 8).isActive = true
            
        }
        
        else{
            
            UIlabel.topAnchor.constraint(equalTo: Before1.bottomAnchor, constant: 8).isActive = true
            
        }
        
        UIlabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
    }
    
    private func imageSettings(UIImage: UIImageView){
        
        UIImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(UIImage)
        
        UIImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16).isActive = true
        
        UIImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        UIImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        UIImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    private func buttonSettings(UIButton: UIButton,textColor: UIColor,UiImage: UIImageView){
        
        UIButton.tintColor = textColor
        
        UIButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(UIButton)
        
        UIButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16).isActive = true
        
        UIButton.centerYAnchor.constraint(equalTo: UiImage.centerYAnchor).isActive = true
        
        UIButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        UIButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }

    
    @IBAction func logout_button_action(_ sender: Any) {
        
    }
    

}
