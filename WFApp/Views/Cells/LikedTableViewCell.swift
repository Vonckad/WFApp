//
//  LikedTableViewCell.swift
//  WFApp
//
//  Created by Vlad Ralovich on 5.02.22.
//

import UIKit
import Kingfisher

class LikedTableViewCell: UITableViewCell {

    static let reuseIdentifier = "liked-cell-reuse-identifier"
    var photoImageView: UIImageView!
    var userLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
 
    private func configure() {
        photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        contentView.addSubview(photoImageView)
        
        userLabel = UILabel()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.numberOfLines = 0
        userLabel.textAlignment = .justified
        contentView.addSubview(userLabel)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            userLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 24),
            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24),
            userLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCell(with imageUrl: String, and text: String) {
        guard let url = URL(string: imageUrl) else { return }
        photoImageView.kf.indicatorType = .activity
        KF.url(url)
            .fade(duration: 1)
            .set(to: photoImageView)
        
        userLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
