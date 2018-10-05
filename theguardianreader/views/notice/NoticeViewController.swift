//
//  NoticiaViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 21/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController {

    var selectedData: String?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var imageViewThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSessao: UILabel!
    @IBOutlet weak var textViewNoticia: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelTitle.text = ""
        labelDate.text = ""
        labelSessao.text = ""
        textViewNoticia.text = ""
        pullNotice()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) {
            _ in
            self.pullNotice()
        }
    }
    
    func pullNews(notice: Notice){
        FetchService.getImage(url: notice.thumbnail, imagem: imageViewThumbnail)
        labelTitle.text = notice.headline
        labelDate.text = Utils.formatToBrazilianData(data: notice.firstPublicationDate)        
        labelSessao.text = notice.sectionName
        if let body =  notice.body{
            if let data = Utils.resizeImageHtml(html: body, size: textViewNoticia.contentSize).formatAttribute(){
                textViewNoticia.attributedText = data
            }
        }
    }
    
    func pullNotice(){
        if let notice = selectedData {
            let url = LinkManager.getUriNotice(resource: notice)
            FetchService.getRequest(url: url, handler: { (item) in
                self.pullNews(notice: ResponseService.mapNotice(json: item))                
            })
        }
    }

}
