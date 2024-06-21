//
//  CocktailsListView.swift
//  CocktailBook
//
//  Created by Uday Venkat on 19/06/24.
//

import SwiftUI

struct CocktailsListView: View {
    
    @StateObject var viewModel = CocktailsListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $viewModel.filterState) {
                    Text("All").tag(CocktailsListViewModel.FilterState.all)
                    Text("Alcoholic").tag(CocktailsListViewModel.FilterState.alcoholic)
                    Text("Non-Alcoholic").tag(CocktailsListViewModel.FilterState.nonAlcoholic)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if viewModel.apiState == .loading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.apiState == .success {
                    List(viewModel.filteredCocktails) { cocktail in
                        NavigationLink(destination: CocktailDetailsView(cocktail: cocktail, viewModel: viewModel)) {
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
                } else {
                    Spacer()
                    Text("No Data Found")
                    Spacer()
                }
            }
            .navigationBarTitle(Text(navigationTitle))
        }
    }
    
    private var navigationTitle: String {
           switch viewModel.filterState {
           case .all:
               return "All Cocktails"
           case .alcoholic:
               return "Alcoholic Cocktails"
           case .nonAlcoholic:
               return "Non-Alcoholic Cocktails"
           }
       }
}

#Preview {
    CocktailsListView()
}
