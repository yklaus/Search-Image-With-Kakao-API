//
//  ImageListCell.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/11/29.
//  Copyright © 2020 yklaus. All rights reserved.
//

import UIKit
import Kingfisher

class ImageListCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func update(with viewModel: ImageListCellViewModel) {
        self.imageView.kf.setImage(with: URL(string: viewModel.thumbnailUrl)!)
    }
}
