//
//  ViewController.swift
//  Movies
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import UIKit
import Models
import API

class SearchViewController: UIViewController {
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var collectionView: UICollectionView! = nil
    
    enum Section: CaseIterable {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>?
    
    private var dependencies: Dependencies!
    private var viewModel: SearchViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Film list"
        searchTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        viewModel = dependencies.createSearchViewModel()
        viewModel.delegate = self
        configure()
    }
    
    func setup(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    private func configure() {
        collectionView = UICollectionView(frame: collectionContainer.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionContainer.addSubview(collectionView)
        collectionView.delegate = self
        let cellRegistration = UICollectionView.CellRegistration
        <MovieCell, Movie> { (cell, indexPath, movie) in
            cell.titleLabel.text = movie.title
            cell.yearLabel.text = movie.year
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Movie) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    @objc func textDidChange() {
        viewModel.textDidChange(to: searchTextField.text)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        viewModel.selectedMovie(id: movie.imdbID)
        showSpinner(true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.movies.count - 1 else {
            return
        }
        viewModel.loadNextPage()
    }
    
    func showSpinner(_ show: Bool) {
        let alpha = show ? 1 : 0
        activityView.alpha = CGFloat(alpha)
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func refresh() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.movies)
        dataSource?.apply(snapshot, animatingDifferences: true)
        collectionView.reloadData()
    }
    
    func didReceiveMovieDetails(_ details: MovieDetails) {
        showSpinner(false)
        guard let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MovieDetailsViewController") as? MovieDetailsViewController else { return }
        viewController.movieDetails = details
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showError(_ error: ApiError) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}



