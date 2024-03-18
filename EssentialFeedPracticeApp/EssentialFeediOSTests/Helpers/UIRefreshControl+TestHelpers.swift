//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeedPracticeAppiOSTests
//
//  Created by Eric Mentele on 3/18/24.
//

import UIKit

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
