//
//  PlaceModel.swift
//  TableViewMyPlaces
//
//  Created by Евгений Федотов on 09.06.2021.
//

import RealmSwift

class Place: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
