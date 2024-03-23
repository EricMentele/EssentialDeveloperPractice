//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeedPracticeAppiOSTests
//
//  Created by Eric Mentele on 3/18/24.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
