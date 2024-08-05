//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let viewModel = PhoneViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        let input = PhoneViewModel.Input(
            phoneNumber: phoneTextField.rx.text.orEmpty.asObservable(),
            nextTap: nextButton.rx.tap.asControlEvent()
        )
        
        let output = viewModel.transform(input: input)
        
        output.validText
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        output.isValid
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nextTap
            .bind { [weak self] in
                print("버튼이 클릭됐어요")
                self?.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
