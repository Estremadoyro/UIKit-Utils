//
//  HomeAlertActionSheetVC.swift
//  NotesClone
//
//  Created by Leonardo  on 25/02/22.
//

import UIKit

class HomeActionSheetVC: UIViewController {
  @IBOutlet private weak var homeActionSheetView: HomeActionSheetView!
  @IBOutlet private weak var dismissHomeActionSheetButton: UIButton!
  @IBOutlet private weak var homeActionSheetHeaderView: UIView!
  // Constraints must have a strong reference? or they get deallocated?
  @IBOutlet private var alertIsHidden: NSLayoutConstraint!
  @IBOutlet private var alertIsDisplayed: NSLayoutConstraint!
  private var didAnimate: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    alertIsDisplayed.isActive = false
    dismissHomeActionSheetButton.superview?.layoutIfNeeded()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !didAnimate {
      didAnimate = true
      animatePresentingView()
      print("did layout subviews")
    }
  }

  deinit { print("\(self) deallocated") }
}

extension HomeActionSheetVC {
  private func animatePresentingView() {
    alertIsDisplayed.isActive = true
    UIView.animate(withDuration: 0.35, delay: 0, animations: { [unowned self] in
      self.homeActionSheetView.superview?.layoutIfNeeded()
    })
  }
}

extension HomeActionSheetVC {
  @IBAction private func dismissHomeAlertActionSheet(_ sender: UIButton) {
    print("dismiss vc")
    dismissActionSheetWithAnimation()
  }

  private func dismissActionSheetWithAnimation() {
    alertIsDisplayed.isActive = false
    let customAnimation: () -> Void = { [unowned self] in
      self.homeActionSheetView.superview?.layoutIfNeeded()
    }
    let customCompletion: (Bool) -> Void = { [unowned self] _ in
      self.dismiss(animated: true, completion: nil)
    }
    UIView.animate(withDuration: 0.35, delay: 0, options: [], animations: customAnimation, completion: customCompletion)
  }
}

extension HomeActionSheetVC {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    let touchesViews = touches.map { $0.view }
    print(touchesViews)
    if touch?.view != homeActionSheetView, touch?.view != homeActionSheetHeaderView {
      dismissActionSheetWithAnimation()
    }
  }
}
