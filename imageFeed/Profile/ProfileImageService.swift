//
//  ProfileImageService.swift
//  imageFeed
//
//  Created by Maxim on 02.03.2025.
//

import Foundation


final class ProfileImageService{
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let oauth2Service = OAuth2Service.shared
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    static let shared = ProfileImageService()
    private init(){}
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        let request = makeReqest(username: username)
        let task = URLSession.shared.objectTask(for: request){ [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result{
                case .success(let userResult):
                guard let avatarURLString = userResult.profileImage.large else {
                    return
                }
                self.avatarURL=avatarURLString
                print(avatarURLString)
                completion(.success(avatarURLString))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo:["URL":avatarURLString])
                
                
            case .failure(let error):
                print("Error in ProfileImageService(fetchProfileImageURL) : \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    private func makeReqest(username: String) -> URLRequest{
        guard let baseURL = URL(string: "https://api.unsplash.com/users/" + username) else{
            print("ошибка получения URL")
            preconditionFailure("Unable to construct baseURL")
        }
        var request = URLRequest(url: baseURL)
        guard let token = oauth2Service.token else {
            print("Unable to token")
            preconditionFailure("Unable to token")
        }
        print(request)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    func cleanAvatarUrl(){
        avatarURL = nil
    }
}
