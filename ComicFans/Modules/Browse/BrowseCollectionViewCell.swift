//
//  BrowseCollectionViewCell.swift
//  ComicFans
//
//  Created by Andrew Masters on 11/6/23.
//

import UIKit

final class BrowseCollectionViewCell: UICollectionViewCell, UIViewLoading {
    @IBOutlet weak var browseBackgroundView: ShadowView!
    @IBOutlet weak var browseImage: UIImageView!
    @IBOutlet weak var browseTitle: UILabel!
    
    func configureCell(title: String?, description: String?) {
        self.backgroundColor = .clear
        self.browseBackgroundView.backgroundColor = .marvelRed()
        self.browseTitle.text = title
    }
    
    func configureImage(image: UIImage?, imagePath: String?, completion: @escaping (UIImage?) -> Void) {
        if let image {
            self.browseImage.image = image
            completion(image)
            return
        } else if let imagePath {
            self.browseImage.downloaded(from: imagePath, contentMode: .scaleAspectFill, completion: completion)
            return
        }
        completion(nil)
    }
}
