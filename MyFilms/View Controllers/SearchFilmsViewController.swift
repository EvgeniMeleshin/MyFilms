//
//  FilmsSearchViewController.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 24.10.2022.
//

import UIKit

class ResultsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class SearchFilmsCell: UITableViewCell {

    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var filmGenres: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        filmImage.image = nil
    }
    
}

class SearchFilmsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkManager: NetworkManagerProtocol = NetworkManager()
    var films: [Film] = []
    var filmModels: [FilmModel] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.ignoresSearchSuggestionsForSearchBarPlacementStacked = true
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.performWithoutAnimation {
                searchController.isActive = true
                searchController.isActive = false
            }
    }
    
    internal func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard !text.isEmpty else { return }
        
        networkManager.fetchData(byName: text) { [unowned self] (filmModels: [FilmModel]) in
            self.filmModels = filmModels
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmModels.count
    }
    
    static func getGenresArrayAsString(array: [Genre]) -> String {
        var stringGenresArray: [String] = []
        for item in array {
            stringGenresArray.append(item.genre)
        }
        return stringGenresArray.map({"\($0)"}).joined(separator: ",")
    }
    
    static func getColorForRating(rating: String) -> UIColor {
        guard !rating.isEmpty else { return .black}
        guard let ratingValueDouble = Double(rating) else { return .black}
        if ratingValueDouble < 5.0 {
            return .red
        } else if ratingValueDouble >= 5.0 && ratingValueDouble < 7.0 {
            return .gray
        } else if ratingValueDouble >= 7.0 {
            return .systemGreen
        } else {
            return .black
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchFilmsCell
        let currentFilm = filmModels[indexPath.row]
        let genresArray = currentFilm.genres
        let stringGenres = SearchFilmsViewController.getGenresArrayAsString(array: genresArray ?? [])
        guard let nameRu = currentFilm.nameRu, let year = currentFilm.year else { return cell }
        cell.filmName.text = nameRu + " (" + year + ")"
        cell.filmGenres.text = stringGenres
        cell.filmRating.text = currentFilm.rating ?? "Рейтинг отсутствует"
        cell.filmRating.textColor = SearchFilmsViewController.getColorForRating(rating: currentFilm.rating ?? "")

        guard let urlString = currentFilm.stringImagePreviewData else { return cell }

        if !urlString.isEmpty {
            guard let url = URL(string: urlString) else { return cell }
            let session = URLSession.shared
            session.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.filmImage.image = image
                    }
                }

            }.resume()
        }
                
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsFoundedFilm" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let film = filmModels[indexPath.row]
            let filmVC = segue.destination as! DetailsViewController
            filmVC.currentFilm = film
        }
    }
    
}
