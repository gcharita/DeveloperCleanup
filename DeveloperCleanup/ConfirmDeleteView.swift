//
//  ConfirmDeleteView.swift
//  DeveloperCleanup
//
//  Created by Giorgos Charitakis on 31/1/23.
//

import SwiftUI

struct ConfirmDeleteView: View {
    var directory: SizedDirectory
    let cancelAction: () -> Void
    let confirmAction: (_ directory: SizedDirectory) -> Void
    
    var body: some View {
        VStack {
            Text("Delete directory at location: \(directory.path). \n\nAre you sure?")
                .multilineTextAlignment(.center)
            HStack {
                Button(
                    action: {
                        cancelAction()
                    },
                    label: {
                        Text("Cancel").frame(width: 80)
                    }
                )
                .controlSize(.large)
                .padding(.trailing, 5)
                Button(
                    action: {
                        confirmAction(directory)
                    },
                    label: {
                        Text("Yes").frame(width: 80)
                    }
                )
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .padding(.leading, 5)
            }
        }.padding()
    }
}

struct ConfirmDeleteView_Previews: PreviewProvider {
    struct IdentifiablePreviewLayout: Identifiable {
        var id: String
        var previewLayout: PreviewLayout
    }
    
    static var previews: some View {
        ConfirmDeleteView(
            directory: SizedDirectory(
                name: "Test Name",
                path: "/some/path",
                size: .notCalculated
            ),
            cancelAction: {},
            confirmAction: { _ in }
        )
    }
}
