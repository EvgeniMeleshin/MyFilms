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
    var imageFilm: UIImage?
    var posterUrlPreview: String?
    
    
    init(name: String, year: String, posterUrlPreview: String) {
        self.nameRu = name
        self.year = year
        self.posterUrlPreview = posterUrlPreview
    }
    
    func saveNewFilm() {
        //newFilm = Fil
    }
    
}
