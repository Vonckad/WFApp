//
//  ViewController.swift
//  WFApp
//
//  Created by Vlad Ralovich on 3.02.22.
//

import UIKit
import UnsplashPhotoPicker

class ViewController: UIViewController {

    var backgroundColor = UIColor(red: 193/255, green: 174/255, blue: 244/255, alpha: 1)
    var button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        button.addTarget(self, action: #selector(presentUnsplashPhotoPicker), for: .touchUpInside)
        button.backgroundColor = .brown
        view.addSubview(button)
    }
    
    @objc func presentUnsplashPhotoPicker() {
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "c9GFb-BEoMjgSkTXUNExh6l32k4sz8ah3Fl0evr3IvI",
            secretKey: "RWqsTzUVpj3oiLIbMw_mJvA-dfymp0JSgMNUEvuQWU0",
            query: "dog")
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self

        present(unsplashPhotoPicker, animated: true, completion: nil)
    }


}

// MARK: - UnsplashPhotoPickerDelegate
extension ViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        print("Unsplash photo picker did select \(photos.count) photo(s)")
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }
}

