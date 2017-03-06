# Alerts

Alert & confirm methods for `UIViewController`

Setup: [How to add a Git repository to your Xcode project][1]

Usage:

* `UIViewController.alert()`

    ```swift
    alert(title: "Alert", message: "This is an alert with an OK button.")
    ```

    ```swift
    alert(title: "Alert", message: "This is an alert with an OK button.") { _ in
        // Code here runs after the user has tapped OK.
    }
    ```

* `UIViewController.alertError()`

    ```swift
    alertError(error: error)
    ```

    ```swift
    alertError(error: error) { _ in
        // Code here runs after the user has tapped OK.
    }
    ```

* `UIViewController.confirm()`

    ```swift
    confirm(title: "Confirm", message: "This is an alert with No & Yes buttons.")
    ```

    ```swift
    confirm(title: "Confirm", message: "This is an alert with No & Yes buttons.") { _ in
        // Code here runs after the user has tapped Yes.
    }
    ```

Released under the [Unlicense][2].


  [1]: https://github.com/acani/Libraries
  [2]: http://unlicense.org
