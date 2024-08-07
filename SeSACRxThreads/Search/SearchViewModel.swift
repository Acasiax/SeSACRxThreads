//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/7/24.
//

import Foundation
import RxSwift
//import RxCocoa

class SearchViewModel {
    let disposeBag = DisposeBag()
    
   

        //서치바 텍스트: searchBar.rx.text.orEmpty
        let inputQuery = PublishSubject<String>()
        //검색 엔터키 클릭: searchBar.rx.searchButtonClicked
        let inputSearchButtonTap = PublishSubject<Void>()
    
    //리스트
    init() {
        inputQuery
        .subscribe(with: self) {owner, value in
        print("inputQuery가 변경됨: \(value)")
        }
        .disposed(by: disposeBag)
        
        
        inputSearchButtonTap
            .subscribe(with: self) {owner, value in
                print("inputSearchButtonTap가 변경됨: \(value)")
                }
                .disposed(by: disposeBag)
        
    }
    

}
