//
//  ServiceFetcher.swift
//  WFApp
//
//  Created by Vlad Ralovich on 19.03.22.
//

import Foundation

protocol ServiceFetcherProtocol {
    func fetchImages(searchItem: String?, complition: @escaping (PhotoModel?) -> Void)
    func fetchRandomImages(complition: @escaping ([ResultsPhoto]?) -> Void)
}

protocol ServiceDataStore {
    var likedPhoto: [ResultsPhoto] { get set }
    func addPhoto(_ photo: ResultsPhoto)
    func removePhoto(_ photo: ResultsPhoto)
}

class ServiceFetcher: ServiceFetcherProtocol, ServiceDataStore {
    var likedPhoto: [ResultsPhoto] = []
    var service: ServiceProtocol = Service()
    
    deinit {
        print("deinit")
    }
    
    func fetchImages(searchItem: String?, complition: @escaping (PhotoModel?) -> Void) {
        service.request(searchItem: searchItem) { data, error in
            if let error = error {
                print("error request = \(error.localizedDescription )")
                complition(nil) //можно подумать передать ошибку дальше
            }
            let decod = self.decodJSON(type: PhotoModel.self, from: data)
            complition(decod)
        }
    }
    
    func fetchRandomImages(complition: @escaping ([ResultsPhoto]?) -> Void) {
        service.request(searchItem: nil) { data, error in
            if let error = error {
                print("error request = \(error.localizedDescription )")
                complition(nil) //можно подумать передать ошибку дальше
            }
            let decod = self.decodJSON(type: [ResultsPhoto].self, from: data)
            complition(decod)
        }
    }
    
    private func decodJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let object = try decoder.decode(type.self, from: data)
            return object
        } catch let jsonError {
            print("jsonError = \(jsonError)")
            return nil
        }
    }
    
    func addPhoto(_ photo: ResultsPhoto) {
        if !likedPhoto.contains(photo) {
            self.likedPhoto.append(photo)
        }
    }
    
    func removePhoto(_ photo: ResultsPhoto) {
        if likedPhoto.contains(photo) {
            self.likedPhoto = self.likedPhoto.filter({$0 != photo })
        }
    }
}
