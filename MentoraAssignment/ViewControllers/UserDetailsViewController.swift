//
//  UserDetailsViewController.swift
//  GitHubUserSearch
//
//  Created by Lokesh Lebaka on 17/09/22.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet var userDetailsTableView: UITableView!
    
    var activeUser: User?
    var isFollowersShown: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (activeUser?.login ?? "User") + "'s details"
        
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeUser != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = userDetailsTableView.dequeueReusableCell(withIdentifier: "UserDisplayTableViewCell", for: indexPath) as? UserDisplayTableViewCell else {
            fatalError("AddAttendeeTableViewCell not found.")
        }
        cell.setUpUserCell(user: activeUser!)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK:- UserDisplayTableViewCellProtocol
extension UserDetailsViewController: UserDisplayTableViewCellProtocol {
    func shareUserDetails(_ message: String) {
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func navigateIndication(view: ButtonTags) {
        if view.rawValue == 0 {
            isFollowersShown = true
        } else {
            isFollowersShown = false
        }
        performSegue(withIdentifier: "toFollowersScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFollowersScreen" {
            let destinationVC = segue.destination as! UserFollowersViewController
            destinationVC.activeUser = activeUser
            destinationVC.isFollowersShown = isFollowersShown
        }
    }
}

// MARK: Factory method

extension UserDetailsViewController {
    static func createViewController() -> UserDetailsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as? UserDetailsViewController
    }
}


extension UIView {

    func applyGradient(colours: [UIColor], cornerRadius: CGFloat?, startPoint: CGPoint, endPoint: CGPoint)  {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        if let cornerRadius = cornerRadius {
            gradient.cornerRadius = cornerRadius
        }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.colors = colours.map { $0.cgColor }
        self.layer.insertSublayer(gradient, at: 0)
    }
}

