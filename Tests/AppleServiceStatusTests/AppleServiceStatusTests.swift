import XCTest
@testable import AppleServiceStatus

final class AppleServiceStatusTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AppleServiceStatus().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
