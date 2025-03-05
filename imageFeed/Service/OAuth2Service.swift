//
//  OAuth2Service.swift
//  imageFeed
//
//  Created by Maxim on 16.02.2025.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    private var lastCode: String?
    
    var token : String?{
        get {
            OAuth2TokenStorage().beerToken
        }
        set{
            OAuth2TokenStorage().beerToken = newValue
        }
    }
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String,Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        guard  lastCode != code else{
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        let request = makeOAuthTokenRequest(code: code)
        let task = URLSession.shared.objectTask(for: request){ [weak self] (result:Result<OAuthTokenResponseBody,Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let tokenResponse):
                let accesstoken = tokenResponse.accessToken
                self.token = accesstoken
                completion(.success(accesstoken))
            case .failure(let error):
                print("Error in OAuth2Service (fetchOAuthToken) : \(error)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard let baseURL = URL(string: "https://unsplash.com") else{
            print("ошибка получения URL")
            preconditionFailure("Unable to construct baseURL")
        }
        
         guard let url = URL(
             string: "/oauth/token"
             + "?client_id=\(Constants.accessKey)"
             + "&&client_secret=\(Constants.secretKey)"
             + "&&redirect_uri=\(Constants.redirectURI)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL
         ) else{
             print("ошибка получения URLRequest")
             preconditionFailure("Unable to construct URLRequest")
         }
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
}
