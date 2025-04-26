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
            Button(action: {
                showingRegister.toggle()
            }) {
                Label("新規プロンプトを追加", systemImage: "plus")
            }
            .padding()

            List {
                ForEach(viewModel.prompts) { prompt in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(prompt.name)
                            .font(.headline)
                        Text("#\(prompt.tag)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(prompt.content)
                            .font(.body)
                            .lineLimit(2)
                    }
                    .contentShape(Rectangle()) // 全体をタップ可能にする
                    .onTapGesture {
                        viewModel.copyToClipboard(prompt.content)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
            .listStyle(PlainListStyle())
        }
        .frame(minWidth: 300, maxHeight: .infinity)
        .sheet(isPresented: $showingRegister) {
            PromptRegisterView(viewModel: viewModel)
        }
    }
}



