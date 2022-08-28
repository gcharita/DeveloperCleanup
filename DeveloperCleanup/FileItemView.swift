//
//  FileItemView.swift
//  DeveloperCleanup
//
//  Created by Giorgos Charitakis on 29/12/21.
//

import SwiftUI

struct FileItemView: View {
    let directory: SizedDirectory
    let deleteAction: () -> Void
    
    @State var isHover = false
    
    private let normalColor = Color(.sRGB, red: 82/255, green: 82/255, blue: 93/255, opacity: 1)
    private let hoverColor = Color(.sRGB, red: 92/255, green: 125/255, blue: 138/255, opacity: 1)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(isHover ? hoverColor : normalColor)
            HStack {
                Text(directory.name)
                    .frame(maxWidth: .infinity, minHeight: 21, alignment: .leading)
                if isHover, directory.size != nil {
                    Button("Delete") {
                        deleteAction()
                    }
                }
                Text(directory.size ?? "Not exists")
            }
            .padding()
        }
        .onHover { isHover = $0 }
    }
}
