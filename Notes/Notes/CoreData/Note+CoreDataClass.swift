//
//  Note+CoreDataClass.swift
//  Notes
//
//  Created by Abul Kashem on 12/2/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(Note)
public class Note: NSManagedObject {

    var addDate: Date? {
        get {
            return rowAddDate as Date?
        }
        set {
            rowAddDate = newValue as NSDate? as Date?
        }
    }
    
    var image: UIImage? {
        get {
            if let imageData = rowImage as Data? {
                return UIImage(data: imageData)
            }else{
                return nil
            }
        }
        set{
            if let image = newValue{
                rowImage = convertImageToNSData(image: image) as Data?
            }
        }
    }
    
    convenience init?(title: String, body: String?, image: UIImage?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext, !title.isEmpty else {
            return nil
        }
        
        self.init(entity: Note.entity(), insertInto: managedContext)
        self.title = title
        self.body = body
        self.addDate = Date(timeIntervalSinceNow: 0)
        
        if let image = image {
            self.rowImage = convertImageToNSData(image: image) as Data?
        }
    }

    
    
    func convertImageToNSData(image: UIImage) -> NSData? {
        return processImage(image: image).pngData() as NSData?
    }
    
    func processImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == .up) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)

        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy else {
            return image
        }
        
        return unwrappedCopy
    }
    
}
