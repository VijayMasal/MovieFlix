//
//  MovieCell.swift
//  MovieFlix
//
//  Created by Vijay Masal on 17/05/20.
//  Copyright © 2020 Vijay Masal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class MovieCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    let posterBaseUrl = "https://image.tmdb.org/t/p/w500"
    var isSearching : Bool = false
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: (240/255.0), green: (179/255.0), blue: (68/255.0), alpha: 1.0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var moveImage: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    var descriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    var deleteButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage( UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var viewModel: MovieCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    private func bindViewModel() {
        titleLabel.text = viewModel?.titles
        descriptionLabel.text = viewModel?.overviews
        if (isSearching == true) {
            deleteButton.isHidden = true
        }
        else{
            deleteButton.isHidden = false
        }
        let strURL = "\(posterBaseUrl)\(viewModel?.poster_paths ?? "")"
        loadImage(urlString: strURL)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor  = UIColor(red: (240/255.0), green: (179/255.0), blue: (68/255.0), alpha: 1.0)
        self.contentView.addSubview(self.container)
        self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.container.addSubview(self.moveImage)
        self.moveImage.translatesAutoresizingMaskIntoConstraints = false
        self.moveImage.leadingAnchor.constraint(equalTo:
            self.container.leadingAnchor).isActive = true
        self.moveImage.bottomAnchor.constraint(equalTo: self.container.bottomAnchor,constant: -5).isActive = true
        self.moveImage.topAnchor.constraint(equalTo: self.container.topAnchor,constant: 5).isActive = true
        self.moveImage.widthAnchor.constraint(equalToConstant:120).isActive = true
        self.container.addSubview(self.titleLabel)
        titleLabel.topAnchor.constraint(equalTo:self.container.topAnchor,constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.moveImage.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.container.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant:20).isActive = true
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        self.container.addSubview(self.descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor,constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo:self.moveImage.trailingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.container.trailingAnchor,constant: -5).isActive = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "Avenir-Book", size: 14)
        self.container.addSubview(self.deleteButton)
        deleteButton.topAnchor.constraint(equalTo:self.descriptionLabel.bottomAnchor,constant: 5).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.container.trailingAnchor,constant: -5).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.container.bottomAnchor,constant: -5).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant:20).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant:20).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MovieCell{
    func loadImage(urlString: String) {
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.moveImage.image = cacheImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        Alamofire.request(url).responseImage{ response in
            if let image = response.result.value{
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async {
                    self.moveImage.image = image
                }
            }
        }
    }
    
}



