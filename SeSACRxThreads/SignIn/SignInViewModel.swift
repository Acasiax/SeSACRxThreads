//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

// 형태. 구현부는 다른 곳에서
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
    
    // Observable > publishSubject > PublishRelay
    struct Output {
        let text: Driver<Joke>
    }
    
    // 탭 했을 때 서버 통신 > 메인 쓰레드에서 동작하지 않을 수 있고..
    // 탭했을 때 UI

    func transform(input: Input) -> Output {
        let result = input.tap
            .flatMap{
                // 처리 2번: 에러 발생 시 빈 스트림을 반환하여 이벤트가 흐르지 않도록 합니다.
                NetworkManager.shared.fetchJokeWithSingle()
                    .catch{ error in
                        return Single<Joke>.never()  // 네트워크 에러 발생 시, 아무 이벤트도 발생하지 않도록 처리
                    }
                // 처리 1번: 에러 발생 시 Joke(joke: "실패", id: 0) 객체를 반환하는 대체 처리 코드
                // .catch { error in
                //    return Observable.just(Joke(joke: "실패", id: 0))
                // }
            }
            // .asSingle() // 🌟🔥
            .asDriver(onErrorJustReturn: Joke(joke: "실패", id: 0))  // 에러 발생 시 "실패"라는 기본 Joke 반환
            .debug("버튼 탭")
        
        return Output(text: result)
    }
}

//1. asSingle 썼더니 > 뷰에 결과가 안나옴. button tap 이벤트 전달이 안됨. 두번째 버튼 실패로 나오고, 세번째부터는 클릭도 안된다. => 전체 스트림을 모두 single로 만들어 버린다.

//2. 탭 옵저버블 내에 네트워크 옵져버블이 있는데.
// 탭 옵저버블은 살아있고, 네트워크가 오류를 보내면. 탭도 오류를 보내기 때문에 두번째에는 실행되지 않는 문제가 발생함. 이거는 싱글의 문제가 아니고, 부모 스트림에 자식 스트림이 있으면 나타나는 문제임. 자식이 흘러온 이벤트를 부모가 받기 때문에 에러를 받을 수 밖에 없는 것임.

//3. 자식 스트림이 에러를 방출하더라도 부모 스트림이 에러를 안 받고 dispose가 안되고 스트림이 유지되게!
// >> 에러 처리 + 스트림 유지


//MARK: - 에러 처리하는 방법
//1. catch 이용하기
//catch 연산자를 사용하여 네트워크 요청 중 에러가 발생했을 때 특정 동작을 수행합니다. 예를 들어, 에러가 발생하면 기본 Joke 객체를 반환하도록 할 수 있습니다.
//
//2. result에서 error로 값을 바꾸기
//result에서 에러가 발생했을 경우, 에러를 처리하여 Joke(joke: "실패", id: 0)와 같은 기본 값을 반환하거나 다른 처리 방식으로 전환할 수 있습니다.

//MARK: - 오류 실패 대응 과제에 적용해보기, 고민하기, 찾아보기.
