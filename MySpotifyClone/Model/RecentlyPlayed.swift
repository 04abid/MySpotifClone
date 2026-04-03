//
//  RecentlyPlayed.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 04.03.26.
//

import Foundation


struct RecentlyPlayedResponse: Codable {
    let items: [RecentlyPlayedItem]
    let next: String?
    let limit: Int
}

struct RecentlyPlayedItem: Codable {
    let track: Track
    let playedAt: String
    
    enum CodingKeys: String, CodingKey {
        case track
        case playedAt = "played_at"
    }
}


struct Track: Codable {
    let id: String
    let name: String
    let artists: [Artist]
    let album: Album?
    let durationMs: Int
    let explicit: Bool?
    let uri: String
    let isPlayable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, artists, album, uri, explicit
        case durationMs = "duration_ms"
        case isPlayable = "is_playable"
    }
}


struct Album: Codable {
    let id: String
    let name: String
    let images: [SpotifyImage]
    let artists: [Artist]
    let albumType: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, images, artists
        case albumType = "album_type"
        case releaseDate = "release_date"
    }
}


struct Artist: Codable {
    let id: String
    let name: String
    let images: [SpotifyImage]?
}


struct SpotifyImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
}


extension Track {
    
    func convertToDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "uri": uri,
            "album": album?.images.first?.url ?? "",
            "artist": artists.first?.name ?? "",
            "duration": durationMs,
        ]
    }
    
   static func fromDictionary(dict: [String:Any]) -> Track? {
      guard let id = dict["id"] as? String,
            let name = dict["name"] as? String,
            let uri = dict["uri"] as? String
        else {return nil}
        
       let duration = dict["duration"] as? Int ?? 0
       let artistName = dict["artist"] as? String ?? ""
       let albumImageUrl = dict["album"] as? String ?? ""
        
        
        let artist = Artist(id: "", name: artistName, images: nil)
        let image = SpotifyImage(url: albumImageUrl, height: nil, width: nil)
        let album = Album(id: "", name: "", images: [image], artists: [], albumType: "", releaseDate: "")
       
       return Track(id: id,
                    name: name,
                    artists: [artist],
                    album: album,
                    durationMs: duration,
                    explicit: nil,
                    uri: uri,
                    isPlayable: nil)
        
    }
}
