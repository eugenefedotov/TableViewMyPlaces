//
//  ViewController.swift
//  TableViewMyPlaces
//
//  Created by Евгений Федотов on 07.06.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var places: [Place]// = Place.getPlaces()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")  as? CustomTableViewCell else { return UITableViewCell() }
        
        let place = places[indexPath.row]

        cell.lblName.text = place.name
        cell.lblType.text = place.type
        cell.lblLocation.text = place.location
        cell.imagePlaces.image = place.image ?? UIImage(named: place.restaurantImage!)
        
        cell.imagePlaces.layer.cornerRadius = cell.imagePlaces.frame.size.height / 2
        cell.imagePlaces.clipsToBounds = true
        
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        
        newPlaceVC.saveNewPlace()
        places.append(newPlaceVC.newPlace!)
        tableView.reloadData()
    }

}

