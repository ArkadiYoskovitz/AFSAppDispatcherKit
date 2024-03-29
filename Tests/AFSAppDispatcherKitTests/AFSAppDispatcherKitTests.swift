import XCTest
@testable import AFSAppDispatcherKit

final class AFSAppDispatcherKitTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut : TestAppDelegate!

    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        sut = TestAppDelegate()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Test doubles
    
    class TestAppDelegate : AFSApplicationDelegateDispatcher {
        
        var didFinishLaunchingCalled = 0
        let service : TestService
        
        override init() {
            didFinishLaunchingCalled = 0
            service = TestService()
        }
        override func obtainServices() -> [AFSApplicationDelegateService] {
            return [service]
        }
        
        override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            didFinishLaunchingCalled += 1
            return false
        }
    }
    class TestService     : NSObject , AFSApplicationDelegateService {
    
        var willFinishLaunchingCalled : Int = 0
        var  didFinishLaunchingCalled : Int = 0
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            willFinishLaunchingCalled += 1
            return true
        }
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            didFinishLaunchingCalled += 1
            return false
        }
        
        override func responds(to aSelector: Selector!) -> Bool {
            if aSelector == #selector(UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)) {
                return false
            } else {
                return super.responds(to: aSelector)
            }
        }
    }
    
    // MARK: Tests - List
    
    static var allTests = [
        ("testDispatchToServiceWorksSuccess" , testDispatchToServiceWorksSuccess),
        ("testDispatchToServiceWorksFailure" , testDispatchToServiceWorksFailure),
        ("testDispatchToSubclassWorksSuccess", testDispatchToSubclassWorksSuccess),
    ]
    
    // MARK: Tests
    func testDispatchToServiceWorksSuccess() {
        // given
        let service = sut.service
        // When
        _ = sut.application(UIApplication.shared, willFinishLaunchingWithOptions: [:])
        // Then
        XCTAssert(service.willFinishLaunchingCalled == 1, "willFinishLaunchingCalled should be one")
    }
    
    func testDispatchToServiceWorksFailure() {
        // given
        let service = sut.service
        // When
        _ = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
        // Then
        XCTAssert(service.didFinishLaunchingCalled == 0, "didFinishLaunchingCalled should be zero")
    }
    func testDispatchToSubclassWorksSuccess() {
        // given
        
        // When
        _ = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
        // Then
        XCTAssert(sut.didFinishLaunchingCalled == 1, "didFinishLaunchingCalled should be one")
    }
}
