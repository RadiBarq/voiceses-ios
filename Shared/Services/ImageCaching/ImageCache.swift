//
//  ImageCacheType.swift
//  Voiceses
//
//  Created by Radi Barq on 31/05/2021.
//
import UIKit

protocol ImageCacheType: class {
    func image(for id: String) -> UIImage?
    
    func insert(_ image: UIImage?, for id: String)
    
    func removeImage(for id: String)
    
    func removeAll()
    
    subscript(_ id: String) -> UIImage? { get set }
}

final class ImageCache {
    private lazy var imagesCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    private let lock = NSLock()
    private let config: Config
    
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageCache: ImageCacheType {
    func image(for id: String) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        return imagesCache.object(forKey: id as NSString)
    }
    
    func insert(_ image: UIImage?, for id: String) {
        guard let image = image else { return removeImage(for: id) }
        lock.lock(); defer { lock.unlock() }
        imagesCache.setObject(image, forKey: id as NSString)
    }
    
    func removeImage(for id: String) {
        lock.lock(); defer { lock.unlock() }
        imagesCache.removeObject(forKey: id as NSString)
    }
    
    subscript(id: String) -> UIImage? {
        get {
            return image(for: id)
        }
        set {
            return insert(newValue, for: id)
        }
    }
    func removeAll() {
        imagesCache.removeAllObjects()
    }
}
