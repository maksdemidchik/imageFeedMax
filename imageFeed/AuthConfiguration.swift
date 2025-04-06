//
//  Constants.swift
//  imageFeed
//
//  Created by Maxim on 13.02.2025.
//

import Foundation
enum Constants{
    static let accessKey = "6aJMMKCAeoeqd9F3eet3fgK69-_JVvaIFrNXSVXufpU"
    static let secretKey = "2dWGPwW7FgF_2G2VA7mSsl6P6fTQphP3HM1QdNUhmfo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static var defaultBaseURL: URL {
            guard let url = URL(string: "https://api.unsplash.com") else {
                preconditionFailure("Unable to construct defaultBaseURL")
            }
            return url
        }
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: Constants.accessKey,
                                     secretKey: Constants.secretKey,
                                     redirectURI: Constants.redirectURI,
                                     accessScope: Constants.accessScope,
                                     defaultBaseURL: Constants.defaultBaseURL,
                                     authURLString: Constants.unsplashAuthorizeURLString)
        }
}
