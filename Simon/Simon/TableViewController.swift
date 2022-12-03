//
//  TableViewController.swift
//  Simon
//
//  Created by IOS on 22/06/22.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ref: DatabaseReference!
    @IBOutlet weak var tableView : UITableView!
    //let animalArray = ["a", "b"]
    struct highscore{
        var score : Int
    }
    var data = [highscore]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database(url: "https://tes2ios-94675-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        ref.child("Leaderboard").observe(.value, with: { (snapshot) in
                    let v = snapshot.value as! NSDictionary
                    print(v as Any)
                    for (_,j) in v {
                        //print(j)
                        for (m,n) in j as! NSDictionary {
                            //print("tes \(m)")
                            print(n)
                            self.data.append(highscore(score: n.self as! Int))
                            print("get")
                        }
                    }
            //print("test")
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
        }) { (error) in
                    print(error.localizedDescription)
                }
              // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let arr = data[indexPath.row]
        cell.textLabel?.text = "Score : \(String(arr.score))"
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
