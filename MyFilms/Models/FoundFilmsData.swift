//
//  FoundFilmsData.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 17.10.2022.
//

import Foundation

// MARK: - FoundFilmsData
struct FoundFilmsData: Codable {
    let keyword: String
    let pagesCount: Int
    let films: [Film]
    let searchFilmsCountResult: Int
}

// MARK: - Film
struct Film: Codable {
    let filmID: Int
    let nameRu, type, year, filmDescription: String
    let filmLength: String?
    let countries: [Country]
    let genres: [Genre]
    let rating: String
    let ratingVoteCount: Int
    let posterURL, posterURLPreview: String

    enum CodingKeys: String, CodingKey {
        case filmID = "filmId"
        case nameRu, type, year
        case filmDescription = "description"
        case filmLength, countries, genres, rating, ratingVoteCount
        case posterURL = "posterUrl"
        case posterURLPreview = "posterUrlPreview"
    }
}

// MARK: - Country
struct Country: Codable {
    let country: String
}

// MARK: - Genre
struct Genre: Codable {
    let genre: String
}

