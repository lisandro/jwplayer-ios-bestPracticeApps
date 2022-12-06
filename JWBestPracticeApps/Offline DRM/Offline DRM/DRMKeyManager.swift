//
//  DRMKeyManager.swift
//  Offline DRM
//
//  Created by David Perez on 02/12/22.
//

import JWPlayerKit
/**
 This class will handle keys stored in your device.
 This will gets notified when the `JWDRMContentLoader` requests to write, delete, check if keys exist, get the URL for the keys in memory, and report errors while handling these keys.
 */
class DRMKeyManager: JWDRMContentKeyManager {
    
    let keyDirectory: URL
    
    init() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
        guard let contentKeyDirectory =  documentDirectory?.appendingPathComponent(".key/", isDirectory: true) else {
            fatalError("This device does not have a valid document directory")
        }
        
        if !FileManager.default.fileExists(atPath: contentKeyDirectory.path, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(at: contentKeyDirectory,
                                                        withIntermediateDirectories: false,
                                                        attributes: nil)
            } catch {
                fatalError("Unable to create directory for content keys at path: \(contentKeyDirectory.path)")
            }
        }
        keyDirectory = contentKeyDirectory
    }
    
    func contentLoader(_ contentLoader: JWPlayerKit.JWDRMContentLoader, writePersistableContentKey contentKey: Data, contentKeyIdentifier: String) {
        do {
           try contentKey.write(to: keyDirectory.appendingPathExtension(contentKeyIdentifier))
        } catch {
            print("Error writing keys to directory:", error.localizedDescription)
        }
    }
    
    func contentLoader(_ contentLoader: JWPlayerKit.JWDRMContentLoader, didWritePersistableContentKey contentKeyIdentifier: String) {
        // We can updated on client side if we were waiting for the keys to be saved on memory.
    }
    
    func contentLoader(_ contentLoader: JWPlayerKit.JWDRMContentLoader, deletePersistableContentKey contentKeyIdentifier: String) {
        do {
            try FileManager.default.removeItem(at: keyDirectory.appendingPathExtension(contentKeyIdentifier))

        } catch {
            print("Error deleting keys from directory:", error.localizedDescription)
        }
    }
    
    func contentLoader(_ contentLoader: JWPlayerKit.JWDRMContentLoader, contentKeyTypeFor contentKeyIdentifier: String) -> JWPlayerKit.JWContentKeyType {
        // We return the type of content, if this is intended to be non persistable then return .nonPersistable to use online DRM.
        return .persistable
    }
    
    func contentLoader(_ contentLoader: JWPlayerKit.JWDRMContentLoader, contentKeyExistsOnDisk contentKeyIdentifier: String) -> Bool {
        // We check the device for the keys at the especified path.
        return FileManager.default.fileExists(atPath: keyDirectory.appendingPathExtension(contentKeyIdentifier).relativePath)
    }
    
    func contentLoader(_ contentLoader: JWPlayerKit.JWDRMContentLoader, urlForPersistableContentKey contentKeyIdentifier: String) -> URL {
        // We return the url for the keys. This gets called after we have checked that they are on system.
        return keyDirectory.appendingPathExtension(contentKeyIdentifier)
    }
    
    func contentLoader(_ contentLoader: JWPlayerKit.JWDRMContentLoader, failedWithError error: JWPlayerKit.JWError) {
        print("Encountered an error from the JWDRMContentLoader: ", error.localizedDescription)
    }
}
