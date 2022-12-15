//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher
import RxSwift

class AccountViewController: UIViewController {

	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
    
    let userViewModel: UserViewModel = UserViewModel()
    let disposeBag = DisposeBag()
    
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        self.configureViewForLogin()
        self.callBacks()
    }
    
    @IBAction func logoutButtonTap(_ sender: UIButton) {
        Utility.clearAllLocalData()
        self.configureViewForLogin()
    }
	
	@IBAction func loginButtonTap(_ sender: UIButton) {
        let loginViewController = LoginViewController()
        loginViewController.userViewModel = userViewModel
        loginViewController.modalPresentationStyle = .overFullScreen
        self.present(loginViewController, animated: true, completion: nil)
	}
    
    private func configureUserData(_ user: UserModel?) {
        if let user = user {
            self.nameLabel.text = user.userName ?? ("Username")
            self.daysLabel.text = user.displayCreatedAt
            if let imagePath = user.userProfileUrl, let url = URL(string: imagePath) {
                self.headImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "Avatar"),
                    options: [
                        .cacheOriginalImage,
                        .transition(.fade(0.25))
                    ]
                )
            }
        }
    }
    
    private func configureViewForLogin() {
        let user = UserService.getUser()
        let isLogged: Bool = user != nil
        nonLoginView.isHidden = isLogged
        loginView.isHidden = !isLogged
        if isLogged {
            self.configureUserData(user)
        }
    }
    
    private func callBacks() {
        userViewModel.model.asObservable()
            .bind { model in
                if model != nil {
                    self.configureViewForLogin()
                }
            }
            .disposed(by: disposeBag)
    }
	
}
