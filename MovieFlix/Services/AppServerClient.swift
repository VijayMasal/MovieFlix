//
//  AppServerClient.swift
//  MovieFlix
//
//  Created by Vijay Masal on 17/05/20.
//  Copyright © 2020 Vijay Masal. All rights reserved.
//
import Alamofire
// MARK: - AppServerClient
class AppServerClient {
    enum GetMoviesFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    typealias GetMoviesResult = Result<Movies, GetMoviesFailureReason>
    typealias GetMoviesCompletion = (_ result: GetMoviesResult) -> Void
    func getMovies(isPlaying : Bool,completion: @escaping GetMoviesCompletion) {
        let url : String
        if (isPlaying == true) {
            url = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        }
        else{
            url = "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        }
        Alamofire.request(url).responseJSON { response in
            if let error = response.error{
                print("error \(error.localizedDescription)")
            }else{
                if let data = response.data {
                    do{
                        let decoder = JSONDecoder()
                        let jsonMovie = try decoder.decode(Movies.self, from: data)
                        completion(.success(payload: jsonMovie))
                        
                    }catch{
                        NSLog("ERROR \(error.localizedDescription)")
                        completion(.failure(nil))
                    }
                }
                
            }
        }
        
    }
}



