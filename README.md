<img width="280" alt="Ekran Resmi 2024-11-03 01 58 58" src="https://github.com/user-attachments/assets/678ee4a4-04f5-4125-a971-be9a92f50ee0">

**Async-Await:**  
Servis katmanında `downloadCurrenciesAsync` ve `downloadCurrenciesContinuation` fonksiyonları async-await yapısıyla veri çekme işlevini sağlar. Bu yapı sayesinde veri çekme işlemleri daha okunaklı hale gelir.

**Continuation:**  
`downloadCurrenciesContinuation` fonksiyonu, eski `completion handler` yapısındaki `downloadCurrencies` fonksiyonunu async-await ile uyumlu hale getirir. `withCheckedThrowingContinuation` ile asenkron süreçler, eski yapılarla uyumlu hale gelir.

**Actors Kullanımı:**  
`@MainActor` ile işaretlenmiş `CryptoListViewModel` sınıfı, Swift’in actor modeline uygundur. Bu model, `cryptoList` gibi verilerin thread-safe bir şekilde güncellenmesini sağlar ve veri yarış koşullarını önler.


 <details>
    <summary><h2>Uygulamanin Amacı</h2></summary>
    Async-Await: Servis katmanında downloadCurrenciesAsync ve downloadCurrenciesContinuation fonksiyonları async-await yapısıyla veri çekme işlevini sağlar. Bu yapı sayesinde veri çekme işlemleri daha okunaklı hale gelir.
    Continuation: downloadCurrenciesContinuation fonksiyonu, eski completion handler yapısındaki downloadCurrencies fonksiyonunu async-await ile uyumlu hale getirir. withCheckedThrowingContinuation ile asenkron süreçler, eski yapılarla uyumlu hale gelir.
    Actors Kullanımı: @MainActor ile işaretlenmiş CryptoListViewModel sınıfı, Swift’in actor modeline uygundur. Bu model, cryptoList gibi verilerin thread-safe bir şekilde güncellenmesini sağlar ve veri yarış koşullarını önler.
  </details>  

  <details>
    <summary><h2>Model (CryptoCurrency)</h2></summary>
    Model, CryptoCurrency struct'ıdır ve Hashable, Decodable, ve Identifiable protokollerini uygulamaktadır. Model, kripto para birimlerinin bilgilerini (currency ve price) ve eşsiz bir UUID (id) içerir. CodingKeys enum'u, JSON verisindeki anahtar adlarını belirlemek için kullanılmıştır.
    
    ```
     struct CryptoCurrency :  Hashable ,  Decodable , Identifiable {
    let id = UUID()
    let currency: String
    let price : String
    
    private enum CodingKeys : String , CodingKey {
        case currency = "currency"
        case price = "price"
    }
    }

    ```
  </details> 

  <details>
    <summary><h2>Servis Katmanı (Webservice)</h2></summary>
    Webservice sınıfı, kripto para verilerini JSON dosyasından indirmek için çeşitli yöntemler sunmaktadır.

  <details>
    <summary><h2>Async-Await Kullanımı</h2></summary>
    downloadCurrenciesAsync fonksiyonunda, async-await ile URLSession kullanılarak asenkron veri indirilmesi sağlanmıştır. Bu fonksiyon, await anahtar kelimesi ile veriyi indirir ve ardından JSONDecoder ile kodunu çözümler. Sonuç olarak [CryptoCurrency] dizisini döndürür.
   
    ```
    func downloadCurrenciesAsync(url: URL) async throws -> [CryptoCurrency] {
    let (data, _) = try await URLSession.shared.data(from: url)
    let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data)
    return currencies ?? []
    }
    ```
  </details> 


  <details>
    <summary><h2>Continuation Kullanımı</h2></summary>
    ownloadCurrenciesContinuation fonksiyonu, eski completion handler yapısındaki downloadCurrencies fonksiyonunu çağırarak, withCheckedThrowingContinuation kullanır. Bu, async-await'e geçişi daha kontrollü hale getirir. continuation.resume(returning:) veya continuation.resume(throwing:) kullanarak başarılı veya başarısız durumlara göre dönüş yapılır.
   
    ```
    func downloadCurrenciesContinuation(url: URL) async throws -> [CryptoCurrency] {
    try await withCheckedThrowingContinuation { continuation in
        downloadCurrencies(url: url) { result in
            switch result {
            case .success(let cryptos):
                continuation.resume(returning: cryptos ?? [])
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    }

    ```
  </details> 
    

  </details> 

  <details>
    <summary><h2>ViewModel (CryptoListViewModel)</h2></summary>
   CryptoListViewModel sınıfı, ObservableObject protokolünü uygular ve arayüze güncellemeler gönderebilmek için @Published bir cryptoList listesine sahiptir.
   Continuation Fonksiyonu: downloadCryptosContination adlı fonksiyon, downloadCurrenciesContinuation fonksiyonunu çağırır. Bu, async-await yapısını kullanarak indirme işlemini gerçekleştirir ve self.cryptoList'i günceller.
    
    ```
         func downloadCryptosContination(url: URL) async {
    do {
        let cryptos = try await webservice.downloadCurrenciesContinuation(url: url)
        self.cryptoList = cryptos.map(CryptoViewModel.init)
    } catch {
        print(error)
    }
    }



    
    ```
  </details> 


  <details>
    <summary><h2>View (MainView)</h2></summary>
   MainView, bir List bileşeni içinde kripto para birimlerini gösterir.
   Async-Await ile Veri Yenileme: Kullanıcı "Refresh" düğmesine bastığında, Task bloğu ile cryptoListViewModel.downloadCryptosContination çağrılır. await ile çağrılan bu fonksiyon, listeyi güncelleyerek yeni verileri getirir.
    
    ```
        override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGamerOver {
            score += 1
        }
    }


    ```
  </details> 

<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyun Basladiktan sonra</h4>
            <img src="https://github.com/user-attachments/assets/678ee4a4-04f5-4125-a971-be9a92f50ee0" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
