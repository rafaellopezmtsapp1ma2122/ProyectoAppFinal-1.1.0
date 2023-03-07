import UIKit

class chatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var chat: Forum?
    
    var foro: ForumCard?
    
    var tabla: [Forum] = []
     
    var tabla2: [onlineUser] = []
   
    
  
    var selectedItem: Int?
    @IBOutlet weak var nameChat: NSLayoutConstraint!
    
    @IBOutlet weak var textoChat: UILabel!
    
    @IBOutlet weak var chatView: UITableView!
    
    @IBOutlet weak var mensajeEscrito: UITextField!
    
    @IBAction func backChat(_ sender: Any) {
        offlineJD()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        newMessage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        keepTheme()
        //online()
        tabla.removeAll()
        autoUpdate2()
        let nib = UINib(nibName: "chatViewCell", bundle: nil)
        chatView.register(nib, forCellReuseIdentifier: "chatViewCell")
        
        chatView.delegate = self
        chatView.dataSource = self
        self.chatView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keepTheme()
        //online()
        //autoUpdate2()
        textoChat.text = foro?.nameForum
    }
    
    override func viewDidAppear(_ animated: Bool) {
        online()
    }
    
    
    func online(){
       
        guard let url = URL(string:"http://127.0.0.1:5000/enterForum")
        else {
            return
        }
        
       
       
        
        
        // Le damos los datos del Array.
        let body: [String: Any] = ["user": ViewController.user?.email ?? "Empty", "forum": foro?.nameForum ?? ""]
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
                print("Error al recibir data.")
                return
            }
            print("\n\n\n")
            print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
            
            
        }.resume()
        
        
        
        
        
    }
    
    func offlineJD(){
        
         guard let url = URL(string:"http://127.0.0.1:5000/exitForum")
         else {
             return
         }
         
        
        
        
         
         
         // Le damos los datos del Array.
         let body: [String: Any] = ["user": ViewController.user?.email ?? "Empty", "forum": foro?.nameForum ?? ""]
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
                 print("Error al recibir data.")
                 return
             }
             print("\n\n\n")
             print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
             
             
         }.resume()
         
    }
    
    func newMessage(){
        
       
            
            
            
            guard let url = URL(string:"http://127.0.0.1:5000/postMessages")
            else {
                return
            }
            
            
            
            // Try cacht
           
            
            
            // Le damos los datos del Array.
          
        let body: [String: Any] = ["user": ViewController.user?.email ?? "Empty", "forum": foro?.nameForum ?? "", "message": mensajeEscrito.text ?? "" ]
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
        
        
    func autoUpdate2(){
        let chattName = foro!.nameForum
       
        let replaced = chattName.replacingOccurrences(of: " ", with: "%20")
        print(chattName)
        let stringURL = "http://127.0.0.1:5000/getMessage/\(replaced)"
        
        guard let url = URL(string: stringURL) else { return }

                var request = URLRequest(url: url)

                

                request.httpMethod = "GET"

                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

                

                URLSession.shared.dataTask(with: request) { [self] (data, response, error) in

                    

                    guard let data = data else { return }



                    do {

                        let decoder = JSONDecoder()

                        self.tabla = try decoder.decode([Forum].self, from: data)
                        print(tabla)

                        DispatchQueue.main.async {

                            self.chatView.reloadData()

                        }



                    } catch let error {

                        

                        print("Error: ", error)

                        

                    }

                }.resume()
        
        
    }

        
    //Preparamos las celdas para añadirlas al table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabla.count
       
        
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatViewCell", for: indexPath) as! chatViewCell
      
        cell.mensage.text = tabla[indexPath.row].message
        cell.userName.text = tabla[indexPath.row].user
     
        return cell
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
