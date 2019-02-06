//
//  NSViewController+Storyboard.swift
//  Clipboard-macOS
//
//  Created by Adam Leitgeb on 05/02/2019.
//  Copyright © 2019 Adam Leitgeb. All rights reserved.
//

import Cocoa

extension NSViewController {
    static func instantiateFromStoryboard() -> NSViewController {
        guard let viewController = storyboard.instantiateController(withIdentifier: storyboardIdentifier) as? NSViewController else {
            fatalError("Unable to instantiate view controller from Storyboard.")
        }
        return viewController
    }

    // MARK: - Utilities

    private static var storyboard: NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }

    private static var storyboardIdentifier: String {
        return NSStoryboard.SceneIdentifier(describing: self)
    }
}
