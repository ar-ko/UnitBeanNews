//
//  NetworkService.swift
//  UnitBeanNews
//
//  Created by ar_ko on 19.12.2020.
//

import Foundation

class NetworkService {
    private init() {}
    static let shared = NetworkService()
    
    
    public func getData<T>(type: T.Type, url: URL, completion: @escaping (Any?) -> ()) where T : Decodable {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            do {
                guard let data = data else { return }
                let json = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
