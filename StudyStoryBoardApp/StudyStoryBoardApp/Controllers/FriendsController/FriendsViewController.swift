//
//  FriendsViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 14.10.2022.
//

import UIKit
import Alamofire
import RealmSwift

class FriendsViewController: UIViewController {
    
    // Идентификатор ячейки
    let friendsViewControllerIdentifier = "friendsViewControllerIdentifier"
    let realm = try! Realm()
    let refresh = UIRefreshControl()
    var friends = [ProfileItem]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self // Делегируем выполнение контроллеру в котором находится TableView
        tableView.dataSource = self // Указывваем контрллер как источник данных
        
        refresh.addTarget(self, action: #selector(refrashDataBase), for: .valueChanged)
        tableView.addSubview(refresh)
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: friendsViewControllerIdentifier)
        
        refresh.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refrashDataBase()
    }
    
    @objc func refrashDataBase() {
        ServiseAPI().getRequestFriends {
            if let profiles = self.realm.objects(Profiles.self).first?.items {
                self.friends = Array(profiles)
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    
    func letter(array: [ProfileItem]) -> [String] {
        var letters = [String]()
        for item in array {
            let letter = String(item.firstName.prefix(1))
            if !letters.contains(letter) {
                letters.append(letter)
            }
        }
        return letters.sorted()
    }
    
    func arrayByLetter(letter: String) -> [ProfileItem] {
        var result = [ProfileItem]()
        for item in friends {
            let letterItem = String(item.firstName.prefix(1))
            if letterItem ==  letter {
                result.append(item)
            }
        }
        return result
    }
}


extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Количество строк ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayByLetter(letter: letter(array: friends)[section]).count
    }
    
    // Количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return letter(array: friends).count
    }
    
    // Создание и конфигурация ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsViewControllerIdentifier, for: indexPath) as? CustomTableViewCell
        else { return UITableViewCell() }
        
        let arrayItems = arrayByLetter(letter: letter(array: friends)[indexPath.section])
        
        cell.configurationCell(object: arrayItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let albumVC = storyboard.instantiateViewController(identifier: "AlbumUserViewController") as? AlbumUserViewController
        else { return }
        
        albumVC.userId = arrayByLetter(letter: letter(array: friends)[indexPath.section])[indexPath.row]
        
        show(albumVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let font = UIFont(name: "MullerMedium", size: 16),
              let header = view as? UITableViewHeaderFooterView
        else {
            print(UIFont.fontNames(forFamilyName: "Muller"))
            fatalError("Don't find font")
        }
        var headerConfig = UIListContentConfiguration.groupedHeader()
        headerConfig.text = letter(array: friends)[section].uppercased()
        headerConfig.textProperties.font = font
        headerConfig.textProperties.color = .black
        headerConfig.textProperties.adjustsFontForContentSizeCategory = true
        header.contentConfiguration = headerConfig
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return letter(array: friends)[section].uppercased()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
}
