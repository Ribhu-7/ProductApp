//
//  APIManager.swift
//  MVVM1
//
//  Created by Apple on 19/06/24.
//

import UIKit

//Singleton preventing inheritance as well as object instance

enum DataError: Error {
    case invalidResponse
    case invalidDecoding
    case invalidURL
    case invalidData
    case network(_ error: Error?)
}

typealias Handler = (Result<[Product], DataError>)->Void

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    func fetchProducts(completion: @escaping Handler){
        guard let url = URL(string: Constant.API.productUrl) else{
            
            return
        }
        
        URLSession.shared.dataTask(with: url){data,response,error in
            guard let data , error == nil else {
                completion(.failure(.invalidData))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch{
                completion(.failure(.network(error)))
            }
            
        }.resume()
    }
    
    
}
