//
//  ViewController.swift
//  BitcoinTicker
//


import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var todoEndpoint = ""
    var crypto = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
    }
    
    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    //Number of columns of data
    func numberOfComponents(in pickView: UIPickerView) -> Int {
        return 1
        
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        crypto = currencyArray[row]
        makeGetCall()
    }
    
    
    //
    //    //MARK: - Networking URLSesion
    //    /***************************************************************/
    func makeGetCall() {
        // Set up the URL request
        todoEndpoint = baseURL + crypto
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                guard let bid = receivedTodo["bid"] as? Double else {
                    print("Could not get todoID as String from JSON")
                    return
                }
                self.updateUIWithBidData(bid: "\(bid)")
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        
    }
    
    //    //MARK: - Update UI
    //    /***************************************************************/
    //
    func updateUIWithBidData(bid : String) {
        DispatchQueue.main.async { // Correct
            self.bitcoinPriceLabel.text = bid
        }
        
    }
    
    
    
}

