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
        pullNoticia()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pullNews(notice: Notice){
        FetchService.getImage(url: notice.thumbnail, imagem: imageViewThumbnail)
        labelTitle.text = notice.headline
        labelDate.text = Utils.formatToBrazilianData(data: notice.firstPublicationDate)        
        labelSessao.text = notice.sectionName
//        textViewNoticia.text = notice.bodyText

//        //noticia.body?.replacingOccurrences(of: "width: 1000", with: "width: 100")
//        //noticia.body?.replacingOccurrences(of: "height: 1000", with: "height: 100")
//
//        //<head><style> .gu-image {height: 40;width: 40;}</style></head>
//
//        /*
//         if let range = snippet.range(of: "height:\"") {
//         let str = snippet[range.upperBound...]
//         print(str) // prints "123.456.7891"
//         }
//         */
//
        if let body =  notice.body{
            //let styleTag = "<head><style> .gu-image {width:\(screenWidth);height:\(screenWidth);} </style></head>"
            //body.insert(contentsOf: styleTag, at: body.startIndex)

            // ---------------------------------
            // TESTE DA FORMATAÇÃO
            // ---------------------------------
            //Utils.resizeImageHtml(html: body)

//            print(textViewNoticia.contentSize())

//            if let data = body.formatAttribute(){
//                textViewNoticia.attributedText = data
//            }
            if let data = Utils.resizeImageHtml(html: body, size: textViewNoticia.contentSize).formatAttribute(){
                textViewNoticia.attributedText = data
            }


        }
    }
    
    func pullNoticia(){
        if let notice = selectedData {
            let url = LinkManager.getUriNotice(recurso: notice)
            FetchService.getRequest(url: url, handler: { (item) in
                self.pullNews(notice: ResponseService.mapNotice(json: item))                
            })
        }
    }

}
