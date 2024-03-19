//
//  UIButton+TestHepers.swift
//  EssentialFeedPracticeAppiOSTests
//
//  Created by Eric Mentele on 3/18/24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
