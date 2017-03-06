import UIKit

extension UIAlertController {
    public static func alert(title title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: handler))
        return alert
    }

    public static func alertError(error: NSError, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        return UIAlertController.alert(title: error.localizedDescription, message: error.localizedRecoverySuggestion, handler: handler)
    }

    public static func confirm(title title: String?, message: String?, handler: (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: handler))
        return alert
    }
}
