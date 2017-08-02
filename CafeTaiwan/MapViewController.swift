//
//  MapViewController.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/6/3.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ReachabilitySwift

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    
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
    
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var officailWebsiteButton: UIButton!
    
    @IBOutlet weak var closeDetailButton: UIButton!
    
    
    var searchController: UISearchController!
    var allCafeShops: [CafeShop]!
    
    
    var currentLocation: CLLocation?
    var userOnCenterCoordinate: CLLocationCoordinate2D?
    var currentAnnotation: CafeShopAnnotation?
    
    let reachability = Reachability()!
    
    
    var cityIndex: Int!
    let citys = [(city: "基隆", lat: 25.127690, lon: 121.739382),
                 (city: "台北", lat: 25.033139, lon: 121.558514),
                 (city: "桃園", lat: 24.996521, lon: 121.318657),
                 (city: "新竹", lat: 24.832899, lon: 121.010270),
                 (city: "苗栗", lat: 24.561990, lon: 120.816375),
                 (city: "台中", lat: 24.144679, lon: 120.683913),
                 (city: "南投", lat: 23.962870, lon: 120.993303),
                 (city: "彰化", lat: 24.045698, lon: 120.516810),
                 (city: "雲林", lat: 23.709785, lon: 120.432353),
                 (city: "嘉義", lat: 23.455351, lon: 120.257344),
                 (city: "台南", lat: 22.998770, lon: 120.224964),
                 (city: "高雄", lat: 22.630864, lon: 120.323805),
                 (city: "屏東", lat: 22.548488, lon: 120.549624),
                 (city: "宜蘭", lat: 24.701098, lon: 121.742895),
                 (city: "花蓮", lat: 23.971692, lon: 121.609450),
                 (city: "台東", lat: 22.792284, lon: 121.065570),
                 (city: "澎湖", lat: 23.572096, lon: 119.581265)]
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        visualEffectView.frame = view.frame
        visualEffectView.alpha = 0
        //effect = visualEffectView.effect
        //visualEffectView.effect = nil
        
        setMapRegion(with: cityIndex)
        
        //  裝按鈕的容器視圖
        let buttonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
        
        //  返回 tableview 按鈕
        let listViewButton = UIButton(type: .custom)
        listViewButton.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        listViewButton.layer.cornerRadius = listViewButton.frame.size.width / 2
        listViewButton.setImage(UIImage(named: "ListButton"), for: .normal)
        listViewButton.addTarget(self, action: #selector(self.backToList), for: .touchUpInside)
        buttonContainerView.addSubview(listViewButton)
        navigationItem.titleView = buttonContainerView
        

        
        //  設定 searchController
        let searchTable  = storyboard?.instantiateViewController(withIdentifier: "SearchView") as! SearchView
        searchTable.allCafeShops = allCafeShops
        
        searchController = UISearchController(searchResultsController: searchTable)
        searchController.searchResultsUpdater = searchTable
        /*
        searchController.searchBar.placeholder = "請輸入店名或地址..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(red: 100 / 255, green: 58 / 255, blue: 44 / 255, alpha: 1)
        */
        setSearchControllerAppearance(with: searchController)
        searchController.searchBar.sizeToFit()
        searchBarView.addSubview(searchController.searchBar)
 
    
        navigationController?.navigationBar.isTranslucent = false
        self.cafeShopTranformAnnotation()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 設置 Reachability
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.networkDisconnected()
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Not reachable")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Button Press
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! SearchView
        let cafeShop = sourceController.didSelectCafeShop
        let coordinate = CLLocationCoordinate2D(latitude: (cafeShop?.latitude)!, longitude: (cafeShop?.longitude)!)
        setMapRegionWithSpan(coordinate: coordinate)
        /*
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        */
    }
    
    @IBAction func chooseCity() {
        let optionMenu = UIAlertController(title: "", message: "請選擇城市", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(cancel)

        for index in 0..<citys.count {
        let action = UIAlertAction(title: citys[index].city, style: .default) { _ in
            self.setMapRegion(with: index)
        }
        
            optionMenu.addAction(action)
        }
        present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func getUserLocationButtonPress() {
        getUserLocation()
    }
    
    @IBAction func closeDetailButtonPress() {
        animateOut()
        currentAnnotation = nil
    }
    
    @IBAction func getDirectionButtonPress() {
        
        guard let currentAnnotation = currentAnnotation else { return }
        getDirection(name: currentAnnotation.name, latitude: nil, longitude: nil, coordinate: currentAnnotation.coordinate)
    }
    
    @IBAction func seeMoreButtonPress() {
        
        guard let currentAnnotation = currentAnnotation else { return }
        loadWebsite(urlString: "https://cafenomad.tw/shop/\(currentAnnotation.id)")
    }
    
    @IBAction func officailWebsiteButtonPress () {
        
        guard let currentAnnotation = currentAnnotation else { return }
        loadWebsite(urlString: currentAnnotation.url)
    }
    
    func backToList() {
        dismiss(animated: true, completion: nil)
    }
    

    //  設定顯示區域
    func setMapRegion(with index: Int) {
        let coordinate = CLLocationCoordinate2D(latitude: self.citys[index].lat, longitude: self.citys[index].lon)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 15000, 15000)
        self.mapView.setRegion(region, animated: true)
        self.navigationItem.leftBarButtonItem?.title = self.citys[index].city
    }
    
    func setMapRegionWithSpan(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.001, 0.001)
        //0.001
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func cafeShopTranformAnnotation() {
        
        for cafeShop in allCafeShops {
            
            let annotation = CafeShopAnnotation()
            annotation.id = cafeShop.id
            annotation.city = cafeShop.city
            annotation.name = cafeShop.name
            annotation.wifi = cafeShop.wifi
            annotation.seat = cafeShop.seat
            annotation.quiet = cafeShop.quiet
            annotation.tasty = cafeShop.tasty
            annotation.cheap = cafeShop.cheap
            annotation.music = cafeShop.music
            annotation.address = cafeShop.address
            annotation.latitude = cafeShop.latitude
            annotation.longitude = cafeShop.longitude
            annotation.url = cafeShop.url
            annotation.limited_time = cafeShop.limited_time
            annotation.socket = cafeShop.socket
            annotation.standing_desk = cafeShop.standing_desk
            annotation.mrt = cafeShop.mrt
            annotation.open_time = cafeShop.open_time
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func animateIn() {
        view.addSubview(detailScrollView)
        
        detailScrollView.backgroundColor = UIColor.clear
        detailScrollView.frame = mapView.frame
        detailScrollView.bounds = mapView.frame
        detailScrollView.contentSize = CGSize(width: mapView.frame.width, height: 930)
        detailScrollView.contentOffset = .zero
        detailScrollView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        //detailScrollView.alpha = 0
        
        //closeDetailButton.alpha = 0
        closeDetailButton.center = searchBarView.center
        view.addSubview(closeDetailButton)
        
        setDetailView()
        
        UIScrollView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            
            //self.detailScrollView.alpha = 1
            self.detailScrollView.transform = CGAffineTransform.identity
            
            self.closeDetailButton.alpha = 1
        }
    }
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.detailScrollView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            //self.detailScrollView.alpha = 0
            self.visualEffectView.alpha = 0
            self.closeDetailButton.alpha = 0
            
        }) { (success: Bool) in
            self.detailScrollView.removeFromSuperview()
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation!.isKind(of: MKUserLocation.self) {
            mapView.userLocation.title = "我的位置"
            return
        }
        currentAnnotation = view.annotation as? CafeShopAnnotation
        animateIn()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "cafeShopPin"
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
            
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            
            annotationView = deqAnno
            annotationView?.annotation = annotation
    
        } else {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "Bitmap")
        }
        
        
        let gesture = UIGestureRecognizer(target: annotationView, action: #selector(self.animateIn))
        annotationView?.addGestureRecognizer(gesture)
        
        return annotationView
    }
 
    
    //  設定 detail 頁面
    func setDetailView() {
        closeDetailButton.backgroundColor = UIColor.clear
        guard let currentAnnotation = currentAnnotation else { return }
        
        //  設定內容文字
        
        nameLabel.text = currentAnnotation.name
        addressLabel.text = currentAnnotation.address
        
        if currentAnnotation.mrt.isEmpty {
            mrtLabel.text = "無"
        } else {
            mrtLabel.text = currentAnnotation.mrt
        }
        
        if currentAnnotation.open_time.isEmpty {
            openTimeLabel.text = "無提供資料"
        } else {
            openTimeLabel.text = currentAnnotation.open_time
        }
        
        switch currentAnnotation.socket {
        case "yse":
            socketLabel.text = "很多"
        case "maybe":
            socketLabel.text = "還好，看座位"
        case "no":
            socketLabel.text = "很少"
        default:
            socketLabel.text = "無提供資料"
        }
        
        switch currentAnnotation.standing_desk {
        case "yes":
            standingDeskLabel.text = "有些座位可以"
        case "no":
            standingDeskLabel.text = "無法"
        default:
            standingDeskLabel.text = "無提供資料"
        }
        
        switch currentAnnotation.limited_time {
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
        
        wifiRatingImage.image = UIImage(named: "WhiteStars" + String(currentAnnotation.wifi))
        seatRatingImage.image = UIImage(named: "WhiteStars" + String(currentAnnotation.seat))
        quietRatingImage.image = UIImage(named: "WhiteStars" + String(currentAnnotation.quiet))
        tastyRatingImage.image = UIImage(named: "WhiteStars" + String(currentAnnotation.tasty))
        cheapRatingImage.image = UIImage(named: "WhiteStars" + String(currentAnnotation.cheap))
        musicRatingImage.image = UIImage(named: "WhiteStars" + String(currentAnnotation.music))
        
        //  店家無官網移除 button
        
        if currentAnnotation.url.isEmpty {
            officailWebsiteButton.removeFromSuperview()
        }
    }
 
    //  確認權限
    func checkAuthStatus() {
        //  首次使用，向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            //  取得定位服務授權
            locationManager.requestWhenInUseAuthorization()
            
            //  更新位置
            locationManager.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .denied {
            
            let alertController = UIAlertController(title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        
        if UserDefaults.standard.object(forKey: "first") == nil || UserDefaults.standard.object(forKey: "first") as! Int != 1 {
            
            setMapRegionWithSpan(coordinate: currentLocation!.coordinate)
            
            UserDefaults.standard.set(1, forKey: "first")
            UserDefaults.standard.synchronize()
        }
    }
    func getUserLocation() {
        
        checkAuthStatus()
        if let currentLocation = currentLocation{
            setMapRegionWithSpan(coordinate: currentLocation.coordinate)
            userOnCenterCoordinate = currentLocation.coordinate
            //setMapRegionWithSpan(coordinate: mapView.userLocation.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        

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

