import Foundation

/// # ``1. Capture lists alongside parameters``
/// The `capture lists MUST` always come `first`

class Student {
  func greeting() {
    print("hello world")
  }
}

class CaptureLists {
  var user: String?
  func captureList() -> () -> Void {
    self.user = "Leonardo"
    let message = "owo"
    let capture = { [weak self, message] in
      print("\(self?.user ?? "no user") says \(message)")
    }
    return capture
  }
}

// let capture = CaptureLists()
// capture.captureList()()

/// # ``2. Strong reference cycles``
/// When obj. `A` owns obj. `B` and obj. `B` owns obj. `A` means a `retain cycle`

class House {
  var ownerDetails: (() -> Void)?
  func printDetails() {
    print("This is a great houser")
  }

  deinit {
    print("House being demolished :(")
  }
}

class Owner {
  var houseDetails: (() -> Void)?
  func printDetails() {
    print("I own a house owoj")
  }

  deinit {
    print("I'm dying :( ")
  }
}

print("Creating house and owner")

/// Using `do` as it ensures anything inside will eventually be destroyed
do {
  let house = House()
  let owner = Owner()
  /// # Creating `reference cycle`
  /// # `House` has a property (`ownerDetails`) that points to a method of `Owner` (`printDetails`)
  /// # and `Owner` has a property (`houseDetails`) that points to a method of `House` (`printDetails`)
  /// # This means `NEITHER` of `Owner` or `House` can be safely `destroyed` which causes `MEMORY LEAKS` (Memory that `CAN'T` be freed, and `might` even crash your app :( )

//  house.ownerDetails = {
//    owner.printDetails()
//  }
//  owner.houseDetails = {
//    house.printDetails()
//  }

  house.ownerDetails = { owner.printDetails() }
  /// # `SOLUTION` -> Create a new `closure` and user `weak capturing` for `one` or `both` values
  /// # `weak owner` means `owner` will `not` be captured by `house.ownerDetails`
  owner.houseDetails = { [weak house] in
    /// # `house` only exists in `do {}` and got destroyed
    house?.printDetails()
  }
  /// # Both `house` and `owner` got `destroyed` during execution, and neither ``house.ownerDetails`` or ``owner.houseDetails`` `captured` the objects
}

print("doneee")

/// # ``3. Accidental strong references```
/// Swift defaults to `strong capturing` which can result to unintentional problems

class Singer {
  func playSong() {
    print("death of a bachelor")
  }
}

func sing() -> (() -> Void) {
  let brandom = Singer()
  let adam = Singer()
  /// # `unowned` will only affect `brandom` unless specified in `adam` aswell ``unowner adam``
  let singing = { [unowned brandom, unowned adam] in
    /// # This will crash, as `brandom` and `adam` have already `ceased to exist`
    brandom.playSong()
    adam.playSong()
  }
  return singing
}

/// # ``4. Copies of closures``
/// When `closures` are `copied` ther captured data becomes `shared among copies`
var numberOfLinesLogged = 0
/// # `numberOfLinesLogged` gets captured inside `logger1`
let logger1 = {
  numberOfLinesLogged += 1
  print("Lines logged \(numberOfLinesLogged)")
}

/// # If a copy of `logger1` is made, then both `logger1` and `logger2` will share the `same captured value` ``pointing at the same captured value``
let logger2 = logger1
logger2()
logger1()
logger2()

/// # ``When to use STRONG, WEAK or UNOWNED``?
/// # `UNOWNED`
/// When you are `sure` the captured value will `never` get destroyed while the `closure` has any change of being called. A weak capture works aswell but the object becomes optional
/// # `WEAK`
/// When there is a `Strong Reference Cycle` scenario, where `A` owns `B` and `B` owns `A`, then either `A` or `B` should be `weakly` captured.
/// Usually, the one to be `destroyed first` should be the one `weakly` captured
/// If `VC A` presents `VC B` then `VC B` might hold a `weak` reference back to `VC A`, as the latter will be destroyed first (after presenting `VC B`)
/// # `STRONG`
/// If there is `no chance` of `Strong Reference Cycle` you can safely strong capture.
/// i.e. Performing an `animation` won't cause `self` to be retained inside the `animation closure`, so strong capturing is recommended
///
/// # If not sure which one to use, then go with `weak` and change it `if needed`
