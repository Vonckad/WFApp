//
//  ViewController.swift
//  WFApp
//
//  Created by Vlad Ralovich on 3.02.22.
//

import UIKit

class ViewController: UIViewController {
    
    private var searchTextField: UISearchBar!
    private var collectionView: ImageCollectionView!
    var actView: UIActivityIndicatorView!
    var gradientView: GradientView!
    
    private var serviceFetcher: ServiceFetcherProtocol = ServiceFetcher()
    var dataStore: ServiceDataStore
    
    init(dataStore: ServiceDataStore) {
        self.dataStore = dataStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientView = GradientView(frame: view.bounds)
        self.view.insertSubview(gradientView, at: 0)
        configureUI()
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
    
        let topView = UIView()
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
        
        let button = UIButton()
        button.setImage(UIImage(named: "random"), for: .normal)
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(loadRandom), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.addSubview(button)
        
        collectionView = ImageCollectionView(frame: .zero, collectionViewLayout: ImageCollectionView.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leftAnchor.constraint(equalTo: view.leftAnchor),
            topView.rightAnchor.constraint(equalTo: view.rightAnchor),
            topView.bottomAnchor.constraint(equalTo: searchTextField.topAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            button.leftAnchor.constraint(equalTo: searchTextField.rightAnchor),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            button.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            
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

//MARK: - createAlertView
extension ViewController {
    private func createAlertView() {
        let allert = UIAlertController.init(title: "Сбой загрузки!", message: "Проверьте подключение к интернету", preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Обновить", style: .default) { _ in
            self.searchTextField.text == "" ? self.loadRandom() : self.loadSearchResult(query:  self.searchTextField.text!)
        }
        
        allert.addAction(reloadAction)
        present(allert, animated: true, completion: nil)
    }
    
    private func stratActView(_ isEnable: Bool) {
        isEnable ? actView.startAnimating() : actView.stopAnimating()
        actView.isHidden = !isEnable
    }
}

//MARK: - loadData
extension ViewController {
    @objc
    private func loadRandom() {
        stratActView(true)
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        serviceFetcher.fetchRandomImages { response in
            guard let results = response else {
                self.createAlertView()
                return
            }
            self.stratActView(false)
            self.collectionView.photoModel.results = results
            self.collectionView.myReloadData()
        }
    }
    
    private func loadSearchResult(query: String) {
        stratActView(true)
        serviceFetcher.fetchImages(searchItem: query) { searchItemResults in
            guard let results = searchItemResults else {
                self.createAlertView()
                return
            }
            self.stratActView(false)
            self.collectionView.photoModel = results
            self.collectionView.myReloadData()
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
        let photo = self.collectionView.photoModel.results[indexPath.row]
        let detailVC = DetailViewController(photo: photo, dataStore: dataStore)
        present(detailVC, animated: true)
    }
}
