//
//  NetworkManager.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 17.10.2022.
//

import Foundation
import UIKit

class NetworkManager {
  
    var filmModel: FilmModel?
    var filmModels: [FilmModel] = []
    var imageData: UIImage?
    var imagePreviewData: UIImage?
    
    // MARK: Fetch data
    func fetchData(byName filmName: String, completion: @escaping ([FilmModel]) -> ()) {
        
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
                    filmModels.removeAll()
                    for film in foundedFilms {
                        createNewFilmModel(film: film)
                        //createFilmModels(film: film)
//                        var filmModel = FilmModel(film: film, imageData: imageData ?? UIImage(), imagePreviewData: imagePreviewData ?? UIImage())
//                        filmModels.append(filmModel)
                    }
                    completion(filmModels)
                    
                } catch let error {
                    print("Error serialization JSON", error)
                }
                
            }
        }
        task.resume()
    }
    
    func createFilmModels(film: Film) {
        
        //let queue = DispatchQueue.global(qos: .utility)
        //let queue = DispatchQueue(label: "test", attributes: .concurrent)
        let group = DispatchGroup()
        
        if let url = URL(string: film.posterURL!) {
            group.enter()
                let session = URLSession.shared
                session.dataTask(with: url) { [unowned self] data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        self.imageData = image
                        group.leave()
                    }

                }.resume()
        }
        
        if let url = URL(string: film.posterURLPreview!) {
            group.enter()
                let session = URLSession.shared
                session.dataTask(with: url) { [unowned self] data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        self.imagePreviewData = image
                        group.leave()
                    }

                }.resume()
        }
        
        group.notify(queue: .main) {
            self.filmModel = FilmModel(film: film, imageData: self.imageData ?? UIImage(), imagePreviewData: self.imagePreviewData ?? UIImage())
            self.filmModels.append(self.filmModel!)
        }
        
    }
    
    func createNewFilmModel(film: Film) {
//        fetchImagePreviewData(film: film) { [unowned self] (imagePreviewData: UIImage) in
//            self.imagePreviewData = imagePreviewData
//        }
                
        //imageData = fetchImageData(film: film)
        filmModel = FilmModel(film: film, imageData: imageData ?? UIImage(), imagePreviewData: imagePreviewData ?? UIImage())
        
//        fetchImagePreviewData(film: film) { [unowned self] (imagePreviewData: UIImage) in
//            self.imagePreviewData = imagePreviewData
//        }
//        
//        filmModel?.imagePreviewData = imagePreviewData
        
        filmModels.append(filmModel!)
    }
    
    func fetchImagePreviewData(film: Film, complition: @escaping (UIImage) -> ()) {

        if let url = URL(string: film.posterURLPreview!) {
           
            let session = URLSession.shared
            session.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    complition(image)
                }

            }.resume()
            
            
        }
        
    }
    
    func fillImagePreviewData(urlString: String, complition: @escaping (UIImage) -> ()) {

        if !urlString.isEmpty {
            guard let url = URL(string: urlString) else { return }
            let session = URLSession.shared
            session.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    complition(image)
                }
            }.resume()
        }
    }
    
    func fetchImageData(film: Film) -> UIImage {
        var result = UIImage()
        
        if let url = URL(string: film.posterURL!) {
           
            let session = URLSession.shared
            session.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        result = image
                    }
                }

            }.resume()
            
            
        }
        return result
    }

}
