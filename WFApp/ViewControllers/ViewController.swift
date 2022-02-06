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
    var likedVC: LikedViewController!
    var gradientView: GradientView!
    var topView: UIView!
    var actView: UIActivityIndicatorView!
    
    enum Section {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, ResultsPhoto>! = nil

    private var loader: ServiceProtocol = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientView = GradientView(frame: view.bounds)
        self.view.insertSubview(gradientView, at: 0)
        
        likedVC = tabBarController?.viewControllers?.last as? LikedViewController
    
        configureUI()
        configureDataSource()
        loadRandom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
        gradientView.animateGradient()
    }
}



//MARK: - configureUI
extension ViewController {
    private func configureUI() {
    
        topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.addSubview(topView)
        
        searchTextField = UISearchBar()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.backgroundImage = UIImage()
        searchTextField.delegate = self
        searchTextField.isOpaque = true
        searchTextField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.addSubview(searchTextField)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topView.bottomAnchor.constraint(equalTo: searchTextField.topAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor),

            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
        actView = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 20, height: 20))
        actView.startAnimating()
        view.addSubview(actView)
    }
}

//MARK: - configureCollectionView
extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
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
        
        dataSource = UICollectionViewDiffableDataSource<Section, ResultsPhoto>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
            cell.imageView.kf.indicatorType = .activity
            guard let urlImage = URL(string: model.urls.regular ?? "") else { return cell }
            KF.url(urlImage)
                .fade(duration: 1)
                .set(to: cell.imageView)
            return cell
        })
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ResultsPhoto>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(photoModel.results)
        dataSource.apply(snapshot, animatingDifferences: false)
        self.actView.stopAnimating()
        self.actView.isHidden = true
    }
}

//MARK: - createAlertView
extension ViewController {
    private func createAlertView(title: String, massage: String) {
        let allert = UIAlertController.init(title: title, message: massage, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Обновить", style: .default) { _ in
            self.searchTextField.text == "" ? self.loadRandom() : self.loadSearchResult(query:  self.searchTextField.text!)
        }
        
        allert.addAction(reloadAction)
        present(allert, animated: true, completion: nil)
    }
}

//MARK: - loadData
extension ViewController {
    private func loadRandom() {
        loader.getRandomPhoto() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.photoModel.results = model
                    self.reloadData()
                case .failure(_):
                    self.createAlertView(title: "Сбой загрузки!", massage: "Проверьте подключение к интернету")
                }
            }
        }
    }
    
    private func loadSearchResult(query: String) {
        loader.getPhoto(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.photoModel = model
                    self.reloadData()
                case .failure(_):
                    self.createAlertView(title: "Сбой загрузки!", massage: "Проверьте подключение к интернету")
                }
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        loadSearchResult(query: searchBar.text!)
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // This will cancel all unfinished downloading task when the cell disappearing.
//        (cell as! PhotoCollectionViewCell).imageView.kf.cancelDownloadTask()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photoModel.results[indexPath.row]
        let detailVC = DetailViewController(photo: photo)
        for pt in likedVC.likedPhoto {
            if photo.id == pt.id {
                detailVC.isLiked = true
            }
        }
        detailVC.delegate = likedVC//tabBarController?.viewControllers?.last as? LikedViewController
        present(detailVC, animated: true)
    }
}
