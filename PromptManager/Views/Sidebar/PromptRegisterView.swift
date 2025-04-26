//
//  PromptRegisterView.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

import SwiftUI

struct PromptRegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PromptListViewModel

    var editingPrompt: PromptItem? = nil

    @State private var name = ""
    @State private var tag = ""
    @State private var content = ""

    init(viewModel: PromptListViewModel, editingPrompt: PromptItem? = nil) {
        self.viewModel = viewModel
        self.editingPrompt = editingPrompt

        _name = State(initialValue: editingPrompt?.name ?? "")
        _tag = State(initialValue: editingPrompt?.tag ?? "")
        _content = State(initialValue: editingPrompt?.content ?? "")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(editingPrompt == nil ? "新しいプロンプトを追加" : "プロンプトを編集")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                if editingPrompt != nil {
                    Button(action: {
                        if let editingPrompt = editingPrompt,
                           let index = viewModel.prompts.firstIndex(where: { $0.id == editingPrompt.id }) {
                            viewModel.delete(at: IndexSet(integer: index))
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.bottom, 10)

            Group {
                TextField("名前", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("タグ", text: $tag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextEditor(text: $content)
                    .frame(height: 400)
                    .padding(8)
                    .background(Color(white: 0.1))
                    .cornerRadius(8)
            }

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("キャンセル")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding()
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(8)

                Button(action: {
                    guard !name.isEmpty, !tag.isEmpty, !content.isEmpty else { return }
                    if let editingPrompt = editingPrompt,
                       let index = viewModel.prompts.firstIndex(where: { $0.id == editingPrompt.id }) {
                        viewModel.prompts[index].name = name
                        viewModel.prompts[index].tag = tag
                        viewModel.prompts[index].content = content
                    } else {
                        let newPrompt = PromptItem(name: name, tag: tag, content: content)
                        viewModel.add(prompt: newPrompt)
                    }
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.2))
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .padding()
        .frame(width: 400)
    }
}
