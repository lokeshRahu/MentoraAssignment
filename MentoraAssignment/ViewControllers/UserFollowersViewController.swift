//
//  UserFollowersViewController.swift
//  GitHubUserSearch
//
//  Created by Lokesh Lebaka on 18/09/22.
//

import UIKit
import SVProgressHUD

class UserFollowersViewController: UIViewController {

    @IBOutlet weak var followersTableView: UITableView!
    
    var isFollowersShown: Bool?
    var activeUser: User?

    var usersArray: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = isFollowersShown == true ? "Followers" : "Following"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fectchUserFollowersDetailsFromGitHub()
    }
    
    func fectchUserFollowersDetailsFromGitHub() {
        
        if ReachabilityManager.shared.isReachable() == true {
            
            view.isUserInteractionEnabled = false
            SVProgressHUD.show(withStatus: "Fetching \(activeUser?.userName ?? "") details...")
            let url = isFollowersShown == true ? activeUser?.followers_url : activeUser?.followers_url?.replacingOccurrences(of: "followers", with: "following")
            
            UserManagerAPI.shared.getUserFollowersDetails(url: url!, completion: { [weak self] (error, users) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    if error == nil {
                        strongSelf.usersArray = users
                        strongSelf.view.isUserInteractionEnabled = true
                        SVProgressHUD.dismiss()
                        strongSelf.followersTableView.reloadData()
                    } else {
                        strongSelf.showAlert(message: error.debugDescription)
                    }
                }
            })
        } else {
            showAlert(message: "No internet connection.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "GitHub", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension UserFollowersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if usersArray.count == 0 {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = isFollowersShown == true ? "No followers" : "No Following"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.font          = UIFont.systemFont(ofSize: 20)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
        
        tableView.backgroundView  = nil
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = followersTableView.dequeueReusableCell(withIdentifier: "searchResultsUserCell", for: indexPath) as? UserDisplayTableViewCell else {
            fatalError("AddAttendeeTableViewCell not found.")
        }
        cell.setUpUserCell(user: usersArray[indexPath.row])
        return cell
    }
}

// MARK: Factory method

extension UserFollowersViewController {
    static func createViewController() -> UserFollowersViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "UserFollowersViewController") as? UserFollowersViewController
    }
}

