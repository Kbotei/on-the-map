//
//  NetworkClient.swift
//  On the Map
//
//  Created by Kbotei on 12/2/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import Foundation

protocol NetworkClient {
    static func getRequest<ResponseType: Decodable>(url: URL,
                                                   responseType: ResponseType.Type,
                                                   completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask
    
    static func postRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL,
                                                                            responseType: ResponseType.Type,
                                                                            body: RequestType,
                                                                            completion: @escaping (ResponseType?, Error?) -> Void)
}

extension NetworkClient {
    
    // MARK - Network Requests
    
    // Pull in a few methods from The Movie Manager app.
    static func getRequest<ResponseType: Decodable>(url: URL,
                                                   responseType: ResponseType.Type,
                                                   completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(NetworkResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
        return task
    }
    
    static func postRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL,
                                                                            responseType: ResponseType.Type,
                                                                            body: RequestType,
                                                                            completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(NetworkResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
}
