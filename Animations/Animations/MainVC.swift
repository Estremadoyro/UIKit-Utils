//
//  ViewController.swift
//  Animations
//
//  Created by Leonardo  on 23/01/22.
//

import UIKit

class MainVC: UIViewController {
  var currentAnimation: Int = 0

  private lazy var mainStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.distribution = .fill
    stack.addArrangedSubview(animationView)
    stack.addArrangedSubview(buttonView)
//    stack.layer.borderWidth = 2
//    stack.layer.borderColor = UIColor.systemPink.cgColor
    return stack
  }()

  private lazy var animationView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(penguin)
    return view
  }()

  private lazy var buttonView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationBtn)
    return view
  }()

  private let penguin: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "penguin")
    image.contentMode = .scaleAspectFit
    image.clipsToBounds = true
//    image.layer.borderColor = UIColor.systemBlue.cgColor
//    image.layer.borderWidth = 1
    return image
  }()

  private let animationBtn: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setTitle("Animation", for: .normal)
    btn.setTitleColor(UIColor.systemBlue, for: .normal)
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
    btn.layer.cornerRadius = 25
    btn.addTarget(self, action: #selector(animate(_:)), for: .touchUpInside)
    return btn
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    subViewsBuilder()
    constraintsBuilder()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    print(mainStack.frame)
    penguin.superview?.layoutIfNeeded()
    print(penguin.frame)
  }

  private func subViewsBuilder() {
    view.addSubview(mainStack)
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),

      animationView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.9),
      buttonView.heightAnchor.constraint(equalTo: mainStack.heightAnchor, multiplier: 0.1),

      penguin.centerXAnchor.constraint(equalTo: animationView.centerXAnchor),
      penguin.centerYAnchor.constraint(equalTo: animationView.centerYAnchor),

      animationBtn.leadingAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.leadingAnchor),
      animationBtn.trailingAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.trailingAnchor),
      animationBtn.topAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.topAnchor),
      animationBtn.bottomAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.bottomAnchor),
    ])
  }
}

extension MainVC {
  @objc
  private func animate(_ sender: UIButton) {
    sender.isHidden = true

    let penguinCenter = CGPoint(x: penguin.frame.size.width / 2, y: penguin.frame.size.height / 2)

    if currentAnimation > 7 { currentAnimation = 0 }
    print("animation counter: \(currentAnimation)")

    let penguinAnimation: () -> Void = {
      switch self.currentAnimation {
        // Change dimensions
        case 0:
          self.penguin.transform = CGAffineTransform(scaleX: 2, y: 2)
        case 1:
          self.penguin.transform = .identity
        // Translate
        case 2:
          self.penguin.transform = CGAffineTransform(
            translationX: (-self.animationView.bounds.width / 2) + penguinCenter.x,
            y: (-self.animationView.bounds.height / 2) + penguinCenter.y)
        case 3:
          self.penguin.transform = .identity
        // Rotate
        case 4:
          self.penguin.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        case 5:
          self.penguin.transform = .identity
        // Change bg color & alpha
        case 6:
          self.penguin.alpha = 0.1
          self.penguin.backgroundColor = UIColor.systemPink
        case 7:
          self.penguin.alpha = 1
          self.penguin.backgroundColor = .clear
        default:
          break
      }
    }

    let completion: (Bool) -> Void = { _ in
      sender.isHidden = false
    }

    /// # No risk of `strong capturing`
    // Closures used insite animate() will run once and then get deallocated
    // If there are no animations, completion gets called straight away
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: penguinAnimation, completion: completion)
    currentAnimation += 1
  }
}
