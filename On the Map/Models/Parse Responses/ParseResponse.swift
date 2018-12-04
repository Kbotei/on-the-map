//
//  ParseResponse.swift
//  On the Map
//
//  Created by Kbotei on 12/3/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import Foundation

struct ParseResponse: Codable {
    let error: String
}

extension ParseResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
