//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum JackError: Error {
    case invalidEmail
    
}


class SignUpViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    
    let emaillData = BehaviorSubject(value: "a@a.com")
 //   let emaillData = PublishSubject<String>()
    let basicColor = Observable.just(UIColor.systemGreen)
    
    let disposeBag = DisposeBag()
    /*
    - 택스트필드 글자수가 4자리 이상이면 true 초록 컬러, 버튼 클릭 가능하게.
    - 4자리 미만이면 false 빨간 컬러, 버튼 클릭 안되서 화면 전환 안되게
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        bind()
       // testPublishSubject()
        
    }
    
    func testPublishSubject() {
        let example = PublishSubject<String>()
        
        //let list: [String] = []
        // let list: Array<String> = []
        //  let list = Array<String>()
        
        example.onCompleted()
        example.onNext("b")
        example.on(.next("a"))
       
        example
            .subscribe(
                onNext: { value in
                    print("publish - \(value)")
                },
                onError: { error in
                    print("publish - \(error)")
                },
                onCompleted: {
                    print("onCompleted")
                },
                onDisposed: {
                    print("onDisposed")
                }
            )
            .disposed(by: disposeBag)
        
      
        example.onNext("c")
        example.onNext("d")
        
    }
    
    
    
    func bind() {
        let validation = emailTextField
            .rx
            .text
            .orEmpty //가드문이나 옵셔널을 벗겨줌
            .map {$0.count >= 4}
        
        validation
            .bind(to: nextButton.rx.isEnabled, validationButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) {owner, value in
                let color: UIColor = value ? .systemGreen : .systemRed
                owner.nextButton.backgroundColor = color
                owner.validationButton.isHidden = !value
                
            }
            .disposed(by: disposeBag)
       // testPublishSubject()
        
      //  emaillData.on(.next("c@c.com"))
        //  emaillData.on(.next("c@c.com2"))
        
        emaillData
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
           
    
        
        validationButton.rx.tap.bind(with: self) { owner, _ in
            owner.emaillData.onNext("b@b.com")
        }
        .disposed(by: disposeBag)
        
        basicColor
            .bind(to: nextButton.rx.backgroundColor, emailTextField.rx.textColor, emailTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        basicColor
            .map{$0.cgColor}
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }
    
    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
}
