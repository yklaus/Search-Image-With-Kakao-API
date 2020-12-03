//
//  ViewController.swift
//  Search-Image-With-Kakao-API
//
//  Created by klaus on 2020/11/29.
//  Copyright © 2020 yklaus. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellId = "ImageCell"
    var viewModel: ImageListViewModel!
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
            self?.changeState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

extension ImageListViewController {
    private func setupViews() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func changeState() {
        switch viewModel.state {
        case .error:
            self.collectionView.isHidden = true
            self.errorLabel.isHidden = false
            self.errorLabel.text = "에러메시지 - 잠시 후 다시 시도하시기 바랍니다."
        case .resultNone:
            self.collectionView.isHidden = true
            self.errorLabel.isHidden = false
            self.errorLabel.text = "검색결과가 없습니다."
        default:
            self.collectionView.isHidden = false
            self.errorLabel.isHidden = true
        }
    }
}

extension ImageListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.viewModel.query = searchText
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: requestWorkItem)
    }
}

extension ImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.cell(at: indexPath) {
        case .image(let imageListCellViewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageListCell
            cell.update(with: imageListCellViewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.loadMore(indexPath)
    }
}

extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 3, height: collectionView.frame.width / 3 - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
}
