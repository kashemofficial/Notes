//
//  NotesDetailsTableViewController.swift
//  Notes
//
//  Created by Abul Kashem on 12/2/23.
//

import UIKit

class NotesDetailsTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var notesTitleTextField: UITextField!
    @IBOutlet weak var notesDateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesImageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    let newNoteDateFormatter = DateFormatter()
    let imagePickerController = UIImagePickerController()
    
    var note: Note?
    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        notesTextView.layer.borderWidth = 1.0
        notesTextView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        notesTextView.layer.cornerRadius = 6.0
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        newNoteDateFormatter.dateStyle = .short
        
        if let note = note{
            notesTitleTextField.text = note.title
            notesTextView.text = note.body
            if let addDate = note.addDate{
                notesDateLabel.text = dateFormatter.string(from: addDate)
            }
            image = note.image
            notesImageView.image = image
        }else{
            notesTitleTextField.text = ""
            notesTextView.text = ""
            notesDateLabel.text = newNoteDateFormatter.string(from: Date(timeIntervalSinceNow: 0))
            notesImageView.image = nil
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func selectImageButton(_ sender: UIButton) {
        
        selectImageSource()
    }
    
    func selectImageSource() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (alertAction) in
            self.takePhotoUsingCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alertAction) in
            self.selectPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func takePhotoUsingCamera() {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            alertNotifyUser(message: "This device has no camera.")
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func selectPhotoFromLibrary() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        image = selectedImage
        notesImageView.image = image
        if let note = note {
            note.image = selectedImage
        }
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        
        guard let title = notesTitleTextField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            alertNotifyUser(message: "Please enter a title before saving the note.")
            return
        }
        
        if let note = note {
            note.title = title
            note.body = notesTextView.text
            note.image = image
            
        } else {
            note = Note(title: title, body: notesTextView.text, image: image)
        }
        
        if let note = note {
            do {
                let managedContext = note.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "The note could not be saved.")
            }
            
        } else {
            alertNotifyUser(message: "The note could not be created.")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}



