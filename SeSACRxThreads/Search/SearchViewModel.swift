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
    //서치바 텍스트: searchBar.rx.text.orEmpty
    let inputQuery = PublishSubject<String>()
    //검색 엔터키 클릭: searchBar.rx.searchButtonClicked
    let inputSearchButtonTap = PublishSubject<Void>()
    
    //더미데이터
    private var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    
    //리스트
    lazy var list = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    
    init() {
        inputQuery
            .subscribe(with: self) {owner, value in
                print("inputQuery가 변경됨: \(value)")
            }
            .disposed(by: disposeBag)
        
        
//        inputSearchButtonTap
//            .withLatestFrom(inputQuery)
//            .subscribe(with: self) {owner, value in
//                print("inputSearchButtonTap가 클릭됨: \(value)")
//                
//                owner.data.insert(value, at: 0)
//                owner.list.onNext(owner.data)
//                
//            }
//            .disposed(by: disposeBag)
        
        
        
        inputQuery
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("실시간 검색 \(value)")
                
                let result = value.isEmpty ? owner.data : owner.data.filter {$0.contains(value)}
                owner.list.onNext(result)
                
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
        
    }
    
    
}
