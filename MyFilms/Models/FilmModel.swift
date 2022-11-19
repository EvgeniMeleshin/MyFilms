//
//  Film.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 24.10.2022.
//

import Foundation
import UIKit

class FilmModel {
    
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
    
    init(nameRu: String, year: String, imageData: UIImage,
         imagePreviewData: UIImage, rating: String,
         myRating: Double, genres: [Genre], filmDescription: String) {
        
        self.nameRu                 = nameRu
        self.year                   = year
        self.imageData              = imageData
        self.imagePreviewData       = imagePreviewData
        self.rating                 = rating
        self.myRating               = myRating
        self.genres                 = genres
        self.filmDescription        = filmDescription
//        self.stringImageData        = posterURL
//        self.stringImagePreviewData = posterURLPreview
        
    }
    
    init(film: Film, imageData: UIImage, imagePreviewData: UIImage) {
        
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
    
    func saveNewFilm() {
        //newFilm = Fil
    }
    
}
