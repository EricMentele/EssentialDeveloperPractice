//
//  FeedRefreshController+TestHelpers.swift
//  EssentialFeedPracticeAppiOS
//
//  Created by Eric Mentele on 3/19/24.
//

import EssentialFeedPracticeAppiOS
import Foundation

extension FeedRefreshViewController {
    func fakeRefreshControlForiOS17Support() {
        let fake = FakeRefreshControl()
        view.allTargets.forEach { target in
            view.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                fake.addTarget(target, action: Selector($0), for: .valueChanged)
            }
        }
        view = binded(fake)
    }
}
