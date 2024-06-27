//
//  ViewController.swift
//  ETTodayDemo
//
//  Created by ChongKai Huang on 2024/6/22.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchTracks()
    }
    
    func setup() {
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        searchButton.addTarget(self, action: #selector(fetchTracks), for: .touchUpInside)
        
        viewModel.delegate = self
    }
    
    @objc func fetchTracks() {
        guard let text = searchTextField.text, !text.isEmpty else {
            viewModel.clearTracks()
            collectionView.reloadData()
            return
        }

        viewModel.searchTrack(keyword: text.replacingOccurrences(of: " ", with: "+"))
    }
    
    @objc func textFieldDidChange() {
        fetchTracks()
    }
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as! TrackCollectionViewCell
        let track = viewModel.tracks[indexPath.row]
        cell.trackArtWorkImageView.kf.setImage(with: URL(string: track.artworkUrl100))
        cell.trackNameLabel.text = track.trackName
        cell.trackTimeMillisLabel.text = track.trackTime
        cell.trackLongDescriptionLabel.text = track.longDescription
        cell.trackLongDescriptionLabel.isHidden = track.longDescription == nil
        cell.trackStatusLabel.text = track.playingStatus.rawValue
        return cell
    }
}
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.play(index: indexPath.row)
    }
}

extension ViewController: SearchViewModelDelegate {
    func didSearchError(error: String) {
        print("error = \(error)")
    }

    func didUpdateTrack() {
        Task { @MainActor in
            collectionView.reloadData()
        }
    }
    
    func didPlayFail(error: String) {
        print("error = \(error)")
    }
}
