//
//  ContentView.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        TabView {
            Tab(Constants.home, systemImage: Constants.homeIconString) {
                HomeView()
            }
            Tab(Constants.search, systemImage: Constants.searchIconString) {
                
            }
            Tab(Constants.download, systemImage: Constants.downloadIconString) {
                
            }
            Tab(Constants.myStuff, systemImage: Constants.myStuffIconString) {
                
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

fileprivate struct NavigationViewWrapper<Content: View>: View {
    let content: () -> Content

    var body: some View {
#if os(macOS)
        NavigationSplitView {
            content()
        } detail: {
            Text("Select an item")
        }
#else
        content()
#endif
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
