//
//  ViewController.swift
//  FlickerApp
//
//  Created by Rahul Kamra on 30/08/20.
//  Copyright © 2020 Rahul Kamra. All rights reserved.
//

import UIKit

class ImageCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var searchBarController: UISearchController!
    let viewModel = FlickerViewModel()
    private var isFirstTimeActive = true
    private var dispatchItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        viewModelClosures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTimeActive {
            searchBarController.isActive = true
            isFirstTimeActive = false
        }
    }
    
    private func showAlert(title: String = "Flickr", message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}

extension ImageCollectionViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    private func createSearchBar() {
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
               
        dispatchItem?.cancel()
        viewModel.search(text: text) {
            print("search completed.")
        }
        
        searchBarController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dispatchItem?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.search(text: searchText) {
                print("search completed.")
            }
        }
        dispatchItem = task
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
}

extension ImageCollectionViewController {
    
    fileprivate func viewModelClosures() {
        
        viewModel.showAlert = { [weak self] (message) in
            DispatchQueue.main.async {
                self?.showAlert(message: message)
            }
        }
        
        viewModel.dataUpdated = { [weak self] in
            DispatchQueue.main.async {
            print("data source updated")
            self?.collectionView.reloadData()
            }
        }
    }
    
    private func loadNextPage() {
        viewModel.fetchNextPage {
            print("next page fetched")
        }
    }
    
    private func configureUI() {
        createSearchBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
}

extension ImageCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let model = viewModel.photoArray[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.photoArray.count - 10) {
            loadNextPage()
        }
    }
    
    
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/3, height: (collectionView.bounds.width)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

