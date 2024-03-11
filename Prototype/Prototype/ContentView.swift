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
    var body: some View {
        List {
            Section(header: Spacer(), footer: Spacer()) {
                ForEach((0...10), id: \.self) {_ in
                                FeedCell()
                            }
                            .listRowSeparator(.hidden)
            }
            .listSectionSeparator(.hidden)
        }
        .listRowSpacing(8.0)
        .navigationTitle("My Feed")
    }
}

struct FeedCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Image(systemName: "pin")
                Text("Peru, Cuzco")
            }
            Image(systemName: "globe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .backgroundStyle(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 0.5))
            Text("This is wrapping to 6 lines This is wrapping to 6 lines This is wrapping to 6 lines This is wrapping to 6 lines This is wrapping to 6 lines This is wrapping to 6 lines This is wrapping to 6 lines This is wrapping to 6 linesThis is wrapping to 6 lines")
                .lineLimit(6)
        }.padding()
    }
}

#Preview {
    ContentView()
}
