//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let disposeBag = DisposeBag()
    //let descriptionLabel = UILabel()
    /*
     11시 58분까지 실습 !
     
     1. 비밀번호 텍스트필드가 8자리 이상일 때가 true
     2. true일 때 버튼 활성화(isEnabled)
     3. 다음 버튼 탭 시 화면 전환
     4. descriptionLabel 임시로 추가("8자 이상 입력해주세요")
     5. true일 때 descriptionLabel 없애기
     
     >>> 48회차 5번 강의 자료에 그대로 작성해두었음
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        setupBindings()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    

    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    
    func setupBindings() {
//        descriptionLabel.text = "8자 이상 입력해주세요"
//        descriptionLabel.textColor = .red
//        // Create an observable for the password's validity
//       //
//        let isPasswordValid = passwordTextField.rx.text.orEmpty
//            .map { $0.count >= 8 }
//            .share(replay: 1)
//        
//        // Bind the validity to the button's isEnabled property
//        isPasswordValid
//            .bind(to: nextButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//        
//        // Show/hide the description label based on the password's validity
//        isPasswordValid
//            .map { !$0 } // invert the boolean value
//            .bind(to: descriptionLabel.rx.isHidden)
//            .disposed(by: disposeBag)
//        
//        // Handle the next button tap
//        nextButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.nextButtonClicked()
//            })
//            .disposed(by: disposeBag)
    }
    
    
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
