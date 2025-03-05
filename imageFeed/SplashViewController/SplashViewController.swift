//
//  SplashViewController.swift
//  imageFeed
//
//  Created by Maxim on 17.02.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service.shared
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.sharedProfile
    private let showAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    private let alertPres=AlertPresenter.shared
    private var splashImage: UIImageView{
        let imgView=UIImageView()
        let img=UIImage(named: "1. Splash Screen (базовая версия) 1")
        imgView.image=img
        return imgView
    }
    private var beerToken = OAuth2TokenStorage().beerToken
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transitionDuringAuthorization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImgConstraintsAndColorView(img: splashImage)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: " TabBarController")
        window.rootViewController = tabBarController
    }
    private func fetchProfile(completion: @escaping () -> Void) {
        guard let token=oauth2Service.token else { return }
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token){ [weak self] result in
            guard let self=self else {
                print("error")
                return
            }
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                let profile=Profile(username: profile.username, name: profile.name, loginName: profile.loginName, bio: profile.bio)
                self.profileService.profile = profile
                self.profileImageService.fetchProfileImageURL(username: profile.username){_ in 
                    
                }
                

            case .failure(let error):
               print("Error in fetchProfile:\(error)")
            }
            completion()
            
        }
    }
    private func fetchoathToken(code:String){
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code){ [weak self] result in
            guard let self=self else { return }
            switch result {
            case .success:
                self.fetchProfile{
                  
                   UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                showAlert()
                
            }
        }
        
    }
    private func setImgConstraintsAndColorView(img:UIImageView){
        img.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(img)
        img.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        img.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        img.widthAnchor.constraint(equalToConstant: 73).isActive=true
        img.heightAnchor.constraint(equalToConstant: 75).isActive=true
        view.backgroundColor = .ypBlack
    }
    
    private func goToAuthViewController(){
        
        let storiesboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storiesboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            print("Error in AuthViewController")
            return
        }
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        print("auth")
          
    }
    
    private func transitionDuringAuthorization(){
        if let token = OAuth2TokenStorage().beerToken {
            UIBlockingProgressHUD.show()
            self.fetchProfile{ [weak self] in
                guard let self = self else { return }
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            }
        }
        else {
            goToAuthViewController()
        }
    }
    
    private func showAlert(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.alertPres.showAlert(self, title: "Что-то пошло не так", message: "Не удалось войти в систему", ButtonTitle: "Ок"){[weak self] in
                guard let self = self else { return }
                self.transitionDuringAuthorization()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
   
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.fetchoathToken(code: code)
            }
        }
}


