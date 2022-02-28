//
//  HomeActionSheetVC+Gesture.swift
//  NotesClone
//
//  Created by Leonardo  on 26/02/22.
//

import UIKit

extension HomeActionSheetVC {
  @IBAction func didPanAction(_ gesture: UIPanGestureRecognizer) {
    let dragTranslation = gesture.translation(in: self.view)
    let actionSheetHeight = homeActionSheetView.frame.size.height
    let masterViewHeight = view.frame.size.height 
    switch gesture.state {
      case .began:
        print("")
      case .changed:
//        print("pan changed")

        if actionSheetHeight <= masterViewHeight {
          print("actionSheetHeight: \(actionSheetHeight)")
          if alertIsFullHeight.isActive {
            alertIsFullHeight.constant = -dragTranslation.y
            print("full constant: \(alertIsDisplayed.constant)")
          } else {
            alertIsDisplayed.constant = -dragTranslation.y
            print("mid constant: \(alertIsDisplayed.constant)")
          }
        } else {
          print("alertIsFullHeight constant: \(alertIsFullHeight.constant)")
          print("alertIsDisplayed constant: \(alertIsDisplayed.constant)")
          print("max dragging reached")
        }

      case .ended:
        print("pan ended")
        print("Action height: \(actionSheetHeight)")
        print("Master height: \(masterViewHeight)")
        print("1/4 frame height: \(masterViewHeight / 4)")
        if actionSheetHeight <= (masterViewHeight / 4) {
          print("hide action")
          dismissActionSheetWithAnimation()
        } else if (actionSheetHeight / 2) + (-dragTranslation.y) > (masterViewHeight * 3 / 5) {
          print("full screen action")
          alertIsFullHeight.constant = 0
          alertIsFullHeight.isActive = true
          alertIsDisplayed.isActive = false
          alertIsHidden.isActive = false
          print("FULL SCREEN HEIGHT: \(homeActionSheetView.frame.height)")
        } else {
          print("else go back to original")
          alertIsDisplayed.isActive = true
          alertIsFullHeight.isActive = false
          alertIsHidden.isActive = false
          alertIsDisplayed.constant = 0
          alertIsFullHeight.constant = 0
        }

      case .cancelled:
        print("pan cancelled")
      case .failed:
//        homeActionSheetView.transform = .identity
        print("pan failed")
      case .possible:
        print("pan possible (default state)")
      @unknown default:
//        homeActionSheetView.transform = .identity
        print("pan unknown")
    }
  }
}
