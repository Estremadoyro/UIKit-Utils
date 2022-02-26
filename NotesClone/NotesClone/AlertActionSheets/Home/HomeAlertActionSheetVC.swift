//
//  HomeAlertActionSheetVC.swift
//  NotesClone
//
//  Created by Leonardo  on 25/02/22.
//

import UIKit

class HomeAlertActionSheetVC: UIViewController {
  @IBOutlet private weak var homeAlertActionSheetView: HomeAlertActionSheetView!
  @IBOutlet private weak var dismissHomeAlertActionSheetButton: UIButton!
  // Constraints must have a strong reference? or they get deallocated?
  @IBOutlet private var alertIsHidden: NSLayoutConstraint!
  @IBOutlet private var alertIsDisplayed: NSLayoutConstraint!
  private var didAnimate: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    alertIsDisplayed.isActive = false
    dismissHomeAlertActionSheetButton.superview?.layoutIfNeeded()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !didAnimate {
      animatePresentingView()
      didAnimate = true
      print("did layout subviews")
    }
  }

  deinit { print("\(self) deallocated") }
}

extension HomeAlertActionSheetVC {
  private func animatePresentingView() {
    alertIsDisplayed.isActive = true
    UIView.animate(withDuration: 0.35, delay: 0, animations: { [unowned self] in
      self.homeAlertActionSheetView.superview?.layoutIfNeeded()
    })
  }
}

extension HomeAlertActionSheetVC {
  @IBAction private func dismissHomeAlertActionSheet(_ sender: UIButton) {
    print("dismiss vc")
    alertIsDisplayed.isActive = false
    let customAnimation: () -> Void = { [unowned self] in
      self.homeAlertActionSheetView.superview?.layoutIfNeeded()
    }
    let customCompletion: (Bool) -> Void = { [unowned self] _ in
      self.dismiss(animated: true, completion: nil)
    }
    UIView.animate(withDuration: 0.35, delay: 0, options: [], animations: customAnimation, completion: customCompletion)
  }
}
