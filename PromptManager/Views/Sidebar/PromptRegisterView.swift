//
//  PromptRegisterView.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

// Views/Sidebar/PromptRegisterView.swift
import SwiftUI

struct PromptRegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PromptListViewModel

    @State private var name = ""
    @State private var tag = ""
    @State private var content = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("名前", text: $name)
            TextField("タグ", text: $tag)
            TextEditor(text: $content)
                .frame(height: 150)
            Button("保存") {
                guard !name.isEmpty, !tag.isEmpty, !content.isEmpty else { return }
                let newPrompt = PromptItem(name: name, tag: tag, content: content)
                viewModel.add(prompt: newPrompt)
                presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }
        .padding()
        .frame(width: 300)
    }
}
