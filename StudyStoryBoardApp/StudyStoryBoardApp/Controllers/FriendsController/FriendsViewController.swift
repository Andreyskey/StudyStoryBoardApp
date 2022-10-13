//
//  FriendsViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class FriendsViewController: UIViewController {
    
    // Идентификатор ячейки
    let friendsViewControllerIdentifier = "friendsViewControllerIdentifier"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self // Делегируем выполнение контроллеру в котором находится TableView
            tableView.dataSource = self // Указывваем контрллер как источник данных
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрация ячейки
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: friendsViewControllerIdentifier)
    }

}


extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Количество строк ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Создание и конфигурация ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsViewControllerIdentifier, for: indexPath) as? CustomTableViewCell
        else { return UITableViewCell() }
        
        guard let img = UIImage(named: "pers") else { return cell }
        
        cell.configurationCell(photo: img, fullName: "Anton Volkov")
        
        return cell
    }
    
}
