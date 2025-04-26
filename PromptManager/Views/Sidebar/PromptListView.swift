//
//  PromptListView.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

// Views/Sidebar/PromptListView.swift
import SwiftUI

struct PromptListView: View {
    @StateObject private var viewModel = PromptListViewModel()
    @State private var showingRegister = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("＋ 新規プロンプトを追加") {
                    showingRegister.toggle()
                }
                Spacer()
            }
            .padding([.top, .horizontal])

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button("すべて") {
                        viewModel.selectTag(nil)
                    }
                    .padding(.horizontal, 6)
                    .background(viewModel.selectedTag == nil ? Color.accentColor.opacity(0.2) : Color.clear)
                    .cornerRadius(8)

                    ForEach(viewModel.allTags, id: \.self) { tag in
                        Button(tag) {
                            viewModel.selectTag(tag)
                        }
                        .padding(.horizontal, 6)
                        .background(viewModel.selectedTag == tag ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
            
            TextField("検索", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            List {
                ForEach(viewModel.filteredPrompts, id: \.id) { prompt in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(prompt.name)
                                    .font(.headline)
                                Text("#\(prompt.tag)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(prompt.content)
                                    .lineLimit(2)
                                    .font(.body)
                            }
                            Spacer()
                            Button(action: {
                                if let index = viewModel.prompts.firstIndex(where: { $0.id == prompt.id }) {
                                    viewModel.delete(at: IndexSet(integer: index))
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.copyToClipboard(prompt.content)
                    }
                }
            }
        }
        .frame(minWidth: 300, maxHeight: .infinity)
        .sheet(isPresented: $showingRegister) {
            PromptRegisterView(viewModel: viewModel)
        }
    }
}

