# 🚦Grand Central Dispatch (GCD)

Optimize application support for Multi-core systems, by using different threads, and creating  **4 different QoS (Quality of Service) queues**. Which have different priorities for different multi-thread needs. [HackingWithSwift reference](https://www.hackingwithswift.com/read/9/3/gcd-101-async).

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
### Try not to call inside a Dispatch queue
```swift
performSelector(inBackground: #selector(fetchData), with: url)
performSelector(onMainThread: #selector(fetchData), with: nil, waitUntilDone: false)
```
