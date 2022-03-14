//
//  ViewController.swift
//  Milestone-82-Extensions
//
//  Created by Leonardo  on 13/03/22.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet private weak var mainView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    5.times {
      print("hello bruddas")
    }
    var characters: [String] = ["Senku", "Kohaku", "Ryusui", "Senku", "Gen"]
    print("original characters: \(characters)")
    let updatedCharacters: [String] = characters.remove(item: "Senku", type: [String].self)
    print("updated characters: \(updatedCharacters)")

    let leo = Person()
    print("Age: \(Person.age)")
    print("Age: \(type(of: leo).age)")

    print(Person.self) // Person Type
    print(Person.Type.self) // Type of Person type
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    mainView.bounceOut(duration: 2)
  }
}

extension UIView {
  func bounceOut(duration: Int) {
    UIView.animate(withDuration: CGFloat(duration), delay: 0, options: [.repeat, .autoreverse]) {
      self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
    }
  }
}

extension Int {
  func times(_ customClosure: () -> Void) {
    for _ in 0 ..< self {
      customClosure()
    }
  }
}

extension Array where Element: Equatable {
  // Mutating only works with VALUE TYPES (Extension, enums, structs, etc)
  // NOT Classes, Actors, Closures (Rerefence Types)
  // T      -> Object's Type
  // T.Type -> Metatype (Type of a type) (Type of a class, structure, protocol)
  // Self   -> Type that conforms the protocol
  mutating func remove<T>(item: Array.Element, type: T.Type) -> Self {
    if let elementToRemoveIndex = firstIndex(where: { $0 == item }) {
      remove(at: elementToRemoveIndex)
    }
    return self
  }
}

enum Person {
  static let age: Int = 23
}
