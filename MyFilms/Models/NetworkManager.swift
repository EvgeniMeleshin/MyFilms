//
//  NetworkManager.swift
//  MyFilms
//
//  Created by Evgeni Meleshin on 17.10.2022.
//

import Foundation
import UIKit

struct NetworkManager {
    
    func findFilms(byName filmNameOriginal: String) {
        
        let filmNameEncode = filmNameOriginal.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        guard let filmNameEncode = filmNameEncode else { return }
        
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(filmNameEncode)"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue(apiKey, forHTTPHeaderField:"X-API-KEY")
        request.timeoutInterval = 60.0
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                //let dataString = String(data: data, encoding: .utf8)
                
                //print(dataString!)
                self.parseJSON(withData: data)
            }
        }
        task.resume()
        
    }
    
    func parseJSON(withData data: Data) {
        
        let decoder = JSONDecoder()
        do {
            //decoder.keyDecodingStrategy = .useDefaultKeys
            let foundFilmsData = try decoder.decode(FoundFilmsData.self, from: data)
            print(foundFilmsData.films[0].nameRu)
        } catch let error as NSError {
//            let alertController = UIAlertController(title: "Error", message: "Error with parse JSON", preferredStyle: .alert)
//            let actionOk = UIAlertAction(title: "OK", style: .default)
//            alertController.addAction(actionOk)
//            present
            //print(error.localizedDescription)
            print(error)
        }
        
    }
    
}
