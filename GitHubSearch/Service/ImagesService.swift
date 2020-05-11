//
//  ImagesService.swift
//  GitHubSearch
//
//  Created by Consultant on 5/10/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    var nsUrl: NSURL? {
        return NSURL(string: self.absoluteString)
    }
}

private class OngoingDownloadStore {

    // In-memory cache for images
    let cache: NSCache = NSCache<NSURL, UIImage>()
    // Dedicated Queue for thread-safety
    let queue: DispatchQueue = DispatchQueue(label: "OngoingDownloadStore", qos: .background, attributes: .concurrent)
    // Tracks all current download tasks
    var ongoingDownloads: [URL: URLSessionTask] = [:]
}

// All use the dedicated Queue for thread-safety
extension OngoingDownloadStore {

    // Returns image, if found in cache
    func get(for url: URL) -> UIImage? {
        queue.sync {
            guard let nsUrl = url.nsUrl else { return nil }
            return cache.object(forKey: nsUrl)
        }
    }
    // Returns Bool is this is a current download
    func isOngoing(_ url: URL) -> Bool {
        queue.sync {
            ongoingDownloads[url] != nil
        }
    }
    // Adds a download to keep track of
    func add(task: URLSessionTask, for url: URL) {
        queue.sync {
            ongoingDownloads[url]?.cancel()
            ongoingDownloads[url] = task
        }
    }
    // Adds an image for a URL
    // Also, remove any download for it, if it exists
    func add(image: UIImage?, for url: URL) {
        queue.sync {
            guard let nsUrl = url.nsUrl else { return }
            if let validImage = image {
                cache.setObject(validImage, forKey: nsUrl)
            }
            self.ongoingDownloads[url] = nil
        }
    }
    // Cancel a task
    func cancel(_ url: URL) {
        queue.sync {
            ongoingDownloads[url]?.cancel()
            ongoingDownloads[url] = nil
        }
    }
}

// Fetch and return UIImages, as needed
final class ImagesService {

    static let shared = ImagesService()
    // All work will be returned on main thread
    private let queue: DispatchQueue = .main
    // Manages its own downloads
    private let session: URLSession = URLSession(configuration: .default)
    // Cache of images downloaded, and ongoing downloads
    private let store = OngoingDownloadStore()
    private init() { }
}

extension ImagesService {

    // Convenience Polymorphic function
    func fetch(from string: String, _ completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: string) else { completion(nil); return }
        fetch(from: url, completion)
    }

    // Fetches an image from a URL
    // Stores/Retrieves from cache, if available
    func fetch(from url: URL, _ completion: @escaping (UIImage?) -> Void) {
        // helper closure, ensures completion is always done on main thread.
        let completion: (UIImage?) -> Void = { image in
            self.queue.async {
                completion(image)
            }
        }
        // Fetch from Store, if available & return
        if let image = store.get(for: url) {
            completion(image); return
        }

        // Send a empty completion
        // For reusable UI
        completion(nil)

        // If it's been requested before, cancel that request
        if store.isOngoing(url) {
            store.cancel(url)
        }

        // Create a request to download that image
        let task = session.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let image = UIImage(data: data)
            // add that to the Store
            self.store.add(image: image, for: url)
            // Pass it back to function callee
            completion(image)
        }

        // Track that download task
        store.add(task: task, for: url)
        task.resume()
    }

}
