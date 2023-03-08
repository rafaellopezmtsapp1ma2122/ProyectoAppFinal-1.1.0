import UIKit

class forumViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var selectedItem: Int?
    var okCell = false
    static var foro = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func createForum(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createForum", sender:
                            sender)
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        //offlineJD()
        keepTheme()
        tabla.removeAll()
        autoUpdate()
        tableView.reloadData()
        //autoUpdate()
        let nib = UINib(nibName: "forumTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "forumTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        tabla.removeAll()
        autoUpdate()
        tableView.reloadData()
        keepTheme()
        
        
    }
    
    
    var tabla: [ForumCard] = []
    let url = URL(string: "http://127.0.0.1:5000/getForum")!
    
    func autoUpdate(){
        
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
               
                tabla.append(ForumCard(json: o))
                
            }
            } catch let errorJson {
                //print(errorJson)
            }
        self.tableView.reloadData()
    }
        



    //Preparamos las celdas para añadirlas al table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabla.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forumTableViewCell", for: indexPath) as! forumTableViewCell
        
        cell.name.text = tabla[indexPath.row].nameForum
        cell.num.text = String(tabla[indexPath.row].numero)
        let strBase64 = tabla[indexPath.row].imagen
        
        do {
            let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            //print(decodedimage)
            cell.imagenForm.image = decodedimage
        }
        catch {
            cell.imagenForm.backgroundColor = .black
            //print("Error jajaj xd")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        okCell = true
        self.performSegue(withIdentifier: "enterChat", sender:
                            tabla[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if okCell == true{
            let ChatViewController = segue.destination as! chatViewController
            //let chat = sender as! Forum
            //ChatViewController.chat = chat
            let foro = sender as! ForumCard
            ChatViewController.foro = foro
        }
    }
    func keepTheme(){
        print(settingsViewController.finalTheme)
        var tema = settingsViewController.finalTheme
        if tema == "dark"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#3A4043")
        } else if tema == "light"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#71787C")
        }
    }
    /*
    func loadUser(){
        guard let url = URL(string: "http://127.0.0.1:5000/enterForum") else { return }

                var request = URLRequest(url: url)

                

                request.httpMethod = "GET"

                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

                

                URLSession.shared.dataTask(with: request) { [self] (data, response, error) in

                    

                    guard let data = data else { return }



                    do {

                        let decoder = JSONDecoder()

                        self.tabla = try decoder.decode([ForumCard].self, from: data)
                      

                        DispatchQueue.main.async {

                            self.tableView
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
                                    print("Error al recivir data.")
                                    return
                                }
                                print("\n\n\n")
                                print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
                                
                                
                            }.resume().reloadData()

                        }



                    } catch let error {

                        

                        print("Error: ", error)

                        

                    }

                }.resume()
}
*/
    func offlineJD(){
        if forumViewController.foro != nil{
            guard let url = URL(string:"http://127.0.0.1:5000/exitForum")
            else {
                return
            }
            
           
           
           
            
            
            // Le damos los datos del Array.
            let body: [String: Any] = ["user": ViewController.user?.email ?? "Empty", "forum": forumViewController.foro]
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
        
    }
}
