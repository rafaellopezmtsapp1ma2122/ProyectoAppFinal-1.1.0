import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferences()
        change()
        updateRember()
    }
   
    
    //Variables y outlets
    
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
    
    var errorLog: errorObj?
    
    
    @IBOutlet weak var myEmail: UITextField!
       
    @IBOutlet weak  var myPaswd: UITextField!
    
    
    @IBAction func register(_ sender: UIButton) {
        self.performSegue(withIdentifier: "register", sender: sender)
    }
    
  
    //Función del LogIn
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
                    //print(error)
                    return
                }
                guard let data = data else{
                    //print("Error Data")
                    return
                }
                //print("\n\n\n")
                //print(String(data: data, encoding: .utf8)!)
                //print(data)
                
                do {
                    
                    let decoder = JSONDecoder()

                    ViewController.user = try decoder.decode(User.self, from: data)
                   
                    ViewController.imageUser = ViewController.user?.image
                    
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: "goHome", sender: sender)
                    }
                    
                } catch let error {
                    
                    print("Error: ", error)
        
                }
               
                DispatchQueue.main.sync {
                    RemberSaved()
                    ViewController.email = myEmail.text!
                }
            }.resume()
            
        }else{
            //Cambiamos el color de fondo de los textfield si estan vacios
            myPaswd.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
            myEmail.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    //Función para obtener las variables de los user defaults
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
    
    var finalRember = "true"

       let remberkey = "remberkey"
       let boolKey = "boolKey"
       let emailkey = "emailkey"
       let passkey = "passkey"

       let varTrue = "true"

       let varFalse = "false"
    
    var emailR = ""
       
       var passR = ""
    
    var recoradando = ""

       func updateRember(){

           let preferencia = userDefaults.string(forKey: remberkey) ?? ""

           print(preferencia)

           if preferencia == varTrue {

               switchBar.setOn(true, animated: true)
               
             

               finalRember = "false"

           }

           else if preferencia == varFalse {

               switchBar.setOn(false, animated: true)
              
               finalRember = "true"

           }

       }

    @IBOutlet weak var switchBar: UISwitch!
    
    
    func RemberSaved() {

           switch finalRember{

           case "true":
              
               emailR = myEmail.text!
               passR = myPaswd.text!

               userDefaults.set(varTrue, forKey: remberkey)
               
               userDefaults.set(emailR, forKey: emailkey)
               userDefaults.set(passR, forKey: passkey)

               recoradando = userDefaults.string(forKey: remberkey)!
               userDefaults.set(recoradando, forKey: boolKey)
             
               updateRember()
               
               print(userDefaults.set(emailR, forKey: emailkey))
               print(userDefaults.set(passR, forKey: passkey))
           case "false":

               emailR.removeAll()
               passR.removeAll()
               userDefaults.set(varFalse, forKey: remberkey)
               recoradando = userDefaults.string(forKey: remberkey)!
               userDefaults.set(recoradando, forKey: boolKey)
               updateRember()

           default:

               userDefaults.set(varTrue, forKey: remberkey)

           }

       }
    
    func change(){
        
       recoradando = userDefaults.string(forKey: remberkey)!
       
        if recoradando == "true"{
            print("recuerdo")

            myEmail.text = userDefaults.string(forKey: emailkey)
            myPaswd.text = userDefaults.string(forKey: passkey)
        }else{
            print("no recuerdo")
        
            myEmail.text = ""
            myPaswd.text = ""
            userDefaults.set("", forKey: emailkey)
            userDefaults.set("", forKey: passkey)
        }
    }
}
