//
//  FileManager.swift
//  PalmTree
//
//  Created by SprintSols on 4/2/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    func saveFileToDocumentDirectory(fileUrl: URL, name: String, extention:String) -> URL? {
        let videoData = NSData(contentsOf: fileUrl as URL)
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        let filePath = path.appendingPathComponent(name + extention)
        do {
            try videoData?.write(to: filePath)
            return filePath
        }
            
        catch {
            print(error)
            return nil
        }
    }
    
    func saveFileToDocumentsDirectory(image: UIImage, name: String, extention: String) -> URL? {
        
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        let imagePath = path.appendingPathComponent(name + extention)
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        do {
            try jpgImageData!.write(to: imagePath)
            
            return imagePath
        } catch {
            print(error)
            
            return nil
        }
    }
    
    func removeFileFromDocumentsDirectory(fileUrl: URL) -> Bool {
        do {
            try self.removeItem(at: fileUrl)
            
            return true
        } catch {
            return false
        }
    }
}
