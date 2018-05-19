//
//  Network.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badResponse
    case httpError(code: Int)
    case emptyData
}

enum NetworkOperationResult<T> {
    case success(result: T)
    case failure(with: Error)
}
typealias NetworkOperationCompletion<T> = (NetworkOperationResult<T>) -> ()

struct API {
    
    private init(){}
    
    static let base = "https://stdevtask3-0510.restdb.io/rest/"
    static let apiKey = "a5b39dedacbffd95e1421020dae7c8b5ac3cc"
    
    struct Headers {
        private init(){}
        static let apiKey = "x-apikey"
    }
    
    enum Endpoints: String {
        case contacts
    }
    
    struct  URLs {
        private init() {}
        static var getContacts: URL {
            return URL(string: base + Endpoints.contacts.rawValue)!
        }
        static var postContact: URL {
            return URL(string: base + Endpoints.contacts.rawValue)!
        }
    }
    
    struct Requests {
        private init() {}
        static var getAllUsers: URLRequest {
            var request = URLRequest(url: API.URLs.getContacts)
            request.setValue("application/json; charset=utf-8",
                             forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8",
                             forHTTPHeaderField: "Accept")
            request.setValue(apiKey, forHTTPHeaderField: Headers.apiKey)
            return request
        }
        static func createNew(user: User) -> URLRequest {
            var request = URLRequest(url: API.URLs.postContact)
            request.setValue("application/json; charset=utf-8",
                             forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8",
                             forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let userJsonData = try? JSONSerialization.data(withJSONObject: user.jsonDict)
            request.httpBody = userJsonData
            request.setValue(apiKey, forHTTPHeaderField: Headers.apiKey)
            return request
        }
    }
    
}

class Network {
    
    static let session =  { () -> URLSession in
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 30
        let session = URLSession(configuration: sessionConfig)
        return session
    }()
    
    static func getContancts(completion: @escaping NetworkOperationCompletion<[User]>) {
        let task = session.dataTask(with: API.Requests.getAllUsers)
        { (data, response, error) in
            if let error = error {
                completion(.failure(with: error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(with: NetworkError.badResponse))
                return
            }
            let statusCode = httpResponse.statusCode
            if !(200 ... 299 ~= statusCode)  {
                completion(.failure(with: NetworkError.httpError(code: statusCode)))
                return
            }
            guard let data = data else  {
                completion(.failure(with: NetworkError.emptyData))
                return
            }
            let contacts = APIDataSerializer.users(from: data)
            completion(.success(result: contacts))
        }
        task.resume()
    }
    
    static func createContanct(for user: User, completion: @escaping NetworkOperationCompletion<User>) {
        let task = session.dataTask(with: API.Requests.createNew(user: user))
        { (data, response, error) in
            if let error = error {
                completion(.failure(with: error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(with: NetworkError.badResponse))
                return
            }
            let statusCode = httpResponse.statusCode
            if !(200 ... 299 ~= statusCode)  {
                completion(.failure(with: NetworkError.httpError(code: statusCode)))
                return
            }
            guard let data = data else  {
                completion(.failure(with: NetworkError.emptyData))
                return
            }
            if let newUser = APIDataSerializer.user(from: data) {
                completion(.success(result: newUser))
            } else {
                completion(.failure(with: NetworkError.emptyData))
            }
        }
        task.resume()
    }
    
}


