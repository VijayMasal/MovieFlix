//
//  MovieModel.swift
//  MovieFlix
//
//  Created by Vijay Masal on 17/05/20.
//  Copyright © 2020 Vijay Masal. All rights reserved.
//

import Foundation
// MARK: - Model
struct Movies : Codable {
    var results : [Movie]
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    init(results : [Movie] ) {
        self.results = results
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decodeIfPresent([Movie].self, forKey: .results) ?? []
    }
}
struct Movie : Codable {
    var title : String
    var overview : String
    var vote_average : Double
    var vote_count : Double
    var popularity : Double
    var poster_path : String
    var release_date : String
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case overview = "overview"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
        case popularity = "popularity"
        case poster_path = "poster_path"
        case release_date = "release_date"
    }
    init(title : String, overview : String, vote_average : Double,vote_count : Double,
         popularity : Double, poster_path: String, release_date: String ) {
        self.title = title
        self.overview = overview
        self.vote_average = vote_average
        self.vote_count = vote_count
        self.popularity = popularity
        self.poster_path = poster_path
        self.release_date = release_date
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        vote_average = try container.decodeIfPresent(Double.self, forKey: .vote_average) ?? 0.0
        vote_count = try container.decodeIfPresent(Double.self, forKey: .vote_count) ?? 0.0
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? 0.0
        poster_path = try container.decodeIfPresent(String.self, forKey: .poster_path) ?? ""
        release_date = try container.decodeIfPresent(String.self, forKey: .release_date) ?? ""
    }
}


