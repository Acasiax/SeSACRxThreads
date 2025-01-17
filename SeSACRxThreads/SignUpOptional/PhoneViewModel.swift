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
        let tap: ControlEvent<Void>
        let phoneNumber: Observable<String>
        let text: ControlProperty<String?>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let validText: Observable<String>
        let isValid: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.text
            .orEmpty
            .map { $0.count >= 8 }
            .share(replay: 1)
        
        let validText = Observable.just("연락처는 8자 이상")
        
        return Output(tap: input.tap, validText: validText, isValid: validation)
    }
}
