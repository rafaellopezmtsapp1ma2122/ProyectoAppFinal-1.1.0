import UIKit

class itemViewController: UIViewController {
    var item: Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        keepTheme()
        
        priceLabel.layer.masksToBounds = true
        priceLabel.layer.cornerRadius = 10
        tagLabel.layer.masksToBounds = true
        tagLabel.layer.cornerRadius = 10
        Button.setImage(UIImage(named:"favorito"), for: .normal)
        Button.setImage(UIImage(named:"estrella"), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        keepTheme()
        
        if item?.user != ViewController.user?.email{
            editButoom.alpha = 0
            deleteButoom.alpha = 0
        }else{
            editButoom.alpha = 1
            deleteButoom.alpha = 1
        }
        let strBase64 = item?.imagenObj ?? ""
        do {
            let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            print(decodedimage)
            imageView.image = decodedimage
        }
        catch {
            imageView.image = UIImage(named: "person.crop.circle.fill.png")
            print("Error jajaj xd")
        }
        
        nameLabel.text = item?.nameObj
        nameLabel.textColor = UIColor.white
        tagLabel.text = item?.tagsObj
        tagLabel.textColor = UIColor.white
        tectLabel.text = item?.text
        priceLabel.text = item?.stringPrice
        priceLabel.textColor = UIColor.white
        favButt.isSelected = item?.fav ?? false
        if item?.fav == true{
            favButt.isEnabled = true
        }
    }
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tectLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var favButt: UIButton!
    
    @IBOutlet weak var editButoom: UIButton!
    
    @IBOutlet weak var deleteButoom: UIButton!
    
    @IBAction func share(_ sender: Any) {
        
        if item?.user == ViewController.user?.email{
            guard let url = URL(string:"http://127.0.0.1:5000/deleteItem")
            else {
                return
            }
            
            // Le damos los datos del Array.
          
            let body: [String: Any] = ["user": item?.user ?? "Empty", "name": nameLabel.text! ]
            var request = URLRequest(url: url)
         
            // Pasamos a Json el Array.
            
            let finalBody = try? JSONSerialization.data(withJSONObject: body)
            request.httpMethod = "POST"
            request.httpBody = finalBody //
            
            // add headers for the request
            request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request){
                (data, response, error) in
                print(response as Any)
                // Imprime el error en caso de que haya un fallo
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else{
                    print("Error al recivir data.")
                    return
                }
                print("\n\n\n")
                print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            }.resume()
        
        }
        
    }
    @IBAction func edit(_ sender: Any) {
        if item?.user == ViewController.user?.name{
            
        }
        
        
    
    }
    @IBAction func backItem(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        
               

               UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {

                   sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

                    

                       }) { (success) in

                           UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {

                               sender.isSelected = !sender.isSelected

                               sender.transform = .identity

                           }, completion: nil)

                       }
        if sender.isSelected == false{
            guard let url = URL(string:"http://127.0.0.1:5000/favoriteItem")
            else {
                return
            }
            
            
            
            // Try cacht
           
            
            // Le damos los datos del Array.
          
            let body: [String: Any] = ["name": item?.nameObj ?? "Empty","user": ViewController.email!]
            var request = URLRequest(url: url)
         
            // Pasamos a Json el Array.
            
            let finalBody = try? JSONSerialization.data(withJSONObject: body)
            request.httpMethod = "POST"
            request.httpBody = finalBody //
            
            // add headers for the request
            request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request){
                (data, response, error) in
                print(response as Any)
                // Imprime el error en caso de que haya un fallo
                if let error = error {
                    //print(error)
                    return
                }
                guard let data = data else{
                    //print("Error al recivir data.")
                    return
                }
                //print("\n\n\n")
                //print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
                
                
            }.resume()
        }
        
        
        
        if sender.isSelected == true{
            guard let url = URL(string:"http://127.0.0.1:5000/notFavorite")
            else {
                return
            }
            
            
            
            // Try cacht
           
            
            // Le damos los datos del Array.
          
            let body: [String: Any] = ["name": item?.nameObj ?? "Empty","user": ViewController.email!]
            var request = URLRequest(url: url)
         
            // Pasamos a Json el Array.
            
            let finalBody = try? JSONSerialization.data(withJSONObject: body)
            request.httpMethod = "POST"
            request.httpBody = finalBody //
            
            // add headers for the request
            request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request){
                (data, response, error) in
                print(response as Any)
                // Imprime el error en caso de que haya un fallo
                if let error = error {
                    //print(error)
                    return
                }
                guard let data = data else{
                    //print("Error al recivir data.")
                    return
                }
                //print("\n\n\n")
                //print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
                
                
            }.resume()
    }
    }
    
    override func didReceiveMemoryWarning() {

                super.didReceiveMemoryWarning()

                // Dispose of any resources that can be recreated.

            }
    
   
    
    func keepTheme(){
        var tema = settingsViewController.finalTheme
        if tema == "dark"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#3A4043")
        } else if tema == "light"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#71787C")
        }
    }
    
    
}
