//
//  LikedViewController.swift
//  WFApp
//
//  Created by Vlad Ralovich on 4.02.22.
//

import UIKit

class LikedViewController: UIViewController {

    var tableView: LikedTableView!
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
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        tabBarController?.tabBar.backgroundColor = UIColor(white: 0, alpha: 0.1)
        tabBarController?.tabBar.backgroundImage = UIImage()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.likedPhoto = dataStore.likedPhoto
        tableView.reloadData()
    }
    
    private func configure() {
        tableView = LikedTableView()
        tableView.likeDelegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

//MARK: - LikedTableViewDelegate
extension LikedViewController: LikedTableViewDelegate {
    func selectCell(photo: ResultsPhoto) {
        let detailVC = DetailViewController(photo: photo, dataStore: dataStore)
        detailVC.delegate = self
        present(detailVC, animated: true)
    }
    
    func deleteCell(photo: ResultsPhoto) {
        dataStore.removePhoto(photo)
    }
}

extension LikedViewController: DetailViewControllerDelegate {
    func dismissDetail(_ dataSourse: ServiceDataStore) {
        tableView.likedPhoto = dataSourse.likedPhoto
        tableView.reloadData()
    }
}
