//
//  ViewController.swift
//  GitHUb
//
//  Created by user on 11.12.2021.
//

import UIKit


struct Document: CustomStringConvertible {
    let id: Int
    let name: String
    
    var description: String {
        return "\(id) - \(name)"
    }
}


class ViewController: UIViewController {


    @IBOutlet weak var textDoc: UILabel!
    
    var documents: [Document] = []

    
    override func viewDidLoad() {
       
//
        super.viewDidLoad()
//        dispatchGroup()
        mainThread()
     
        // Do any additional setup after loading the view.
    }
    
    
    
    func mainThread() {
        
        
        let firstChar = UnicodeScalar("А").value //Unicode буквы А - 1040
        let lastChar = UnicodeScalar("Я").value //Unicode буквы Я - 1071
        
        for charCode in firstChar...lastChar {
                let docName = String(UnicodeScalar(charCode)!) //Unicode возвращаем в string (в символ)
                let lastId = self.documents.last?.id ?? 0
                let newId = lastId + 1
                let doc = Document(id: newId, name: docName)
                self.documents.append(doc)
        }
     
        //Текст
            print (self.documents)
        self.textDoc.lineBreakMode = .byWordWrapping
        self.textDoc.numberOfLines = 0
        self.textDoc.text = self.documents.description
       
 
}
    
    //Одновременное изменение их значений из нескольких потоков может привести к ошибке
    func dispatchGroup() {
        let dispatchGroup = DispatchGroup()
        
        let firstChar = UnicodeScalar("А").value //Unicode буквы А - 1040
        let lastChar = UnicodeScalar("Я").value //Unicode буквы Я - 1071
        
        for charCode in firstChar...lastChar {
            DispatchQueue.global().async(group: dispatchGroup) {
                print (Thread.current)
                let docName = String(UnicodeScalar(charCode)!) //Unicode возвращаем в string (в символ)
                let lastId = self.documents.last?.id ?? 0
                let newId = lastId + 1
                let doc = Document(id: newId, name: docName)
                self.documents.append(doc)
            }
        }
     
        //Текст
        dispatchGroup.notify(queue: DispatchQueue.main) {
            
            print (self.documents)
        self.textDoc.lineBreakMode = .byWordWrapping
        self.textDoc.numberOfLines = 0
        self.textDoc.text = self.documents.description
    }
    }
}

