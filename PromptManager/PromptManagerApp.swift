//
//  PromptManagerApp.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

// PromptManagerApp.swift
import SwiftUI

@main
struct PromptManagerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var windowManager = WindowManager()

    var body: some Scene {
        MenuBarExtra("PromptManager", systemImage: "text.bubble") {
            Button("プロンプト一覧を開く") {
                windowManager.openPromptWindow()
            }
            Divider()
            Button("終了") {
                NSApp.terminate(nil)
            }
        }
    }
}
