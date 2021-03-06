//
//  MovieViewModel.swift
//  MovieFlix
//
//  Created by Vijay Masal on 17/05/20.
//  Copyright © 2020 Vijay Masal. All rights reserved.
//
// MARK: -ViewModel
class MovieViewModel {
    enum MovieCellViewCellType {
        case normal(cellViewModel: MovieCellViewModel)
        case error(message: String)
        case empty
    }
    let showLoadingHud: Bindable = Bindable(false)
    let rowsCells = Bindable([MovieCellViewModel]())
    let appServerClient: AppServerClient
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    func getFactsData(isPlaying : Bool) {
        appServerClient.getMovies(isPlaying: isPlaying, completion: { [weak self] result in
            switch result {
            case .success(let movies):
                guard movies.results.count > 0 else {
                    return
                }
                self?.rowsCells.value = movies.results.compactMap({$0})
            case .failure(let error):
                print("error \(error.debugDescription)")
            }
        })
    }
}
