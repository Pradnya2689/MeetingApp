//
//  UserTableViewCell.swift
//  MeetingApp
//
//  Created by Administrator on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var userNameLB: UILabel!
    @IBOutlet weak var instructLB: UILabel!
    @IBOutlet weak var venueLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var seatAvaLB: UILabel!
    @IBOutlet weak var subcribeBtn: UIButton!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var meetingCodeBtn: UIButton!
    @IBOutlet weak var endMeetingBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
