//
//  ContentView.swift
//  Prototype
//
//  Created by Eric Mentele on 3/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MyFeedList()
        }
    }
}

struct MyFeedList: View {
    let feed = FeedImageViewModel.prototypeFeed
    
    var body: some View {
        List {
            Section(header: Spacer(), footer: Spacer()) {
                ForEach(feed, id: \.imageName) { feedItem in
                    FeedCell(feedImage: feedItem)
                            }
                            .listRowSeparator(.hidden)
            }
            .listSectionSeparator(.hidden)
        }
        .listRowSpacing(8.0)
        .navigationTitle("My Feed")
        .listStyle(.grouped)
    }
}

struct FeedCell: View {
    let feedImage: FeedImageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let location = feedImage.location {
                HStack() {
                    Image(systemName: "pin")
                    Text(location)
                }
            }
            
            Image(feedImage.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .backgroundStyle(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 7))
            if let description = feedImage.description {
                Text(description)
                    .lineLimit(6)
            }
        }.padding()
    }
}

#Preview {
    ContentView()
}
