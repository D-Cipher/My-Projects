import UIKit

extension UIViewController {
    public func alert(title title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController.alert(title: title, message: message, handler: handler)
        presentViewController(alert, animated: true, completion: nil)
    }

    public func alertError(error: NSError, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController.alertError(error, handler: handler)
        presentViewController(alert, animated: true, completion: nil)
    }

    public func confirm(title title: String?, message: String?, handler: (UIAlertAction) -> Void) {
        let alert = UIAlertController.confirm(title: title, message: message, handler: handler)
        presentViewController(alert, animated: true, completion: nil)
    }
}
