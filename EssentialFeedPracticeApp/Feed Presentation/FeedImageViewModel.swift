//
//  FeedImageViewModel.swift
//  EssentialFeedPracticeAppiOS
//
//  Created by Eric Mentele on 3/20/24.
//

import Foundation
import EssentialFeedPracticeApp

public final class FeedImageViewModel<Image> {
    typealias Observer<T> = (T) -> Void
    
    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    private let imageTransformer: (Data) -> Image?
    
    var description: String? {
        return model.description
    }
    
    var location: String?  {
        return model.location
    }
    
    var hasLocation: Bool {
        return location != nil
    }
    
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private var task: FeedImageDataLoaderTask?

    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    public func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    public func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
}
