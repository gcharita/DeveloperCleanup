//
//  ContentView.swift
//  DeveloperCleanup
//
//  Created by Giorgos Charitakis on 26/12/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        List(viewModel.directories, id: \.name) { directory in
            VStack {
                FileItemView(directory: directory) {
                    viewModel.delete(directory: directory)
                }
            }
            .onTapGesture {
                guard case .ready(.some) = directory.size else { return }
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: directory.path)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel(directories: [
            .init(name: "Test 1", path: "", size: .calculating),
            .init(name: "Test 2", path: "", size: .ready(value: "20,2 GB")),
            .init(name: "Test 3", path: "", size: .error(NSError(domain: "Test domain", code: -2))),
        ]))
    }
}
