import UIKit

class chatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var chat: Forum?
    
    var foro: ForumCard?
    
  
   
    
  
    var selectedItem: Int?
    @IBOutlet weak var nameChat: NSLayoutConstraint!
    
    @IBOutlet weak var textoChat: UILabel!
    
    @IBOutlet weak var chatView: UITableView!
    
   
    @IBAction func backChat(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keepTheme()
    
        autoUpdate()
        let nib = UINib(nibName: "chatViewCell", bundle: nil)
        chatView.register(nib, forCellReuseIdentifier: "chatViewCell")
        super.viewDidLoad()
        chatView.delegate = self
        chatView.dataSource = self
        self.chatView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keepTheme()
        textoChat.text = chat?.nameUser
    }
    
    var tabla: [Forum] = []
    
    
    
    func newMessage(){
        /*
        if name.text?.isEmpty == false &&  des.text?.isEmpty == false && price.text?.isEmpty == false{
            
            
            
            guard let url = URL(string:"http://127.0.0.1:5000/postItem")
            else {
                return
            }
            
            
            
            // Try cacht
           
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
        */
        
    }

    

    
    func autoUpdate(){
        var chattName = foro!.nameForum
       
        let replaced = chattName.replacingOccurrences(of: " ", with: "")
        print(chattName)
        var stringURL = "http://127.0.0.1:5000//getMessage/\(replaced)"
        print("url")
        print(stringURL)
        let url = URL(string: stringURL )!
        do {
            //Cogemos los datos de la url
            let data = try Data(contentsOf: url)
            //Lo transformamos de JSON a datos que pueda usar swift
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        
            //Creamos un array vacio para añadir las futuras varaibles que obtengamos del JSON
            var listaTemp: [Any] = []
           
            
            //Recorremos el JSON en busqueda de valores nulos y si no lo son se añaden al array anterior
            for explica in json as! [Any] {
               
                if type(of: explica) != NSNull.self{
                   
                    listaTemp.append(explica)
                    
                }
            }
            //Recorremos la lista que acabamos de crear y añadimos al otro array de objetos que hemos creado especificamente para las listas
            for o in listaTemp as! [[String: Any]] {
               
                
                tabla.append(Forum(json: o))
                
               
            }
            } catch let errorJson {
                print(errorJson)
            }
        
        self.chatView.reloadData()
        
    }
        
    //Preparamos las celdas para añadirlas al table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabla.count
       
        
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatViewCell", for: indexPath) as! chatViewCell
        //cell.userName.text = tabla[indexPath.row].nameUser
        //cell.mensage.text = tabla[indexPath.row].mensaje
        cell.userName.text = "Jonh David"
        cell.mensage.text = "ALBERTO ES UN OTAKO"
     
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        
    }
    
    
    func keepTheme(){
        var tema = settingsViewController.finalTheme
        if tema == "dark"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#3A4043")
        } else if tema == "light"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#71787C")
        }
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemViewController = segue.destination as! itemViewController
        let item = sender as! Item
        itemViewController.item = item
    }*/

  

}
