import UIKit

extension NSLayoutConstraint {
    public convenience init(item item1: AnyObject, attribute attribute1: NSLayoutAttribute, relation: NSLayoutRelation = .Equal, item item2: AnyObject? = nil, attribute attribute2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        let attribute = item2 == nil ? .NotAnAttribute : (attribute2 ?? attribute1)
        self.init(item: item1, attribute: attribute1, relatedBy: relation, toItem: item2, attribute: attribute, multiplier: multiplier, constant: constant)
    }

    public class func constraintsWithSubview(subview: UIView, superview: UIView, insets: UIEdgeInsets, localized: Bool = true) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: subview, attribute: .Top, item: superview, constant: insets.top),
            NSLayoutConstraint(item: subview, attribute: (localized ? .Leading : .Left), item: superview, constant: insets.left),
            NSLayoutConstraint(item: subview, attribute: .Bottom, item: superview, constant: -insets.bottom),
            NSLayoutConstraint(item: subview, attribute: (localized ? .Trailing : .Right), item: superview, constant: -insets.right)
        ]
    }
}
