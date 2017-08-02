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
    
    @IBOutlet weak var wifiRatingImage: UIImageView!
    @IBOutlet weak var seatRatingImage: UIImageView!
    @IBOutlet weak var quietRatingImage: UIImageView!
    @IBOutlet weak var tastyRatingImage: UIImageView!
    @IBOutlet weak var cheapRatingImage: UIImageView!
    @IBOutlet weak var musicRatingImage: UIImageView!
    
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

        //  取消 tableview 分隔線
        tableView.separatorStyle = .none
        
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
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return cafeShop.url.isEmpty ? 15: 16
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
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

        //  設定評分圖片
        
        wifiRatingImage.image = UIImage(named: "BlackStars" + String(cafeShop.wifi))
        seatRatingImage.image = UIImage(named: "BlackStars" + String(cafeShop.seat))
        quietRatingImage.image = UIImage(named: "BlackStars" + String(cafeShop.quiet))
        tastyRatingImage.image = UIImage(named: "BlackStars" + String(cafeShop.tasty))
        cheapRatingImage.image = UIImage(named: "BlackStars" + String(cafeShop.cheap))
        musicRatingImage.image = UIImage(named: "BlackStars" + String(cafeShop.music))
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
