//
//  ViewController.swift
//  crudCoreData
//
//  Created by Irving Guapo on 29/08/20.
//  Copyright © 2020 Irving. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //Outlet
    
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var ageOutlet: UITextField!
    @IBOutlet weak var statusOutlet: UISwitch!
    
    
    //Funcion de conexion
    func conn() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //Actions
    
    //Botòn agregar nuevos usuarios
    @IBAction func btnAdd(_ sender: UIButton) {
        
        //Constante que hace referencia a la conexion a coreData
        let context = conn()
        //Constante que hace referencia a la entidad donde se guardaran los datos
        let entitiUsers = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUSers = NSManagedObject.init(entity: entitiUsers!, insertInto: context)
        
        //Constante indicando que en el campo edad se espera un numero entero
        let age = Int16(ageOutlet.text!)
        
        //Guardado de información usando los componentes de la vista
        newUSers.setValue(nameOutlet.text, forKey: "name")
        newUSers.setValue(age, forKey: "age")
        newUSers.setValue(statusOutlet.isOn, forKey: "state")
        
        
        //Guardado de la información verificando si existen errores
        do {
            try context.save()
            print("SuccssFully Saved!")
            empy() // Deja los campos vacios
            
        } catch let err as NSError {
            print("Save Error!", err)
        }
    }
    
    //boton para mostrar todos los usuarios
    @IBAction func GetUsers(_ sender: UIButton) {
        let context = conn()
        
        let fetchRequest : NSFetchRequest<Users> = Users.fetchRequest()
        
        do {
            let res =  try context.fetch(fetchRequest)
            
            print("Total Users = \(res.count)")
            
            for ress in res as [NSManagedObject] {
                
                let nameUser = ress.value(forKey: "name")
                let ageUser = ress.value(forKey: "age")
                let statusUser = ress.value(forKey: "state")
                
                
                
                print("UserName: \(nameUser!) - UserAge: \(ageUser!) - StatusUser: \(statusUser!)-")
            }
            
        } catch let err as NSError {
            print("Error gettin data!", err)
        }
    }
    
    
    
    
    
    
    
    
    
    //funcion para quitar el teclado al hacer click fuera del el
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    //Funcion que deja los campos vacios
    func empy() {
        nameOutlet.text = ""
        ageOutlet.text = ""
        statusOutlet.isOn = false
    }
    
    
    
    
    //Botón Borrar todos los usuarios
    
    
    @IBAction func deleteUsers(_ sender: UIButton) {
        
        let context = conn()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        let deleted = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleted)
            print("SuccssFully deleted!")
        } catch let err as NSError {
            print("Error for deleted", err)
        }
    }
    
    
}

