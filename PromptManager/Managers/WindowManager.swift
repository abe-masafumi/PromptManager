//
//  WindowManager.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

import SwiftUI

class WindowManager: ObservableObject {
    private var promptWindow: NSWindow?

    func openPromptWindow() {
        if promptWindow == nil {
            let hostingController = NSHostingController(rootView: PromptListView())
            promptWindow = NSWindow(contentViewController: hostingController)
            promptWindow?.setContentSize(NSSize(width: 400, height: 600))
            promptWindow?.styleMask = [.titled, .closable, .miniaturizable]
            promptWindow?.isReleasedWhenClosed = false
            promptWindow?.title = "Prompt Manager"
        }
        promptWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
