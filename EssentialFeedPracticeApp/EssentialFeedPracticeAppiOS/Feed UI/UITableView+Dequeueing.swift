//
//  UITableView+Dequeueing.swift
//  EssentialFeedPracticeAppiOS
//
//  Created by Eric Mentele on 3/23/24.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
