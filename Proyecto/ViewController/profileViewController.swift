import UIKit

class profileViewController: UIViewController,UITableViewDataSource, UITableViewDelegate  {

    //Generamos las variables
    var tabla: [Item] = []
    
    var tablaFavoritos: [Favorite] = []
    
    var selectedItem: Int?
    
    var okCell = false
    
    //Implementamos los outlets y las func
    
    @IBOutlet weak var nameUser: UILabel!
    
    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var myElementsTable: UITableView!
    
    @IBOutlet weak var Menu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keepTheme()
        //Cargamos la imagen de perfil
        //profileImg()
        reloadProfile()
        tabla.removeAll()
        updateElementsTableView()
        tablaFavoritos.removeAll()
        SaveFavorites()
        //Colocamos el nombre de usuario
        nameUser.text = ViewController.user?.name
        //Preparamos el menú
        Menu.showsMenuAsPrimaryAction = true
        Menu.menu = addMenuItems()
        //Preparamis las celdas asociando al archivo xib corresponsiente.
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        myElementsTable.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        //Referenciamos el delegate y el dataSource
        myElementsTable.delegate = self
        myElementsTable.dataSource = self
        //Refrescamis la table view
        self.myElementsTable.reloadData()
        
        
    }
    
    
    
    
    @IBAction func modify(_ sender: Any) {
        self.performSegue(withIdentifier: "editProfile", sender: UIAction.self)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        profileImg()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        keepTheme()
        //profileImg()
        reloadProfile()
        tablaFavoritos.removeAll()
        SaveFavorites()
        tabla.removeAll()
        updateElementsTableView()

    }
    
    func SaveFavorites(){
        let url2 = URL(string: "http://127.0.0.1:5000/getFavorite")!
        do {
            //Cogemos los datos de la url
            let data = try Data(contentsOf: url2)
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
               
                tablaFavoritos.append(Favorite(json: o))
               
            }
            } catch let errorJson {
                print(errorJson)
            }
        
        self.myElementsTable.reloadData()
        
    }

//Generamos una funcion que permita dar una acción a los distintos elementos del menú ademas de dar propiedades al mismo desplegable
    func addMenuItems() -> UIMenu{
        
        //Variable para el botón options
        let menuItems = UIMenu(title: "Options", options: .displayInline, children: [

            UIAction(title: "Edit Profile", handler: { (_) in print("Edit")

                self.performSegue(withIdentifier: "editProfile", sender: UIAction.self)

            }),

            //Variable para boton settings
            UIAction(title: "Settings", handler: { (_) in print("Settings")

                self.performSegue(withIdentifier: "settings", sender: UIAction.self)

            }),
            
            //Variable para boton settings
            UIAction(title: "Logout", attributes: .destructive, handler: { (_) in print("Logout")
                
                //Cambiamos de view controller al del login
                self.performSegue(withIdentifier: "logOut", sender:
                                    UIAction.self)

            }),

            ])

            return menuItems

    }
   
    //Función para la conversión de la imagen de Base64 a imagen y poderla implementarla en el lugar correspondiente
    func profileImg(){
        
       
        let strBase64 = ViewController.user?.image ?? ""
            
      
                //Generamos las variable de las diferentes imagenes tanto codificadas como para codificar
                let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        if dataDecoded.isEmpty{
                    self.imageUser.image = UIImage(named: "Group 227profile.png")
                }else{
                    let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                    //print(decodedimage)
                    //Colocamos la imagen en su lugar correspondiente
                    self.imageUser.image = decodedimage
                }
               
      
       
                //Si se produce algun error colocamos una imagen por defecto y imprimimos un error
               
                //print("Error jajaj xd")
          
        
        
       
    }
    //Funcion para el conteo de los elementos los cuales se van a añadir a ese table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabla.count
        
    }
    //Genermos las celdas con sus datos correspondientes en sus celdas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath) as! DemoTableViewCell
        
        cell.objName.text = tabla[indexPath.row].nameObj
        cell.objTags.text = tabla[indexPath.row].tagsObj
        cell.objPrice.text = tabla[indexPath.row].stringPrice
        
        if tablaFavoritos.isEmpty{
            for j in tabla{
                tabla[indexPath.row].fav = false
            }
        }else{
            for i in tablaFavoritos {
                
                if i.nameObjFav == tabla[indexPath.row].nameObj{
                  
                    tabla[indexPath.row].fav = true
                   
                }else{
                
                    tabla[indexPath.row].fav = false
                
                    
                    
            }
               
            }
        }
        
        if tabla[indexPath.row].fav == true{
            cell.favItem.image = UIImage(named: "estrella.png")
            
        }
        if tabla[indexPath.row].fav == false{
            cell.favItem.image = UIImage(named: "favorito.png")
            
        }
        //Decodifocamos la imagen para su postorior uso en la celda
        let strBase64 = tabla[indexPath.row].imagenObj
        do {
            let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            print(decodedimage)
            cell.objImage.image = decodedimage
        }
        catch {
            cell.objImage.backgroundColor = .black
            print("Error jajaj xd")
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedItem = indexPath.row
        okCell = true
        self.performSegue(withIdentifier: "item2", sender:
                            tabla[indexPath.row])
        
    }
    
    func updateElementsTableView(){
        
        let url = URL(string: "http://127.0.0.1:5000/getItem")!
        
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
                
              
                    tabla.append(Item(json: o))
             
                
               
            }
            
            
            
            } catch let errorJson {
                print(errorJson)
            }
        
        self.myElementsTable.reloadData()
        
    }
    
    func reloadProfile(){
        guard let url =  URL(string:"http://127.0.0.1:5000/login")
        else{
            return
        }
        //Preparamos las variables a enviar
        let body: [String: String] = ["email": ViewController.email ?? "", "token": ViewController.pass ?? ""]
       
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
            DispatchQueue.main.async {
                nameUser.text = ViewController.user?.name
                profileImg()
            }
            
               //ViewController.imageUser = ViewController.user?.image
                /*profileViewController.nombreAntiguo = ViewController.user?.name ?? "default value"*/
                
            } catch let error {
                
                print("Error: ", error)
                
            }
           
         
        }.resume()
        
        //nameUser.text = ViewController.user?.name
    }
    
    func keepTheme(){
        var tema = settingsViewController.finalTheme
        print(settingsViewController.finalTheme)
        if tema == "dark"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#3A4043")
        } else if tema == "light"{
            view.backgroundColor = settingsViewController.getUIColor(hex: "#71787C")
        }
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if okCell == true{
            let ItemViewController = segue.destination as! itemViewController
            let item = sender as! Item
            ItemViewController.item = item
        }
       
    }
    
    


}
