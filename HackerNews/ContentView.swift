//
//  ContentView.swift
//  HackerNews
//
//  Created by Nathaniel Fredericks on 2019-06-09.
//  Copyright © 2019 Nathaniel Fredericks. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @ObjectBinding var store = StoryStore()
    
    var body: some View {
        NavigationView {
            List {
                SegmentedControl(selection: $store.feedType) {
                    ForEach(FeedType.allCases.identified(by: \.self)) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                
                ForEach(store.stories) { story in
                    NavigationButton(destination: StoryWebView(story: story)) {
                        StoryRow(story: story)
                    }
                }
                }
                .navigationBarTitle(Text("Hacker News"))
                .navigationBarItems(trailing: Button(action: {
                    guard !self.store.isLoading else { return }
                    
                    self.store.stories.removeAll()
                    self.store.fetchStories(feed: self.$store.feedType.value)
                }) {
                    if store.isLoading {
                        ActivityIndicatorView(style: .medium)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                            .accessibility(label: Text("Reload"))
                    }
                    }
            )
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
