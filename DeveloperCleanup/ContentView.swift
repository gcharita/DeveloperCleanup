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
                guard directory.size != nil else { return }
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: directory.path)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
