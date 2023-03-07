import UIKit

class homeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var token = String()
    var selectedItem: Int?
    var okCell = false
    let cellSpacingHeight: CGFloat = 5
    var tabla: [Item] = []
    var tablaFavoritos: [Favorite] = []
    static var nameItem: String?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func create(_ sender: UIButton) {
        okCell = false
        self.performSegue(withIdentifier: "create", sender:
                            sender)
    }
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
      
        keepTheme()
        tablaFavoritos.removeAll()
        SaveFavorites()
        tabla.removeAll()
        updateElementsTableView()
        self.token = ViewController.token ?? ""
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keepTheme()
        tablaFavoritos.removeAll()
        SaveFavorites()
       
        tabla.removeAll()
        updateElementsTableView()
       
        
    }
    
 
    
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
        

   /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return cellSpacingHeight
        }*/

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
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
      
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath) as! DemoTableViewCell
       // let indexPathTapped = tableView.indexPath(for: cell)
        cell.objName.text = tabla[indexPath.row].nameObj
        
        cell.objPrice.text = tabla[indexPath.row].stringPrice
        if tablaFavoritos.isEmpty{
            for j in tabla{
                if j.user == ViewController.user?.email{
                    
                    tabla[indexPath.row].fav = false
                }
            }
        }else{
            for i in tablaFavoritos {
                
                if i.nameObjFav == tabla[indexPath.row].nameObj{
                    if i.userFav == ViewController.user?.email{
                    tabla[indexPath.row].fav = true
                    }
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
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if okCell == true{
            let ItemViewController = segue.destination as! itemViewController
            let item = sender as! Item
            ItemViewController.item = item
            homeViewController.nameItem = item.nameObj
            print( homeViewController.nameItem)
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

