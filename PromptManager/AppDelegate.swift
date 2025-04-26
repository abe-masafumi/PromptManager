//
//  AppDelegate.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

// AppDelegate.swift
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory) // Dock非表示
    }
}
