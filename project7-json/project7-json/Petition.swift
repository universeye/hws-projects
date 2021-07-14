//
//  Petition.swift
//  project7-json
//
//  Created by Terry Kuo on 2021/7/14.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
