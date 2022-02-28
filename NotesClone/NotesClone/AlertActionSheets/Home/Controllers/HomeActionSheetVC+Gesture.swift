//
//  HomeActionSheetVC+Gesture.swift
//  NotesClone
//
//  Created by Leonardo  on 26/02/22.
//

import UIKit

enum ConstraintUpdateType {
  case toHidden
  case toMidHeight
  case toFullScreen
}

extension HomeActionSheetVC {
  fileprivate var activateSheetFullScreen: Void {
    alertIsFullHeight.constant = 0
    alertIsFullHeight.isActive = true
    alertIsDisplayed.isActive = false
    alertIsHidden.isActive = false
  }

  fileprivate var activateSheetMidHeight: Void {
    alertIsDisplayed.constant = 0
    alertIsFullHeight.constant = 0
    alertIsDisplayed.isActive = true
    alertIsFullHeight.isActive = false
    alertIsHidden.isActive = false
  }

  internal var activateSheetHidden: Void {
    alertIsDisplayed.constant = 0
    alertIsFullHeight.constant = 0
    alertIsDisplayed.isActive = false
    alertIsFullHeight.isActive = false
    alertIsHidden.isActive = true
  }

  @IBAction func didPanAction(_ gesture: UIPanGestureRecognizer) {
    let dragTranslation = gesture.translation(in: view)
    let actionSheetHeight = homeActionSheetView.frame.size.height
    let masterViewHeight = view.frame.size.height - view.safeAreaInsets.top
    switch gesture.state {
      case .began:
        break
      case .changed:
        print("Action height: \(actionSheetHeight)")
        print("Master height: \(masterViewHeight)")
        if actionSheetHeight < masterViewHeight || dragTranslation.y > 0 {
          print("actionSheetHeight: \(actionSheetHeight)")
          if alertIsFullHeight.isActive {
            // Top anchor, must be negative as only option is dragging down
            alertIsFullHeight.constant = dragTranslation.y
          } else {
            // Height anchor, must be positive
            alertIsDisplayed.constant = -dragTranslation.y
          }
        } else {
          print("max dragging reached")
        }

      case .ended:
        print("pan ended")
        if actionSheetHeight <= (masterViewHeight / 4) {
          print("hide action")
          constraintsUpdateWithAnimation(updateType: .toHidden) { [unowned self] in
            self.activateSheetHidden
          }
        } else if (actionSheetHeight / 2) + (-dragTranslation.y) > (masterViewHeight * 3 / 5) {
          print("full screen action")
          constraintsUpdateWithAnimation(updateType: .toFullScreen) { [unowned self] in
            self.activateSheetFullScreen
          }
          homeActionSheetView.superview?.layoutIfNeeded()
        } else {
          print("else go back to original")
          constraintsUpdateWithAnimation(updateType: .toMidHeight) { [unowned self] in
            self.activateSheetMidHeight
          }
        }
      case .possible:
        break
      case .cancelled:
        break
      case .failed:
        break
      @unknown default:
        constraintsUpdateWithAnimation(updateType: .toMidHeight) { [unowned self] in
          self.activateSheetMidHeight
        }
        print("pan unkwnown default")
    }
  }
}
