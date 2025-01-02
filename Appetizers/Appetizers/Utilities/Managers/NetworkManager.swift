//
//  NetworkManager.swift
//  Appetizers
//
//  Created by Валентина Лінчук on 11/12/2024.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    static let baseUrl = "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/"
    private let appetizerURL = baseUrl + "appetizers"
    
    private init() {}
    
    func getAppetizers(completed: @escaping (Result<[Appetizer], APError>) -> ()) {
        guard let url = URL(string: appetizerURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error  {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(AppetizerResponse.self, from: data)
                completed(.success(decodedResponse.request))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImages(fromURLString urlString: String, completed: @escaping (UIImage?) -> ()) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            guard let data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}

//protocol NetworkManagerDelegate: AnyObject {
//    func didReceiveAppetizers(_ appetizers: [Appetizer])
//    func didFailWithError(_ error: APError)
//}
//import Foundation
//
//final class NetworkManager {
//    
//    static let shared = NetworkManager()
//    
//    static let baseUrl = "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/"
//    private let appetizerURL = baseUrl + "appetizers"
//    
//    weak var delegate: NetworkManagerDelegate? // Слабая ссылка на делегата
//    
//    private init() {}
//    
//    func fetchAppetizers() {
//        Task {
//            do {
//                let appetizers = try await getAppetizers()
//                DispatchQueue.main.async { [weak self] in
//                    self?.delegate?.didReceiveAppetizers(appetizers)
//                }
//            } catch let error as APError {
//                DispatchQueue.main.async { [weak self] in
//                    self?.delegate?.didFailWithError(error)
//                }
//            } catch {
//                DispatchQueue.main.async { [weak self] in
//                    self?.delegate?.didFailWithError(.invalidData)
//                }
//            }
//        }
//    }
//    
//    private func getAppetizers() async throws -> [Appetizer] {
//        guard let url = URL(string: appetizerURL) else {
//            throw APError.invalidURL
//        }
//        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw APError.invalidResponse
//        }
//        
//        do {
//            let decodedResponse = try JSONDecoder().decode(AppetizerResponse.self, from: data)
//            return decodedResponse.request
//        } catch {
//            throw APError.invalidData
//        }
//    }
//}
