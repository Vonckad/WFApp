//
//  LikedTableView.swift
//  WFApp
//
//  Created by Vlad Ralovich on 21.03.22.
//

import UIKit

protocol LikedTableViewDelegate {
    func selectCell(photo: ResultsPhoto)
    func deleteCell(photo: ResultsPhoto)
}

class LikedTableView: UITableView {

    var likedPhoto: [ResultsPhoto] = []
    var likeDelegate: LikedTableViewDelegate?
    
    init() {
        super.init(frame: .zero, style: .plain)
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        register(LikedTableViewCell.self, forCellReuseIdentifier: LikedTableViewCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension LikedTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cell.count = \(likedPhoto.count)")
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
            let photo = likedPhoto[indexPath.row]
            likeDelegate?.deleteCell(photo: photo)
            likedPhoto.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        likeDelegate?.selectCell(photo: likedPhoto[indexPath.row])
    }
}
