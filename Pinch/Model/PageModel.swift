//
//  PageModel.swift
//  Pinch
//
//  Created by Petar Iliev on 6/24/23.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-\(imageName)"
    }
}
