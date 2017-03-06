import UIKit
import Networking

class Account: NSObject {
    private let AccountAccessTokenKey = "AccountAccessTokenKey"
    dynamic var accessToken: String? {
        get {
            guard let accessToken = api.accessToken else {
                api.accessToken = NSUserDefaults.standardUserDefaults().stringForKey(AccountAccessTokenKey)
                return api.accessToken
            }
            return accessToken
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: AccountAccessTokenKey)
            api.accessToken = newValue
        }
    }
    var chats = [Chat]()
    dynamic var email: String!
    var user: ServerUser!
    dynamic var users = [User]()

    func continueAsGuest() {
        let minute: NSTimeInterval = 60, hour = minute * 60, day = hour * 24
        chats = [
            Chat(user: User(ID: 1, username: "laurenli", firstName: "Lauren", lastName: "Li"), lastMessageText: "Get the message? :p", lastMessageSentDate: NSDate()),
            Chat(user: User(ID: 2, username: "MingmingKo", firstName: "Mingming", lastName: "Ko"), lastMessageText: "You sell the xbox yet?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -5)),
            Chat(user: User(ID: 3, username: "QueenG", firstName: "Queenie", lastName: "Guo"), lastMessageText: "Hey I have something of yours, but I decided to keep it ;)", lastMessageSentDate: NSDate(timeIntervalSinceNow: -minute*12)),
            Chat(user: User(ID: 4, username: "umi_umi", firstName: "Umi", lastName: "Zhou"), lastMessageText: "But, I think you are still the coolest!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*13)),
            Chat(user: User(ID: 5, username: "CathyLi", firstName: "Cathy", lastName: "Li"), lastMessageText: "that's on my mind", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*34)),
            Chat(user: User(ID: 6, username: "AziKoz", firstName: "Azi", lastName: "Koźhoeva"), lastMessageText: "after how many years now!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*2-1)),
            Chat(user: User(ID: 7, username: "TheoryLi", firstName: "Theorina", lastName: "Li"), lastMessageText: "Hey, you found a better one 👍", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*3)),
            Chat(user: User(ID: 8, username: "FayeMing", firstName: "Faye", lastName: "Ming"), lastMessageText: "The movie has a happily ever after?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*4)),
            Chat(user: User(ID: 9, username: "MegQ", firstName: "Meg", lastName: "Qin"), lastMessageText: "that makes me 😊", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*5)),
            Chat(user: User(ID: 10, username: "AndiChang", firstName: "Andi", lastName: "Chang"), lastMessageText: "Tell your mom I said Hi!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*6)),
            Chat(user: User(ID: 11, username: "JayLin", firstName: "Jay", lastName: "Lin"), lastMessageText: "I liked her! She's really genuine person.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*7)),
            Chat(user: User(ID: 12, username: "TinaZhang", firstName: "Tina", lastName: "Zhang"), lastMessageText: "I'm so young and stupid around you guys.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*8)),
            Chat(user: User(ID: 13, username: "CaroLin", firstName: "Carol", lastName: "Lin"), lastMessageText: ":/", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*9)),
            Chat(user: User(ID: 14, username: "ZoeLee", firstName: "Zoe", lastName: "Lee"), lastMessageText: "You believed in me, I'll prove you right !", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*10)),
            Chat(user: User(ID: 15, username: "heba", firstName: "нева", lastName: "Тейнг"), lastMessageText: "Am I still crazy like that?", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 16, username: "cebe", firstName: "северное", lastName: "сияние"), lastMessageText: ":)", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 17, username: "boking", firstName: "Bo", lastName: "King"), lastMessageText: "I'll keep my promise.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 18, username: "cindyLai", firstName: "Cindy", lastName: "Lai"), lastMessageText: "😊", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 19, username: "ChristinaHu", firstName: "Christina", lastName: "Hu"), lastMessageText: "May our paths cross if your in town.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 20, username: "MinJu", firstName: "MinJu", lastName: "Oh"), lastMessageText: "I'll see you... from a far", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            Chat(user: User(ID: 21, username: "HeeYeon", firstName: "Hee", lastName: "Yeon"), lastMessageText: "take care, old friend!", lastMessageSentDate: NSDate(timeIntervalSinceNow: -day*11)),
            /*Chat(user: User(ID: 22, username: "CathyChen", firstName: "Cathy", lastName: "Chen"), lastMessageText: "I have no profile picture or extended ASCII initials.", lastMessageSentDate: NSDate(timeIntervalSinceNow: -hour*24))*/
        ]

        chats[0].loadedMessages = [
            [
                Message(incoming: true, text: "Don't use me in your app 🙄", sentDate: NSDate(timeIntervalSinceNow: -60*60*24*2-60*60)),
                Message(incoming: false, text: "haha! havent talked to you in a long time, but still charming as ever.", sentDate: NSDate(timeIntervalSinceNow: -60*60*24*2))
            ],
            [
                Message(incoming: true, text: "...and your jokes are still so bad.", sentDate: NSDate(timeIntervalSinceNow: -33)),
                Message(incoming: false, text: "Hey! Well that's because you're too slow to get message", sentDate: NSDate(timeIntervalSinceNow: -19))
            ]
        ]

        for chat in chats {
            users.append(chat.user)
            chat.loadedMessages.append([Message(incoming: true, text: chat.lastMessageText, sentDate: chat.lastMessageSentDate)])
        }

        email = "cy@cynonymous.com"
        user = ServerUser(ID: 0, username: "cynonymous", firstName: "Cy", lastName: "nonymous")
        accessToken = "guest_access_token"
    }

    func getMe(viewController: UIViewController) -> NSURLSessionDataTask {
        let request = api.request("GET", "/me", auth: true)
        let dataTask = Net.dataTaskWithRequest(request, viewController, loadingViewType: .None) { JSONObject in
            let dictionary = JSONObject as! Dictionary<String, AnyObject>
            let name = dictionary["name"] as! Dictionary<String, String>
            self.user.serverFirstName = name["first"]!
            self.user.serverLastName = name["last"]!
            self.email = dictionary["email"]! as! String
        }
        dataTask.resume()
        return dataTask
    }

    func patchMe(viewController: UIViewController, firstName: String, lastName: String) -> NSURLSessionDataTask {
        user.firstName = firstName
        user.lastName = lastName
        let request = api.request("PATCH", "/me", ["first_name": firstName, "last_name": lastName], auth: true)
        let dataTask = Net.dataTaskWithRequest(request, viewController, loadingViewType: .None,
            errorHandler: { _ in
                self.user.firstName = self.user.serverFirstName
                self.user.lastName = self.user.serverLastName
            }) { _ in
                self.user.serverFirstName = firstName
                self.user.serverLastName = lastName
        }
        dataTask.resume()
        return dataTask
    }

    func changeEmail(viewController: UIViewController, newEmail: String) -> NSURLSessionDataTask {
        var enterCodeViewController: EnterCodeViewController!
        let request = api.request("POST", "/email", ["email": newEmail], auth: true)
        let dataTask = Net.dataTaskWithRequest(request, viewController,
            backgroundSuccessHandler: { _ in
                enterCodeViewController = EnterCodeViewController(method: .Email, email: newEmail)
            }, mainSuccessHandler: { _ in
                let rootNavigationController = viewController.navigationController!
                let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: enterCodeViewController, action: #selector(EnterCodeViewController.cancelAction))
                enterCodeViewController.navigationItem.leftBarButtonItem = cancelBarButtonItem
                let navigationController = UINavigationController(rootViewController: enterCodeViewController)
                rootNavigationController.presentViewController(navigationController, animated: true, completion: {
                    rootNavigationController.popViewControllerAnimated(false)
                })
            })
        dataTask.resume()
        return dataTask
    }

    func logOut(viewController: UIViewController) -> NSURLSessionDataTask {
        let request = api.request("DELETE", "/sessions", auth: true)
        let dataTask = Net.dataTaskWithRequest(request, viewController, loadingTitle: "Logging Out") { _ in
            self.reset()
        }
        dataTask.resume()
        return dataTask
    }

    func deleteAccount(viewController: UIViewController) -> NSURLSessionDataTask {
        let request = api.request("DELETE", "/me", auth: true)
        let dataTask = Net.dataTaskWithRequest(request, viewController, loadingTitle: "Deleting") { _ in
            self.reset()
        }
        dataTask.resume()
        return dataTask
    }

    func setUserWithAccessToken(accessToken: String, firstName: String, lastName: String) {
        let userIDString = accessToken.substringToIndex(accessToken.endIndex.advancedBy(-33))
        let userID = UInt(Int(userIDString)!)
        user = ServerUser(ID: userID, username: "", firstName: firstName, lastName: lastName)
    }

    func reset() {
        accessToken = nil
        chats = []
        email = nil
        user = nil
        users = []
    }

    func logOutGuest() {
        reset()
    }
}

let AccountDidSendMessageNotification = "AccountDidSendMessageNotification"
