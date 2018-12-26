//
//  ParseClient.swift
//  On the Map
//
//  Created by Kbotei on 12/2/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import Foundation

class ParseClient {
    static let applicationId = "APPID"
    static let apiKey = "APIKEY"
    
    enum Endpoints {
        static let base = "https://parse.udacity.com/parse/classes"
        
        case createLocation
        case studentLocations
        case updateLocation(String)
        
        var stringValue: String {
            switch self {
            case .createLocation:
                return Endpoints.base + "/StudentLocation"
            case .studentLocations:
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .updateLocation(let objectId):
                return Endpoints.base + "/StudentLocation/\(objectId)"
            }
        }
        
        var url: URL { return URL(string: stringValue)! }
    }
    
    // MARK - Network Requests
    
    class func getStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        let task = getRequest(url: Endpoints.studentLocations.url, responseType: StudentLocationResults.self) { data, error in
            if let data = data {
                StudentData.locations = data.results
                completion(data.results, nil)
            } else {
                completion([], error)
            }
        }
        
        task.resume()
    }
    
    class func createStudentLocation(location: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        postRequest(url: Endpoints.createLocation.url, responseType: StudentInformation.self, body: location) { response, error in
            if let response = response {
                completion(!response.objectId!.isEmpty, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // Pull in a few methods from The Movie Manager app.
    class func getRequest<ResponseType: Decodable>(url: URL,
                                                    responseType: ResponseType.Type,
                                                    completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
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
        return task
    }
    
    static func postRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL,
                                                                             responseType: ResponseType.Type,
                                                                             body: RequestType,
                                                                             completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
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
