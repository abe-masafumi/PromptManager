//
//  PromptStorageService.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

// Services/PromptStorageService.swift
import Foundation

class PromptStorageService {
    static let shared = PromptStorageService()
    private let fileURL: URL

    private init() {
        let documentDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = documentDirectory.appendingPathComponent("PromptManager")
        try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        fileURL = appDirectory.appendingPathComponent("prompts.json")
    }

    func loadPrompts() -> [PromptItem] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([PromptItem].self, from: data)) ?? []
    }

    func savePrompts(_ prompts: [PromptItem]) {
        let data = try? JSONEncoder().encode(prompts)
        try? data?.write(to: fileURL)
    }
}
