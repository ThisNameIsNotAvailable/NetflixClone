//
//  APICaller.swift
//  NetflixClone
//
//  Created by Alex on 25/11/2022.
//

import Foundation

struct Constants {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let API_KEY = ""
    static let youtube_api_key = ""
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3"
}

enum APIError: Error {
    case failedToGetData
    case incorrectURL
}
class APICaller {
    static let shared = APICaller()
    
    private init(){}
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "/trending/movie/day?api_key=\(Constants.API_KEY)") else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getTrendingTVs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "/trending/tv/day?api_key=\(Constants.API_KEY)") else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getUpcomigMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "/movie/upcoming?api_key=\(Constants.API_KEY)") else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "/movie/popular?api_key=\(Constants.API_KEY)") else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "/movie/top_rated?api_key=\(Constants.API_KEY)") else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL + "/discover/movie?api_key=\(Constants.API_KEY)") else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchWithQuery(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        guard let url = URL(string: Constants.baseURL + "/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TitlesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getMovieWithQuery(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)/search?q=\(query)&key=\(Constants.youtube_api_key)") else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
