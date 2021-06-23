//
//  StorageManager.swift
//  TableViewMyPlaces
//
//  Created by Евгений Федотов on 18.06.2021.
//

import RealmSwift

let realm = try! Realm()
let placeO = realm.objects(Place.self)

class StorageManager {
    static func saveObj(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func editObj(selectedPlace: Place, place: Place) {
        try! realm.write {
            selectedPlace.name = place.name
            selectedPlace.location = place.location
            selectedPlace.type = place.type
            selectedPlace.imageData = place.imageData
        }
    }
    
    static func removeObj(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
