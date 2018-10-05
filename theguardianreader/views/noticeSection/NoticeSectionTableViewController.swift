//
//  NoticiasSessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 19/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class NoticeSectionTableViewController: UITableViewController {

    var numberPage : Int = 0
    var selectedData: String?
    var titulo: String?
    var isRefreshing : Bool = false
    var noticeSection = [NoticeSection]()
 
    override func viewWillAppear(_ animated: Bool) {
        self.title = titulo
        self.pullRefreshSessao()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeSection.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NoticeViewController,
            let sender = sender as? String {
            destinationViewController.selectedData = sender
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "noticeSegue", sender: noticeSection[indexPath.row].id)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as!      NoticeSectionTableViewCell

        FetchService.getImage(url: noticeSection[indexPath.row].thumbnail,imagem: cell.imageThumbnail)

        cell.imageThumbnail.layer.borderWidth = 0.75
        cell.imageThumbnail.layer.borderColor = UIColor.darkGray.cgColor
        cell.imageThumbnail.backgroundColor = UIColor.lightGray
        cell.imageThumbnail.layer.cornerRadius = 1.0
        cell.imageThumbnail.clipsToBounds = true

        cell.labelData.text = Utils.formatToBrazilianData(data: noticeSection[indexPath.row].webPublicationDate)
        cell.labelNoticia.text = noticeSection[indexPath.row].webTitle
            
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 300.0 {
            pullRefreshSessao()
        }
    }
    
    func pullRefreshSessao(){
        if !isRefreshing {
            isRefreshing = true
            numberPage += 1
            if let section = selectedData{
                let url = LinkManager.getUriSectionNotice(resource: section, pageQtt: 20, page: numberPage)
                FetchService.getRequest(url: url, handler: { (items) in
                    let noticeSectionResponse = ResponseService.mapNoticeSection(json: items)
                    
                    if self.noticeSection.count == 0 && noticeSectionResponse.count == 0{
                        self.noticeSection.append(NoticeSection(id: "", webPublicationDate: "", webTitle: "Empty Section", apiUrl: "", thumbnail: ""))
                        self.tableView.reloadData()
                    }
                    
                    if self.noticeSection.count == 0 || noticeSectionResponse.count != 0 {
                        self.noticeSection += noticeSectionResponse
                        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                        self.tableView.reloadData()
                    }
                    
                    self.isRefreshing = false
                })
            }
        }
    }
    
}
