import XCTest
import Alerts

class UIAlertControllerTests: XCTestCase {
    func testAlert() {
        assertOKAlert(UIAlertController.alert(title: title, message: message))
    }

    func testAlertError() {
        assertOKAlert(UIAlertController.alertError(error))
    }

    func testConfirm() {
        assertYesNoAlert(UIAlertController.confirm(title: title, message: message, handler: { _ in }))
    }
}
