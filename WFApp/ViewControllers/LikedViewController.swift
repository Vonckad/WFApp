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
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        tabBarController?.tabBar.backgroundColor = UIColor(white: 0, alpha: 0.1)
        tabBarController?.tabBar.backgroundImage = UIImage()
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
        tableView.backgroundColor = .clear
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
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            likedPhoto = likedPhoto.filter({$0 != likedPhoto[indexPath.row]})
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController(photo: likedPhoto[indexPath.row])
        detailVC.isLiked = true
        detailVC.delegate = self
        present(detailVC, animated: true)
    }
}

//MARK: - DetailViewControllerDelegate
extension LikedViewController: DetailViewControllerDelegate {
    func addPhoto(_ photo: ResultsPhoto) {
        likedPhoto.append(photo)
    }
    func removePhoto(_ photo: ResultsPhoto) {
        likedPhoto = likedPhoto.filter({$0 != photo})
        if tableView != nil {
            tableView.reloadData()
        }
    }
}


