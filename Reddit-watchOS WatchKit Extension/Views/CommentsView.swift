//
//  CommentsView.swift
//  Reddit
//
//  Created by Carson Katri on 7/29/19.
//  Copyright © 2019 Carson Katri. All rights reserved.
//

import SwiftUI
import Request

struct CommentsView: View {
    let post: Post
    
    var noComments: some View {
        Text("😞 No comments...")
            .frame(height: nil)
    }
    
    var body: some View {
        // Load the comments
        RequestView([CommentListing].self, Request {
            Url("https://www.reddit.com/r/\(post.subreddit)/\(post.id).json")
            Header.Accept(.json)
        }) { listings in
            if listings != nil {
                // `dropFirst` because `first` is the actual post
                if listings!.dropFirst().map({ $0.data.children }).flatMap({ $0.map { $0.data } }).count > 0 {
                    ForEach(listings!.dropFirst().map({ $0.data.children }).flatMap { $0.map { $0.data } }, id: \.id) { comment in
                        VStack(alignment: .leading) {
                            Text(comment.author)
                                .foregroundColor(.gray)
                                .font(.system(size: 10))
                            Text(comment.body ?? "")
                        }
                    }
                } else {
                    self.noComments
                }
            } else {
                self.noComments
            }
            SpinnerView()
        }
    }
}
