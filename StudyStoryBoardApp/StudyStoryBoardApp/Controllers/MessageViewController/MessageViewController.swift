//
//  MessageViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 07.01.2023.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: identifierMessageViewCOntroller)
    }
    
    let identifierMessageViewCOntroller = "identifierMessageViewCOntroller"

}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifierMessageViewCOntroller, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        cell.configurationCell(friend: friends[indexPath.section], group: nil, isLast: true, isFirst: true, isMessage: true)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friends.count
    }
    
    
}
