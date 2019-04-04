//
//  CompatibilityFullscreenHeaderCell.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 3/24/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

class CompatibilityFullscreenHeaderCell: UITableViewCell {
    
    let compatibilityCell = CompatibilityCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(compatibilityCell)
        compatibilityCell.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
