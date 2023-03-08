import UIKit

class createForumViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Referenciamos los outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keepTheme()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keepTheme()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirm(_ sender: Any) {
        
        if name.text?.isEmpty == false{
            guard let url = URL(string:"http://127.0.0.1:5000/postForum")
            else {
                return
            }
            
           
           
            let imageData:NSData = image.image?.jpegData(compressionQuality: 0) as! NSData
            //print("\n AAAAAAAA: ", imageData)
           
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            //print("\n BASE64: ", strBase64)
            
            // Le damos los datos del Array.
            let body: [String: Any] = ["name": name.text ?? "Empty", "image": strBase64]
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
    //Activamos el image picker para poder seleccionar la imagen deseada
    @IBAction func changeImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //Seleccionamos la imagen deseada y la colocamos en la view con la imagen correspondiente a la deseada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image.image = img
        self.dismiss(animated: true, completion: nil) // Cierra la galería al elegir foto.
    }
    
    //Cerramos el image picker al seleccionar la imagen
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { // Si se cancela, regresa de nuevo.
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
