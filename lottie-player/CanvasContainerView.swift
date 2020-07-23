//
//  CanvasContainerView.swift
//  lottie-player
//
//  Created by Muis on 23/07/20.
//  Copyright © 2020 WillowTree Apps, Inc. All rights reserved.
//

import Cocoa

protocol CanvasContainerDelegate: class {
    func handleFileObject(_ url: URL)
}

final class CanvasContainerView: FlippedView {
    
    weak var delegate: CanvasContainerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerForDraggedTypes([.fileURL])
    }
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let canReadPasteboardObjects = sender.draggingPasteboard
            .canReadObject(
                forClasses: [NSURL.self],
                options: nil
        )
        
        if canReadPasteboardObjects {
            return .copy
        }
        
        return NSDragOperation()
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboardObjects = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil), pasteboardObjects.count > 0 else { return false }
        pasteboardObjects.forEach({ object in
            if let url = object as? NSURL {
                self.delegate?.handleFileObject(url as URL)
            }
        })
        sender.draggingDestinationWindow?.orderFrontRegardless()
        return true
    }
}
