//
//  CocktailDetailsView.swift
//  CocktailBook
//
//  Created by Uday Venkat on 20/06/24.
//

import SwiftUI

struct CocktailDetailsView: View {
    
    let cocktail: Cocktail
    
    @ObservedObject var viewModel: CocktailsListViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
    
                HStack() {
                    Spacer()
                    Image(systemName: "clock")
                    Text("\(cocktail.preparationMinutes) minutes")
                    Spacer()
                }
                
                Image(cocktail.imageName)
                    .resizable()
                    .frame(height: 250, alignment: .center)
                    .padding()
                    .scaledToFit()
                    .clipped()
                
                Text("Description")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                Text(cocktail.longDescription)
                    .font(.callout)
                    .padding(.horizontal)
                
                Text("Ingredients")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                ForEach(cocktail.ingredients, id: \.self) { ingredient in
                    HStack {
                        Image(systemName: "arrowshape.right.fill")
                        Text(ingredient)
                            .font(.callout)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(cocktail.name)
            .navigationBarItems(trailing: Button(action: {
                viewModel.toggleFavorite(cocktail: cocktail)
            }) {
                Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(cocktail.isFavorite ? .red : .primary)
            })
        }
    }
}
#Preview {
    CocktailDetailsView(
        cocktail: Cocktail(id: "0", name: "Piña colada", type: "alcoholic", shortDescription: "Velvety-smooth texture...", longDescription: "The Piña Colada is a Puerto Rican rum drink...", preparationMinutes: 7, imageName: "pinacolada", ingredients: ["4 oz rum", "3 oz fresh pineapple juice...", "2 oz cream of coconut...", "1 ounce freshly squeezed lime juice (optional)", "2 cups ice", "Fresh pineapple, for garnish"]),
        viewModel: CocktailsListViewModel()
    )
}
