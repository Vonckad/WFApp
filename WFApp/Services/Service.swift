//
//  Service.swift
//  WFApp
//
//  Created by Vlad Ralovich on 4.02.22.
//

import Foundation

protocol ServiceProtocol {
    func request(searchItem: String?, complition: @escaping (Data?, Error?) -> ())
}

class Service: ServiceProtocol {
    
    func request(searchItem: String?, complition: @escaping (Data?, Error?) -> ()) {
        let parameters = self.prepareParam(searchItem, random: searchItem != nil)
        let url = url(params: parameters, random: searchItem != nil)
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = prepareHeaders()
        urlRequest.httpMethod = "get"
        let dataTask = createDataTask(from: urlRequest, complition: complition)
        dataTask.resume()
        print("url = \(url)")
    }
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                complition(data, error)
            }
        }
    }
    
    private func prepareHeaders() -> [String : String]? {
        var headers = [String : String]()
        headers["Authorization"] = "Client-ID c9GFb-BEoMjgSkTXUNExh6l32k4sz8ah3Fl0evr3IvI"
        return headers
    }
    
    private func prepareParam(_ str: String?, random: Bool) -> [String : String] {
        var parameters = [String : String]()
        parameters["query"] = str
        parameters["page"] = "1"
        if !random {
            parameters["count"] = "20"
        } else {
            parameters["per_page"] = "20"
        }
        return parameters
    }
    
    private func url(params: [String : String], random: Bool) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = !random ? "/photos/random" : "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    /*func getRandomPhoto(onResult: @escaping (Result<[ResultsPhoto], Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.unsplash.com/photos/random?page=1&per_page=20&client_id=\(clientId)&count=20") else {return}
        let urlRequest = URLRequest(url: url)

        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                onResult(.failure(error!))
                return
            }
            do {
                let response: [ResultsPhoto] = try JSONDecoder().decode([ResultsPhoto].self, from: data)
                onResult(.success(response))
            } catch(let error) {
                onResult(.failure(error))
            }
        })
        dataTask.resume()
    }
*/
}
