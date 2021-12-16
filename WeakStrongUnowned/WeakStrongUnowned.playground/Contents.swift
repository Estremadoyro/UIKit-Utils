import UIKit

/// # `Capture lists` come before a `closure's parameter list`

class Singer {
  func playStrongSong() {
    print("hey look ma I made it")
  }

  func playWeakSong() {
    print("house of memories")
  }

  func playUnownedSong() {
    print("the death of a bachelor")
  }
}

func sing() -> [() -> Void] {
  /// # `STRONG CAPTURE` (Default, no unwrapping)
  /// # `bradom` is made inside the `sing()` method, `normally` it would get destroyed when the `method ended`
  /// # `HOWEVER` the closure `singing` has `brandom` insie it, which means `Swift` will make sure it stays `alive` for as long as the `closure exists` somewhere
  let brandom = Singer()
  let singing_strong = {
    /// # If `Swift` allowed `brandom` to be destroyed, then calling `singing` would `not be safe` anymore, as the method `brandom.playSong()` wouldn't exist anymore
    brandom.playStrongSong()
  }
  /// # `WEAK CAPTURE` (Needs unwrapping)
  /// # `brandom` is `not captured` by the close that uses it, so it might get `destroyed` and set to `nil`. That's why it is an `optional` type
  /// # `brandom` exists `ONLY` inside `sing()`
  let singing_weak = { [weak brandom] in
    if let brandom_exists = brandom {
      brandom_exists.playWeakSong()
    }
    print("brandom is nil")
  }

  /// # `UNOWNED CAPUTRE` (Implicit unwrap)
  /// # Works just as `implicitly unwrapping an optional`, `brandom` is no longer an `optional`, is has already been forced unwrapped, and `in the current scenario` it will `crash` as `brandom` only `exists` in `sing()`
  let singing_unowned = { [unowned brandom] in
    brandom.playUnownedSong()
  }
  return [singing_strong, singing_weak, singing_unowned]
}

sing()[1]()
