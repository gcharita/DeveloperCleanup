//
//  ContentViewModel.swift
//  DeveloperCleanup
//
//  Created by Giorgos Charitakis on 29/12/21.
//

import Foundation

struct Directory: Codable {
    let name: String
    let path: String
}

struct SizedDirectory {
    let name: String
    let path: String
    var size: String?
    
    init(directory: Directory) {
        name = directory.name
        path = directory.path.replacingOccurrences(of: "~", with: FileManager.default.homeDirectoryForCurrentUser.path)
        size = size(forPath: path)
    }
    
    private func size(forPath path: String) -> String? {
        do {
            return try URL(fileURLWithPath: path).sizeOnDisk()
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var directories = [SizedDirectory]()
    
    init() {
        updateDirectories()
    }
    
    func delete(directory: SizedDirectory) {
        do {
            try FileManager.default.removeItem(atPath: directory.path)
            updateDirectories()
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func updateDirectories() {
        let decoder = JSONDecoder()
        do {
            let url = Bundle.main.url(forResource: "directories", withExtension: "json")
            let data = try Data(contentsOf: url.require(hint: "directories.json file not exist in app bundle."))
            
            directories = try decoder.decode([Directory].self, from: data).map(SizedDirectory.init)
        } catch {
            preconditionFailure("directories.json file not configured correctly: \(error)")
        }
    }
}

extension URL {
    /// check if the URL is a directory and if it is reachable
    func isDirectoryAndReachable() throws -> Bool {
        guard try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else {
            return false
        }
        return try checkResourceIsReachable()
    }

    /// returns total allocated size of a the directory including its subFolders or not
    func directoryTotalAllocatedSize(includingSubfolders: Bool = true) throws -> Int? {
        guard try isDirectoryAndReachable() else { return nil }
        var urls: LazySequence<Array<URL>>
        
        if includingSubfolders {
            guard let files = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)?.allObjects as? [URL] else { return nil }
            urls = files.lazy
        } else {
            urls = try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil).lazy
        }
        return try urls.reduce(0) { (result: Int, next: URL) in
            let fileSize = try next.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0
            return fileSize + result
        }
    }

    /// returns the directory total size on disk
    func sizeOnDisk() throws -> String? {
        guard let size = try directoryTotalAllocatedSize() else { return nil }
        URL.byteCountFormatter.countStyle = .file
        guard let byteCount = URL.byteCountFormatter.string(for: size) else { return nil }
        return byteCount
    }
    private static let byteCountFormatter = ByteCountFormatter()
}
