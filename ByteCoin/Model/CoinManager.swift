//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didFailWithError(error: Error)
    func didUpdateRate(selectedCoinData : CoinData)
}


struct CoinManager{
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "80556A11-B3FE-4D41-A850-B349FA6B0C8B"
    
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(_ selectedCoin: String){
        let urlString = "\(baseURL)/\(selectedCoin)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let selectedCoinData = self.paramsJSON(coinData: safeData){
                        delegate?.didUpdateRate(selectedCoinData: selectedCoinData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func paramsJSON(coinData: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let price = decodedData.rate
            let asset_id = decodedData.asset_id_quote
            let coinData = CoinData(asset_id_quote: asset_id, rate: price)
            return coinData
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
