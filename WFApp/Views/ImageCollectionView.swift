//
//  ImageCollectionView.swift
//  WFApp
//
//  Created by Vlad Ralovich on 17.03.22.
//

import UIKit
import Kingfisher

class ImageCollectionView: UICollectionView {

    var photoModel: PhotoModel = PhotoModel(results: [])
    
    private var myDataSource: UICollectionViewDiffableDataSource<Section, ResultsPhoto>! = nil
    
    enum Section {
        case main
    }
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        backgroundColor = .clear
        register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        showsVerticalScrollIndicator = false
        keyboardDismissMode = .onDrag
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        
        myDataSource = UICollectionViewDiffableDataSource<Section, ResultsPhoto>(collectionView: self, cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
            cell.imageView.kf.indicatorType = .activity
            guard let urlImage = URL(string: model.urls.regular ?? "") else { return cell }
            KF.url(urlImage)
                .fade(duration: 1)
                .set(to: cell.imageView)
            return cell
        })
    }
    
    func myReloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ResultsPhoto>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(photoModel.results)
        myDataSource.apply(snapshot, animatingDifferences: false)
//        self.actView.stopAnimating()
//        self.actView.isHidden = true
    }
    
}
