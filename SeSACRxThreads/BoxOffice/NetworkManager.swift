//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/8/24.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    
}

final class NetworkManager {
    static let shared = NetworkManager()
    
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
                } else {
                    print("응답이 왔으나 실패")
                    observer.onError(APIError.unknownResponse)
                    
                }
                
            }.resume()
         
            return Disposables.create()
            
        }
        return result
        
    }
}
