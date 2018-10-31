//
//  XTableSection.swift
//  XCollectionData
//
//  Created by Matthias Hochgatterer on 31.10.18.
//

import Foundation

open class XTableSection: XCollectionSection {
    public let header: String?
    public let footer: String?
    
    public init(identifier: String, header: String? = nil, footer: String? = nil) {
        self.header = header
        self.footer = footer
        
        super.init(identifier: identifier)
    }
}
