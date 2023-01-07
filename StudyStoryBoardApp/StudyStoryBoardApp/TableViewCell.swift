//
//  TableViewCell.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 05.11.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    func configuration(text: String) {
        label.text = text
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup() {
        var backroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backroundConfig.cornerRadius = 20
        self.backgroundConfiguration = backroundConfig
    }
}
