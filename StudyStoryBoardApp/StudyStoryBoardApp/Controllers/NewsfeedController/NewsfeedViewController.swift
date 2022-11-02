//
//  NewsfeedViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 01.11.2022.
//

import UIKit

class NewsfeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let newsfeedViewControllerIdentificator = "newsfeedViewControllerIdentificator"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: newsfeedViewControllerIdentificator)
    }
    

}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postOne.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newsfeedViewControllerIdentificator, for: indexPath) as? PostTableViewCell
        else { return UITableViewCell() }
        
        cell.configurate(post: postOne[indexPath.row], indexPath: indexPath.row)
        
        return cell
    }
    
}
