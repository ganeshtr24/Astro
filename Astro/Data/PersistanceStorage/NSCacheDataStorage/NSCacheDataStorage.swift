//
//  NSCacheDataStorage.swift
//  Astro
//
//  Created by Ganesh TR on 26/03/23.
//

import Foundation

class NSCacheDataStorage {
    
    var nsCache = NSCache<NSString, NSData>()

    init() {}
    
    func fetch(for key: String) -> Data? {
        nsCache.object(forKey: key as NSString) as? Data
    }
    
    func save(key: String, data: Data) {
            nsCache.setObject(data as NSData, forKey: key as NSString)
    }
}
