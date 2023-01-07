//
//  ViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 05.11.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let data = [
        ["11", "12", "13", "14"],
        ["21", "22", "23"],
        ["31", "32", "33", "34", "35"],
        ["41", "42", "43", "44"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.configuration(text: data[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let headerViewSectionBotoom = tableView.headerView(forSection: indexPath.section)?.bottomAnchor,
              let footerViewSectionTop = tableView.footerView(forSection: indexPath.section)?.topAnchor
        else { return }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        tableView.addSubview(view)
        view.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 16).isActive = true
        view.rightAnchor.constraint(equalTo: tableView.rightAnchor, constant: 16).isActive = true
        view.topAnchor.constraint(equalTo: headerViewSectionBotoom, constant: -16).isActive = true
        view.bottomAnchor.constraint(equalTo: footerViewSectionTop, constant: -16).isActive = true
    }
    
    
}
