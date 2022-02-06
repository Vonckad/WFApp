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
    var userLabel: UILabel!
    
    var dateLabel: UILabel!
    var locationLabel: UILabel!
    var countLabel: UILabel!
    
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
            likePhotoButton.setTitle("Unlike", for: .normal)
            likePhotoButton.backgroundColor = .red
        }

        userLabel.attributedText = setupText(bolt: "Имя автора: ", normal: photo.user.name ?? "")
        dateLabel.attributedText = setupText(bolt: "Дата создания: ",
                                             normal: Date.getFormattedDate(photo.created_at ?? ""))
        locationLabel.attributedText = setupText(bolt: "Местоположение: ", normal: photo.location?.title ?? "")
        countLabel.attributedText = setupText(bolt: "Количество скачиваний: ", normal: "\(photo.downloads ?? 0)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        likePhotoButton.layer.cornerRadius = likePhotoButton.frame.height / 2
    }
    
    private func setupText(bolt: String, normal: String) -> NSMutableAttributedString {
        
        let attributsBold = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)]
        let attributsNormal = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        let attributedString = NSMutableAttributedString(string: bolt, attributes: attributsBold)
        let normalStringPart = NSMutableAttributedString(string: normal, attributes: attributsNormal)
        attributedString.append(normalStringPart)
        
        return attributedString
    }
    
    private func configure() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        userLabel = UILabel()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.textAlignment = .left
        view.addSubview(userLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .left
        view.addSubview(dateLabel)
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textAlignment = .left
        locationLabel.numberOfLines = 0
        view.addSubview(locationLabel)
        
        countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textAlignment = .left
        view.addSubview(countLabel)
        
        likePhotoButton = UIButton()
        likePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        likePhotoButton.setTitle("Like", for: .normal)
        likePhotoButton.backgroundColor = .green
        likePhotoButton.addTarget(self, action: #selector(likePhoto), for: .touchUpInside)
        view.addSubview(likePhotoButton)
        
        dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setTitle("Закрыть", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissDetailVC), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dismissButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            
            imageView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 8),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            
            userLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            userLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            userLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -8),
            
            locationLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -8),
            
            countLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
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

//MARK:- convert Date
extension Date {
    static func getFormattedDate(_ string: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"

        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!);
    }
}
