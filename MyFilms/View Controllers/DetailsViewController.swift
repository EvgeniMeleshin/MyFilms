//
//  FoundedFilmDetailsViewController.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 14.11.2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var filmDescription: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    @IBOutlet weak var filmGenres: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var currentFilm: FilmModel?
    var alreadyAdded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard currentFilm != nil else { return }
        guard let nameRu = currentFilm?.nameRu, let year = currentFilm?.year else { return }
        filmName.text = nameRu + " (\(year))"
        let rating = currentFilm?.rating ?? "Рейтинг отсутствует"
        filmRating.text = rating == "null" ? "Рейтинг отсутствует" : rating
        filmRating.textColor = SearchFilmsViewController.getColorForRating(rating: currentFilm?.rating ?? "")
        filmGenres.text = SearchFilmsViewController.getGenresArrayAsString(array: currentFilm?.genres ?? [])
        filmDescription.text = currentFilm?.filmDescription ?? ""
        
        if alreadyAdded {
            filmImage.image = currentFilm?.imageData
            saveButton.isHidden = true
            
        } else {
            guard let stringImageData = currentFilm?.stringImageData else { return }
            setFilmImage(urlString: stringImageData)
        }

    }
    
    private func setFilmImage(urlString: String) {
        if !urlString.isEmpty {
            guard let url = URL(string: urlString) else { return }
            let session = URLSession.shared
            session.dataTask(with: url) { [unowned self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.filmImage.image = image
                    }
                }

            }.resume()
        }
    }
    
    @IBAction func saveToMyFilms(_ sender: UIButton) {
        let appDelegate             = UIApplication.shared.delegate as! AppDelegate
        let context                 = appDelegate.persistentContainer.viewContext
        guard let entity            = NSEntityDescription.entity(forEntityName: "FilmStorage", in: context) else { return }
        let filmObject              = FilmStorage(entity: entity, insertInto: context)
        if let filmId = currentFilm?.filmId {
            filmObject.filmId       = Int32(filmId)
        }
        
        filmObject.nameRu           = currentFilm?.nameRu
        filmObject.genres           = SearchFilmsViewController.getGenresArrayAsString(array: currentFilm?.genres ?? [])
        filmObject.rating           = currentFilm?.rating
        filmObject.year             = currentFilm?.year
        filmObject.filmDescription  = currentFilm?.filmDescription
        filmObject.imageData        = filmImage.image?.pngData()
        filmObject.date             = .now
        
        do {
            try context.save()
            showMessage()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func showMessage() {
        let alert = UIAlertController(title: "", message: "Added to my films", preferredStyle: .alert)
        alert.view.tintColor = UIColor.systemGreen
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
}
