//
//  SharedTestHelpers.swift
//  EssentialFeedPracticeAppTests
//
//  Created by Eric Mentele on 2/29/24.
//

import Foundation
import EssentialFeedPracticeApp

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
