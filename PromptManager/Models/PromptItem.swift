//
//  PromptItem.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

// Models/PromptItem.swift
import Foundation

struct PromptItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var tag: String
    var content: String

    init(name: String, tag: String, content: String) {
        self.id = UUID()
        self.name = name
        self.tag = tag
        self.content = content
    }
}
