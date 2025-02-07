//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Maxim on 30.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatarImage: UIImageView = {
        let view=UIImageView()
        let image=UIImage(named:"avatar")
        view.image=image
        return view
    }()
    
    private var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .yPgrey
        return label
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .yPwhite
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .yPwhite
        return label
    }()
    
    private var logOutButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSettings(image: avatarImage)
        labelSettings(UIlabel: nameLabel, choiseBefore: "ImageView", before1: avatarImage, before2: nameLabel)
        labelSettings(UIlabel: loginNameLabel, choiseBefore: "label", before1: avatarImage,before2: nameLabel)
        labelSettings(UIlabel: descriptionLabel, choiseBefore: "label", before1: avatarImage,before2: loginNameLabel)
        let logOutButton = UIButton.systemButton(with: UIImage(named: "logout_button") ?? UIImage(), target: self, action: #selector(self.logoutButtonAction))
        buttonSettings(button: logOutButton, textColor: .redYP, image: avatarImage)
        self.logOutButton = logOutButton
    }
    
    private func labelSettings(UIlabel: UILabel,choiseBefore:String,before1: UIImageView,before2: UILabel)
    {
        UIlabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(UIlabel)
        if choiseBefore == "label" {
            UIlabel.topAnchor.constraint(equalTo: before2.bottomAnchor, constant: 8).isActive = true
        } else {
            UIlabel.topAnchor.constraint(equalTo: before1.bottomAnchor, constant: 8).isActive = true
        }
        UIlabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func imageSettings(image: UIImageView){
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16).isActive = true
        image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        image.widthAnchor.constraint(equalToConstant: 70).isActive = true
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func buttonSettings(button: UIButton,textColor: UIColor,image: UIImageView){
        button.tintColor = textColor
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    @objc private func logoutButtonAction() {
        // TODO: - Добавить логику при нажатии на кнопку
    }
    

}
