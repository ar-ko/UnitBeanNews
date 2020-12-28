//
//  NewsfeedCell.swift
//  UnitBeanNews
//
//  Created by ar_ko on 19.12.2020.
//

import UIKit

protocol FeedCellViewModel {
    var title: String { get }
    var author: String { get }
    var publishDate: String { get }
    var numberOfComments: String { get }
    var urlToImage: String? { get }
    var url: String { get }
}

class NewsfeedCell: UITableViewCell {
    
    static let reuseId = "NewsfeedCell"
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var publishDate: UILabel!
    @IBOutlet private weak var numberOfComments: UILabel!
    @IBOutlet private weak var imagePreview: WebImageView!
    
    override func prepareForReuse() {
        imagePreview.image = nil
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(viewModel: FeedCellViewModel) {
        author.text = viewModel.author
        title.text = viewModel.title
        numberOfComments.text = viewModel.numberOfComments
        publishDate.text = viewModel.publishDate
        
        if let url = viewModel.urlToImage {
            imagePreview.set(imageURL: url) {
                guard let photoHeight = self.imagePreview.image?.size.height, let photoWidth = self.imagePreview.image?.size.width else { return }
                
                let ratio = photoHeight / photoWidth
                let cardViewWidth = UIScreen.main.bounds.width - 32
                self.imageViewHeightConstraint.constant = cardViewWidth * ratio
            }
        }
        
        
    }
}
