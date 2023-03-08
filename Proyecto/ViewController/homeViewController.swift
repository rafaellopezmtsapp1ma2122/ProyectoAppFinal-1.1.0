import UIKit

class homeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //Variable
    var token = String()
    var selectedItem: Int?
    var okCell = false
    let cellSpacingHeight: CGFloat = 5
    var tabla: [Item] = []
    var tablaFiltrada: [Item] = []
    var tablaFavoritos: [Favorite] = []
    static var nameItem: String?
    static var started = false
    
    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func create(_ sender: UIButton) {
        okCell = false
        self.performSegue(withIdentifier: "create", sender:
                            sender)
    }
    
    
    //Funciones de ciclo de vida
    override func viewDidLoad(){
        super.viewDidLoad()
      
        keepTheme()
        
        tablaFavoritos.removeAll()
        SaveFavorites()
        tabla.removeAll()
        updateElementsTableView()
        self.token = ViewController.token ?? ""
        //Preperamos el diseño de las celdas
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        homeViewController.started = true
        self.tableView.reloadData()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keepTheme()
        print(homeViewController.started)
        if homeViewController.started == false{
            tablaFavoritos.removeAll()
            SaveFavorites()
            tabla.removeAll()
            updateElementsTableView()
        }
    }
    
    //Recargamos los datos
    @IBAction func reload(_ sender: Any) {
      
        tablaFavoritos.removeAll()
        tabla.removeAll()
        SaveFavorites()
        updateElementsTableView()
        tableView.reloadData()
    }
    
    
    
    let url = URL(string: "http://127.0.0.1:5000/getItem")!
    
    func updateElementsTableView(){
        
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
                //print(errorJson)
            }
        
        self.tableView.reloadData()
        
    }
        

    func searchLoad(){
     
    }

    //Preparamos las celdas para añadirlas al table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabla.count
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
                //print(errorJson)
            }
        
        self.tableView.reloadData()
        
    }
   
    //Preparamos las celdas con datos
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath) as! DemoTableViewCell
     
        cell.objName.text = tabla[indexPath.row].nameObj
        
        cell.objPrice.text = tabla[indexPath.row].stringPrice
    
            var encontrado = false
            
            for i in tablaFavoritos {
                
                if i.nameObjFav == tabla[indexPath.row].nameObj{
                
                    if i.userFav == ViewController.user!.email{
                        
                        encontrado = true
                        break
                    
                    
                    }
                }
               
            }
        
        tabla[indexPath.row].fav = encontrado
        if encontrado{
            cell.favItem.image = UIImage(named: "estrella.png")
        }
        else{
            cell.favItem.image = UIImage(named: "favorito.png")
        }
        //Descargamos la imagen
        let strBase64 = tabla[indexPath.row].imagenObj
        
        do {
            let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            //print(decodedimage)
            cell.objImage.image = decodedimage
        }
        catch {
            cell.objImage.backgroundColor = .black
            //print("Error jajaj xd")
        }
        
       
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedItem = indexPath.row
        okCell = true
        self.performSegue(withIdentifier: "item", sender:
                            tabla[indexPath.row])
        
    }
    
   //Transladamos los datos de una view  a otra
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if okCell == true{
            let ItemViewController = segue.destination as! itemViewController
            let item = sender as! Item
            ItemViewController.item = item
            homeViewController.nameItem = item.nameObj
           
        }
       
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

