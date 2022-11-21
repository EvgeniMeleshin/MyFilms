//
//  Film.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 24.10.2022.
//

import Foundation
import UIKit

struct FilmModel {
    
    var filmId: Int?
    var nameRu: String?
    var year: String?
    var imageData: UIImage?
    var imagePreviewData: UIImage?
    var stringImageData: String?
    var stringImagePreviewData: String?
    var rating: String?
    var myRating: Double?
    var genres: [Genre]?
    var filmDescription: String?
    var stringGenres: String? {
        var stringGenresArray: [String] = []
        for item in genres ?? [] {
            stringGenresArray.append(item.genre)
        }
        return stringGenresArray.map({"\($0)"}).joined(separator: ",")
    }
    var nameYear: String? {
        guard let nameRu = nameRu else { return "" }
        return nameRu + " (\(String(describing: year))"
    }
    
    init(filmId: Int, nameRu: String, year: String, imageData: UIImage,
         imagePreviewData: UIImage, rating: String,
         myRating: Double, genres: [Genre], filmDescription: String) {
        
        self.filmId                 = filmId
        self.nameRu                 = nameRu
        self.year                   = year
        self.imageData              = imageData
        self.imagePreviewData       = imagePreviewData
        self.rating                 = rating
        self.myRating               = myRating
        self.genres                 = genres
        self.filmDescription        = filmDescription
        
        
    }
    
    init(film: Film, imageData: UIImage, imagePreviewData: UIImage) {
        
        self.filmId                 = film.filmID
        self.nameRu                 = film.nameRu
        self.year                   = film.year
        self.imageData              = imageData
        self.imagePreviewData       = imagePreviewData
        self.rating                 = film.rating
        self.myRating               = 0.0
        self.genres                 = film.genres
        self.filmDescription        = film.filmDescription
        self.stringImageData        = film.posterURL
        self.stringImagePreviewData = film.posterURLPreview
        
    }
    
    init(film: FilmStorage) {
        
        self.filmId                 = Int(film.filmId)
        self.nameRu                 = film.nameRu
        self.year                   = film.year
        
        if let imageData = film.imageData {
            self.imageData          = UIImage(data: imageData)
        }
        
        if let imageData = film.imagePreviewData {
            self.imagePreviewData    = UIImage(data: imageData)
        }
        self.rating                 = film.rating
        self.myRating               = 0.0
        
        let stringGenres = film.genres ?? ""
        if stringGenres.count > 0 {
            let stringGenresArray = stringGenres.components(separatedBy: ",")
            var genres: [Genre] = []
            for item in stringGenresArray {
                genres.append(Genre(genre: item))
            }
            self.genres             = genres
        }
        
        self.filmDescription        = film.filmDescription
        
    }
    
}
