//
//  BirthDayViewModel.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthDayViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let year = BehaviorRelay(value: 2023)
        let month = BehaviorRelay(value: 8)
        let day = BehaviorRelay(value: 1)
        
        input.birthday
            .bind(with: self) { (owner, date) in
                let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
                
                if let yearValue = components.year,
                   let monthValue = components.month,
                   let dayValue = components.day {
                    year.accept(yearValue)
                    month.accept(monthValue)
                    day.accept(dayValue)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(year: year, month: month, day: day, nextTap: input.nextTap)
    }
}
 
