//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
    
    let disposeBag = DisposeBag()
    
    // 테이블뷰 데이터
    private let movieList: Observable<[String]> = Observable.just(["a", "b"])
    
    // 컬렉션뷰 데이터
    private let recentList: Observable<[String]> = Observable.just([])
    
    struct Input {
        
    }
    
    struct Output {
        let movieList: Observable<[String]> // 테이블뷰
        let recentList: Observable<[String]> // 컬렉션뷰
    }
    
    func transform(input: Input) -> Output {
        return Output(movieList: movieList, recentList: recentList)
    }
}

