//
//  AppDelegate.swift
//  Clipboard-macOS
//
//  Created by Adam Leitgeb on 05/02/2019.
//  Copyright © 2019 Adam Leitgeb. All rights reserved.
//

import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject {

    // MARK: - Properties

    private var eventMonitor: EventMonitor?
    private var pasteboardMonitor: PasteboardMonitor?

    private let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    private let popover = NSPopover()

    // MARK: - Actions

    @objc
    private func toggleMenuPopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            openPopover()
        }
    }
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let viewController = TextEditViewController.instantiateFromStoryboard()
        popover.contentViewController = viewController

        setupMenuBarButton()
        setupEventMonitor()
        setupPasteboardMonitor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // TODO: - Persist text
    }

    // MARK: - Setup

    private func setupMenuBarButton() {
        guard let button = statusItem.button else {
            return
        }
        button.image = NSImage(named: "StatusBarIconImage")
        button.action = #selector(toggleMenuPopover(_:))
    }

    private func setupEventMonitor() {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let `self` = self else {
                return
            }
            if self.popover.isShown {
                self.closePopover(event)
            }
        }
    }

    private func setupPasteboardMonitor() {
        guard let textEditViewController = popover.contentViewController as? TextEditViewController else {
            return
        }
        pasteboardMonitor = PasteboardMonitor()
        pasteboardMonitor?.delegate = textEditViewController
        pasteboardMonitor?.startPolling()
    }

    // MARK: - Utilities

    private func openPopover() {
        guard let button = statusItem.button else {
            return
        }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        eventMonitor?.start()
    }

    private func closePopover(_ sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}
