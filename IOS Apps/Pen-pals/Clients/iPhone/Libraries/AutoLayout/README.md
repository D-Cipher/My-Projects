# AutoLayout

Auto Layout helper methods

Setup: [How to add a Git repository to your Xcode project][1]

Usage:

* Initialize a constraint with optional arguments

    Give `view1` a width of 100

    ```swift
    let constraint = NSLayoutConstraint(item: view1, attribute: .Width, constant: 100)
    ```

    Make the tops of `view1` & `view2` equal

    ```swift
    let constraint = NSLayoutConstraint(item: view1, attribute: .Top, item: view2)
    ```

* Create constraints for a subview with insets

    ```swift
    let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    let constraints = NSLayoutConstraint.constraintsWithSubview(textField, subview: contentView, insets: insets)
    NSLayoutConstraint.activateConstraints(constraints)
    ```

Released under the [Unlicense][2].


  [1]: https://github.com/acani/Libraries
  [2]: http://unlicense.org
