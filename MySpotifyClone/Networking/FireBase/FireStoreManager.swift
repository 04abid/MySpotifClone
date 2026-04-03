//
//  FireStoreManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 16.03.26.
//

import Foundation
import FirebaseFirestore


class FireStoreManager {
    private let db = Firestore.firestore()
    
    func getDataFromFireBase(completion:@escaping((String?,String?) -> Void)) {
        db.collection("SpotifyConfig").document("Credentials").getDocument {snapshot, error in
            if let error {
                completion(nil,error.localizedDescription)
            } else if let snapshot {
                guard let  info = snapshot.data() else {
                    completion(nil,nil)
                    return
                }
                let clientID = info["ClientID"] as? String
                let clientSecret = info["ClientSecret"] as? String
                completion(clientID,clientSecret)
            }
        }
    }
    
    func saveDataToFireBase(model: Track) {
        db.collection("likedTracks").document(model.id).setData(model.convertToDictionary())
    }
    
    func deleteDataFromFireBase(model:Track) {
        db.collection("likedTracks").document(model.id).delete()
    }
    
    func fetchDataFromFireBase(completion:@escaping(([Track]?,String?) -> Void)) {
        db.collection("likedTracks").getDocuments { snapShot, error in
            if let error {
                completion(nil,error.localizedDescription)
            } else if let snapShot {
               let data = snapShot.documents.compactMap{doc in
                    Track.fromDictionary(dict: doc.data())}
                    completion(data,nil)
            }
        }
    }
}
