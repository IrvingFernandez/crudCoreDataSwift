//
//  UpdateViewController.swift
//  crudCoreData
//
//  Created by Irving Guapo on 08/09/20.
//  Copyright © 2020 Irving. All rights reserved.
//

import UIKit
import CoreData

class UpdateViewController: UIViewController {
    
    @IBOutlet weak var uName: UITextField!
    
    @IBOutlet weak var uAge: UITextField!
    
    @IBOutlet weak var uState: UISwitch!
    
    
    var userToEdit : Users!
    
    
    
    
    //Funcion de conexion
    func conn() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.persistentContainer.viewContext
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edit()
        

    }

    @IBAction func btnUpdate(_ sender: UIButton) {
        
        
         //Constante que hace referencia a la conexion a coreData
         let context = conn()

         
         //Constante indicando que en el campo edad se espera un numero entero
         let age = Int16(uAge.text!)
         
         //Guardado de información usando los componentes de la vista
         userToEdit.setValue(uName.text, forKey: "name")
         userToEdit.setValue(age, forKey: "age")
         userToEdit.setValue(uState.isOn, forKey: "state")
         
         
         //Guardado de la información verificando si existen errores
         do {
             try context.save()
             print("SuccssFully Saved!")
            
            //regresa a la aterior vista 
            performSegue(withIdentifier: "segueReturnTable", sender: self)
            
            
            
            
         } catch let err as NSError {
             print("Save Error!", err)
         }
        
    }
    
    //funcion para quitar el teclado al hacer click fuera del el
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
      }
    
    //Editar
    func edit() {
        
        print("Name : \(userToEdit.name!)")
        
        uName.text = userToEdit.name
        uAge.text = "\(userToEdit.age)"
        if userToEdit.state {
            uState.isOn = true
        }else{
            uState.isOn = false
        }
    }
    
}
