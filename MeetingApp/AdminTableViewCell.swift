//
//  AdminTableViewCell.swift
//  MeetingApp
//
//  Created by Administrator on 31/01/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class AdminTableViewCell: UITableViewCell {

    @IBOutlet weak var feedBACKBtn: UIButton!
    @IBOutlet weak var maxCntLb: UILabel!
    @IBOutlet weak var approvalBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var seatAvabLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var instructorLb: UILabel!
    @IBOutlet weak var venueLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    var instrID:String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
