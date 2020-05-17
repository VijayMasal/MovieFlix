//
//  MovieCellViewModel.swift
//  MovieFlix
//
//  Created by Vijay Masal on 17/05/20.
//  Copyright © 2020 Vijay Masal. All rights reserved.
//
// MARK: -ViewModel
import Foundation
protocol MovieCellViewModel {
    var movieItem: Movie { get }
    var titles: String { get }
    var overviews: String { get }
    var vote_averages : Double {get}
    var vote_counts : Double {get}
    var popularitys : Double {get}
    var poster_paths: String { get }
    var release_dates: String { get }
}
extension Movie : MovieCellViewModel{
    var movieItem: Movie {
        return self
    }
    var titles: String {
        return title
    }
    var overviews: String {
        return overview
    }
    var vote_averages: Double {
        return vote_average
    }
    var vote_counts: Double {
        return vote_count
    }
    var popularitys: Double {
        return popularity
    }
    var poster_paths: String {
        return poster_path
    }
    var release_dates: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from: release_date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString = dateFormatter.string(from: s! )
        return dateString
    }
}
