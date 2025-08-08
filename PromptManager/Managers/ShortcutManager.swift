//
//  ShortcutManager.swift.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

import Carbon
import Cocoa

class ShortcutManager {
    static let shared = ShortcutManager()
    
    private var eventTap: CFMachPort?
    private static var globalAction: (() -> Void)? // ✅ グローバル変数でアクションを保持

    func registerShortcut(action: @escaping () -> Void) {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        if osVersion.majorVersion == 15 && osVersion.minorVersion == 4 {
            print("⚠️ macOS 15.4の既知の問題: グローバルショートカットが正常に動作しない場合があります。")
            print("📋 Apple公式情報: macOS 15.5で修正済み (https://developer.apple.com/forums/thread/780929)")
            print("💡 解決方法: macOS 15.5以降にアップデートしてください。")
        }
        
        if !AXIsProcessTrusted() {
            print("⚠️ アクセシビリティ権限が必要です。システム環境設定 > セキュリティとプライバシー > プライバシー > アクセシビリティでPromptManagerを許可してください。")
            
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
            AXIsProcessTrustedWithOptions(options as CFDictionary)
            return
        }

        let eventMask = (1 << CGEventType.keyDown.rawValue)

        // ✅ アクションをグローバル変数に保存（C関数ポインタの制約を回避）
        ShortcutManager.globalAction = action

        eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: ShortcutManager.handleEvent, // ✅ 切り出した static 関数を渡す
            userInfo: nil
        )

        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
    }

    // ✅ C関数ポインタとして使用可能な static 関数
    private static let handleEvent: CGEventTapCallBack = { _, type, event, _ in
        if type == .keyDown {
            let key = UInt16(event.getIntegerValueField(.keyboardEventKeycode))
            let flags = event.flags

            if key == UInt16(kVK_ANSI_Semicolon) && flags.contains(.maskControl) {
                globalAction?() // ✅ グローバル変数に保存したアクションを実行
                return nil
            }
        }
        return Unmanaged.passRetained(event)
    }

    func unregisterShortcut() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
        }
    }
}
