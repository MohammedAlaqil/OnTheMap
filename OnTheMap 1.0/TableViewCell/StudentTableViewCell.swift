//
//  StudentTableViewCell.swift
//  OnTheMap 1.0
//
//  Created by M7md on 28/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
class StudentTableViewCell : UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelURL: UILabel!
    
   
    func MakeChangeToCell(_ student: StudentLocation) {
        labelTitle.text = student.labelName
        labelURL.text = student.mediaURL!
    }
        
        
    
        
}
