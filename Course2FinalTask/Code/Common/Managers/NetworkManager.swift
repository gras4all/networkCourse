//
//  NetworkManager.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 02.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    static let kToken = "token"
    
    static var shared: NetworkManager = NetworkManager()
    
    let scheme = "http"
    let host = "localhost"
    let hostPath = "http://localhost:8080"
    var token = "" {
        didSet {
            if let data = token.data(using: .utf8) {
                let status = KeyChain.save(key: KeyChain.kToken, data: data)
                print("KeyChain save status: ", status)
            }
        }
    }
    var defaultHeaders: [String: String] {
        var headers = [
            "Content-Type" : "application/json",
        ]
        headers["token"] = token
        return headers
    }
    var isOffline: Bool = false
    
    let sharedSession = URLSession.shared
    
    func performRequest(request: URLRequest,
                        completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = sharedSession.dataTask(with: request, completionHandler: completion)
        dataTask.resume()
    }
    
    func loginRequest(username: String,
                      password: String,
                      success: @escaping () -> Void,
                      errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/signin"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeaders
        let parameters: [String: Any] = [
            "login": username,
            "password": password
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        performRequest(request: request, completion: { [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else { return }
            if let data = data,
               let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                _self.token = loginResponse.token
                success()
            }
        })
    }
    
    func logoutRequest(success: @escaping () -> Void,
                       errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/signout"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeaders
        performRequest(request: request, completion: { [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else { return }
            success()
        })
    }
    
    func feedRequest(success: @escaping ([Post]) -> Void, errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/posts/feed"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        performRequest(request: request, completion: {  [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else {
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode([Post].self, from: data) {
               success(response)
            }
        })
    }
    
    func getPostsUserRequest(userId: String, success: @escaping ([Post]) -> Void, errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/users/\(userId)/posts"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        performRequest(request: request, completion: {  [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else {
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode([Post].self, from: data) {
               success(response)
            }
        })
    }
    
    func getUsersLikedThisPost(postId: String, success: @escaping ([User]) -> Void, errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/posts/\(postId)/likes"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        performRequest(request: request, completion: {  [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else {
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode([User].self, from: data) {
               success(response)
            }
        })
    }
    
    func getFollowingUsers(userId: String, success: @escaping ([User]) -> Void, errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/users/\(userId)/following"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        performRequest(request: request, completion: {  [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else {
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode([User].self, from: data) {
               success(response)
            }
        })
    }
    
    func getFollowedUsers(userId: String, success: @escaping ([User]) -> Void, errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/users/\(userId)/followers"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        performRequest(request: request, completion: {  [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else {
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode([User].self, from: data) {
               success(response)
            }
        })
    }
    
    func likeRequest(postId: String,
                     success: @escaping (Post) -> Void,
                     errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/posts/like"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeaders
        let parameters: [String: Any] = [
            "postID": postId,
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        performRequest(request: request, completion: { [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else { return }
            if let data = data,
               let post = try? JSONDecoder().decode(Post.self, from: data) {
                success(post)
            }
        })
    }
    
    func unlikeRequest(postId: String,
                     success: @escaping (Post) -> Void,
                     errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/posts/unlike"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeaders
        let parameters: [String: Any] = [
            "postID": postId,
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        performRequest(request: request, completion: { [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else { return }
            if let data = data,
               let post = try? JSONDecoder().decode(Post.self, from: data) {
                success(post)
            }
        })
    }
    
    func followRequest(userId: String,
                     success: @escaping (User) -> Void,
                     errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/users/follow"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeaders
        let parameters: [String: Any] = [
            "userID": userId,
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        performRequest(request: request, completion: { [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else { return }
            if let data = data,
               let user = try? JSONDecoder().decode(User.self, from: data) {
                success(user)
            }
        })
    }
    
    func unfollowRequest(userId: String,
                     success: @escaping (User) -> Void,
                     errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/users/unfollow"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeaders
        let parameters: [String: Any] = [
            "userID": userId,
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        performRequest(request: request, completion: { [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else { return }
            if let data = data,
               let user = try? JSONDecoder().decode(User.self, from: data) {
                success(user)
            }
        })
    }
    
    func createPostRequest(image: String,
                           description: String,
                           success: @escaping (Post) -> Void,
                           errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/posts/create"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeaders
        let parameters: [String: Any] = [
            "image": image,
            "description": description,
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        performRequest(request: request, completion: { [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else { return }
            if let data = data,
               let post = try? JSONDecoder().decode(Post.self, from: data) {
                success(post)
            }
        })
    }
    
    func getCurrentUser(success: @escaping (User) -> Void, errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/users/me"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        performRequest(request: request, completion: {  [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else {
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode(User.self, from: data) {
               success(response)
            }
        })
    }
    
    func getUser(userId: String, success: @escaping (User) -> Void, errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/users/\(userId)"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        performRequest(request: request, completion: {  [weak self] (data, response, error) in
            guard let _self = self else { return }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else {
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode(User.self, from: data) {
               success(response)
            }
        })
    }
    
    func checkToken(token: String, success: @escaping () -> Void, errorHandler: @escaping (Int) -> Void) {
        let requestPath = "/checkToken"
        guard let url = getUrl(path: requestPath) else {
            return
        }
        var request = URLRequest(url: url)
        var headers = defaultHeaders
        headers["token"] = token
        request.allHTTPHeaderFields = headers
        performRequest(request: request, completion: {  [weak self] (data, response, error) in
            guard let _self = self else { return }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    _self.token = token
                    success()
                }
            } else {
                errorHandler(-1)
            }
            guard _self.checkResponse(path: requestPath, error: error, response: response, data: data, errorHandler: errorHandler) else {
                return
            }
        })
    }
    
    func logout() {
        token = ""
        AppSettings.shared.currentUser = nil
        KeyChain.deleteItems()
    }
    
    private func getUrl(path: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.port = 8080
        urlComponents.path = path
        return urlComponents.url
    }
    
    private func checkResponse(path: String,
                               error: Error?,
                               response: URLResponse?,
                               data: Data?,
                               errorHandler: ((Int) -> Void)? = nil) -> Bool {
        if let error = error {
            print(error.localizedDescription)
            if let httpResponse = response as? HTTPURLResponse {
                errorHandler?(httpResponse.statusCode)
            } else {
                errorHandler?(-1)
            }
            return false
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("======> " + path + " completed with status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                errorHandler?(httpResponse.statusCode)
            }
        }
        guard let data = data else {
            print("no data received")
            return false
        }
        return true
    }
    
}

