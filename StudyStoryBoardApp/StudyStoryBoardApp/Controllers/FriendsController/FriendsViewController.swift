//
//  FriendsViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit

class FriendsViewController: UIViewController {
    
    let myFriends = [
        "Dmitry Rogozin",
        "Paul Walker",
        "Susan Coffey",
        "Somato Dope",
        "Kate Anderson"
    ]
    
    var indexCell = 0
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showAlbum" else { return }
        guard let destination = segue.destination as? AlbumUserViewController
        else { return }
        destination.name = myFriends[indexCell]
    }
    
    deinit {
        print("Delete FriendsController")
    }

}


extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Количество строк ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends.count
    }
    
    // Количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Создание и конфигурация ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsViewControllerIdentifier, for: indexPath) as? CustomTableViewCell
        else { return UITableViewCell() }
        
        guard let img = UIImage(named: myFriends[indexPath.row])
        else { return cell }
    
        cell.configurationCell(photo: img, fullName: myFriends[indexPath.row])
        
        return cell
    }
    
    // Убираем выделение ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        indexCell = indexPath.row
        performSegue(withIdentifier: "showAlbum", sender: nil)
    }
    
}
