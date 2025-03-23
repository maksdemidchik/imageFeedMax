//
//  ImageListService.swift
//  imageFeed
//
//  Created by Maxim on 20.03.2025.
//

import Foundation
final class ImageListService{
    private (set) var photos: [Photo] = []
    private let oauth2Service = OAuth2Service.shared
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private var taskForLikeRequest: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImageListService()
    private init(){}
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        taskForLikeRequest?.cancel()
        let request = makeRequestForLike(id: photoId, liked: isLike)
        let task = URLSession.shared.objectTask(for: request){[weak self] (result:Result<PhotoForLike,Error>) in
            guard let self = self else { return }
            switch result{
            case . success(let like):
                let like = like.photo.isLiked
                if let index = self.photos.firstIndex(where: {$0.id == photoId}){
                    let photo = self.photos[index]
                    let newPhoto = Photo(id: photo.id, size: photo.size, createdAt: photo.createdAt, description: photo.description, thumbImageURL: photo.thumbImageURL, largeImageURL: photo.largeImageURL, isLiked: like)
                    self.photos[index] = newPhoto
                }
                completion(.success(()))
                NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: self)
            case .failure(let error):
                print("Error in ImageListService(changeLike) : \(error)")
                completion(.failure(error))
            }
            self.taskForLikeRequest = nil
        }
        self.taskForLikeRequest = task
        task.resume()
    }
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        let request = makePhotosRequest()
        guard task == nil else { return }
        let task = URLSession.shared.objectTask(for: request){ [weak self ] (result:Result<[PhotoResult],Error>) in
            guard let self = self else { return }
            switch result{
             case .success(let photoResult):
                photoResult.forEach{photo in
                    let newPhoto = Photo(id: photo.id, size: CGSize(width: photo.width, height: photo.height), createdAt: photo.createdAt, description: photo.description, thumbImageURL: photo.urls.thumb, largeImageURL: photo.urls.full, isLiked: photo.isLiked)
                    self.photos.append(newPhoto)
                }
                let nextPage = (lastLoadedPage ?? 0) + 1
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: self)
             case .failure(let error):
                print("Error in ImageListService(fetchPhotosNextPage) : \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
        
    }
    
    private func makePhotosRequest() -> URLRequest{
        let nextPage = (lastLoadedPage ?? 0) + 1
        self.lastLoadedPage = nextPage
        guard let baseURL = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)") else{
            print("ошибка получения URL")
            preconditionFailure("Unable to construct baseURL")
        }
        var request = URLRequest(url: baseURL)
        guard let token = oauth2Service.token else {
            print("Unable to token")
            preconditionFailure("Unable to token")
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private func makeRequestForLike(id: String, liked: Bool) -> URLRequest{
        guard let baseURL = URL(string: "https://api.unsplash.com/photos/\(id)/like") else{
            print("ошибка получения URL")
            preconditionFailure("Unable to construct baseURL")
        }
        var request = URLRequest(url: baseURL)
        guard let token = oauth2Service.token else {
            print("Unable to token")
            preconditionFailure("Unable to token")
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = liked ? "POST" : "DELETE"
        return request
    }
    func cleanPhoto(){
        photos.removeAll()
        lastLoadedPage = 0
    }
}
