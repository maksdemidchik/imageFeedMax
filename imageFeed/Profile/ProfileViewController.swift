//
//  ProfileViewController.swift
//  imageFeed
//
//  Created by Maxim on 30.01.2025.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url:URL)
    func setUserInfo(profile: Profile?)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    private var profileImageServiceObserver: NSObjectProtocol?
    private let alert = AlertPresenter.shared
    private var avatarImage: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named:"avatar")
        view.image = image
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
    var presenter: ProfilePresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        profileImageObserver()
        self.view.backgroundColor = .ypBlack
        presenter?.viewDidLoad()
    }
    
    @objc private func logoutButtonAction() {
        alert.showAlertTwoButton(self, title: "Пока, пока!", message: "Уверены, что хотите выйти?", buttonTitle: "Да", buttonTitleTwo: "Нет"){ [weak self] in
            guard let self = self else { return }
            self.presenter?.reset()
        }
    }
    
    private func labelSettings(label: UILabel,choiseBefore:String,before1: UIImageView,before2: UILabel)
    {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        if choiseBefore == "label" {
            label.topAnchor.constraint(equalTo: before2.bottomAnchor, constant: 8).isActive = true
        } else {
            label.topAnchor.constraint(equalTo: before1.bottomAnchor, constant: 8).isActive = true
        }
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
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
    private func updateUI(){
        imageSettings(image: avatarImage)
        labelSettings(label: nameLabel, choiseBefore: "ImageView", before1: avatarImage, before2: nameLabel)
        labelSettings(label: loginNameLabel, choiseBefore: "label", before1: avatarImage,before2: nameLabel)
        labelSettings(label: descriptionLabel, choiseBefore: "label", before1: avatarImage,before2: loginNameLabel)
        let logOutButton = UIButton.systemButton(with: UIImage(named: "logout_button") ?? UIImage(), target: self, action: #selector(self.logoutButtonAction))
        buttonSettings(button: logOutButton, textColor: .redYP, image: avatarImage)
        self.logOutButton = logOutButton
        self.view.backgroundColor = .ypBlack
        logOutButton.accessibilityIdentifier = "logOutButton"
    }
    
    private func profileImageObserver(){
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main){ [weak self] _ in
            guard let self = self else { return }
            self.presenter?.updateAvatar()
        }
    }
    func updateAvatar(url:URL){
        let processor = RoundCornerImageProcessor(cornerRadius: 90,backgroundColor: .ypBlack)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(with: url,
                                placeholder: UIImage(named: "placeholder.jpeg"),
                                options: [.processor(processor)])
    }
    func setUserInfo(profile: Profile?){
        if let profile{
            nameLabel.text = profile.name
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        }
    }
    
}
