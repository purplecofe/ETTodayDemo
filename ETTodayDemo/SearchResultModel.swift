//
//  SearchResultModel.swift
//  ETTodayDemo
//
//  Created by ChongKai Huang on 2024/6/27.
//

import Foundation

struct SearchResultModel {
    let longDescription: String?
    let artworkUrl100: String
    let trackName: String?
    let trackTime: String?
    let previewUrl: String?
    var playingStatus: PlayingStatus

    enum PlayingStatus: String {
        case playing = "正在播放▶️"
        case pause = "暫停⏸️"
        case stop = ""
    }
}
