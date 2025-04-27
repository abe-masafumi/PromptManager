//
//  AppDelegate.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//


import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var promptWindow: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        ShortcutManager.shared.registerShortcut {
            self.togglePromptWindow()
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "text.bubble", accessibilityDescription: "Prompt Manager")
        }

        // メニューを作成して設定
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "プロンプト一覧を表示", action: #selector(togglePromptWindow), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "アプリを終了", action: #selector(terminateApp), keyEquivalent: ""))
        statusItem.menu = menu

        setupPromptWindow()
    }

    @objc func togglePromptWindow() {
        if promptWindow.isVisible {
            promptWindow.orderOut(nil)
        } else {
            let viewModel = PromptListViewModel()
            promptWindow.contentView = NSHostingView(rootView: PromptListView(viewModel: viewModel))
            positionWindowAtRight()
            promptWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    @objc func terminateApp() {
        NSApp.terminate(nil)
    }

    private func setupPromptWindow() {
        let screenFrame = NSScreen.main?.frame ?? NSRect.zero
        let windowHeight: CGFloat = 200

        promptWindow = CustomWindow( // ✅ CustomWindow をそのまま使う
            contentRect: NSRect(x: 0, y: 0, width: screenFrame.width, height: windowHeight),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        promptWindow.isOpaque = false
        promptWindow.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.95)
        promptWindow.level = .statusBar
        promptWindow.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        promptWindow.orderOut(nil)
    }

    private func positionWindowAtRight() {
        if let screen = getScreenWithCursor() {
            let screenFrame = screen.frame
            
            let viewModel = PromptListViewModel()
            promptWindow.contentView = NSHostingView(rootView: PromptListView(viewModel: viewModel))
            
            promptWindow.setFrame(
                NSRect(
                    x: screenFrame.maxX - 350,
                    y: screenFrame.minY,
                    width: 350,
                    height: screenFrame.height
                ),
                display: true
            )

            // 🔥 ここを追加・上書き 🔥
            promptWindow.isOpaque = false
            promptWindow.backgroundColor = NSColor(calibratedWhite: 0.0, alpha: 0.4)
            promptWindow.hasShadow = false
        }
    }



    private func getScreenWithCursor() -> NSScreen? {
        let mouseLocation = NSEvent.mouseLocation
        
        for screen in NSScreen.screens {
            if screen.frame.contains(mouseLocation) {
                return screen
            }
        }
        
        return NSScreen.main
    }
}
