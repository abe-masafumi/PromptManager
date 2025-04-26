//
//  PromptListViewModel.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

// ViewModels/PromptListViewModel.swift
import Foundation
import AppKit


class PromptListViewModel: ObservableObject {
    @Published var prompts: [PromptItem] = []

    init() {
        load()
    }

    func load() {
        prompts = PromptStorageService.shared.loadPrompts()
    }

    func add(prompt: PromptItem) {
        prompts.append(prompt)
        PromptStorageService.shared.savePrompts(prompts)
    }

    func delete(at offsets: IndexSet) {
        prompts.remove(atOffsets: offsets)
        PromptStorageService.shared.savePrompts(prompts)
    }

    func copyToClipboard(_ content: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
    }
}
