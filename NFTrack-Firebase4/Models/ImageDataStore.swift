//
//  ImageDataStore.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-05-23.
//

import Foundation
import UIKit.UIImage

class ImageDataStore<T> {
    fileprivate var posts: [T]!
    public var numberOfImage: Int {
        return posts.count
    }
    
    public func loadImage(at index: Int) -> DataLoadOperation? {
        if (0..<posts.count).contains(index) {
            return dataLoadBuffer(posts[index])
        }
        return .none
    }
    
    fileprivate func dataLoadBuffer(_ post: T) -> DataLoadOperation? {
        return nil
    }
    
    init(posts: [T]) {
        self.posts = posts
    }
}

/// DataLeadOperation needs to take in a certain parameter, but the input data takes many different forms
class PostImageDataStore: ImageDataStore<Post> {
    final override func dataLoadBuffer(_ post: Post) -> DataLoadOperation? {
        if let images = post.images, images.count > 0, let i = images.first {
            return DataLoadOperation(i)
        } else {
            return .none
        }
    }
}

class ChatImageDataStore: ImageDataStore<ChatListModel> {
    final var userId: String!
    final override func dataLoadBuffer(_ post: ChatListModel) -> DataLoadOperation? {
        if post.sellerUserId != userId {
            return DataLoadOperation(post.sellerPhotoURL)
        } else {
            return DataLoadOperation(post.buyerPhotoURL)
        }
    }
    
    init(posts:[ChatListModel], userId: String) {
        super.init(posts: posts)
        self.userId = userId
    }
}

class MessageImageDataStore: ImageDataStore<Message> {
    override func dataLoadBuffer(_ post: Message) -> DataLoadOperation? {
        if let imageURL = post.imageURL {
            return DataLoadOperation(imageURL)
        } else {
            return nil
        }
    }
}

class ReviewImageDataStore: ImageDataStore<Review> {
    final override func dataLoadBuffer(_ post: Review) -> DataLoadOperation? {
        if post.reviewerPhotoURL != "NA" {
            return DataLoadOperation(post.reviewerPhotoURL)
        } else {
            return .none
        }
    }
}

class DataLoadOperation: Operation {
    final var image: UIImage?
    final var loadingCompleteHandler: ((UIImage?) -> ())?
    private var _imageString: String
    
    init(_ imageString: String) {
        _imageString = imageString
    }
    
    override func main() {
        if isCancelled { return }
        guard let url = URL(string: _imageString) else {
            return
        }
        
        downloadImageFrom(url) { (image) in
            DispatchQueue.main.async() { [weak self] in
                guard let `self` = self else { return }
                if self.isCancelled { return }
                self.image = image
                print("download image", image)
                self.loadingCompleteHandler?(self.image)
            }
        }
    }
}

func downloadImageFrom(_ url: URL, completeHandler: @escaping (UIImage?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let _image = UIImage(data: data)
        else { return }
        completeHandler(_image)
    }.resume()
}
