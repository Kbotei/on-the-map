//
//  ParseClient.swift
//  On the Map
//
//  Created by Kbotei on 12/2/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import Foundation

class ParseClient { //: NetworkClient {
    static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    enum Endpoints {
        static let base = "https://parse.udacity.com/parse/classes"
        
        case studentLocations
        
        var stringValue: String {
            switch self {
            case .studentLocations:
                return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL { return URL(string: stringValue)! }
    }
    
    // MARK - Network Requests
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        let task = getRequest(url: Endpoints.studentLocations.url, responseType: [StudentLocation].self) { data, error in
            if let data = data {
                completion(data, nil)
            } else {
                completion([], error)
            }
        }
        
        task.resume()
    }
    
    // Pull in a few methods from The Movie Manager app.
    class func getRequest<ResponseType: Decodable>(url: URL,
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
                    let errorResponse = try decoder.decode(ParseResponse.self, from: data) as Error
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
                    let errorResponse = try decoder.decode(ParseResponse.self, from: data) as Error
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
