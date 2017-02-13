//
//  ApproveCellTableViewCell.swift
//  MeetingApp
//
//  Created by Administrator on 10/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class ApproveCellTableViewCell: UITableViewCell {

    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var IdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
