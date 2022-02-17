# 🔗 Useful links
- [README.md documentation](https://docs.github.com/en/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- [Organize Layout Code](https://dilloncodes.com/how-i-organize-layout-code-in-swift)
- [CollectionView & Scroll](https://medium.com/@max.codes/programmatic-custom-collectionview-cell-subclass-in-swift-5-xcode-10-291f8d41fdb1)
- [Modern CollectionViews](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [NavigationBar Apperance](https://stackoverflow.com/questions/56910797/ios13-navigation-bar-large-titles-not-covering-status-bar)
- [RoundedCorner & Shadow](https://medium.com/bytes-of-bits/swift-tips-adding-rounded-corners-and-shadows-to-a-uiview-691f67b83e4a)
- [Corner masking](https://sarunw.com/posts/how-to-set-corner-radius-for-some-corners/)
- [UserDefaults](https://cocoacasts.com/ud-9-how-to-save-an-image-in-user-defaults-in-swift)
- [Communication Patterns](https://betterprogramming.pub/5-ways-to-pass-data-between-view-controllers-18acb467f5ec)
- [View Controller Heirarchy](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/TheViewControllerHierarchy.html)
- [Font Size Guidelines](https://learnui.design/blog/ios-font-size-guidelines.html)
- [ScrollView tricks](https://useyourloaf.com/blog/easier-scrolling-with-layout-guides/)
- [Memory Leaks debugging](https://doordash.engineering/2019/05/22/ios-memory-leaks-and-retain-cycle-detection-using-xcodes-memory-graph-debugger/)
- [View Controller LifeCycle](https://medium.com/good-morning-swift/ios-view-controller-life-cycle-2a0f02e74ff5)
-[Reducing memory footprint for UIImages](https://swiftsenpai.com/development/reduce-uiimage-memory-footprint/)
-[Fix Massive View Controllers](https://www.hackingwithswift.com/articles/86/how-to-move-data-sources-and-delegates-out-of-your-view-controllers)

# 📌 Tips
Inline switches (For/Case/Let)
```swift
for case let CONDITIONS {}
// i.e
for case let node as SKSPriteNode in nodesAtPoint {}
```
MapKit annotation components
| Name | Type |
| --- | --- | 
| Title | String |
| Subtitle | String |
| Position | CLLocationCoordinate2D |

- Title
- Subtitle: String
Set navigation back button, must be done on the NavigationVC pushing
```swift
self.navigationItem.backBarButtonItem = UIBarButtonItem(title:style:target:action)
```
Get image from URL with URLSession
```swift
func fetchImageFromURL(url: URL?) {
    guard let url = url else { return }

    // Its completion handler already runs in a background thread
    URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
      if let anError = error {
        debugPrint("Data task error: \(anError.localizedDescription)")
      }
      guard let aData = data, let image = UIImage(data: aData) else {
        return
      }
      if let httpResponse = response as? HTTPURLResponse {
        debugPrint("Network response: \(httpResponse.statusCode)")
      }
      DispatchQueue.main.async { [weak self] in
        self?.image = image
      }
    }).resume()
  }
```
Get image from URL from Data object
```swift
func fetchImageFromURL(url: URL?) { 
  DispatchQueue.global(qos: .userInitiated).async {
    if let data = try? Data(contentsOf: url) {
      if let image = UIImage(data: data) {
        DispatchQueue.main.async { [weak self] in
          self?.image = image
        }
      }
    }
  }
}
```
Read JSON file from Bundle
```swift
guard let url = Bundle.main.url(forResource: "countries.json", withExtension: nil) else {
  return
}
do { 
  let data = try Data(contentsOf: url) 
  let decodedData = try JSONDecoder().decode(Countries.self, from: data)
  return decodedData
  
} catch {
  print(error)
  return Countries(countries: [Country]())
}
```
Prevent sloppy trainsitions when pushing/popping VCs by setting the background color.
```swift
view.backgroundColor = UIColor.white
```
Don't forget to **deinit** View Controllers when not used/seen on screen
```swift
private var picker: PHPicker? // initial nil reference to picker

// Calling picker
@objc private func importPicture() {
  picker = Picker() // picker allocated
  picker?.pickerDelegate = self
  let pickerVC = picker?.photoPickerVC
  guard let pickerVC = pickerVC else { return }
  present(pickerVC, animated: true, completion: nil)
}

// Delegate method
func didSelectPicture(picture: UIImage) {
  picker = nil // picker deallocated
}
// On root VC, deallocating the pushed VC before the main screen (UITable) appears
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated: animated)
  // In case user didn't pick a picture, there is no PHPicker delegate for that
  self.picker != nil { self.picker = nil }
}
```

# 📝 Info.plist 
| Key | Value | Meaning |
| --- | --- | --- |
| Supported interface orientations (iPhone) | Portrait (bottom home button) | Set portrait mode only |
| Privacy - Camera Usage Description | *Reason* | Access device camera
# 📐 CGShapeLayer
### Set corner radius to some edges
```swift
view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top corners round
```
### Add corner radius and shadow to a view
Should be called inside **viewDidLayoutSubviews** in a VC, but if not, an **async** call will do it in a **UIView** subclass.\
- **IMPORTANT**, *viewDidLayoutSubviews* can be called multiple times without the subviews updating, hence you **must** prevent the *shadowLayer* from getting called endlessly by any layout update. 
- Just call it once, otherwise multiple shadows will stack on top of each other and consume memory significally. 
- You could make the CAShapeLayer optional and only run the code when it's *nil* this way it will be called only once per lifecycle. However, there are multiple ways to accomplish this same behavior, implement them as convenient.
```swift
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.shadowLayer = CAShapeLayer()
      strongSelf.shadowLayer.path = UIBezierPath(roundedRect: strongSelf.cellContainer.bounds, cornerRadius: 10).cgPath
      strongSelf.shadowLayer.fillColor = UIColor.white.cgColor
      strongSelf.shadowLayer.shadowColor = UIColor.black.cgColor
      strongSelf.shadowLayer.shadowPath = strongSelf.shadowLayer.path
      strongSelf.shadowLayer.shadowOffset = .zero
      strongSelf.shadowLayer.shadowOpacity = 0.2
      strongSelf.shadowLayer.shadowRadius = strongSelf.shadowRadius
      strongSelf.cellContainer.layer.insertSublayer(strongSelf.shadowLayer, at: 0)
    }

```
# 📋 TableView
## TableViewCell
Comes with an embeded **contentView** inside the **cell**, it's size must not be edited, as it is done manually by the API.
# 💻 Setup without Storyboards
### First
Remove the **Main interface** from the *Deployment Info* section
### Second
Navigate inside the **info.plist** file.\
Information Property List
- Application Scene Manifest
  - Scene Configuration
    - Application Session Role
      - Item 0 (Default Configuration)
        -  **Storyboard Name**, delete its dictionary record (Minus button when clicked)
### Finally
Inside the **SceneDelegate.swift** file write this code in the **func scene(scene:willConnectTo:options)** method. In a nutshell, you create a new *window* with the *UIWindow* object, then set its scene with the windowScene already unwrapped, set its main view controller and make it visible.
```swift
guard let windowScene = (scene as? UIWindowScene) else { return }
window = UIWindow(frame: windowScene.coordinateSpace.bounds)
window?.windowScene = windowScene
window?.rootViewController = ViewController()
window?.makeKeyAndVisible()
```

# 📱 User Defaults
Used for saving minor data in the user's device. Data is located using a **forKey** as unique id in UserDefaults. It should **not** be used for **large/complex/sensitive** data, like images, it's **not secure** will slow the application launch with large data. Keychain is an option though. Models must conform **Codable** in order to code it's data into a JSON type.
#### Aimed for:
✅ User Settings\
✅ Program Settings\
Writing to UserDefaults can be done in multiple ways for different value-types, but the most common is the **object-type**.\
For the **JSON** approach, **Person** will have to conform **Codable**
```swift
class Person: Codable { 
    var name: String
    var image: String
    init(name: String, image: String) { 
        self.name = name
        self.image = image
    }
}
```
For the **NSSKeyedArchive/Unarchived** approach, **Person** will have to conform **NSObject, NSCoding and NSSecureCoding**. This approach allows **objc compatibility**.
```swift
class Person: NSObject, NSCoding, NSSecureCoding { 
    static var supportSecureCoding: Bool = true
    var name: String
    var image: String
    init(name: String, image: String) { 
        self.name = name
        self.image = image
    }
    // Required methods to conform the protocols
    required init?(coder: NSCoder) { 
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    func encode(with coder: NSCoder) { 
        coder.encode(self.name, forKey: "name")
        coder.encode(self.image, forKey: "image")
    }
}
```
And here is a new instance, an array of Person with only one element, example sake
```swift
let people = [Person(name: "Leonardo", image: "/Some/User/Image/Path")]
```

## Writing to UserDefaults 
```swift
UserDefaults.standard.set(SomeObject, forKey: "custom-key")
```
### JSON Encoder
Encode the data type into JSON format and then save it in UserDefaults under a key.
```swift
if let data = JSONEncoder().encode(people) {
    UserDefaults.standard.set(data, forKey: "people")
}
```
### NSKeyedArchiver
Will transform any **object value-type** to a **data value-type** in order to safe to UserDefaults
```swift
let archive = try NSKeyedArchiver.archiveData(withRootObject: people, requiringSecureCoding: false)
    UserDefaults.standard.set(archive, forKey: "people")
```
## Reading from UserDefaults 
```swift
UserDefaults.standard.object(forKey: "people") as? Data
```
### JSON Decoder
Read user defaults by key, then decode it into it's corresponding data-type structure.
```swift
if let loadedData = UserDefaults.standard.data(forKey: "people") { 
    if let decodedData = JSONDecoder().decode([Person].self, from loadedData) {
        self.people = decodedData
    }
}
```
### NSKeyedUnarchiver
Find the object in UserDefaults by key, cast it to **Data** and then unarchive it.\
The **ofClassed** must contain **NSString.self, CustomObject.self, and all other NS types in the model**, or else it will result in console warnings of future deprecation.
```swift
let data = UserDefaults.standard.object(forKey: "people") as? Data
let unarchivedData = NSKeyedUnarchiver.unarchivedObject(ofClasses: [Person.self, NSArray.self, NSString.self], from: data) as? [Person]
self.people = unarchivedData
```

# 🚦 Grand Central Dispatch (GCD)
Optimize application support for Multi-core systems, by using different threads, and creating  **4 different QoS (Quality of Service) queues**. Which have different priorities for different multi-thread needs. The **default** queue **higher** than **Utiliy** but **lower** than **User Initiated**. [HackingWithSwift reference](https://www.hackingwithswift.com/read/9/3/gcd-101-async).

## 1️⃣ User Interactive
Highest priority background thread. Should be used for work that is **important to keep the user interface (UI) working**.  
i.e.: *Automatic API request on a view, that a dashboard depends on.*
## 2️⃣ User Initiated
Should be used to execute **tasks requested by the user**, which will be waiting for them to execute in order to continue using the app.  
i.e.: *Tapping on a button.*
## 3️⃣ Utility
For **long-running tasks** that the user is aware of, but **doesn't desperate needs it done quick** and can continue doing other stuff on the app.  
i.e.: *Uploading files into Mega*.
## 4️⃣ Background 
For **long-running tasks** that the user isn't aware of, nor cares when completed. **Not important for the user**.  
i.e.: *Sending statistical app information*
## DispatchQueue
```swift
DispatchQueue.global(qos: .userInitiated).async {
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            self.parse(json: data)
            return
        }
    }
}
```
## PerformSelector
Try not to call inside a Dispatch queue
```swift
performSelector(inBackground: #selector(fetchData), with: url)
performSelector(onMainThread: #selector(fetchData), with: nil, waitUntilDone: false)
```
