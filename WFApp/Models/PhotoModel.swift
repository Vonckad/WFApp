//
//  PhotoModel.swift
//  WFApp
//
//  Created by Vlad Ralovich on 4.02.22.
//

import Foundation

struct PhotoModel: Decodable, Hashable {
    var results: [ResultsPhoto]
}

struct ResultsPhoto: Decodable, Hashable {
    var id: String?
//    var created_at: String?
//    var updated_at: String?
//    var promoted_at: String?
//    var width: Int?
//    var height: Int?
//    var color: String?
//    var blur_hash: String?
    var description: String?
    var alt_description: String?
    var urls: UrlsPhoto
    var user: User
}

struct UrlsPhoto: Decodable, Hashable {
    var raw: String?
    var full: String?
    var regular: String?
}

struct User: Decodable, Hashable {
    let name: String?
    let location: String?
    let total_collections: Int?
}
