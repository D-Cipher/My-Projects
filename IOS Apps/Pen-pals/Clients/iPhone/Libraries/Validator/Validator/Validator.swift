import Foundation.NSCharacterSet

private let invalidNameMessage      = " name must be between 1 & 50 characters."
public  let invalidFirstNameMessage = "First" + invalidNameMessage
public  let invalidLastNameMessage  = "Last" + invalidNameMessage
public  let invalidUsernameMessage  = "Username must be alphanumeric and between 5 & 15 characters."
public  let invalidCodeMessage      = "Code must be 4 digits."
public  let invalidEmailMessage     = "Email must contain an at sign (@) and be between 3 & 254 characters."

extension String {
    public func strip() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    public var isAlphanumeric: Bool {
        return !isEmpty && rangeOfString("[^a-zA-Z0-9]", options: .RegularExpressionSearch) == nil
    }

    public var isNumeric: Bool {
        return !isEmpty && rangeOfString("[^0-9]", options: .RegularExpressionSearch) == nil
    }

    public var isValidName: Bool {
        return 1...50 ~= characters.count
    }

    public var isValidUsername: Bool {
        return 5...15 ~= characters.count && isAlphanumeric
    }

    public var isValidEmail: Bool {
        return 3...254 ~= characters.count && characters.contains("@")
    }

    public var isValidCode: Bool {
        return characters.count == 4 && isNumeric
    }
}
