import UIKit

class registerViewController: UIViewController {

    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var newUsername: UITextField!
    
    @IBOutlet weak var newPass: UITextField!
    
    @IBOutlet weak var rePass: UITextField!
    
    func confirmPass() -> String{
        let pass = newPass.text
        let rePaswd = rePass.text
        
        if pass == rePaswd{
            return "ok"
        }else{
            return "error"
        }
    }
    
    func notEmpty() -> Bool{
        if newUsername.text?.isEmpty == false && newPass.text?.isEmpty == false && rePass.text?.isEmpty == false && email.text?.isEmpty == false{
            
            return true
            
        }else{
            return false
        }
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
      
            if confirmPass()=="ok" && notEmpty()==true{
                guard let url = URL(string:"http://127.0.0.1:5000/register")
                else {
                    return
                }
                
                let body: [String: Any] = ["name": newUsername.text ?? "Empty", "token": newPass.text ?? "Empty", "email": email.text ?? "Empty" ]
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
                    self.token = String(data: data, encoding: .utf8)
                    print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goHome2", sender: sender)
                    }
                    
                }.resume()
                
            }else{
                //Cambiamos el color de fondo de los textfield si estan vacios
                rePass.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
                newPass.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
                
            }
    }
}
