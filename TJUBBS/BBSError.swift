//
//  BBSError.swift
//  TJUBBS
//
//  Created by Halcao on 2018/11/8.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

enum BBSError: Error {
    case custom(String)
    case errorCode(Int, String)
}

extension BBSError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .custom(let desc):
            return desc
        case .errorCode(let code, let desc):
            return desc + " 错误码: \(code)"
        }
    }
}
