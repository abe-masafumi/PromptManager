//
//  MenuBarExtraView.swift
//  PromptManager
//
//  Created by masafumi.abe on 2025/04/26.
//

// Views/DefaultUI/MenuBarExtraView.swift
import SwiftUI

struct MenuBarExtraView: View {
    @StateObject private var viewModel = PromptListViewModel() // ViewModelをここで管理
    
    var body: some View {
        PromptListView(viewModel: viewModel) // viewModelを渡す
    }
}
