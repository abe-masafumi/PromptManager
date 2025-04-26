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

    var filteredPrompts: [PromptItem] {
        var results = prompts
        if let tag = selectedTag {
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
