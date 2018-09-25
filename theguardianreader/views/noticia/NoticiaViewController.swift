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
    @IBOutlet weak var imageViewThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSessao: UILabel!
    @IBOutlet weak var labelNoticia: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelTitle.text = ""
        labelDate.text = ""
        labelSessao.text = ""
        labelNoticia.text = ""
        pullNoticia()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pullNews(noticia: Noticia){
        
        if let url = URL(string: noticia.thumbnail ?? "https://media.guim.co.uk/208c837d2ca2fdc5c5ffb5e7e3d6a6c4afed2d82/0_0_1300_780/500.jpg"){
            self.imageViewThumbnail.load.request(with: url, onCompletion: { image, error, operation in
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    self.imageViewThumbnail.layer.add(transition, forKey: nil)
                    self.imageViewThumbnail.image = image
                }
            })
        }
        
        labelTitle.text = noticia.headline
        labelDate.text = ApiService.formataData(data: noticia.firstPublicationDate)
        labelSessao.text = noticia.sectionName
        labelNoticia.text = noticia.bodyText
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
