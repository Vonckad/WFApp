//
//  ViewController.swift
//  WFApp
//
//  Created by Vlad Ralovich on 3.02.22.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    private var searchTextField: UISearchBar!
    private var collectionView: UICollectionView!
    private var photoModel: PhotoModel = PhotoModel(results: [])
    private var backgroundColor = UIColor(red: 193/255, green: 174/255, blue: 244/255, alpha: 1)
    
    enum Section {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, ResultsPhoto>! = nil

    private var loader: ServiceProtocol = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = backgroundColor
        view.addSubview(GradientView(frame: view.bounds))
        configureUI()
        configureDataSource()
        
        loader.getRandomPhoto() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.photoModel.results = model
                    self.reloadData()
                case .failure(let error):
                    print("Erorr loader = \(error)")
                }
            }
        }
    }
}

//MARK: - configureUI
extension ViewController {
    private func configureUI() {
    
        searchTextField = UISearchBar()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.backgroundImage = UIImage()
        searchTextField.delegate = self
        view.addSubview(searchTextField)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            searchTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),

            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

//MARK: - configureCollectionView
extension ViewController {
    func createLayout() -> UICollectionViewLayout {
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
    
    func configureDataSource() {
    
        dataSource = UICollectionViewDiffableDataSource<Section, ResultsPhoto>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
            cell.imageView.kf.indicatorType = .activity
            guard let urlImage = URL(string: model.urls.regular ?? "") else { return cell }
            cell.imageView.kf.setImage(with: urlImage, options: [.cacheMemoryOnly])
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.white.cgColor
            return cell
        })
        
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ResultsPhoto>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(photoModel.results)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        
        loader.getPhoto(guery: searchBar.text!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.photoModel = model
                    self.reloadData()
                case .failure(let error):
                    print("Erorr loader = \(error)")
                }
            }
        }
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // This will cancel all unfinished downloading task when the cell disappearing.
//        (cell as! PhotoCollectionViewCell).imageView.kf.cancelDownloadTask()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        let photo = photoModel.results[indexPath.row]
        let detailVC = DetailViewController(imageUrl: photo.urls.regular ?? "", mainTitle: "")
//        navigationController?.pushViewController(detailVC, animated: true)
        present(detailVC, animated: true)
    }
}
