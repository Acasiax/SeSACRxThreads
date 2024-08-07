//
//  MovieCollectionView.swift
//  SeSACRxThreads
//
//  Created by 이윤지 on 8/7/24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
        
        
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        layer
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
