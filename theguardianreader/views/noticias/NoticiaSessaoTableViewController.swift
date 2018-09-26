//
//  NoticiasSessaoTableViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 19/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit
import ImageLoader

class NoticiaSessaoTableViewController: UITableViewController {

    var numberPage : Int = 0
    var selectedData: String?
    var titulo: String?
    var isRefreshing : Bool = false
    var links = [NoticiaSessao]()
 
    override func viewWillAppear(_ animated: Bool) {
        self.title = titulo
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
        // #warning Incomplete implementation, return the number of rows
        return links.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? NoticiaViewController,
            let sender = sender as? String {
            destinationViewController.selectedData = sender
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "listaNoticia", sender: links[indexPath.row].id)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticiaCelula", for: indexPath) as! NoticiaSessaoTableViewCell

        // Configure the cell...
       
        // https://upload.wikimedia.org/wikipedia/commons/b/b1/Loading_icon.gif
        
        if let url = URL(string: links[indexPath.row].img  ?? "https://media.guim.co.uk/208c837d2ca2fdc5c5ffb5e7e3d6a6c4afed2d82/0_0_1300_780/500.jpg"){
            cell.imageThumbnail.load.request(with: url, onCompletion: { image, error, operation in
                //print("image \(String(describing: image?.size)), render-image \(String(describing: cell.imageThumbnail.image?.size))")
                if operation == .network {
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionFade
                    cell.imageThumbnail.layer.add(transition, forKey: nil)
                    cell.imageThumbnail.image = image
                }
            })
        }
        
        cell.labelData.text = ApiService.formataData(data: links[indexPath.row].webPublicationDate)
        //cell.labelData.text = links[indexPath.row].webPublicationDate
        
        cell.labelNoticia.text = links[indexPath.row].webTitle
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            pullRefreshSessao()
        }
    }
    
    func pullRefreshSessao(){
        if !isRefreshing {
            isRefreshing = true
            numberPage += 1
            if let section = selectedData{
                FetchService.requestSessao(section: section,pagesQtt: 15,page: numberPage, handler: { (items) in
                    if let items = items {
                        self.links += items
                    }
                    self.tableView.reloadData()
                    self.isRefreshing = false
                })
            }
        }
    }
    
}
