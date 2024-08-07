//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let viewModel = NickNameViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        //Observable Stream이 공유되지 않는다.
        //보통 구독을 할 때마다 새로운 스트림이 생긴다.
        //share를 통해서 스트림을 공유하게 만들 수 있다.
        
        //share를 안쓰고 스트림을 공유할 수 없을까?
        //sunscribe에서 ui스럽게 bind로 왔다면,
        //구독할 때 스트림을 공유하게 만들어주는 또다른 친구 (share) 말고 -> drive 이다!
        //subscribe vs bind
        
        // MARK: - Input
        let input = NickNameViewModel.Input(
            tap: nextButton.rx.tap.asControlEvent(),
            nickname: nicknameTextField.rx.text.orEmpty.asObservable(),
            text: nicknameTextField.rx.text
        )
        
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.validText
            .bind(to: nextButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        output.isValid
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.tap
            .bind { _ in
                print("버튼이 클릭됐어요")
                self.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
