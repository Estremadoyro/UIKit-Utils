//
//  HomeCustomActionView.swift
//  NotesClone
//
//  Created by Leonardo  on 24/02/22.
//

import UIKit

class HomeCustomActionView: UIView {
  private let parentAlertController: UIAlertController
  private var parentView: UIView {
    guard let parent = parentAlertController.view else { return UIView() }
    return parent
  }

  private var closeIconButton = UIButton(type: .system)
  weak var homeActionSheetDelegate: HomeActionSheetDelegate?

  init(parentController: UIAlertController) {
    self.parentAlertController = parentController
    super.init(frame: .zero)
    becomeFirstResponder()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit { print("\(self) deinited") }
}

extension HomeCustomActionView {
  open func buildView() {
    configureView()
    buildSubViews()
    buildConstraints()
  }
}

extension HomeCustomActionView {
  private func buildSubViews() {
    addSubview(closeIconButton)
  }

  private func configureView() {
    backgroundColor = UIColor.systemGray6
//    backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
    layer.cornerRadius = 15
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    configureCloseIcon()
  }

  private func buildConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 35),
      topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0),
      leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: -8),
      trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 8),
    ])
    NSLayoutConstraint.activate([
      closeIconButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      closeIconButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
      closeIconButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.10),
      closeIconButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
    ])
  }
}

extension HomeCustomActionView {
  private func configureCloseIcon() {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium, scale: .large)
    let image = UIImage(systemName: "x.circle.fill", withConfiguration: largeConfig)?.withRenderingMode(.alwaysOriginal)
    closeIconButton.translatesAutoresizingMaskIntoConstraints = false
    closeIconButton.setImage(image, for: .normal)
//    closeIconButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    closeIconButton.tintColor = UIColor.systemGray5
    closeIconButton.addTarget(self, action: #selector(closeActionView), for: .touchUpInside)
  }
}

extension HomeCustomActionView {
  @objc
  private func closeActionView() {
    print("close")
    homeActionSheetDelegate?.didDismissActionDelegate(ac: parentAlertController)
    // animation doesnt need capture list
    UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { self.alpha = 0.0 }, completion: { _ in
      self.removeFromSuperview()
    })
  }
}

extension HomeCustomActionView {}
