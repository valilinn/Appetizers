//
//  AppetizerListViewModel.swift
//  Appetizers
//
//  Created by Валентина Лінчук on 11/12/2024.
//

import SwiftUI

final class AppetizerListViewModel: ObservableObject {
    
    @Published var appetizers: [Appetizer] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    
    func getAppetizers() {
        isLoading = true
        NetworkManager.shared.getAppetizers { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let appetizers):
                    self?.appetizers = appetizers
                case .failure(let error):
                    switch error {
                    case .invalidURL:
                        self?.alertItem = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        self?.alertItem = AlertContext.invalidResponse
                        
                    case .invalidData:
                        self?.alertItem = AlertContext.invalidData
                        
                    case .unableToComplete:
                        self?.alertItem = AlertContext.unableToComplete
                        
                    }
                }
            }
        }
    }
}
