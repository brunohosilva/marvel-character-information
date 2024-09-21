//
//  GenerateMD5.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

import Foundation
import CryptoKit

public func md5(_ string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8)!)
    return digest.map { String(format: "%02hhx", $0) }.joined()
}


