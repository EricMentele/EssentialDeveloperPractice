//
//  FeedListView.swift
//  Prototype
//
//  Created by Eric Mentele on 3/12/24.
//

import SwiftUI

public struct FeedListView: View {
    @State private var feed: [FeedImageViewModel]
    
    public init(feed: [FeedImageViewModel] = []) {
        self.feed = feed
    }
    
    public var body: some View {
        Divider()
        if feed.isEmpty {
            ProgressView()
        }
        
        List {
            Section(header: Spacer(), footer: Spacer()) {
                ForEach(feed, id: \.imageName) { feedItem in
                    FeedImageCell(feedImage: feedItem)
                }
                .listRowSeparator(.hidden)
            }
            .listSectionSeparator(.hidden)
        }
        .listRowSpacing(8.0)
        .navigationTitle("My Feed")
        .listStyle(.grouped)
        .padding(.init(top: 0, leading: -8, bottom: 0, trailing: -8))
        .onAppear {
            refresh()
        }
        .refreshable {
            feed = []
            refresh()
        }
    }
}

extension FeedListView {
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.feed.isEmpty {
                self.feed = FeedImageViewModel.prototypeFeed
            }
        }
    }
}


#Preview {
    FeedListView()
}
