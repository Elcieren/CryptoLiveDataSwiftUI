//
//  ContentView.swift
//  CryptoLiveDataSwiftUI
//
//  Created by Eren Elçi on 2.11.2024.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var cryptoListViewModel : CryptoListViewModel
    
    init() {
        self.cryptoListViewModel = CryptoListViewModel()
    }
    
    var body: some View {
        NavigationStack {
            List(cryptoListViewModel.cryptoList, id:\.id) { crypto in
                VStack {
                    Text(crypto.currency).font(.title3).foregroundStyle(.black).frame(maxWidth: .infinity, alignment: .leading)
                    Text(crypto.price).font(.title2).foregroundStyle(Double(crypto.price) ?? 0.0 > 0.0034 ? .green : .red).frame(maxWidth: .infinity, alignment: .leading)
                }
            }.toolbar(content: {
                Button {
                    //butona tiklaminca ne olcak
                    Task.init {
                        await cryptoListViewModel.downloadCryptosContination(url:URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")! )
                    }
                   
                } label: {
                    Text("Refresh")
                }

            })
            .navigationTitle("Crypto List")
            
        }.task {
            await cryptoListViewModel.downloadCryptosContination(url:URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")! )
            
            //await cryptoListViewModel.dowloadCryptoAsync(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")! )
        }
        
        
        
        /* .onAppear {
            
           // cryptoListViewModel.dowloadCrypto(url: URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!)
        } */
    }
}
    
    #Preview {
        MainView()
    }

