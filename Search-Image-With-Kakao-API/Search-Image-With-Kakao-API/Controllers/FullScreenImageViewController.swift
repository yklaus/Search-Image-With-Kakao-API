//
//  FullScreenImageViewController.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/12/02.
//  Copyright © 2020 yklaus. All rights reserved.
//

import UIKit

import SnapKit
import Kingfisher

class FullScreenImageViewController: UIViewController {
    
    var viewModel: FullScreenImageViewModel!
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let siteNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let datetimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.onUpdate = { [weak self] in
            self?.updateUi()
        }
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.viewDidDisappear()
        super.viewDidDisappear(animated)
    }
}

extension FullScreenImageViewController {
    func setupViews() {
        let scrollView = UIScrollView()
        
        contentView.addSubview(imageView)
        contentView.addSubview(siteNameLabel)
        contentView.addSubview(datetimeLabel)
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        siteNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(16)
        }
        
        datetimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(siteNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(16)
        }
    }
    
    func updateUi() {
        imageView.kf.setImage(with: URL(string: viewModel.imageUrl))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if !viewModel.datetime.isEmpty {
            self.datetimeLabel.isHidden = false
            let date = dateFormatter.date(from: viewModel.datetime)
            let dateString = dateFormatter2.string(from: date!)
            self.datetimeLabel.text = "문서 작성 시간: \(dateString)"
        } else {
            self.datetimeLabel.isHidden = true
        }
        
        if !viewModel.displaySiteName.isEmpty {
            self.siteNameLabel.isHidden = false
            self.siteNameLabel.text = "출처: \(viewModel.displaySiteName)"
        } else {
            self.siteNameLabel.isHidden = true
        }
        
        let imageViewHeight = self.viewModel.calculateImageHeight(screenWidth: self.view.frame.width)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(imageViewHeight + 100)
        }
    }
}
