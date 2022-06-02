//
//  CompositionalLayout.swift
//  Sandbox-CompositionalLayout
//
//  Created by Leonardo  on 2/06/22.
//

import UIKit

enum CompositionalGroupAlignment {
  case vertical
  case horizontal
}

enum CustomCompositionalLayout {
  static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, spacing: CGFloat) -> NSCollectionLayoutItem {
    let itemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    return item
  }

  // For different CollectionLayoutItem configurations
  static func createGroup(alignment: CompositionalGroupAlignment,
                          width: NSCollectionLayoutDimension,
                          height: NSCollectionLayoutDimension,
                          items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup
  {
    let groupSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
    switch alignment {
      case .vertical:
        return NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: items)
      case .horizontal:
        return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: items)
    }
  }

  // For a common CollectionLayoutItem confguration
  static func createGroup(alignment: CompositionalGroupAlignment,
                          width: NSCollectionLayoutDimension,
                          height: NSCollectionLayoutDimension,
                          item: NSCollectionLayoutItem,
                          count: Int) -> NSCollectionLayoutGroup
  {
    let groupSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
    switch alignment {
      case .vertical:
        return NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: count)
      case .horizontal:
        return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count)
    }
  }
}
