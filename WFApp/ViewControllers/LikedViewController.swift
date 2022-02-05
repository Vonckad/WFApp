//
//  LikedViewController.swift
//  WFApp
//
//  Created by Vlad Ralovich on 4.02.22.
//

import UIKit

class LikedViewController: UIViewController {

    var tableView: UITableView!
    var likedPhoto: [ResultsPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func configure() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LikedTableViewCell.self, forCellReuseIdentifier: LikedTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension LikedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPhoto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikedTableViewCell.reuseIdentifier, for: indexPath) as! LikedTableViewCell
        let photo = likedPhoto[indexPath.row]
        cell.configureCell(with: photo.urls.regular ?? "", and: photo.user.name ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - DetailViewControllerDelegate
extension LikedViewController: DetailViewControllerDelegate {
    func addPhoto(_ photo: ResultsPhoto) {
        likedPhoto.append(photo)
//        print("likedPhoto.append \(photo.id)")
//        tableView.reloadData()
    }
}
