//
//  PromptListView.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

import SwiftUI

struct PromptListView: View {
    @StateObject var viewModel: PromptListViewModel
    @State private var showingRegister = false
    @State private var editingPrompt: PromptItem? = nil

    var body: some View {
        VStack(alignment: .leading) {

            NewPromptCreateCardView(title: "＋ 新規プロンプトを追加")
                .padding(.bottom, 5)
                .onTapGesture {
                    editingPrompt = nil
                    showingRegister = true
                }

            Text("prompt : [\(viewModel.prompts.count)件]")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    TagButton(title: "すべて", isSelected: viewModel.selectedTag == nil) {
                        viewModel.selectTag(nil)
                    }
                    ForEach(viewModel.allTags, id: \.self) { tag in
                        TagButton(title: tag, isSelected: viewModel.selectedTag == tag) {
                            viewModel.selectTag(tag)
                        }
                    }
                }
                .padding(.horizontal)
            }

            TextField("検索", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredPrompts) { prompt in
                        PromptCardView(
                            prompt: prompt,
                            onEdit: {
                                editingPrompt = prompt
                                showingRegister = true
                            }
                        )
                        .onTapGesture {
                            viewModel.copyToClipboard(prompt.content)
                        }
                    }
                }
            }

        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showingRegister) {
            PromptRegisterView(viewModel: viewModel, editingPrompt: editingPrompt)
        }
    }
}

struct NewPromptCreateCardView: View {
    var title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(white: 0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
        }
    }
}

struct TagButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue.opacity(0.6) : Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// PromptCardView修正
struct PromptCardView: View {
    var prompt: PromptItem
    var onEdit: () -> Void

    @State private var expanded: Bool = false
    @State private var isCopied: Bool = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if !prompt.tag.isEmpty {
                        Text("#\(prompt.tag)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button("編集", action: onEdit)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .buttonStyle(PlainButtonStyle())
                }
                Text(prompt.name)
                    .font(.headline)
                    .bold()
                Text(prompt.content)
                    .font(.body)
                    .lineLimit(expanded ? nil : 3)
                    .foregroundColor(.primary)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                if prompt.content.count > 100 {
                    Button(expanded ? "折りたたむ" : "続きを読む") {
                        withAnimation {
                            expanded.toggle()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(white: 0.2))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .onTapGesture {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(prompt.content, forType: .string)
                withAnimation {
                    isCopied = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isCopied = false
                    }
                }
            }

            if isCopied {
                Text("Copied!")
                    .font(.caption)
                    .padding(6)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding([.top, .trailing], 10)
                    .transition(.scale)
            }
        }
    }
}


#Preview {
    PromptListView(viewModel: PromptListViewModel())
}
