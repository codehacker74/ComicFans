//
//  CategoryCollectionCell.swift
//  ComicFans
//
//  Created by Andrew Masters on 11/4/23.
//

import UIKit

final class CategoryCollectionCell: UICollectionViewCell {
    @IBOutlet weak var categoryBackground: ShadowView!
    @IBOutlet weak var title: UILabel!
    
    func configureCell(title: String) {
        self.title.text = title
    }
}