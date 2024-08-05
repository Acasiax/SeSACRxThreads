//
//  NickNameViewmodel.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class NickNameViewModel {
    
    struct Input {
        let tap: ControlEvent<Void>
        let nickname: Observable<String>
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
            .map { $0.count >= 3 } // 닉네임이 3자 이상이어야 함
            .share(replay: 1) //🌟 불필요하게 스트림이 발생하는 것을 줄일 수 있음. 있고 없고의 차이가 크다🌟
        
        let validText = Observable.just("닉네임은 3자 이상")
        
        return Output(tap: input.tap, validText: validText, isValid: validation)
    }
}
