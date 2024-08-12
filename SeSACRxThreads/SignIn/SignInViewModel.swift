//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa


//형태. 구현부는 다른 곳에서
// Input, Output 이게 제네릭 구조였으면 좋겠다!
// Swift Generic > associated type

protocol BaseViewModel<Input> {
   
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
    var disposeBag: DisposeBag { get }
}




class SignInViewModel: BaseViewModel {
   

    let disposeBag = DisposeBag()
    
    
    struct Input {
        let tap: ControlEvent<Void>
        
        
        
    }
    
    //Observable > publishSubject > PublishRely
    struct Output {
        let text: Driver<String>
        
        
    }
    
    
  //탭 했을 때 서버 통신 > 메인 쓰레드에서 동작하지 않을 수 있고..
    //탭했을 때 UI
    
    func transform(input: Input) -> Output {
        let result = input.tap
            .map { "a@a.com" }
            .asDriver(onErrorJustReturn: "a@a.com")
        
        
        return Output(text: result)
    }
    
}
