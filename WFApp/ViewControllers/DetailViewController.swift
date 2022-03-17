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
        
    private var photo: ResultsPhoto
    private var imageView: UIImageView!
    private var userLabel: UILabel!
    
    private var dateLabel: UILabel!
    private var locationLabel: UILabel!
    private var countLabel: UILabel!
    
    private var likePhotoButton: UIButton!
    private var dismissButton: UIButton!
    
    var delegate: DetailViewControllerDelegate?
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
        
        let guide = view.safeAreaLayoutGuide
        let spacing = CGFloat(16)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: spacing),
            dismissButton.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -spacing),
            
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            imageView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: spacing),
            imageView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: spacing),
            imageView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -spacing),
            
            userLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing),
            userLabel.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: spacing),
            userLabel.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -spacing),
            
            dateLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: spacing),
            dateLabel.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: spacing),
            dateLabel.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -spacing),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: spacing),
            locationLabel.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: spacing),
            locationLabel.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -spacing),
            
            countLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: spacing),
            countLabel.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: spacing),
            countLabel.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -spacing),
            
            likePhotoButton.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: spacing),
            likePhotoButton.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: spacing),
            likePhotoButton.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -spacing),
            likePhotoButton.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor, constant: -spacing)
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
