//
//  PasteboardWatcher.swift
//  Clipboard-macOS
//
//  Created by Adam Leitgeb on 06/02/2019.
//  Copyright © 2019 Adam Leitgeb. All rights reserved.
//

import Cocoa

protocol PasteboardMonitorDelegate: class {
    func newPasteboardStringObtained(_ string: String)
}

class PasteboardMonitor: NSObject {

    // MARK: - Properties

    weak var delegate: PasteboardMonitorDelegate?
    private let pasteboard = NSPasteboard.general

    private var changeCount: Int
    private var timer: Timer?

    // MARK: - Initialization

    override init() {
        changeCount = pasteboard.changeCount
        super.init()
    }

    func startPolling () {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: checkPastboardChange)
    }

    func stopPolling() {
        timer?.invalidate()
    }

    // MARK: - Utilities

    private func checkPastboardChange(_ timer: Timer) {
        guard let pasteboardString = pasteboard.string(forType: .string), pasteboard.changeCount != changeCount else {
            return
        }
        delegate?.newPasteboardStringObtained(pasteboardString)

        changeCount = pasteboard.changeCount
    }
}
