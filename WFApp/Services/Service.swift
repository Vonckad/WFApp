//
//  Service.swift
//  WFApp
//
//  Created by Vlad Ralovich on 4.02.22.
//

import Foundation

protocol ServiceProtocol {
    func getPhoto(guery: String, onResult: @escaping (Result<PhotoModel, Error>) -> Void)
    func getRandomPhoto(onResult: @escaping (Result<[ResultsPhoto], Error>) -> Void)
}
//https://api.unsplash.com/photos/random?page=1&per_page=20&query=&client_id=c9GFb-BEoMjgSkTXUNExh6l32k4sz8ah3Fl0evr3IvI&count=20
class Service: ServiceProtocol {
    let clientId = "c9GFb-BEoMjgSkTXUNExh6l32k4sz8ah3Fl0evr3IvI"
    func getPhoto(guery: String, onResult: @escaping (Result<PhotoModel, Error>) -> Void) {
        
        let session = URLSession.shared
        guard let url = URL(string: "https://api.unsplash.com/search/photos?page=1&per_page=20&query=\(guery)&client_id=\(clientId)") else {return}
        let urlRequest = URLRequest(url: url)

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
            do {
                let response = try JSONDecoder().decode(PhotoModel.self, from: data)
                onResult(.success(response))
            } catch(let error) {
//                print(error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }
    
    func getRandomPhoto(onResult: @escaping (Result<[ResultsPhoto], Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.unsplash.com/photos/random?page=1&per_page=20&client_id=\(clientId)&count=20") else {return}
        let urlRequest = URLRequest(url: url)

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
//            print("random data = \(data.description)")
            do {
                let response: [ResultsPhoto] = try JSONDecoder().decode([ResultsPhoto].self, from: data)
                onResult(.success(response))
            } catch(let error) {
//                print("JSONDecoder error = ", error)
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }

}
