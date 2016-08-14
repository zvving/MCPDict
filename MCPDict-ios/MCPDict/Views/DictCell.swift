//
//  DictCell.swift
//  MCPDict
//
//  Created by zengming on 6/5/16.
//  Copyright © 2016 ioi.im. All rights reserved.
//

import UIKit

class DictCell: UITableViewCell {
    
    @IBOutlet weak var labelHZ: UILabel!
    @IBOutlet weak var labelUnicode: UILabel!
    
    @IBOutlet weak var labelMC: UILabel!
    @IBOutlet weak var labelPU: UILabel!
    @IBOutlet weak var labelCT: UILabel!
    @IBOutlet weak var labelSH: UILabel!
    @IBOutlet weak var labelMN: UILabel!
    @IBOutlet weak var labelKR: UILabel!
    @IBOutlet weak var labelVN: UILabel!
    @IBOutlet weak var labelJPGO: UILabel!
    @IBOutlet weak var labelJPKAN: UILabel!
    @IBOutlet weak var labelJPTOU: UILabel!
    @IBOutlet weak var labelJPKWAN: UILabel!
    @IBOutlet weak var labelJPOTHER: UILabel!
    
    @IBOutlet weak var imgViewStar: UIImageView!
    
    func configCellWith(model:DictModel) -> Void {
        
        labelHZ.text = model.hz
        labelUnicode.text = "U+\(model.unicodeString)"
        labelMC.text = Orthography.displayMC(model.mc)
        labelPU.text = Orthography.displayPU(model.pu)
        labelCT.text = model.ct
        labelSH.text = model.sh
        labelMN.text = model.mn
        labelKR.text = model.kr
        labelVN.text = Orthography.displayVN(model.vn)
        labelJPGO.text = Orthography.displayJP(model.jp_go)
        labelJPKAN.text = Orthography.displayJP(model.jp_kan)
        labelJPTOU.text = Orthography.displayJP(model.jp_tou)
        labelJPKWAN.text = Orthography.displayJP(model.jp_kwan)
        labelJPOTHER.text = Orthography.displayJP(model.jp_other)
        
        let imgName = model.hasFavorited ? "ic_star_yellow" : "ic_star_white"
        imgViewStar.image = UIImage(named: imgName)
    }
    
}
