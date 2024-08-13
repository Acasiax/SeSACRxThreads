//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

// 반응형 프로그래밍
// 50회차: Unicast vc Multicast
// 52회차 강의자료: Hot Observable, cold Observable
// RxCommunity >> RxDataSource
// Zip vs CombindLatest vs withLatestFrom
//debounce vs throuttle

// RxSwift vs Combine
// Observable vs Publisher
// Observer vs Subscriber
// Subscribe vs sink
// Disposeble vs AnyCancallable
// PublishSubject vs PassthroughSubject
// BehaviorSubject vs CurrentvalueSubject

// MVVM Input, Output RxSwift


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Combine

class ViewController: UIViewController {
    
    
    
    let disposeBag = DisposeBag()
    let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        bind()
        
    }
    
    func bind() {
        nextButton.rx.tap
            .flatMap {
                NetworkManager.shared
                    .fetchJokeWithSingleResultType()
//                    .catch { _ in
//                        let joke = Joke(joke: "", id: 404)
//                        return Single<Joke>.just(joke)
//                    }
            }
            
            .subscribe(with: self) { owner, value in
                print(">> subscribe \(value)")
            } onError: { owner, error in
                print(">> onError")
            } onCompleted: { owner in
                print(">> onCompleted")
            } onDisposed: { owner in
                print(">> onDisposed")
            }
            .disposed(by: disposeBag)
    }

    
//    func bind() {
//        nextButton.rx.tap
//
//        // Result 타입으로써 해결한
//            .flatMap {
//                self.childObservableResultType()
//            }
//
//        // catch를 통해 해결한 flatMap
////            .flatMap {
////                self.childObservable()
////                    .catch { error in
////                        self.observable404()
////                    }
////            }
//            .subscribe(with: self) { owner, value in
//                print(">> subscribe \(value)")
//
//                switch value {
//                case .success(let value):
//                    print("success \(value)")
//                case .failure(let error):
//                    print("error \(error)")
//                }
//
//            } onError: { owner, error in
//                print(">> onError")
//            } onCompleted: { owner in
//                print(">> onCompleted")
//            } onDisposed: { owner in
//                print(">> onDisposed")
//            }
//            .disposed(by: disposeBag)
//    }
    
    // 1. flatmap 에서 onComplete를 굳이 왜 써야 하는가?
    // 2. error 시 에는 왜 버튼이 클릭이 안 되는가?
    // 3. .catch 로 어떻게 해결해나갈 수 있나? 버튼이 클릭이 계속 되도록!
    // 4. error 이벤트를 보내야 하는 상황에서도, error를 안 보내면 되지 않나? >> resultType
    func childObservable() -> Observable<Int> {
        return Observable.create { observer in
            
//            observer.onNext(Int.random(in: 1...10))
//            observer.onCompleted() // 정상적으로 종료가 된 것
            
            observer.onError(JackError.invalidEmail)
            
            return Disposables.create()
        }.debug("childObservable")
    }
    
    func childObservableResultType() -> Observable<Result<Int, JackError>> {
        return Observable.create { observer in
            
            // 내가 보내는 것은 실패이나, 실패를 RxSwift next 주머니에 실어서 보내기!
            // onError로 에러를 보내는 것과 onNext 로 에러를 보내는 것의 차이
            observer.onNext(.failure(.invalidEmail))
            observer.onCompleted()
            
//            observer.onNext(.success(8))
            
            return Disposables.create()
        }.debug("childObservable")
    }
    
    
    
    func observable404() -> Observable<Int> {
        return Observable.create { observer in
            
            observer.onNext(404)
            observer.onCompleted() // 정상적으로 종료가 된 것
            
            return Disposables.create()
        }.debug("childObservable")
    }
}



//댓글 좋아요 안됨. 유저 검색x
//포스트 기반 좋아요 설정 여행
