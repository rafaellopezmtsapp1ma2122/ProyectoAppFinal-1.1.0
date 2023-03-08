import UIKit

class createItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var des: UITextView!
    @IBOutlet weak var price: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        keepTheme()
        imagePicker.delegate = self
        des.backgroundColor = UIColor.white
        des.layer.masksToBounds = true
        des.layer.cornerRadius = 10
    }
    
    //Mantener el tema una vez aparezca la vista
    override func viewWillAppear(_ animated: Bool) {
        keepTheme()
    }
    
    // Volver atrás
    @IBAction func backCreateItem(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Comprobar si algún campo vacio existe y en función de si existe o no, realiza la peticion POST o no
    @IBAction func confirm(_ sender: Any) {
        
        if name.text?.isEmpty == false &&  des.text?.isEmpty == false && price.text?.isEmpty == false{
            
            guard let url = URL(string:"http://127.0.0.1:5000/postItem")
            else {
                return
            }

            let imageData:NSData = image.image?.jpegData(compressionQuality: 0) as! NSData
    //        print("\n AAAAAAAA: ", imageData)
           
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
    //        print("\n BASE64: ", strBase64)
            
            // Le damos los datos del Array.
          
            let body: [String: Any] = ["name": name.text ?? "Empty", "image": strBase64, "price": Int(price.text!) ?? 0, "description": des.text ?? "Empty","user": ViewController.email!]
            var request = URLRequest(url: url)
         
            // Pasamos a Json el Array.
            
            let finalBody = try? JSONSerialization.data(withJSONObject: body)
            request.httpMethod = "POST"
            request.httpBody = finalBody
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
    //Función para cambiar imagen del objeto
    @IBAction func changeImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //Funcion para seleccionar imagen de la galería
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image.image = img
        self.dismiss(animated: true, completion: nil) // Cierra la galería al elegir foto.
    }

    // Si se cancela, regresa de nuevo.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
