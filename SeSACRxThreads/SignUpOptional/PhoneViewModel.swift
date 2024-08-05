//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/5/24.
//

import RxSwift
import RxCocoa

class PhoneViewModel {
    
    struct Input {
        let phoneNumber: Observable<String>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let validText: Observable<String>
        let isValid: Observable<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let validText = Observable.just("연락처는 8자 이상")
        
        let isValid = input.phoneNumber
            .map { $0.count >= 8 }
            .share(replay: 1)
        
        return Output(validText: validText, isValid: isValid, nextTap: input.nextTap)
    }
}
