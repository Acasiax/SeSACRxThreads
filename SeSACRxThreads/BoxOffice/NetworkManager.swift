//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/8/24.
//

import Foundation
import RxSwift
import Alamofire

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    static let jokeURL = "https://v2.jokeapi.dev/joke/Programming?type=single"
    
    
    // Observable 객체로 Alamofire 통신
    func fetchJoke() -> Observable<Joke> {
        return Observable.create { observer -> Disposable in
            
            AF.request(NetworkManager.jokeURL)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Joke.self) { response in
                    switch response.result {
                    case .success(let success):
                        observer.onNext(success)
                        observer.onCompleted() //🌟
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }.debug("Joke API 통신")
        
    }


    // Single 객체로 Alamofire 통신
    func fetchJokeWithSingle() -> Single<Joke> {
     
            return Single.create { observer -> Disposable in
                
                AF.request(NetworkManager.jokeURL)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: Joke.self) { response in
                        
                        switch response.result {
                        case .success(let success):
                            observer(.success(success))
                        case .failure(let error):
                            observer(.failure(error))
                        }
                        
                        
                    }
                
                return Disposables.create()
            }.debug("Joke API 통신")
    }


    // Single 객체로 Alamofire 통신 + Result Type 활용
    func fetchJokeWithSingleResultType() -> Single<Result<Joke, JackError>> {
        return Single.create { observer -> Disposable in
            
            AF.request(NetworkManager.jokeURL)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Joke.self) { response in
                    
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        observer(.success(.failure(.invalidEmail)))
                    }
                    
                    
                }
            
            return Disposables.create()
        }.debug("Joke API 통신")
        
    }

    
    private init() {}
    
    func callBoxOffice(date: String) -> Observable<Movie> {
        let api = APIKey.movieKey
        
       // let date = 20240801
        
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(api)&targetDt=\(date)"

        let result =  Observable<Movie>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) {
                data, response, error in
                
                if let error = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted() //🌟🌟
                } else {
                    print("응답이 왔으나 실패")
                    observer.onError(APIError.unknownResponse)
                    
                }
                
            }.resume()
         
            return Disposables.create()
            
        }.debug("박스오피스 조회")
        return result
        
    }
}
