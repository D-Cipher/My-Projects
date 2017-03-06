import UIKit
import UIButtonBackgroundColor

class WelcomeViewController: UIViewController {
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orangeColor()
        
        /*
        let logoLabel = UILabel(frame: CGRect(x: 0, y: 44, width: view.frame.width, height: 60))
        logoLabel.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin, .FlexibleBottomMargin]
        logoLabel.font = UIFont.boldSystemFontOfSize(72)
        logoLabel.text = "Chats"
        logoLabel.textAlignment = .Center
        logoLabel.textColor = .whiteColor()
        view.addSubview(logoLabel)

        let taglineLabel = UILabel(frame: CGRect(x: 0, y: 150, width: view.frame.width, height: 30))
        taglineLabel.autoresizingMask = logoLabel.autoresizingMask
        taglineLabel.font = UIFont.boldSystemFontOfSize(24)
        taglineLabel.text = "Chat with Friends"
        taglineLabel.textAlignment = .Center
        taglineLabel.textColor = .whiteColor()
        view.addSubview(taglineLabel)
        */
        
        let logoImage = UIImage(named: "penpal_clear")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.frame = CGRect(x: (view.frame.width/2)-150, y: (view.frame.height/2)-248, width: 300, height: 300)
        view.addSubview(logoImageView)
        
        let continueAsGuestButton = UIButton(type: .Custom)
        continueAsGuestButton.addTarget(account, action: #selector(Account.continueAsGuest), forControlEvents: .TouchUpInside)
        continueAsGuestButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
        continueAsGuestButton.frame = CGRect(x: (view.frame.width/2)-150, y: (view.frame.height/2)+30, width: 300, height: 60)
        continueAsGuestButton.setTitleColor(.whiteColor(), forState: .Normal)
        continueAsGuestButton.setTitleColor(.whiteColor(), forState: .Highlighted)
        continueAsGuestButton.setTitle("Pen-pals", forState: .Normal)
        continueAsGuestButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 50)
        view.addSubview(continueAsGuestButton)

        let signUpButton = UIButton(type: .Custom)
        signUpButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleWidth]
        signUpButton.setBackgroundColor(.orangeColor(), forState: .Normal)
        signUpButton.frame = CGRect(x: 0, y: view.frame.height-128, width: view.frame.width, height: 64)
        signUpButton.titleLabel?.font = UIFont.boldSystemFontOfSize(32)
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.addTarget(self, action: #selector(WelcomeViewController.signUpLogInAction(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(signUpButton)

        let logInButton = UIButton(type: .Custom)
        logInButton.tag = 1
        logInButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleWidth]
        logInButton.setBackgroundColor(.blueColor(), forState: .Normal)
        logInButton.frame = CGRect(x: 0, y: view.frame.height-64, width: view.frame.width, height: 64)
        logInButton.titleLabel?.font = UIFont.boldSystemFontOfSize(32)
        logInButton.setTitle("Facebook Login", forState: .Normal)
        logInButton.addTarget(self, action: #selector(WelcomeViewController.signUpLogInAction(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(logInButton)
    }

    // MARK: - Actions

    func signUpLogInAction(button: UIButton) {
        let tableViewController = button.tag == 0 ? SignUpTableViewController() : LogInTableViewController()
        let navigationController = UINavigationController(rootViewController: tableViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
