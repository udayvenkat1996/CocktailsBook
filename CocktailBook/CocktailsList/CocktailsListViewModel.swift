//
//  CocktailsListViewModel.swift
//  CocktailBook
//
//  Created by Uday Venkat on 19/06/24.
//

import Combine
import Foundation

enum ApiState {
    case loading
    case success
    case error
}

class CocktailsListViewModel: ObservableObject {
    
    @Published var cocktails: [Cocktail] = []
    @Published var filteredCocktails: [Cocktail] = []
    @Published var filterState: FilterState = .all {
        didSet {
            filterCocktails()
        }
    }
    @Published var apiState: ApiState = .loading

    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchCocktails()
    }
    
    func fetchCocktails() {
        apiState = .loading
        cocktailsAPI.cocktailsPublisher
            .decode(type: [Cocktail].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cocktails in
                self?.apiState = .success
                self?.cocktails = cocktails
                self?.filterCocktails()
            }
            .store(in: &cancellables)
    }
    
    private func filterCocktails() {
        var filtered: [Cocktail]
        
        switch filterState {
        case .all:
            filtered = cocktails
        case .alcoholic:
            filtered = cocktails.filter { $0.type == "alcoholic" }
        case .nonAlcoholic:
            filtered = cocktails.filter { $0.type == "non-alcoholic" }
        }
        
        // Separate favorites and non-favorites
        let favorites = filtered.filter { $0.isFavorite }.sorted { $0.name < $1.name }
        let nonFavorites = filtered.filter { !$0.isFavorite }.sorted { $0.name < $1.name }
        
        filteredCocktails = favorites + nonFavorites
    }
    
    func toggleFavorite(cocktail: Cocktail) {
        if let index = cocktails.firstIndex(where: { $0.id == cocktail.id }) {
            cocktails[index].isFavorite.toggle()
        }
    }
    
    enum FilterState {
        case all
        case alcoholic
        case nonAlcoholic
    }
}
