import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferences()
        
        
        // Do any additional setup after loading the view.
    }
    
    let userDefaults = UserDefaults.standard
    
    let OnOff = "OnOff"
    let themekey = "themekey"
    let dark = "dark"
    let light = "light"
    
    static var email: String?
    
    static var token: String?
    
    static var userNameInpt: String?
    
    static var pass: String?
    
    var recibi: String?
    
    static var imageUser: String?
    
    static var user: User?
    
    
    //let jsonString = [String: Any]

    
    //let jsonData = Data(jsonString.utf8)
    
    @IBOutlet weak var myEmail: UITextField!
       
    @IBOutlet weak  var myPaswd: UITextField!
    
    
    @IBAction func register(_ sender: UIButton) {
        self.performSegue(withIdentifier: "register", sender: sender)
    }
    
    @IBAction func switchRemember(_ sender: UISwitch) {
        if sender.isOn == true {
            print("recordar activado ")
        }else{
            print("recordar desactivado")
        }
    }
    
    @IBAction func logOn(_ sender: Any) {
        //Comprobamos que no esten vacios los textfield e iniciamos la acción del metodo post para enviar los datos de usuario
       
        if myEmail.text?.isEmpty == false && myPaswd.text?.isEmpty == false{
            
            ViewController.pass = myPaswd.text
            
            guard let url =  URL(string:"http://127.0.0.1:5000/login")
            else{
                return
            }
            //Preparamos las variables a enviar
            let body: [String: String] = ["email": myEmail.text ?? "", "token": myPaswd.text ?? ""]
           
            let finalBody = try? JSONSerialization.data(withJSONObject: body)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           
            //Enviamos los datos
            URLSession.shared.dataTask(with: request){ [self]
                (data, response, error) in
                //print(response as Any)
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else{
                    print("Error Data")
                    return
                }
                print("\n\n\n")
                print(String(data: data, encoding: .utf8)!)
                print(data)
                
                do {
                    
                    let decoder = JSONDecoder()

                    ViewController.user = try decoder.decode(User.self, from: data)
                    ViewController.imageUser = ViewController.user?.image
                    
                    
                } catch let error {
                    
                    print("Error: ", error)
                    
                }
                recibi = String(data: data, encoding: .utf8)
                
                
                //Recibimos la respuesta del servido si existe o no el usuario enviado y devuelve correcto o incorrecto y ya mandamos a la página correspondiente.
                
                if recibi! != "fallo"{
                    
                    if recibi! != "fallo2"{
                        
                        ViewController.email = myEmail.text!
                        DispatchQueue.main.sync {
                            self.performSegue(withIdentifier: "goHome", sender: sender)
                        }
                    }
                }
                    
             
            }.resume()
            
        }else{
            //Cambiamos el color de fondo de los textfield si estan vacios
            myPaswd.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
            myEmail.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    func preferences(){
        
        if userDefaults.string(forKey: themekey) == dark{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#3A4043")
            settingsViewController.finalTheme = "dark"
        }
        else if userDefaults.string(forKey: themekey) == light {
            view.backgroundColor = settingsViewController.getUIColor(hex: "#71787C")
            settingsViewController.finalTheme = "light"
        }
        
   

    }
}
