//
//  PromiseViewController.swift
//  GitHUb
//
//  Created by user on 21.12.2021.
//

import UIKit
import PromiseKit
import Alamofire

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

enum ApplicationError: Error {
    case noUsers
    case noPosts
    case postsCouldNotBeParsed
}

final class PostAPi {
    //запрос для юзеров
    func gatAllWriters() -> Promise<[User]> {
        return Promise<[User]> { resolver in
            
            let url = "https://jsonplaceholder.typicode.com/users"
            
            AF.request(url).responseJSON { response in
                if let error = response.error {
                    resolver.reject(error)
                }
                
                if let data = response.data {
                    do {
                        let user = try JSONDecoder().decode([User].self, from: data)
                        resolver.fulfill(user)
                    } catch {
                        resolver.reject(ApplicationError.noUsers)
                    }
                }
            }
            
        }
    }
    //запрос для постов
    func getPost(for userID: Int) -> Promise<[Post]> {
        return Promise<[Post]> { resolver in
            
            let url = "https://jsonplaceholder.typicode.com/posts"
            
            AF.request(url).responseJSON { response in
                if let error = response.error {
                    resolver.reject(error)
                }
                
                if let data = response.data {
                    do {
                        let post = try JSONDecoder().decode([Post].self, from: data)
                        resolver.fulfill(post)
                    } catch {
                        resolver.reject(ApplicationError.noPosts)
                    }
                }
            }
            
        }
    }
}




class PromiseViewController: UITableViewController {
    
    let postAPI = PostAPi()
    var users: [User] = []
    
    func promise(){
       
            firstly {
                self.postAPI.gatAllWriters()
            }.ensure{
                
            }
            .done { users in
                self.users = users
                
                self.tableView.reloadData()
                
            } .catch { error in
                print (error)
            }
        }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
//        //Старт лоудер
//        firstly {
//            postAPI.gatAllWriters()
//        } .then { user in
//            self.postAPI.getPost(for: user[0].id)
//        }.ensure {
//            //лоудер завершить
//        }.done { post in
//            print (post)
//        } .catch { error in
//            print (error)
//        }
        
        promise()
       
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].username
        return cell
    }
    
    
    
}
