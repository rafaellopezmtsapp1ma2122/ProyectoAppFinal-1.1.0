import UIKit

class itemViewController: UIViewController {
    //Variables
    var item: Item?
    
    //Outlets
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tectLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favButt: UIButton!
    @IBOutlet weak var editButoom: UIButton!
    @IBOutlet weak var deleteButoom: UIButton!

    //Funciones de Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        //Funcion del tema
        keepTheme()
        //Editamos los bordes del elemento precio
        priceLabel.layer.masksToBounds = true
        priceLabel.layer.cornerRadius = 10
        //Preparamos las imagenes para el boton especial
        Button.setImage(UIImage(named:"favorito"), for: .normal)
        Button.setImage(UIImage(named:"estrella"), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        keepTheme()
        //Mostramos o ocultamos lo botones segun si son propietarios o no
        if item?.user != ViewController.user?.email{
            editButoom.alpha = 0
            deleteButoom.alpha = 0
        }else{
            editButoom.alpha = 1
            deleteButoom.alpha = 1
        }
        //Descaraga de la imagen
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
        //Colocamos los textos en sus respectivos campos
        nameLabel.text = item?.nameObj
        nameLabel.textColor = UIColor.white
        tectLabel.text = item?.text
        priceLabel.text = item?.stringPrice
        priceLabel.textColor = UIColor.white
        favButt.isSelected = item?.fav ?? false
        if item?.fav == true{
            favButt.isEnabled = true
        }
    }
    
    @IBAction func share(_ sender: Any) {
        
        //Peticion POST para eliminar un elemento
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
                    homeViewController.started = false
                    self.dismiss(animated: true, completion: nil)
                }
                
            }.resume()
        
        }
        
    }
    
    //Boton para editar si sus credenciales son correspondientes para poder editar
    @IBAction func edit(_ sender: Any) {
        if item?.user == ViewController.user?.email{
            self.performSegue(withIdentifier: "editItem", sender:
                                sender)
        }
    }
    //Volver a la página anterior
    @IBAction func backItem(_ sender: Any) {
        homeViewController.started = true
            self.dismiss(animated: true, completion: nil)
    }
    //Botón de favotitos
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        
            
               UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {

                   sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

                    

                       }) { (success) in

                           UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {

                               sender.isSelected = !sender.isSelected

                               sender.transform = .identity

                           }, completion: nil)

                       }
        //Petición POST para añadir a favoritos un item
        if sender.isSelected == false{
            guard let url = URL(string:"http://127.0.0.1:5000/favoriteItem")
            else {
                return
            }

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
        
        //Petición POST para eliminar a favoritos un item
        if sender.isSelected == true{
            guard let url = URL(string:"http://127.0.0.1:5000/notFavorite")
            else {
                return
            }
            
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

            }
    
    //Mantener el tema guardado en preferencias
    func keepTheme(){
        //Guardamos los presets
        var tema = settingsViewController.finalTheme
        //Dependiendo del presest usamos un color
        if tema == "dark"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#3A4043")
        } else if tema == "light"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#71787C")
        }
    }
    

}
