import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let request = UserInfoRequest(userID: "89757") { (result) in
            //
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }
        HTTPClient.shared.startRequest(request)
    }

}

