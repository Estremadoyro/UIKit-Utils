//
//  HomeTableNavigation.swift
//  NotesClone
//
//  Created by Leonardo  on 19/02/22.
//

import UIKit

class HomeTableNavigationBar {
  weak var homeTableVC: UIViewController?

  init(homeTableVC: UIViewController) {
    self.homeTableVC = homeTableVC
  }

  deinit {
    print("\(self) deinited")
  }
}

extension HomeTableNavigationBar {
  open func buildNavigationBarItems() {
    let moreButtonImage = UIImage(systemName: "ellipsis.circle")?.withRenderingMode(.alwaysTemplate)

    let moreButton = UIBarButtonItem(image: moreButtonImage, style: .plain, target: self, action: #selector(showMoreOptions))
    moreButton.tintColor = UIColor.systemYellow
    let rightBarItems: [UIBarButtonItem] = [moreButton]
    homeTableVC?.navigationItem.rightBarButtonItems = rightBarItems
  }
}

extension HomeTableNavigationBar {
  @objc
  private func showMoreOptions() {
    print("show more buttons")
  }
}
