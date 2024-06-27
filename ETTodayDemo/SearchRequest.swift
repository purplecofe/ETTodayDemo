//
//  SearchRequest.swift
//  ETTodayDemo
//
//  Created by ChongKai Huang on 2024/6/22.
//
import Foundation

class SearchRequest: BaseRequest<SearchRequest.SearchResponse> {
    struct SearchResponse: Codable {
        let resultCount: Int
        let results: [Result]
        
        struct Result: Codable {
            let longDescription: String?
            let artworkUrl100: String
            let trackName: String?
            let trackTimeMillis: Int?
            let previewUrl: String?
        }
    }

    init(keyword: String) {
        super.init(path: API.search + keyword)
    }

    override func decode(data: Data) throws -> SearchResponse {
        do {
            let model = try JSONDecoder().decode(SearchResponse.self, from: data)
            return model
        } catch {
            throw error
        }
    }
}
