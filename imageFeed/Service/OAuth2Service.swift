//
//  OAuth2Service.swift
//  imageFeed
//
//  Created by Maxim on 16.02.2025.
//

import Foundation

final class OAuth2Service {
    
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
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String,Error>) -> Void)
    {
        let request = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.data(for: request){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.token = response.accessToken
                    completion(.success(response.accessToken))
                }
                catch{
                    print("ошибка декодирования \(error)")
                    completion(.failure(error))
                    return
                }
                
            case .failure(let error):
                print("ошибка сети \(error)")
                completion(.failure(error))
                return
            }
        }
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
