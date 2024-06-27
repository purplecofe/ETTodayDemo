//
//  SearchViewModel.swift
//  ETTodayDemo
//
//  Created by ChongKai Huang on 2024/6/26.
//

import Foundation
import AVFoundation

protocol SearchViewModelDelegate: AnyObject {
    func didSearchError(error: String)
    func didUpdateTrack()
    func didPlayFail(error: String)
}

class SearchViewModel: NSObject {
    private var player: AVPlayer?
    private var playingIndex: Int?
    weak var delegate: SearchViewModelDelegate?
    
    private(set) var tracks: [SearchResultModel] = []
    private var searchTask: Task<(), Error>?
    
    func searchTrack(keyword: String) {
        player = nil
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                let response = try await SearchRequest(keyword: keyword).execute()
                if Task.isCancelled {
                    return
                }
                
                tracks = response.results.map { result -> SearchResultModel in
                    let trackTime: String?
                    if let trackTimeMillis = result.trackTimeMillis {
                        print(trackTimeMillis)
                        let hours = trackTimeMillis / 3600000
                        let minutes = (trackTimeMillis % 3600000) / 60000
                        let seconds = (trackTimeMillis % 60000) / 1000
                        if hours <= 0 {
                            trackTime = String(format: "%02d:%02d", minutes, seconds)
                        } else {
                            trackTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                        }
                    } else {
                        trackTime = nil
                    }
                    return SearchResultModel(longDescription: result.longDescription,
                                             artworkUrl100: result.artworkUrl100,
                                             trackName: result.trackName,
                                             trackTime: trackTime,
                                             previewUrl: result.previewUrl,
                                             playingStatus: .stop)
                }
                
                delegate?.didUpdateTrack()
            } catch is CancellationError, URLError.Code.cancelled  {
            } catch {
                delegate?.didSearchError(error: error.localizedDescription)
            }
        }
    }
    
    private func playNewTrack(_ index: Int) {
        player?.pause()
        if let previewUrl = tracks[index].previewUrl,
           let url = URL(string: previewUrl) {
            let player = AVPlayer(url: url)
            player.volume = 1.0
            player.play()
            playingIndex = index
            tracks[index].playingStatus = .playing
            self.player = player
        } else {
            playingIndex = nil
            delegate?.didPlayFail(error: "Preview url is nil")
        }
    }
    
    func play(index: Int) {
        if let playingIndex = playingIndex {
            if playingIndex == index {
                if tracks[playingIndex].playingStatus == .playing {
                    tracks[playingIndex].playingStatus = .pause
                    player?.pause()
                } else {
                    tracks[playingIndex].playingStatus = .playing
                    player?.play()
                }
            } else {
                tracks[playingIndex].playingStatus = .stop
                playNewTrack(index)
            }
        } else {
            playNewTrack(index)
        }
        delegate?.didUpdateTrack()
    }
    
    func clearTracks() {
        tracks.removeAll()
    }
}

extension SearchViewModel: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("error = \(error)")
    }
}
