//
//  Loadable.swift
//  MovieFlix
//
//  Created by Vijay Masal on 17/05/20.
//  Copyright © 2020 Vijay Masal. All rights reserved.
//

import Foundation
import UIKit
protocol Loadable {
    func showLoadingView()
    func hideLoadingView()
}
final class LoadingView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 5
        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            activityIndicatorView.color = UIColor.white
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorView.startAnimating()
        }
    }
    
    public func animate() {
        activityIndicatorView.startAnimating()
    }
}

fileprivate struct Constants {
    fileprivate static let loadingViewTag = 1234
}
extension Loadable where Self: UIViewController {
    func showLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.animate()
        
        loadingView.tag = Constants.loadingViewTag
    }
    
    func hideLoadingView() {
        view.subviews.forEach { subview in
            if subview.tag == Constants.loadingViewTag {
                subview.removeFromSuperview()
            }
        }
    }
}
