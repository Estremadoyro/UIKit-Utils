import UIKit

protocol RequestProtocol {
  var network: RequestEndpoint { get set }
  var mock: RequestEndpoint { get set }
}

// Requets Endpoints
protocol RequestEndpoint {
  func getAnimesForUserByDate()
}

// Mock & Network managers
final class NetworkManager: RequestEndpoint {
  func getAnimesForUserByDate() {
    print("Make network call")
  }
}

struct MockManager: RequestEndpoint {
  func getAnimesForUserByDate() {
    print("Load mock from Bundle")
  }
}

final class RequestsManager: RequestProtocol {
  lazy var network: RequestEndpoint = NetworkManager()
  lazy var mock: RequestEndpoint = MockManager()
}

protocol ScreenVC: UIViewController {
  var requestsManager: RequestProtocol { get set }

  func configureNavigationItems()
  func configureRightNavigationItems()
  func configureLeftNavigationItems()
}

final class HomeVC: UIViewController, ScreenVC {
  var requestsManager: RequestProtocol

  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureNavigationItems() {}
  func configureRightNavigationItems() {}
  func configureLeftNavigationItems() {}
}

// Wrap ViewController
final class RootScreenWrapper {
  private let rootVC: ScreenVC

  init(rootVC: ScreenVC) {
    self.rootVC = rootVC
  }

  func wrapRootVC() -> UIViewController {
    return UINavigationController(rootViewController: rootVC)
  }
}

// Product Interface
protocol Boot {
  var rootVC: ScreenVC { get set }
  var requestsManager: RequestProtocol { get set }

  func createRootScreen() -> UIViewController
}

// Products
final class DevelopBoot: Boot {
  internal lazy var requestsManager: RequestProtocol = RequestsManager()
  internal lazy var rootVC: ScreenVC = HomeVC(requestsManager: requestsManager)

  func createRootScreen() -> UIViewController {
    let wrapper = RootScreenWrapper(rootVC: rootVC)
    let wrappedVC = wrapper.wrapRootVC()
    return wrappedVC
  }
}

final class ProductionBoot: Boot {
  internal lazy var requestsManager: RequestProtocol = RequestsManager()
  internal lazy var rootVC: ScreenVC = HomeVC(requestsManager: requestsManager)

  func createRootScreen() -> UIViewController {
    let rootVC = UINavigationController(rootViewController: self.rootVC)
    return rootVC
  }
}

@frozen enum BootType {
  case develop
  case production
}

// Factory
final class BootFactory {
  func getBoot(_ bootType: BootType) -> Boot {
    switch bootType {
      case .develop:
        return DevelopBoot()
      case .production:
        return ProductionBoot()
    }
  }
}

// Client
final class SessionDelegate {
  var rootVC: UIViewController?

  func configureRootVC() {
    let bootFactory = BootFactory()
    let boot: Boot = bootFactory.getBoot(.develop)
    rootVC = boot.createRootScreen()
  }
}

// Test
let session = SessionDelegate()
session.configureRootVC()
if let sessionVC = session.rootVC {
  print("Session's VC: \(sessionVC)")
}
