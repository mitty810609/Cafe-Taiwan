//
//  CityMenuTableViewController.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/5/23.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import UIKit

class CityMenuTableViewController: UITableViewController {
    
    //  選擇的城市
    var currentCity = ""
    let citys = ["基隆", "台北", "桃園", "新竹", "苗栗", "台中", "南投", "彰化", "雲林",
    "嘉義", "台南", "高雄", "屏東", "宜蘭", "花蓮", "台東", "澎湖", "", "", ""]
    //  選擇城市對應的索引值
    var selectedIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return citys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        
        cell.textLabel?.text = citys[indexPath.row]
        
        var color: UIColor!
        
        if cell.textLabel?.text == currentCity {
            color = UIColor.red
        } else {
            color = UIColor.black
        }

        cell.textLabel?.textColor = color
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cityMenuTableViewController = segue.source as! CityMenuTableViewController
        
        //  將選擇的城市指派給 cureentCity，ListView 頁面即可從來源得到選擇的城市
        if let selectRow = cityMenuTableViewController.tableView.indexPathForSelectedRow?.row {
            currentCity = citys[selectRow]
            selectedIndex = selectRow
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
