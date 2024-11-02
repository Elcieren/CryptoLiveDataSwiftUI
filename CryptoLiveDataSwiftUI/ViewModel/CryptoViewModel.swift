//
//  CryptoViewModel.swift
//  CryptoLiveDataSwiftUI
//
//  Created by Eren Elçi on 2.11.2024.
//

import Foundation

@MainActor
class CryptoListViewModel : ObservableObject {
    
    @Published var cryptoList = [CryptoViewModel]()
    let  webservice = Webservice()
    
    
    func downloadCryptosContination(url : URL) async {
        do{
            let cryptos = try await  webservice.downloadCurrenciesContinuation(url: url)
            self.cryptoList = cryptos.map(CryptoViewModel.init)
            /*
            DispatchQueue.main.async {
                self.cryptoList = cryptos.map(CryptoViewModel.init)
            }*/
        } catch {
            print(error)
        }
        
    }
    
    
    /*
    func dowloadCryptoAsync(url: URL) async {
        do {
            let cryptos = try await webservice.downloadCurrenciesAsync(url: url)
            DispatchQueue.main.async {
                self.cryptoList = cryptos.map(CryptoViewModel.init)
            }
        } catch {
            print(error)
        }
        
    }
     */
    
    
    /*
    func dowloadCrypto(url : URL) {
        webservice.downloadCurrencies(url: url) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let cyrptos):
                if let cyrptos = cyrptos {
                    DispatchQueue.main.async {
                        self.cryptoList = cyrptos.map(CryptoViewModel.init)
                    }
                    
                }
            }
        }
    } */
    
    
    
    
    
    
}


struct CryptoViewModel {
    
    let crypto : CryptoCurrency
    
    var id : UUID {
        crypto.id
    }
    
    var currency : String {
        crypto.currency
    }
    
    var price : String {
        crypto.price
    }
    
}
