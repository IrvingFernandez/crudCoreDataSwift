//
//  TableViewController.swift
//  crudCoreData
//
//  Created by Irving Guapo on 05/09/20.
//  Copyright © 2020 Irving. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //tableView
    @IBOutlet weak var tableView: UITableView!
    
    //Arreglo vacio para el table view
    var user : [Users] = []
    
    //Conexion a core data
    func conn() -> NSManagedObjectContext {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.persistentContainer.viewContext
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.dataSource = self
         tableView.reloadData()
        getData()

   
    }
    
    // Numero de secciones del table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Numero de filas que tendra el table vew
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return user.count
    }
    
    //Nunero de celdas del table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let userCell = user[indexPath.row]
        

        if userCell.state  {
            cell.textLabel?.text = "✅ \(userCell.name!)"
            cell.detailTextLabel?.text = "\(userCell.age)"
        }else{
            cell.textLabel?.text = "❌ \(userCell.name!)"
            cell.detailTextLabel?.text = "\(userCell.age)"
        }
        
        
        return cell
    }
    
    //------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueUpdate", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueUpdate" {
            if let id = tableView.indexPathForSelectedRow {
                let roww = user[id.row]
                let send = segue.destination as! UpdateViewController
                
                send.userToEdit = roww
            }
        }
    }
    
    //Botón deslizable para borrar
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = conn()
        let userr = user[indexPath.row]
        
        if editingStyle == .delete{
            context.delete(userr)
            do {
                try context.save()
            } catch let err as NSError {
                print("Error to Deleted", err)
            }
        }
        
        getData()
        tableView.reloadData()
    }
    
    //funciones
    
    func getData()  {
        let context = conn()
        
        let fetchRequest : NSFetchRequest<Users> = Users.fetchRequest()
        
        do {
            user = try context.fetch(fetchRequest)
        } catch let err as NSError {
            print("Error", err)
        }
    }

}
