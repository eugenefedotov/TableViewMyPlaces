//
//  NewPlaceViewController.swift
//  TableViewMyPlaces
//
//  Created by Евгений Федотов on 13.06.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var imageIsChanged = false
    var selectedPlace: Place?

    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        saveBtn.isEnabled = false        
        nameField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        if selectedPlace != nil {
            setupEditing()
        }
        
        let controller = ViewController()
        print(controller)
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = UIImage(named: "camera")
            let photoIcon = UIImage(named: "photo")
            
            // открываем вставку изображения
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    func savePlace() {
        let image = imageIsChanged ? placeImage.image : UIImage(named: "imagePlaceholder")
        let imageData = image?.pngData()
        let newPlace = Place(name: nameField.text!, location: locationField.text, type: typeField.text, imageData: imageData)
        
        if let selectedPlace = selectedPlace {
            StorageManager.editObj(selectedPlace: selectedPlace, place: newPlace)
        } else {
            StorageManager.saveObj(newPlace)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func setupEditing() -> Void {
        
        setupNavigationBar()
        
        guard let data = selectedPlace?.imageData, let image = UIImage(data: data) else { return }
        nameField.text = selectedPlace?.name
        locationField.text = selectedPlace?.location
        typeField.text = selectedPlace?.type
        placeImage.image = image
        placeImage.contentMode = .scaleAspectFill
        
        imageIsChanged = true
    }
    
    func setupNavigationBar() -> Void {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backButtonTitle = ""
        }
        navigationItem.leftBarButtonItem = nil
        title = selectedPlace?.name
        
        saveBtn.isEnabled = true
    }

}

// MARK: - TextFieldDelegate

extension NewPlaceViewController: UITextFieldDelegate {
    // Скрываем клаву по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc
    private func textFieldChange() {
        saveBtn.isEnabled = !(nameField.text?.isEmpty ?? false)
    }
}

// MARK: - Work with image

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
