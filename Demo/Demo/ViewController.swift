import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        getUserList()
        //
        getUserInfo(userID: "354287")
    }
    
    // 根据userID获取用户信息
    func getUserInfo(userID: String) {
        //
        let request = UserInfoRequest(userID: userID) { (result) in
            //
            print(Thread.isMainThread)
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }
        HTTPClient.shared.startRequest(request)
    }
    
    // 获取用户列表
    func getUserList() {
        //
        let request = UserListRequest { (result) in
            //
            print(Thread.isMainThread)
            switch result {
            case .success(let users):
                print(users)
            case .failure(let error):
                print(error)
            }
        }
        HTTPClient.shared.startRequest(request)
    }
    
}

