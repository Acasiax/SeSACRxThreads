//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa

//1) debounce throttle
//

//1. 과제는 rx쓰레드를 새롭게 다운받아서 회원가입 기능들을 해보아라
//2. 서치(버킷리스트 별표시 ) 과제 rx로 해보기

class SearchViewController: UIViewController {
   
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
       
    let disposeBag = DisposeBag()
    
//    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
//    
    
  //  lazy var list = BehaviorSubject(value: data)
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
        bindRefactoring()
    }
    
    func bind() {
     viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                 
                
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .systemBlue
                cell.downloadButton.rx.tap.subscribe(with: self) { owner, _ in
                    print("버튼을 클릭했어요")
                    
                    owner.navigationController?.pushViewController(DetailViewController(), animated: true)
                    
                }
                .disposed(by: cell.disposeBag)
                

            }
            .disposed(by: disposeBag)
        
     //numberOfRowInSection, cellForRowAt, didSelectRowAt >>> 최소한 이거는 쓰지 말자
        // RxSwift에서는 /numberOfRowInSection x
        // >> RxCommunity
        // RxDataSources
        
        // RxSwift Diffable / DataSource
        
        // 🔥 Realm VS Diffable
        
        
        
        // .withUnretained(self) //순환참조 신경 안쓰게 도와주는 것임
        
//        searchBar.rx.searchButtonClicked
//          
//            .withLatestFrom(searchBar.rx.text.orEmpty) {void, text in
//                return text
//                //+ "만세"
//            }
//         
//            .bind(with: self) { owner, value in
//                owner.data.insert(value, at: 0)
//                owner.list.onNext(owner.data)
//                print("검색버튼을 클릭했습니다.")
//            }
//            .disposed(by: disposeBag)
//        
        
        //debounce vs throttle
        //final
        

        
         
    }
    
    
    func bindRefactoring() {
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)){ row, element, cell in
                
                cell.appIconImageView.backgroundColor = .systemBlue
                cell.downloadButton.rx.tap.subscribe(with: self) { owner, _ in
                    owner.navigationController?.pushViewController(DetailViewController(), animated: true)
                }
                
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.inputQuery)
            .disposed(by: disposeBag)
        
        
        searchBar.rx.searchButtonClicked
            .bind(to: viewModel.inputSearchButtonTap)
            .disposed(by: disposeBag)
        
        
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
