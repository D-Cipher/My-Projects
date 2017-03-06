import XCTest
import Alerts

class UIViewControllerTests: XCTestCase {
    var mockViewController = MockViewController()
    class MockViewController: UIViewController {
        var alert: UIAlertController?
        override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
            alert = viewControllerToPresent as? UIAlertController
        }
    }

    func testAlert() {
        mockViewController.alert(title: title, message: message)
        assertOKAlert(mockViewController.alert!)
    }

    func testAlertError() {
        mockViewController.alertError(error)
        assertOKAlert(mockViewController.alert!)
    }

    func testConfirm() {
        mockViewController.confirm(title: title, message: message, handler: { _ in })
        assertYesNoAlert(mockViewController.alert!)
    }
}
