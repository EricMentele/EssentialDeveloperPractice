//
//  FeedImageViewModel.swift
//  EssentialFeedPracticeAppiOS
//
//  Created by Eric Mentele on 3/20/24.
//

import Foundation
import EssentialFeedPracticeApp

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
