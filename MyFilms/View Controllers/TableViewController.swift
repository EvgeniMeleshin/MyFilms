//
//  ViewController.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 17.10.2022.
//

import UIKit

class TableViewController: UITableViewController {

    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.findFilms(byName: "Начало")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}

