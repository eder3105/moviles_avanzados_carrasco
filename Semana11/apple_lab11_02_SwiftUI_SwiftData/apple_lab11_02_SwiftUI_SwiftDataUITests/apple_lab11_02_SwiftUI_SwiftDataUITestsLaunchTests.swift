//
//  apple_lab11_02_SwiftUI_SwiftDataUITestsLaunchTests.swift
//  apple_lab11_02_SwiftUI_SwiftDataUITests
//
//  Created by Tecsup on 5/11/26.
//

import XCTest

final class apple_lab11_02_SwiftUI_SwiftDataUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
