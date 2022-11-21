//
//  ViewController.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 17.10.2022.
//

import UIKit
import CoreData

class MyFilmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmGenres: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    
}

class MyFilmsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    
    var myFilms: [FilmStorage] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let context = getContext()
        let fetchRequest: NSFetchRequest<FilmStorage> = FilmStorage.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            myFilms = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFilms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyFilmTableViewCell
        guard let nameRu = myFilms[indexPath.row].nameRu, let year = myFilms[indexPath.row].year else { return cell }
        cell.filmName.text = nameRu + " (\(year))"
        cell.filmGenres.text = myFilms[indexPath.row].genres
        cell.filmRating.text = myFilms[indexPath.row].rating
        cell.filmRating.textColor = SearchFilmsViewController.getColorForRating(rating: cell.filmRating.text ?? "")
        guard let imageData = myFilms[indexPath.row].imageData else { return cell }
        cell.filmImage.image = UIImage(data: imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let myFilm = myFilms[indexPath.row]
        let context = getContext()
        context.delete(myFilm)
        myFilms.remove(at: indexPath.row)
        
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsMyFilm" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let film = myFilms[indexPath.row]
            let filmVC = segue.destination as! DetailsViewController
            filmVC.currentFilm = FilmModel(film: film)
            filmVC.alreadyAdded = true
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}

