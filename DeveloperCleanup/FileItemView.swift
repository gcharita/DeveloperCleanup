//
//  FileItemView.swift
//  DeveloperCleanup
//
//  Created by Giorgos Charitakis on 29/12/21.
//

import SwiftUI

struct FileItemView: View {
    @ObservedObject var directory: SizedDirectory
    let openAction: () -> Void
    let deleteAction: () -> Void
    let refreshAction: () -> Void
    
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
                switch directory.size {
                case .ready(.some):
                    Button("Open", action: openAction)
                    Button("Delete", action: deleteAction)
                    Button("Refresh", action: refreshAction)
                case .notCalculated:
                    Button("Open", action: openAction)
                    Button("Refresh", action: refreshAction)
                case .error:
                    Button("Refresh", action: refreshAction)
                default:
                    EmptyView()
                }
                switch directory.size {
                case .ready(let value):
                    Text(value ?? "Not exists")
                case .calculating:
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                case .notCalculated:
                    Text("Not calculated")
                default:
                    Text("Not exists")
                }
            }
            .padding()
        }
        .onHover { isHover = $0 }
    }
}

struct FileItemView_Previews: PreviewProvider {
    struct IdentifiablePreviewLayout: Identifiable {
        var id: String
        var previewLayout: PreviewLayout
    }
    
    static var previews: some View {
        let previewLayouts = [
            IdentifiablePreviewLayout(
                id: "400x50",
                previewLayout: .fixed(width: 400, height: 50)
            ),
//            IdentifiablePreviewLayout(
//                id: "200x40",
//                previewLayout: .fixed(width: 200, height: 40)
//            ),
//            IdentifiablePreviewLayout(
//                id: "150x30",
//                previewLayout: .fixed(width: 150, height: 30)
//            ),
        ]
        
        return ForEach(previewLayouts) { myLayout in
            FileItemView(
                directory: SizedDirectory(
                    name: "Test Name",
                    path: "",
                    size: .notCalculated
                ),
                openAction: {},
                deleteAction: {},
                refreshAction: {},
                isHover: true
            ).previewLayout(myLayout.previewLayout)
        }
    }
}
