//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeedPracticeAppiOSTests
//
//  Created by Eric Mentele on 3/18/24.
//

import UIKit
import EssentialFeedPracticeAppiOS

extension FeedImageCell {
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }
    
    var locationText: String? {
        return locationLabel.text
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        feedImageContainer.isShimmering
    }
    
    var renderedImage: Data? {
        feedImageView.image?.pngData()
    }
    
    var isShowingRetryAction: Bool {
        !retryButton.isHidden
    }
    
    func simulateRetryAction() {
        retryButton.simulateTap()
    }
}

