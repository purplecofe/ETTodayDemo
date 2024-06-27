//
//  TrackCollectionViewCell.swift
//  ETTodayDemo
//
//  Created by ChongKai Huang on 2024/6/22.
//

import UIKit
import AVFoundation

class TrackCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var trackArtWorkImageView: UIImageView! {
        didSet {
            trackArtWorkImageView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackTimeMillisLabel: UILabel!
    @IBOutlet weak var trackLongDescriptionLabel: UILabel!
    @IBOutlet weak var trackStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.frame.size.width = UIScreen.main.bounds.width
        return attributes
    }
}
