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

class FilmsSearchViewController: UITableViewController, UISearchResultsUpdating {
    
    var films: [Film] = []
    let searchController = UISearchController(searchResultsController: nil)//ResultsVC())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.ignoresSearchSuggestionsForSearchBarPlacementStacked = true
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard !text.isEmpty else { return }
        fetchData(byName: text) { [unowned self] (films: [Film]) in
            self.films = films
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        //let vc = searchController.searchResultsController as? ResultsVC
        // vc?.view.backgroundColor = .white
        //tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
 

    static func getGenresArrayAsString(array: [Genre]) -> String {
        var stringGenresArray: [String] = []
        for item in array {
            stringGenresArray.append(item.genre)
        }
        return stringGenresArray.map({"\($0)"}).joined(separator: ",")
    }
    
    static func getColorForRating(rating: String) -> UIColor {
        guard !rating.isEmpty else { return UIColor.black}
        guard let ratingValueDouble = Double(rating) else { return UIColor.black}
        var color = UIColor()
        if ratingValueDouble < 5.0 {
            color = UIColor.red
        } else if ratingValueDouble >= 5.0 && ratingValueDouble < 7.0 {
            color = UIColor.gray
        } else if ratingValueDouble >= 7.0 {
            color = UIColor.systemGreen
        }   else {
            color = UIColor.black
        }
        return color
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoundedFilmCell
        let currentFilm = films[indexPath.row]
        let genresArray = currentFilm.genres
        let stringGenres = FilmsSearchViewController.getGenresArrayAsString(array: genresArray ?? [])
        cell.filmName.text = currentFilm.nameRu! + " (" + currentFilm.year! + ")"
        cell.filmGenres.text = stringGenres
        cell.filmRating.text = currentFilm.rating ?? "Рейтинг отсутствует"
        cell.filmRating.textColor = FilmsSearchViewController.getColorForRating(rating: currentFilm.rating ?? "")
        guard let urlString = currentFilm.posterURLPreview else { return cell }

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
    
    // MARK: Fetch data
    func fetchData(byName filmName: String, completion: @escaping ([Film]) -> ()) {
        
        let filmNameEncode = filmName.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        guard let filmNameEncode = filmNameEncode else { return }
        
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(filmNameEncode)"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue(apiKey, forHTTPHeaderField:"X-API-KEY")
        request.timeoutInterval = 60.0
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [unowned self] data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let foundFilmsData = try decoder.decode(FoundFilmsData.self, from: data)
                    guard let foundedFilms = foundFilmsData.films else { return }

                    films.removeAll()
                    for film in foundedFilms {
                        films.append(film)
                    }
                    completion(films)
                    
                } catch let error {
                    print("Error serialization JSON", error)
                }
                
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilm" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let film = films[indexPath.row]
            let filmVC = segue.destination as! FoundedFilmDetailsViewController
            filmVC.currentFilm = film
        }
    }
    
}
