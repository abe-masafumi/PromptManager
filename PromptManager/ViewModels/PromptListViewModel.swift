//
//  PromptListViewModel.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

import Foundation
import AppKit

class PromptListViewModel: ObservableObject {
    @Published var prompts: [PromptItem] = []
    @Published var selectedTag: String? = nil
    @Published var searchText: String = ""

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

    func movePrompt(from: PromptItem, to: PromptItem) {
        guard let fromIndex = prompts.firstIndex(where: { $0.id == from.id }),
              let toIndex = prompts.firstIndex(where: { $0.id == to.id }),
              fromIndex != toIndex else { return }
        
        let item = prompts.remove(at: fromIndex)
        prompts.insert(item, at: toIndex)
        
        PromptStorageService.shared.savePrompts(prompts)
    }

    func save() {
        PromptStorageService.shared.savePrompts(prompts)
    }

    var filteredPrompts: [PromptItem] {
        var results = prompts
        if let tag = selectedTag, !tag.isEmpty {
            results = results.filter { $0.tag == tag }
        }
        if !searchText.isEmpty {
            results = results.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.tag.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        return results
    }

    var allTags: [String] {
        Array(Set(prompts.map { $0.tag })).sorted()
    }

    func selectTag(_ tag: String?) {
        selectedTag = tag
    }
}

