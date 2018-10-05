//
//  NoticiaViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 21/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit
import JTMaterialSpinner

class NoticeViewController: UIViewController {

    var selectedData: String?
    var spinnerImgView = JTMaterialSpinner()
    var spinnerView = JTMaterialSpinner()
    
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
        
        spinnerImgView.circleLayer.lineWidth = 1.0
        spinnerImgView.circleLayer.strokeColor = UIColor.black.cgColor
        spinnerImgView.animationDuration = 1
        self.view.addSubview(spinnerImgView)
        
        spinnerView.circleLayer.lineWidth = 3.0
        spinnerView.circleLayer.strokeColor = UIColor.black.cgColor
        spinnerView.animationDuration = 1
        self.view.addSubview(spinnerView)
        
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
            self.positionSpinner()
        }
    }
    
    func beginSpinner (){
        positionSpinner()
        self.spinnerView.isHidden = false
        self.spinnerView.beginRefreshing()
    }
    func stopSpinner () {
        self.spinnerView.isHidden = true
        self.spinnerView.endRefreshing()
    }
    
    func positionSpinner () {
        let contentFrame = UIScreen.main.bounds
        let positionWidthImg = UIDevice.current.orientation.isLandscape ? contentFrame.width/2.10 : contentFrame.width/2.0
        
        let positionWidth = UIDevice.current.orientation.isLandscape ? contentFrame.width/2.15 : contentFrame.width/2.25
        
        self.spinnerImgView.frame = CGRect(x: positionWidthImg, y: contentFrame.height / 6, width: 15, height: 15)
        
        self.spinnerView.frame = CGRect(x: positionWidth, y: contentFrame.height/2.75, width: 50, height: 50)
    }
    
    func pullNews(notice: Notice){
        self.spinnerImgView.beginRefreshing()
        FetchService.getImage(url: notice.thumbnail, imagem: imageViewThumbnail){ () in
            self.spinnerImgView.endRefreshing()
        }
        
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
            self.beginSpinner()
            FetchService.getRequest(url: url, handler: { (item) in
                self.stopSpinner()
                self.pullNews(notice: ResponseService.mapNotice(json: item))
            })
        }
    }

}
