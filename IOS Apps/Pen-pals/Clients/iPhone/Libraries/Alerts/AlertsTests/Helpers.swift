import XCTest

let title = "title", message = "message"
let error = NSError(domain: "domain", code: 1, userInfo: [NSLocalizedDescriptionKey: title, NSLocalizedRecoverySuggestionErrorKey: message])

func assertOKAlert(alert: UIAlertController) {
    XCTAssertEqual(alert.title, title)
    XCTAssertEqual(alert.message, message)
    XCTAssertEqual(alert.actions[0].title, "OK")
}

func assertYesNoAlert(alert: UIAlertController) {
    XCTAssertEqual(alert.title, title)
    XCTAssertEqual(alert.message, message)
    XCTAssertEqual(alert.actions[0].title, "No")
    XCTAssertEqual(alert.actions[1].title, "Yes")
}
