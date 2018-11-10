//
//  EncryptionHelper.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/9/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//

import CryptoSwift
import Foundation

class EncryptionHelper {
    static func hash (string: String) -> String {
        return string.md5()
    }
}
