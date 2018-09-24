//
//  ModalSessaoViewController.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 24/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

protocol ModalSessaoDelegate {
    func getSessao(with data: Sessao)
}

class ModalSessaoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var sessao = Sessao(id: "",webTitle: "- All -", apiUrl: "")
    var sessoes = [Sessao]()
    
    var delegate: ModalSessaoDelegate?
    
    @IBOutlet weak var pickerSessao: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSessao.delegate = self
        pickerSessao.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessoes.append(sessao)
        pullRefreshSessoes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func escolherSessao(_ sender: Any) {
        delegate?.getSessao(with: sessoes[pickerSessao.selectedRow(inComponent: 0)])
        self.dismiss(animated: true)
    }
    
    func pullRefreshSessoes(){
        FetchService.requestSessoes(handler: { (items) in
            if let items = items {
                self.sessoes += items
            }
            self.pickerSessao.reloadAllComponents()
        })
    }
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sessoes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sessoes[row].webTitle
    }
}
