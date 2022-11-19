//
//  FoundedFilmDetailsViewController.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 14.11.2022.
//

import UIKit
import CoreData

class FoundedFilmDetailsViewController: UIViewController {

    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var filmDescription: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    @IBOutlet weak var filmGenres: UILabel!
    
    var currentFilm: FilmModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard currentFilm != nil else { return }
        
        filmName.text = (currentFilm?.nameRu)! + " (" + (currentFilm?.year)! + ")"
        
        let rating = currentFilm?.rating ?? "Рейтинг отсутствует"
        filmRating.text = rating == "null" ? "Рейтинг отсутствует" : rating
        filmRating.textColor = FilmsSearchViewController.getColorForRating(rating: currentFilm?.rating ?? "")
        filmGenres.text = FilmsSearchViewController.getGenresArrayAsString(array: currentFilm?.genres ?? [])
        filmDescription.text = currentFilm?.filmDescription ?? ""
        setFilmImage(urlString: (currentFilm?.stringImageData)!)

    }
    
    func setFilmImage(urlString: String) {
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "FilmStorage", in: context) else { return }
        let filmObject = FilmStorage(entity: entity, insertInto: context)
        filmObject.nameRu = filmName.text
        filmObject.date = .now
        
        do {
            try context.save()
            showMessage()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func showMessage() {
        let alert = UIAlertController(title: "", message: "Added to my films", preferredStyle: .alert)
        alert.view.tintColor = UIColor.systemGreen
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
}
