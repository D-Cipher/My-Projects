import XCTest
import TextFieldTableViewCell

class TextFieldTableViewCellTests: XCTestCase {
    let textFieldTableViewController = TextFieldTableViewController(style: .Grouped)

    func testInitWithStyleReuseIdentifier() {
        let tableView = textFieldTableViewController.tableView
        let cell = textFieldTableViewController.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! TextFieldTableViewCell
        XCTAssertEqual(cell.selectionStyle, UITableViewCellSelectionStyle.None)
        XCTAssertEqual(cell.textField.superview, cell.contentView)
        XCTAssertFalse(cell.textField.translatesAutoresizingMaskIntoConstraints)

        // TODO: Test specific constraints
        // I think I did this in chats somewhere
        // I think I have generic code to test constraints

    }

    func testTextFieldForRowAtIndexPath() {
        let tableView = textFieldTableViewController.tableView
        let indexPath = NSIndexPath(forRow: 1, inSection: 0)
        textFieldTableViewController.tableView(tableView, cellForRowAtIndexPath: indexPath) as! TextFieldTableViewCell
        let textField = tableView.textFieldForRowAtIndexPath(indexPath)
        XCTAssertEqual(textField?.tag, 1)
    }
}

class TextFieldTableViewController: UITableViewController {
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldCell")
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        cell.textField.tag = indexPath.row
        return cell
    }
}
