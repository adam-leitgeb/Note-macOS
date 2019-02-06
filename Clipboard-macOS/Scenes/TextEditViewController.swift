//
//  TextEditViewController.swift
//  Clipboard-macOS
//
//  Created by Adam Leitgeb on 05/02/2019.
//  Copyright © 2019 Adam Leitgeb. All rights reserved.
//

import Cocoa

class TextEditViewController: NSViewController {

    // MARK: - Outlets

    @IBOutlet private weak var clipboardButton: NSButton!
    @IBOutlet private weak var scrollableContentTextView: NSScrollView!

    // MARK: - Properties

    private lazy var contentTextView: NSTextView = {
        return scrollableContentTextView.documentView as! NSTextView
    }()

    private var clipboard: String {
        return NSPasteboard.general.string(forType: .string) ?? ""
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupClipboardButton()
        setupTextViews()
    }

    // MARK: - Setup

    private func setupClipboardButton() {
        clipboardButton.title = clipboard.isEmpty ? "Clipboard is Empty" : "Show Clipboard"
        clipboardButton.isEnabled = !clipboard.isEmpty
    }

    private func setupTextViews() {
        contentTextView.font = NSFont.systemFont(ofSize: 14)
    }

    // MARK: - Actions
    
    @IBAction private func clipboardButtonTapped(_ sender: NSButton) {
        if !clipboard.isEmpty {
            contentTextView.string = clipboard
        }
    }
}

extension TextEditViewController: PasteboardMonitorDelegate {
    func newPasteboardStringObtained(_ string: String) {
        setupClipboardButton()
    }
}
