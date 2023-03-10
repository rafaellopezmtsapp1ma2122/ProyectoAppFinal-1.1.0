import UIKit
import Photos

class modViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    
    let imagePicker = UIImagePickerController()

    @IBAction func backEdit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    static var imageUser: String?
    static var name: String?
    
    var userMod: User?
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        userName.text = ViewController.user?.name
        keepTheme()
        
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        keepTheme()
        imagePicker.delegate = self
        
        profileImg()
        
        userName.text = ViewController.user?.name

    }
    
    // Creamos una funcion para activar el ImagePicker.

    @IBAction func changeImage(_ sender: Any) {

        imagePicker.allowsEditing = false

        imagePicker.sourceType = .photoLibrary

        self.present(imagePicker, animated: true, completion: nil)

    }

    // Creamos la funcion para el funcionamiento del ImagePicker.

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        image.image = img

        self.dismiss(animated: true, completion: nil) // Cierra la galería al elejir foto.

    }

    func profileImg(){
        
       // if ViewController.user?.image != "" {
            
        let strBase64 = ViewController.user?.image ?? ""
            
                //Generamos las variable de las diferentes imagenes tanto codificadas como para codificar
                let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
                if dataDecoded.isEmpty{
                    self.image.image = UIImage(named: "Group 227profile.png")
                }else{
                    let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                    //print(decodedimage)
                    //Colocamos la imagen en su lugar correspondiente
                    self.image.image = decodedimage
                }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { // Si se cancela, regresa de nuevo.

        self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func updateProfile(_ sender: UIButton) {
        
        
        guard let url = URL(string:"http://127.0.0.1:5000/editUser")
        else {
            return
        }
        
        // Try cacht
       
        let imageData:NSData = image.image?.jpegData(compressionQuality: 0) as! NSData
//        print("\n AAAAAAAA: ", imageData)
       
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//        print("\n BASE64: ", strBase64)
        
        // Le damos los datos del Array.
        let body: [String: Any] = ["name": userName.text ?? "Empty",  "image": strBase64, "email": ViewController.user?.email ?? ""]
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
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
     
            //Recibimos la respuesta del servidor si existe o no el usuario enviado y devuelve correcto o incorrecto y ya mandamos a la página correspondiente.
            do {
                print("decode")
                let decoder = JSONDecoder()

                ViewController.user = try decoder.decode(User.self, from: data)
                
            } catch let error {
                
                print("Error: ", error)
                
            }
        
        }.resume()
        
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
