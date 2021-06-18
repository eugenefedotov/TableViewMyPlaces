//
//  StorageManager.swift
//  TableViewMyPlaces
//
//  Created by Евгений Федотов on 18.06.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObj(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
}
