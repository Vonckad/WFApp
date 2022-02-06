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
    func removePhoto(_ photo: ResultsPhoto)
}

class DetailViewController: UIViewController {
        
    var photo: ResultsPhoto
    var delegate: DetailViewControllerDelegate?
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var likePhotoButton: UIButton!
    var dismissButton: UIButton!
    
    var isLiked = false
    
    init(photo: ResultsPhoto) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5970487542, green: 0.5506352338, blue: 0.9098039269, alpha: 1)
        navigationController?.isNavigationBarHidden = false
        configure()
        if isLiked {
            likePhotoButton.setTitle("UnLike", for: .normal)
            likePhotoButton.backgroundColor = .red
        }
        
        titleLabel.text = "\(photo.description)\n\(photo.alt_description)\n\(photo.user.name)\n\(photo.user.location)"
    }
    
    private func configure() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        
        likePhotoButton = UIButton()
        likePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        likePhotoButton.setTitle("Like", for: .normal)
        likePhotoButton.backgroundColor = .green
        likePhotoButton.addTarget(self, action: #selector(likePhoto), for: .touchUpInside)
        view.addSubview(likePhotoButton)
        
        dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setTitle("close", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissDetailVC), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dismissButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            
            imageView.topAnchor.constraint(equalTo: dismissButton.topAnchor, constant: 8),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: likePhotoButton.topAnchor, constant: -8),
            
            likePhotoButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            likePhotoButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
        loadImage()
    }
    
    private func loadImage() {
        guard let url = URL(string: photo.urls.regular ?? "") else { return }
        imageView.kf.indicatorType = .activity
        KF.url(url)
            .fade(duration: 1)
            .set(to: imageView)
    }
    
    @objc func likePhoto() {
        if isLiked {
            isLiked = false
            delegate?.removePhoto(photo)
            likePhotoButton.setTitle("Like", for: .normal)
            likePhotoButton.backgroundColor = .green
        } else {
            isLiked = true
            delegate?.addPhoto(photo)
            likePhotoButton.setTitle("UnLike", for: .normal)
            likePhotoButton.backgroundColor = .red
        }
    }
    
    @objc func dismissDetailVC() {
        dismiss(animated: true)
    }
}
