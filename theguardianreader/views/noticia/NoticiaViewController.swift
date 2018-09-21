//
//  NoticiaViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 21/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class NoticiaViewController: UIViewController {

    var selectedData: String?
    //var noticia = Noticia()
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSessao: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pullNoticia()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pullNews(noticia: Noticia){
        labelTitle.text = noticia.headline
        labelDate.text = noticia.firstPublicationDate
        labelSessao.text = noticia.sectionName
        textVNoticia.text = noticia.bodyText
    }
    
    func pullNoticia(){
        if let news = selectedData {
            
            FetchService.requestNews(id: news, handler: { (items) in
                if let item = items {
                    self.pullNews(noticia: item)
                }
            })
        }
    }

}
