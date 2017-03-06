import UIKit
import AutoLayout

public class TextFieldTableViewCell: UITableViewCell {
    public var textFieldLeftLayoutConstraint: NSLayoutConstraint!
    public let textField = UITextField(frame: .zero)

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        contentView.addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        let insets = UIEdgeInsets(top: 0, left: separatorInset.left+1, bottom: 0, right: 0)
        let constraints = NSLayoutConstraint.constraintsWithSubview(textField, superview: contentView, insets: insets)
        textFieldLeftLayoutConstraint = constraints[1]
        NSLayoutConstraint.activateConstraints(constraints)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITableView {
    public func textFieldForRowAtIndexPath(indexPath: NSIndexPath) -> UITextField? {
        return (cellForRowAtIndexPath(indexPath) as! TextFieldTableViewCell?)?.textField
    }
}
