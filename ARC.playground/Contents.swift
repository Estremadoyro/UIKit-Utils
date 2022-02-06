/// # Everytime there is a new instance of a class, ``ARC`` allocates information abount that instance, and saves it in memory
/// # ``ARC`` frees up memory whenever an `instance` is `no longer needed`
/// # ``ARC`` tracks how many properties, constants and variables are currently referring to a each `class intance`
/// # But `never deallocates` the instance from memory when there is `at least` 1 strong reference to it
/// # Whenever a property, constant or variable is assigned to a `class instance`, a ``strong reference`` is made.
import Foundation

class Student {
  let name: String

  init(name: String) {
    self.name = name
//    print("\(name) is beign initialized")
  }

  deinit {
//    print("\(name) is beign deinitialized")
  }
}

/// # All references are `optional` meaning their `initial value` is ``nil``
var reference1: Student?
var reference2: Student?
var reference3: Student?

/// #  There is now a `strong reference` from ``reference1`` to the new `Person` instance
// It's not deallocated as there is at least 1 strong reference ARC doens't deallocate reference1
reference1 = Student(name: "Leonardo")
// 2 more strong references are stablished
reference2 = reference1
reference3 = reference1
// breaking 2 references, but Person instance is yet not deallocated
/// # Person is ``STILL```not deallcoated`
/// # `reference3` is still `strong refering` to the `Person instance`
reference1 = nil
reference2 = nil
// Until the last strong reference is broken
reference3 = nil

/// # There are where a `class instance` may never stop having `strong references`
// It can happen if 2 class instances hold a strong reference to each other
// Each instance keeps the other alive
/// # Strong reference cycles can be ``resolved`` with: ``weak, or unowned`` references instead of `strong references`

// Strong Reference Cycle

// Each Person instance has an optional apartment property that is initialiy nil
class Person {
  let name: String
  var apartment: Apartment?

  init(name: String) {
    self.name = name
//    print("\(name) is beign initialized")
  }

  deinit {
//    print("\(name) is beign deinialized")
  }
}

class Apartment {
  let unit: String
  var tenant: Person?

  init(unit: String) {
    self.unit = unit
//    print("Apartment \(unit) is beign initialized")
  }

  deinit {
//    print("Apartment \(unit) is beign deinitialized")
  }
}

// variables with optional types (nil initialy)
var leonardo: Person?
var unitC301: Apartment?

// strong references created
leonardo = Person(name: "Leonardo")
unitC301 = Apartment(unit: "C301")

// Leonardo's apartment has a strong reference to C301
leonardo!.apartment = unitC301
// Apartment C301 has a strong reference to tenant Leonardo
unitC301!.tenant = leonardo

/// # Attempting to free memory, but `none of them get deallocated`
// Can't deallocate Leonardo as an Apartment has a strong reference to it
leonardo = nil
// Can't deallocate Apartment, as Leonardo has a strong reference to it
unitC301 = nil
/// print(leonardo) -- Will return nil, but STILL holding memory

/// # The `Strong Reference Cycle` prevents `Person` and `Apartment` from ever being `deallocated`, as `each instance point to each other`
/// # As the refences can't be broken

/// # ``weak & unowned`` enable one `instance` in a reference cycle to refer to the other `without` keeping a `strong reference` to it
/// # ``weak``    when the other instance has as `shorter lifetime`
/// # ``unowned`` when both instances have the `same lifetime` or a longer one
/// # In the example, it's appropiate for an `Apartment` to have `no tenant` at some point in its lifetime. The Apartment obj. is useful without a tenant
// It depeneds on each codebase and logic to determine which one has a longer lifetime, aka obj has value without the reference. Apartment with nil tenenat

/// # ``weak`` doesn't stop `ARC` from `deallocating` the reference
/// # A ``weak`` reference doesn't hold a `strong reference` to the `instance it's refering to`. So the other instance can be deallocated while there is a `weak reference` pointing to it
/// # ``ARC`` automatically sets a `weak reference to nil` when the `instance` that it refers to is `deallocated`
/// # Because ``weak references`` need to allow it's value to change to ``nil`` during runtime, they can only be `variables` of optional type
// Property observers aren't called when ARC changes a weak reference to nil
/// # When `either` property can be `nil`

class Person1 {
  var name: String
  var apartment: Apartment1?

  init(name: String) {
    self.name = name
//    print("\(name) is beign initialized")
  }

  deinit {
//    print("\(name) is beign deinitialized")
  }
}

class Apartment1 {
  var unit: String
  /// # `Prevent reference cycle`: Adding `weak`, making it a `weak reference` rather than a `strong reference`
  /// # Now `Person1` can be deallocated when set to `nil`
  weak var tenant: Person1?

  init(unit: String) {
    self.unit = unit
//    print("Apartment \(unit) is beign initialized")
  }

  deinit {
//    print("Apartment \(unit) is beign deinitialized")
  }
}

var leonardo1: Person1?
var unitC302: Apartment1?

leonardo1 = Person1(name: "Leonardo")
unitC302 = Apartment1(unit: "C302")

leonardo1!.apartment = unitC302
unitC302!.tenant = leonardo1

/// # `Leonardo1` now is only being referenced in a ``weak`` manner, so it can `safely deallocate`
leonardo1 = nil /// # now `unitC302.tenant` is ``nil``

/// # And Apartment1 can deallocate aswell, `as leonardo1 is now nil`, so ``ARC`` automatically `sets a weak reference to nil` when the instance that it refers to is `deallocated`
unitC302 = nil

/// # ``unowned`` unlike ``weak`` references, are expected to `always` have `value`, meaning they are `not optional`.
/// # ``ARC`` `never` sets an `unowned` reference value to `nil`
/// # The unowned reference value should always point to an instance that hasn't been deallocated
/// # If trying to access an ``unowned`` reference that has been `deallocated` there will be a `runtime error`
/// # Used when the `other instance` has the `same, or longer lifetime`
/// # When 1 property can't ever be nil

// A CreditCard MUST always have a Customer, if there is none, then it CreditCard will be deallocated
// You can't deallocate the Customer that the CreditCard is pointing to, so unwoned is necessary to prevent a Reference Cycle and reflect their relation
/// #  When 1 property `can't be nil`

class Customer {
  let name: String
  var card: CreditCard?

  init(name: String) {
    self.name = name
//    print("\(name) is beign initialized")
  }

  deinit {
//    print("\(name) is beign deinitialized")
  }
}

class CreditCard {
  // so that number property capacity is large enough to store a 16-digit card number on both 32 and 64 bit systems
  let number: Int64
  // The customer property shall never be accessed if the Customer it points to is deallocated
  unowned let customer: Customer

  init(number: Int64, customer: Customer) {
    self.number = number
    self.customer = customer
//    print("Card #\(number) for customer \(customer.name) is beign initialized")
  }

  deinit {
//    print("Card #\(number) is beign deinitialized")
  }
}

var john: Customer? // initial value of nil as it is an optional

john = Customer(name: "John")
john?.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)

// This will deallocate both Customer and CreditCard, since John doesn't exist anymore, there are no strong references left for CreditCard
john = nil

/// # ``optional unowned`` can be used in the same context as a ``weak`` reference
/// # Difference with ``weak`` is that you are `responsible for refering to a valid object` or beign set to `nil`

class Department {
  var name: String
  // department owns all of its courses
  var courses: [Course]

  init(name: String) {
    self.name = name
    self.courses = []
  }

  deinit {
//    print("1 Department: \(name) deallocated")
  }
}

class Course {
  var name: String
  // every course must belong to a department
  unowned let department: Department
  // some courses may not have a next recommended course
  unowned var nextCourse: Course?

  init(name: String, in department: Department) {
    self.name = name
    self.department = department
    self.nextCourse = nil
  }

  deinit {
    print("Course \(name) deallocated")
  }
}

var department: Department?
department = Department(name: "Engineering")

let intro = Course(name: "Software I", in: department!)
let intermediate = Course(name: "Software II", in: department!)
let advanced = Course(name: "Software III", in: department!)

intro.nextCourse = intermediate
intermediate.nextCourse = advanced
department!.courses = [intro, intermediate, advanced]

department = nil

/// # When `both 2 properties` can't be `nil`

// Every country must have a capital city
class Country {
  let name: String
  // Must be a strong reference, if not then during initialition of Country, it's City instance set to the property will be deallocated
  // As capitalCity is weak, and ther are NO other strong references pointing to City(name:country), ARC will deallocate it automatically.
  // For having its strong reference count @ 0
  var capitalCity: City! // Initial value of nil but can be accessed without having to unwrap

  init(name: String, capitalName: String) {
    // Init Phase 1 complete, self is not available for use
    self.name = name // Now, Country is fully initialized, and ready to use self
    // Can't access self until Country is fully initiated, thus making capitalCity! forceunwrap solves the problem
    self.capitalCity = City(name: capitalName, country: self)
  }

  // runs async
  deinit {
//    print("1 Country deallocated")
  }
}

// Every capital city must belong to a country
class City {
  let name: String
  unowned let country: Country

  init(name: String, country: Country) {
    self.name = name
    self.country = country
  }
}

func test() {
  let country = Country(name: "Peru", capitalName: "Lima")
//  print("Country: \(country.name) | Capital: \(country.capitalCity.name)")
  // gets automatically deallocated when the test() obj gets destroyed
}

test()

// lazy properties are only accessed after initialization has been completed and thus self exists

/// # Strong Reference Cycles for Closures
// Both Classes and Closures are Reference Types

class HTMLElement {
  let name: String
  let text: String?

  /// # Holds a strong reference to its `closure` ``() -> String``
  lazy var asHTML: () -> String = { [unowned self] in
    if let text = self.text {
      /// # Holds a strong reference to its `class` ``self``
      return "<\(self.name)><\(text)></\(self.name)>"
    } else {
      return "<\(self.name) />"
    }
  }

  init(name: String, text: String? = nil) {
    self.name = name
    self.text = text
  }

  deinit {
    print("\(self) is beign deinitialzied")
  }
}

// Hold strong reference to HTMLElement
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello my bruddas")
print(paragraph!.asHTML())
paragraph = nil // never gets deallocated

/// # ``Captures in Closures``
/// # ``unowned``  when the `closure` and the `instance` it captures (`self` most of the time) will always refer to each other and will always be `deallocated` at the same time
/// # ``weak`` (always optional) when the `instance` it captures may become `nil` at some point. Automatically become `nil` when the instance they reference is ``deallocated``

/// # `` Strong reference`` (Solutions)
/// # ``weak``      when both instances can become `nil` at any point, should refer the the instance with shorter lifetime
// Must be optional
///  # ``unowned``  when the `instance it refers to` is expected to `never` become `nil`. (CreditCard has an `unowned` Customer, as it should `not` be `nil`, accessing an `unowned nil Customer` will result in a runtime error. Used when both `instances` share the `same lifetime` or the on with the `longer lifetime`
/// # ``ARC`` never sets an `unowned` reference's value to `nil`
// Not necessary to be optional
