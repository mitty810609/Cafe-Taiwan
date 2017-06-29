//
//  PriorityMenuViewController.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/5/25.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import UIKit

class PriorityMenuViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!

    let priorityItem = ["網路穩定", "通常有位", "安靜程度", "咖啡好喝", "價格便宜", "裝潢音樂"]
    var currentPriorityItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //  MARK: - PickerView Delegate & Data Source
    
    //  pickerView 有幾列可以選擇
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //  各列裡面有多少資料可以選擇
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorityItem.count
    }
    
    //  各列顯示的字串
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return priorityItem[row]
    }
    
    //  選擇的項目
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPriorityItem = priorityItem[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
