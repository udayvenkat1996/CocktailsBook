import XCTest
import SwiftUI
import Combine
@testable import CocktailBook

class CocktailBookTests: XCTestCase {
    
    var cocktails: [Cocktail] = []
    var viewModel: CocktailsListViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var navigationController: UINavigationController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CocktailsListViewModel()
        guard let file = Bundle.main.url(forResource: "sample", withExtension: "json") else {
            fatalError("sample.json can not be found")
        }
        guard let data = try? Data(contentsOf: file) else {
            fatalError("can not load contents of sample.json")
        }
        guard let jsonData = try? JSONDecoder().decode([Cocktail].self, from: data) else {
            fatalError("could not convert to model")
        }
        viewModel?.cocktails = jsonData
        cocktails = jsonData
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCocktailsListData() throws {
        
        if let cocktail: Cocktail = self.cocktails.first {
            XCTAssertEqual(cocktail.id, "0")
            XCTAssertEqual(cocktail.name, "Piña colada")
            XCTAssertEqual(cocktail.type, "alcoholic")
            XCTAssertEqual(cocktail.shortDescription, "Velvety-smooth texture and a taste of the tropics are what this tropical drink delivers.")
            XCTAssertEqual(cocktail.longDescription, "The Piña Colada is a Puerto Rican rum drink made with pineapple juice (the name means “strained pineapple” in Spanish) and cream of coconut. By most accounts, the modern-day Piña Colada seems to have originated from a 1954 version that bartender named Ramón “Monchito” Marrero Perez shook up at The Caribe Hilton hotel in San Juan, Puerto Rico. While you may not be sipping this icy-cold tiki drink on the beaches of Puerto Rico, it’s sure to get you in a sunny mood no matter the season.")
            XCTAssertEqual(cocktail.preparationMinutes, 7)
            XCTAssertEqual(cocktail.imageName, "pinacolada")
            XCTAssertEqual(cocktail.ingredients.count, 6)
            XCTAssertEqual(cocktail.ingredients[0], "4 oz rum")
            XCTAssertEqual(cocktail.ingredients[1], "3 oz fresh pineapple juice, chilled (or use frozen pineapple chunks for a smoothie-like texture)")
        }
    }
    
    func testFetchCoctailsApi() throws {
        
        viewModel?.filterState = .all
        let expectations = expectation(description: "API Reponse Expectation")
        viewModel?.fetchCocktails()
        viewModel?.$filteredCocktails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cocktails in
                if self?.viewModel?.apiState == .success {
                    self?.cocktails = cocktails
                    expectations.fulfill()
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        if let cocktail: Cocktail = cocktails.first {
            XCTAssertEqual(cocktail.id, "5")
            XCTAssertEqual(cocktail.name, "Basil Lemonade Punch")
            XCTAssertEqual(cocktail.type, "non-alcoholic")
        }
    }
    
    func testToggleFavorite() throws {
        let cocktail = cocktails[0]
        viewModel?.toggleFavorite(cocktail: cocktail)
        XCTAssertTrue(((viewModel?.cocktails[0].isFavorite) != nil))
    }

    func testAlcoholicFilterState() throws {
        viewModel?.filterState = .alcoholic
        if let cocktail: Cocktail = viewModel?.filteredCocktails.first {
            XCTAssertEqual(cocktail.name, "Bloody Mary")
            XCTAssertEqual(cocktail.type, "alcoholic")
        }
    }
    
    func testNonAlcoholicFilterState() throws {
        viewModel?.filterState = .nonAlcoholic
        if let cocktail: Cocktail = viewModel?.filteredCocktails.first {
            XCTAssertEqual(cocktail.name, "Basil Lemonade Punch")
            XCTAssertEqual(cocktail.type, "non-alcoholic")
        }
    }

    func testNavigationToDetailView() throws {
        let view = CocktailDetailsView(cocktail: Cocktail(id: "0", name: "Piña colada", type: "alcoholic", shortDescription: "Velvety-smooth texture...", longDescription: "The Piña Colada is a Puerto Rican rum drink...", preparationMinutes: 7, imageName: "pinacolada", ingredients: ["4 oz rum", "3 oz fresh pineapple juice...", "2 oz cream of coconut...", "1 ounce freshly squeezed lime juice (optional)", "2 cups ice", "Fresh pineapple, for garnish"]), viewModel: viewModel ?? CocktailsListViewModel())
           
        navigationController
                    = UINavigationController(rootViewController:  UIHostingController(rootView: view))
        XCTAssertNotNil(view.body)
        XCTAssertEqual(view.cocktail.type, "alcoholic")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
