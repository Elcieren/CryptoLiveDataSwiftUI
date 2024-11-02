//
//  CryptoCurrency.swift
//  CryptoLiveDataSwiftUI
//
//  Created by Eren Elçi on 2.11.2024.
//

import Foundation


struct CryptoCurrency :  Hashable ,  Decodable , Identifiable {
    let id = UUID()
    let currency: String
    let price : String
    
    private enum CodingKeys : String , CodingKey {
        case currency = "currency"
        case price = "price"
    }
}
