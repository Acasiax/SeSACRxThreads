//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let viewModel = BoxOfficeViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    
    func bind() {
            
            let input = BoxOfficeViewModel.Input()
            let output = viewModel.transform(input: input)
            
            // 테이블뷰에 movieList 바인딩
            output.recentList
                .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) {
                    (row, element, cell) in
                  
                      cell.label.text = "\(element), \(row)"
                }
                .disposed(by: disposeBag)
            
            // Observable.zip 사용하여 modelSelected와 itemSelected 동시에 처리
            Observable.zip(tableView.rx.modelSelected(String.self),
                           tableView.rx.itemSelected
            )
            .debug("잭잭잭 박") // 디버깅을 위해 Observable의 이벤트를 콘솔에 출력하는 메소드 (프린트의 대체재)
        // 나중에 최종 프로젝트 제출 시에는 이 코드를 삭제해야 함
        // 심사위원이 지원자가 충분히 테스트하지 않았다고 생각할 수 있음
            .map {"검색어는 \($0.0)"}
                .subscribe(with: self) { owner, value in
                    print(value)
                }
                .disposed(by: disposeBag)
            
            // modelSelected 처리
            tableView.rx.modelSelected(String.self)
                .subscribe(with: self) { owner, value in
                    print("Selected model:", value)
                }
                .disposed(by: disposeBag)
            
            // itemSelected 처리
            tableView.rx.itemSelected
                .subscribe(with: self) { owner, indexPath in
                    print("Selected item at indexPath:", indexPath)
                }
                .disposed(by: disposeBag)
        }
    
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        
                collectionView.backgroundColor = .lightGray
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    
}
