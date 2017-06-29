//
//  DetailTableViewController.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/5/22.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import UIKit
import SafariServices
import MapKit

class DetailTableViewController: UITableViewController, MKMapViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mrtLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var socketLabel: UILabel!
    @IBOutlet weak var limitedTimeLabel: UILabel!
    @IBOutlet weak var standingDeskLabel: UILabel!
    
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var officailWebsiteButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var cafeShop: CafeShop!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
/*
        //  背景圖片
        let backgroundView = UIImageView(frame: view.bounds)
            //UIScreen.main.bounds)
        backgroundView.image = UIImage(named: "CafePhoto")
        backgroundView.contentMode = .scaleAspectFill
        view.addSubview(backgroundView)
*/
        //  模糊效果
/*        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds;
        backgroundView.addSubview(blurEffectView)
        //view.addSubview(blurEffectView)
*/
        
        //  將 backgroundView 插入 tableView
        //tableView.insertSubview(backgroundView, at: 0)
        //tableView.backgroundColor = UIColor.clear
        //view.insertSubview(backgroundView, at: 0)
        //view.addSubview(self.tableView)
        
        //  取消 tableview 分隔線
        tableView.separatorStyle = .none
        
//        seeMoreButton.frame = CGRect(x: 0, y: 0, width: 1000, height: 100)
//        seeMoreButton.layer.cornerRadius = 10
//        seeMoreButton.backgroundColor = UIColor.brown
        setLabelText()
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: cafeShop.latitude, longitude: cafeShop.longitude)
        annotation.title = cafeShop.name
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
        mapView.setRegion(region, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return cafeShop.url.isEmpty ? 15: 16
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "identifier"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = UIImage(named: "Bitmap")
            annotationView.canShowCallout = true
        
        return annotationView
    }
    //  設定 label 文字
    func setLabelText() {
        nameLabel.text = cafeShop.name
        addressLabel.text = cafeShop.address
        
        if cafeShop.mrt.isEmpty {
            mrtLabel.text = "無"
        } else {
            mrtLabel.text = cafeShop.mrt
        }
        
        if cafeShop.open_time.isEmpty {
            openTimeLabel.text = "無提供資料"
        } else {
            openTimeLabel.text = cafeShop.open_time
        }
        
        switch cafeShop.socket {
        case "yse":
            socketLabel.text = "很多"
        case "maybe":
            socketLabel.text = "還好，看座位"
        case "no":
            socketLabel.text = "很少"
        default:
            socketLabel.text = "無提供資料"
        }
        
        switch cafeShop.standing_desk {
        case "yes":
            standingDeskLabel.text = "有些座位可以"
        case "no":
            standingDeskLabel.text = "無法"
        default:
            standingDeskLabel.text = "無提供資料"
        }
        
        switch cafeShop.limited_time {
        case "yse":
            limitedTimeLabel.text = "一律有限時"
        case "maybe":
            limitedTimeLabel.text = "看情況，假日或客滿限時"
        case "no":
            limitedTimeLabel.text = "一律不限時"
        default:
            limitedTimeLabel.text = "無提供資料"
        }

        
    }
    @IBAction func seeMoreButtonPress() {
        loadWebsite(urlString: "https://cafenomad.tw/shop/\(cafeShop.id)")
    }
    
    @IBAction func getDirectionButtonPress() {
        getDirection(name: cafeShop.name, latitude: cafeShop.latitude, longitude: cafeShop.longitude, coordinate: nil)
    }
    
    @IBAction func officailWebsiteButtonPress() {
        loadWebsite(urlString: cafeShop.url)
    }

//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
//
//        // Configure the cell...
//        cell.backgroundColor = UIColor.clear
//        return cell
//    }


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
extension UIViewController {
    //  使用 SFSafariController 載入網頁
    func loadWebsite(urlString: String) {
        if let url = URL(string: urlString) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }
    
    //  導航
    func getDirection(name: String, latitude: Double?, longitude: Double?, coordinate: CLLocationCoordinate2D?) {
        
        let destinationCoordinate = (coordinate != nil) ? coordinate!: CLLocationCoordinate2DMake(latitude!, longitude!)
        let placeMark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placeMark)
        
        //   目的地名稱
        mapItem.name = name
        
        let launchOption = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOption)
    }
}
