# TextFieldTableViewCell

`UITableViewCell` with a `UITextField` inside

Setup: [How to add a Git repository to your Xcode project][1]

Dependencies:

* [AutoLayout][2]

Usage:

```swift
import UIKit

class EnterEmailTableViewController: UITableViewController, UITextFieldDelegate {
    convenience init() {
        self.init(style: .Grouped)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneAction")
        title = "Enter Email"
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldCell")
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        // cell.textFieldLeftLayoutConstraint.constant = tableView.separatorInset.left + 10 // custom layout
        let textField = cell.textField
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
        textField.clearButtonMode = .WhileEditing
        textField.delegate = self
        textField.keyboardType = .EmailAddress
        textField.placeholder = "Email"
        textField.returnKeyType = .Done
        textField.becomeFirstResponder()
        return cell
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doneAction()
        return false
    }

    // MARK: - Actions

    func doneAction() {
        let email = tableView.textFieldForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!.text!
        .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        print("Email entered: \(email)")
    }
}
```

Released under the [Unlicense][2].


  [1]: https://github.com/acani/Libraries
  [2]: https://github.com/acani/AutoLayout
  [3]: http://unlicense.org
