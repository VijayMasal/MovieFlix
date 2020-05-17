//
//  DetailViewController.swift
//  MovieFlix
//
//  Created by Vijay Masal on 17/05/20.
//  Copyright © 2020 Vijay Masal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class DetailViewController: UIViewController {
    var panGesture       = UIPanGestureRecognizer()
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    var movie : MovieCellViewModel?
    var imageCache = NSCache<AnyObject, AnyObject>()
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let posterBaseUrl = "https://image.tmdb.org/t/p/w500"
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        dragView.isUserInteractionEnabled = true
        dragView.addGestureRecognizer(panGesture)
        titleLbl.text = movie?.titles
        descriptionLbl.text = movie?.overviews
        dateLbl.text = movie?.release_dates
        ratingLbl.text = "\(movie?.vote_averages ?? 0)%"
        durationLbl.text = "0 h 0 min"
        let strURL = "\(posterBaseUrl)\(movie?.poster_paths ?? "")"
        loadImage(urlString: strURL)
    }
    func loadImage(urlString: String) {
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.posterImage.image = cacheImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        Alamofire.request(url).responseImage{ response in
            if let image = response.result.value{
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async {
                    self.posterImage.image = image
                }
            }
        }
    }
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(dragView)
        let translation = sender.translation(in: self.view)
        dragView.center = CGPoint(x: dragView.center.x, y: dragView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}
