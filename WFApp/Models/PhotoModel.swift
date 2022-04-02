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
    var created_at: String?
    var urls: UrlsPhoto
    var user: User
    var location: LocationPhoto?
    var downloads: Int?
//    var isLike: Bool? = false
}

struct UrlsPhoto: Decodable, Hashable {
    var raw: String?
    var regular: String?
}

struct User: Decodable, Hashable {
    let name: String?
}

struct LocationPhoto: Decodable, Hashable {
    var title: String?
    var name: String?
    var city: String?
    var country: String?
}
