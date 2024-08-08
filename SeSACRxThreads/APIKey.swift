//
//  APIKey.swift
//  NetworkProject
//
//  Created by 이윤지 on 6/11/24.
//

import Foundation

//이그노어 파일
//파일 생성 전에 .gitignore 파일에 "이름을 먼저 명세"
struct APIURL {
    static let TMDBmovieURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(APIKey.TMDBAPIKey)&language=en-US&page=1"
    
    static let KakaoBookURL = "https://dapi.kakao.com/v3/search/book?query="
    // static let KakaoBookURL = "https://dapi.kakao.com/v3/search/book?query=%EC%8B%9C"
    static let KoGPTURL = "https://api.kakaobrain.com/v1/inference/kogpt/generation"
    static let naverBookURL = "https://openapi.naver.com/v1/search/book.json?"
    static let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo="
    static let upbitURL = ""
    static let movieURLComponents: URLComponents = {
            var components = URLComponents(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json")!
            return components
        }()
    
}

struct APIKey {
    
    static let kakaoAuthorization = "KakaoAK 7d4b077db4cbd9fc4e1c7f7ccd0f3376"
    static let kakaoContent_Type = "application/json"
    
    static let movieKey = "7837802f3b92cc15de0d033485739761"
    static let weatherKey = "98452eee52fc2e5b3aa9be02efc8a3fb"
    
    static let naverClientSecret = "nghSpIbgag"
    static let naverClientID = "YRYf5Pu9DVkCo_G1pb04"
    static let naverBookURL = "https://openapi.naver.com/v1/search/book.json?"
    
    static let TMDBAPIKey = "5f2db2ebdd9c192816eae0ca0e888406"
    static let TMDBAcesseToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ZjJkYjJlYmRkOWMxOTI4MTZlYWUwY2EwZTg4ODQwNiIsInN1YiI6IjY2NjVhNjM0YTBkZmU4OTM3Y2UwY2QzYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S6Yn5qQLaAZVZIVwlmXtaPtiUbnnR_nDH4GuzBv9rKc"
    static let KakaoAPIKey = "7d4b077db4cbd9fc4e1c7f7ccd0f3376"
}

