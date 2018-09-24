//
//  PesquisaTableViewCell.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 24/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class PesquisaTableViewCell: UITableViewCell {

    //    - Título da notícia.
    @IBOutlet weak var labelNoticia: UILabel!
    
    //    - Data de registro da publicação.
    @IBOutlet weak var labelDataPublicacao: UILabel!
    
    //    - Sessão da notícia.
    @IBOutlet weak var labelSessao: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
