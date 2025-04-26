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
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
