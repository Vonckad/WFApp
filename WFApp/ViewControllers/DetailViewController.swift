//
//  DetailViewController.swift
//  WFApp
//
//  Created by Vlad Ralovich on 4.02.22.
//

import UIKit
import Kingfisher

protocol DetailViewControllerDelegate {
    func addPhoto(_ photo: ResultsPhoto)
}

class DetailViewController: UIViewController {
        
    var photo: ResultsPhoto
    var delegate: DetailViewControllerDelegate?
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var likePhotoButton: UIButton!
    
    init(photo: ResultsPhoto) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    private func configure() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        likePhotoButton = UIButton()
        likePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        likePhotoButton.setTitle("Like", for: .normal)
        likePhotoButton.backgroundColor = .green
        likePhotoButton.addTarget(self, action: #selector(likePhoto), for: .touchUpInside)
        view.addSubview(likePhotoButton)
        
        guard let url = URL(string: photo.urls.regular ?? "") else { return }
        imageView.kf.indicatorType = .activity
        KF.url(url)
            .fade(duration: 1)
            .set(to: imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
//            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            likePhotoButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 44),
            likePhotoButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24),
            likePhotoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24),
            likePhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func likePhoto() {
        delegate?.addPhoto(photo)
        likePhotoButton.setTitle("UnLike", for: .normal)
        likePhotoButton.backgroundColor = .red
    }
}
