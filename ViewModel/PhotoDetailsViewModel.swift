//
//  PhotoDetailsViewModel.swift
//  PhotoLib
//
//  Created by Marat Saytakov on 6/30/20.
//

import SwiftUI

typealias PhotoDetailsCellInfo = (title: String, value: String)

//struct PhotoDetailsCellInfo {
//  let title: String, value: String
//}

private let nf = NumberFormatter()

class PhotoDetailsViewModel {
  
  let photoInfo: PhotoInfo
  let tableData: [PhotoDetailsCellInfo]
  
  init(photoInfo: PhotoInfo) {
    self.photoInfo = photoInfo

    nf.locale = Locale(identifier: "us")
    nf.groupingSize = 3
    nf.usesGroupingSeparator = true

    func formatted(_ number: Int) -> String {
      nf.string(from: NSNumber(value: number)) ?? String(number)
    }

    tableData = [
      ("Author", photoInfo.user),
      ("Downloads", formatted(photoInfo.downloads)),
      ("Views", formatted(photoInfo.views)),
      ("Likes", formatted(photoInfo.likes)),
      ("Comments", formatted(photoInfo.comments)),
    ]
  }

  var numberOfRows: Int {
    tableData.count
  }

  func titleForHeaderInSection(_ section: Int) -> String {
    "Details".uppercased()
  }

}

#if !os(macOS)
import UIKit

extension PhotoDetailsViewModel {

  func cellTexts(at indexPath: IndexPath) -> PhotoDetailsCellInfo {
    tableData[indexPath.row]
  }

}
#endif
