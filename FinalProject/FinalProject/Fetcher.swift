//
//  Fetcher.swift
//  FinalProject
//
//  Created by Van Simmons on 4/24/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

class Fetcher: NSObject, URLSessionDelegate {
    
    // Copied from Lecture 12, didn't see the point in re-writing this
    
    func session() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }
    
    // MARK: URLSessionDelegate
    func urlSession(_ session: URLSession,
                    didBecomeInvalidWithError error: Error?) {
        NSLog("\(#function): Session became invalid: " +
            "\(error?.localizedDescription ?? "(null)")")
    }
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        NSLog("\(#function): Session received authentication challenge")
        completionHandler(.performDefaultHandling,nil)
    }
    
    
    enum EitherOr {
        case failure(String)
        case success(Data)
    }
    
    typealias JSONCompletionHandler = (_ json: Any?, _ message: String?) -> Void
    func fetchJSON(url: URL, completion: @escaping JSONCompletionHandler) {
        fetch(url: url) { (result: EitherOr) in
            switch result {
            case .failure(let message):
                return completion(nil, message)
                
            case .success(let data):
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                    return completion(nil, "Could not parse JSON")
                }
                completion(json, nil)
            }
        }
    }
    
    typealias FetchCompletionHandler = (_ result: EitherOr) -> Void
    func fetch(url: URL, completion: @escaping FetchCompletionHandler) {
        let task = session().dataTask(with: url) {
            (data: Data?, response: URLResponse?, netError: Error?) in
            guard let response = response as? HTTPURLResponse, netError == nil
                else {
                    return completion(.failure(netError!.localizedDescription))
            }
            guard response.statusCode == 200
                else {
                    return completion(.failure("\(response.description)"))
            }
            guard let data = data
                else {
                    return completion(.failure("valid response but no data"))
            }
            completion(.success(data))
        }
        task.resume()
    }

    
    
}
