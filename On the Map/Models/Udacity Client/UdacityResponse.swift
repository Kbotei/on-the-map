//
//  UdacityResponse.swift
//  On the Map
//
//  Created by Kbotei on 12/4/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
