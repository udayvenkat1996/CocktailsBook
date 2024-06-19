//
//  CocktailsListView.swift
//  CocktailBook
//
//  Created by Uday Venkat on 19/06/24.
//

import SwiftUI

struct CocktailsListView: View {
    
    @State var filteredCocktails: [Cocktail] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List(filteredCocktails) { cocktail in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(cocktail.name)
                                .fontWeight(cocktail.isFavorite ? .bold : .regular)
                                .foregroundColor(cocktail.isFavorite ? .red : .primary)
                            Text(cocktail.shortDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if cocktail.isFavorite {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("All Cocktails"))
            .onAppear() {
                guard let file = Bundle.main.url(forResource: "sample", withExtension: "json") else {
                    fatalError("sample.json can not be found")
                }
                guard let data = try? Data(contentsOf: file) else {
                    fatalError("can not load contents of sample.json")
                }
                do {
                    self.filteredCocktails = try JSONDecoder().decode([Cocktail].self, from: data)
                } catch {
                    print("Could not convert the json to model")
                }
            }
        }
    }
}

#Preview {
    CocktailsListView()
}
