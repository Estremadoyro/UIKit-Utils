//
//  HomeAlertActionSheet.swift
//  NotesClone
//
//  Created by Leonardo  on 24/02/22.
//

import UIKit

class HomeAlertActionSheet {
  weak var homeVC: UIViewController?

  init(_ homeVC: UIViewController?) {
    self.homeVC = homeVC
  }

  deinit { print("\(self) deinited") }
}

extension HomeAlertActionSheet {
  open func configureActionSheet() {
    let ac = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    let homeCustomActionView = HomeCustomActionView(parentController: ac)
    homeCustomActionView.homeActionSheetDelegate = self
    ac.view.addSubview(homeCustomActionView)
    homeCustomActionView.buildView()

    ac.view.translatesAutoresizingMaskIntoConstraints = false
    ac.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    self.homeVC?.present(ac, animated: true, completion: nil)
  }
}

extension HomeAlertActionSheet: HomeActionSheetDelegate {
  func didDismissActionDelegate(ac: UIAlertController) {
    print("dismiss action")
    ac.dismiss(animated: true, completion: nil)
  }
}
