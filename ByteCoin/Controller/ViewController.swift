//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var scrollLable: UIPickerView!
    @IBOutlet weak var coinLable: UILabel!
    
    let scrollManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollLable.dataSource = self
        scrollLable.delegate = self
        
        // Do any additional setup after loading the view.
    }
}
//MARK: -UIPickerView

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scrollManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return scrollManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCoin = scrollManager.currencyArray[row]
        scrollManager.getCoinPrice(selectedCoin)
        print(selectedCoin)
    }
}

//MARK: -CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateRate(selectedCoinData : CoinData) {
        DispatchQueue.main.async{
            self.priceLable.text = String(format: "%.1f", selectedCoinData.rate)
            self.coinLable.text = selectedCoinData.asset_id_quote
        }
    }
}

