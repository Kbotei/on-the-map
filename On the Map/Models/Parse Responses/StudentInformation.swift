//
//  StudentLocation.swift
//  On the Map
//
//  Created by Kbotei on 12/3/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?
    let udacity: Udacity?
}

struct Udacity: Codable {
    let username: String
    let password: String
}
