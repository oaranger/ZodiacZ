//
//  SignFullscreenHeaderCell.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 3/21/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

class SignFullscreenHeaderCell: UITableViewCell {
    
    let signDetailsCelll = SignDetailsCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(signDetailsCelll)
        signDetailsCelll.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
