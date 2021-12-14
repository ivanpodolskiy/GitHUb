//
//  OperationViewController.swift
//  GitHUb
//
//  Created by user on 13.12.2021.
//

import UIKit

class OperationViewController: UIViewController {
    
    
    var mas: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //        operationQueueCommonTask()
//        operationQueueConcurrent()
        operationChain()
    }
    
    @IBOutlet weak var textLabel: UILabel!
    
    func operationQueueCommonTask() {
        let queue = OperationQueue()
        
        queue.addOperation {
            print ("Тяжеловесная операция")
            print (Thread.current)
            
            
            OperationQueue.main.addOperation {
                print ("UI thread")
                print (Thread.current)
                
            }
        }
    }
    
    func operationQueueConcurrent() {
        
     
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        
        queue.addOperation {
            
            for i in 0..<10 {
                print ("🤠 \(i)")
                print (Thread.current)
            }
        }
        
        queue.addOperation {
            for i in 0..<10{
                print ("🤡 \(i)")
                print (Thread.current)

            }
        }
        
        
        queue.addOperation {
            for i in 0..<10{
                print ("🤖 \(i)")
                print (Thread.current)
               
                //                print(mas)
            }
        }
        
        //        OperationQueue.main{
        //            print (mas)
        //            self.textLabel.text = mas.description
        //        }
        
    }
    
    func operationChain() { //Killer feature пример: загружаем 10 картинок одновремено, а вторая операция будет завситть от загрузки  2 положить в массив. Т.е вторая операция зависит от выполнения первой
        
        let queue = OperationQueue.main
        
        //Создаем операции
        let operation1 = BlockOperation() {
            for i in 0..<10 {
                print ("🤠 \(i)")
                print (Thread.current)
                self.mas.append("🤠 - " + String(i))
                
        
            }
        }
        
        let operation2 = BlockOperation() { //системная опирация
            for i in 0..<10 {
                print ("🤡 \(i)")
                print (Thread.current)
                self.mas.append("🤡 - " + String(i))
            }
        }
        let operation3 = BlockOperation() { //системная опирация
            for i in 0..<10 {
                print ("🤖 \(i)")
                print (Thread.current)
                self.mas.append("🤖 - " + String(i))
            }
        }
        
        let finalOperation = BlockOperation(){
            self.textLabel.text = self.mas.description
            self.textLabel.lineBreakMode = .byWordWrapping
            self.textLabel.numberOfLines = 0
            
        }
        //выстраиваем систему
        operation2.addDependency(operation1) //вторая операция будет здать пока выполнится операция1 и так далее...
        operation3.addDependency(operation2)
        finalOperation.addDependency(operation3)
        
        //создаем массив с операциями
        let operations = [operation1, operation2, operation3, finalOperation]
        
        //Операция 
        queue.addOperations(operations, waitUntilFinished: false)
        
        
    }
}
