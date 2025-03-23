//
//  ProfileService.swift
//  imageFeed
//
//  Created by Maxim on 01.03.2025.
//

import Foundation


final class ProfileService{
    private var prof: Profile?
    private let urlSession = URLSession.shared
    static let sharedProfile = ProfileService()
    
    private init() {}
    
    private var task: URLSessionTask?
    
    private var lastToken: String?
    var profile: Profile? {
        get{
            return prof
        }
        set{
            prof=newValue
        }
    }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        guard lastToken != token else {
            
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastToken = token
        let request = makeReqest(token: token)
        let task = URLSession.shared.objectTask(for: request){ [weak self] (result:Result<ProfileResult,Error>) in
            guard let self = self else { return }
            switch result{
            case .success(let profileInformation):
                var bio = ""
                if let bio1 = profileInformation.bio{
                    bio=bio1
                }
                var firstName = ""
                if let firstName1 = profileInformation.firstName{
                    firstName=firstName1
                }
                var secondName = ""
                if let secondName1 = profileInformation.lastName{
                    secondName=secondName1
                }
                let name = firstName + " " + secondName
                let profile = Profile(username: profileInformation.username, name: name, loginName: ("@"+profileInformation.username), bio: bio)
                completion(.success(profile))
            case .failure(let error):
                print("Error in ProfileService(fetchProfile) : \(error)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastToken = nil
        }
        self.task = task
        task.resume()
    }
    
    func makeReqest(token: String) -> URLRequest{
        guard let baseURL = URL(string: "https://api.unsplash.com/me") else{
            print("ошибка получения URL")
            preconditionFailure("Unable to construct baseURL")
        }
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        print(request)
        return request
    }
   
    
}
