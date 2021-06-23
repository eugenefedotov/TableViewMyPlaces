//
//  ViewController.swift
//  TableViewMyPlaces
//
//  Created by Евгений Федотов on 07.06.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var places: Results<Place>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")  as? CustomTableViewCell else {
            return UITableViewCell()
        }

        let place = places[indexPath.row]

        cell.lblName.text = place.name
        cell.lblType.text = place.type
        cell.lblLocation.text = place.location
        cell.imagePlaces.image = UIImage(data: place.imageData!)

        cell.imagePlaces.layer.cornerRadius = cell.imagePlaces.frame.size.height / 2
        cell.imagePlaces.clipsToBounds = true

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let DeleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.removeObj(self.places[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        DeleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [DeleteAction])
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = places[indexPath.row]
            guard let newPlaceVC = segue.destination as? NewPlaceViewController else { return }
            newPlaceVC.selectedPlace = place
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        
        newPlaceVC.savePlace()
        tableView.reloadData()
    }

}

