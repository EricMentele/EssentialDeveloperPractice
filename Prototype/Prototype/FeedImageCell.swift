//
//  FeedImageCell.swift
//  Prototype
//
//  Created by Eric Mentele on 3/12/24.
//

import SwiftUI

public struct FeedImageCell: View {
    private let feedImage: FeedImageViewModel
    
    public init(feedImage: FeedImageViewModel = FeedImageViewModel.prototypeFeed.first!) {
        self.feedImage = feedImage
    }
    
    @State private var opacity = 0.0
    
    public var body: some View {
        VStack(alignment: .leading) {
            if let location = feedImage.location {
                HStack() {
                    Image(systemName: "mappin.and.ellipse")
                    Text(location)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            
            Image(feedImage.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .backgroundStyle(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .opacity(opacity)
                .onAppear() {
                    withAnimation(.linear(duration: 1)) {
                        opacity = 1
                    }
                }
                .onDisappear() {
                    opacity = 0
                }
            if let description = feedImage.description {
                Text(description)
                    .lineLimit(6)
            }
        }.padding()
    }
}

#Preview {
    FeedImageCell(feedImage: FeedImageViewModel.prototypeFeed.first!)
}
