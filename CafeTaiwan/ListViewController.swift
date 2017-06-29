//
//  ListViewController.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/5/18.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import UIKit


class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuTransitionManagerDelegate, UIPopoverPresentationControllerDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityMenuButton: UIBarButtonItem!

    let menuTransitionManager = MenuTransitionManager()
    let urlString = "https://cafenomad.tw/api/v1.2/cafes"
    var allCafeShops = [CafeShop]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    
    //  預設排序為網路穩定
    var priorityItem = "網路穩定" {
        didSet {
            prioritySort()
            tableView.reloadData()
        }
    }
    
    //  預設為台北所相對應 Index 為 1
    var cityIndex = 1 {
        didSet {
            tableView.reloadData()
        }
    }
    let cityName = ["keelung", "taipei", "taoyuan", "hsinchu", "miaoli", "taichung",
                    "nantou", "changhua", "yunlin", "chiayi", "tainan", "kaohsiung",
                    "pingtung", "yilan", "hualien", "taitung", "penghu"]
    //  各城市裝咖啡館的容器
    var cityCafe =
        ["keelung": [CafeShop](), "taipei":[CafeShop](),
         "taoyuan": [CafeShop](), "hsinchu": [CafeShop](),
         "miaoli": [CafeShop](), "taichung": [CafeShop](),
         "nantou": [CafeShop](), "changhua": [CafeShop](),
         "yunlin": [CafeShop](), "chiayi": [CafeShop](),
         "tainan": [CafeShop](), "kaohsiung": [CafeShop](),
         "pingtung": [CafeShop](), "yilan": [CafeShop](),
         "hualien": [CafeShop](), "taitung": [CafeShop](),
         "penghu": [CafeShop]()]
    
    //  用來顯示搜尋過後的結果
    var searchResults = [CafeShop]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //  設定 mapView 按鈕
        let buttonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        let mapViewButton = UIButton(type: .custom)
        mapViewButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        mapViewButton.setImage(UIImage(named: "MapButton"), for: .normal)
        mapViewButton.backgroundColor = UIColor.clear
        
        mapViewButton.addTarget(self, action: #selector(self.presentToMapView), for: .touchUpInside)
        
        buttonContainerView.addSubview(mapViewButton)
        
        
        navigationItem.titleView = buttonContainerView
        
        
        getData()
        
        
        //  在 view 上層插入 imageView 當作背景
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "CafePhoto")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        //  讓返回鍵無字
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        //  設定 tableView 背景為透明黑
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        //  取消分隔線
        tableView.separatorStyle = .none
        
        
        UINavigationBar.appearance().backgroundColor = UIColor.brown

        //  設定 SearchController
        searchController.searchBar.placeholder = "請輸入店名或地址..."
        searchController.searchResultsUpdater = self
        //  searchBar 啟動時，內容不會轉為黯淡顏色
        searchController.dimsBackgroundDuringPresentation = false
        //  searchbar 啟動時，不要隱藏 navigationBar
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview Delegate & Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return (cityCafe[cityName[cityIndex]]?.count)!
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        
        let cafeShop = (searchController.isActive) ? searchResults[indexPath.row]: cityCafe[cityName[cityIndex]]?[indexPath.row]
        
        
        cell.nameLabel.text = cafeShop?.name
        cell.addressLabel.text = cafeShop?.address
        
        switch priorityItem {
        case "網路穩定":
            cell.ratingImage.image = UIImage(named: "WhiteStars" + String(describing: cafeShop!.wifi))
        case "通常有位":
            cell.ratingImage.image = UIImage(named: "WhiteStars" + String(describing: cafeShop!.seat))
        case "安靜程度":
            cell.ratingImage.image = UIImage(named: "WhiteStars" + String(describing: cafeShop!.quiet))
        case "咖啡好喝":
            cell.ratingImage.image = UIImage(named: "WhiteStars" + String(describing: cafeShop!.tasty))
        case "價格便宜":
            cell.ratingImage.image = UIImage(named: "WhiteStars" + String(describing: cafeShop!.cheap))
        case "裝潢音樂":
            cell.ratingImage.image = UIImage(named: "WhiteStars" + String(describing: cafeShop!.music))
        default:
            break
        }
        
        //  設定 cell 背景、字體顏色
        cell.nameLabel.textColor = UIColor.white
        cell.addressLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        
        
        return cell
    }
    

    //  取得資料
    func getData() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                self.parseJson(data: data)
                
                //  切回主執行緒攻動 UI
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        //  開始任務
        task.resume()
    }
    
    //  解析 JSon
    func parseJson(data: Data)  {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
            
            for cafe in jsonResult {
                
                let cafeShop = CafeShop()
                cafeShop.id = cafe["id"] as! String
                cafeShop.city = cafe["city"] as! String
                cafeShop.name = cafe["name"] as! String
                cafeShop.address = cafe["address"] as! String
                cafeShop.latitude = Double(cafe["latitude"] as! String)!
                cafeShop.longitude = Double(cafe["longitude"] as! String)!
                cafeShop.wifi = cafe["wifi"] as! Double
                cafeShop.seat = cafe["seat"] as! Double
                cafeShop.quiet = cafe["quiet"] as! Double
                cafeShop.tasty = cafe["tasty"] as! Double
                cafeShop.cheap = cafe["cheap"] as! Double
                cafeShop.music = cafe["music"] as! Double
                cafeShop.url = cafe["url"] as! String
                cafeShop.limited_time = cafe["limited_time"] as! String
                cafeShop.socket = cafe["socket"] as! String
                cafeShop.standing_desk = cafe["standing_desk"] as! String
                cafeShop.mrt = cafe["mrt"] as! String
                cafeShop.open_time = cafe["open_time"] as! String
                
                //  全台咖啡館資料作為搜尋時的來源
                allCafeShops.append(cafeShop)
                
                //  存入相對應的城市 Key 值
                switch cafeShop.city {
                case "keelung":
                    cityCafe["keelung"]?.append(cafeShop)
                case "taipei":
                    cityCafe["taipei"]?.append(cafeShop)
                case "taoyuan":
                    cityCafe["taoyuan"]?.append(cafeShop)
                case "hsinchu":
                    cityCafe["hsinchu"]?.append(cafeShop)
                case "miaoli":
                    cityCafe["miaoli"]?.append(cafeShop)
                case "taichung":
                    cityCafe["taichung"]?.append(cafeShop)
                case "nantou":
                    cityCafe["nantou"]?.append(cafeShop)
                case "changhua":
                    cityCafe["changhua"]?.append(cafeShop)
                case "yunlin":
                    cityCafe["yunlin"]?.append(cafeShop)
                case "chiayi":
                    cityCafe["chiayi"]?.append(cafeShop)
                case "tainan":
                    cityCafe["tainan"]?.append(cafeShop)
                case "kaohsiung":
                    cityCafe["kaohsiung"]?.append(cafeShop)
                case "pingtung":
                    cityCafe["pingtung"]?.append(cafeShop)
                case "yilan":
                    cityCafe["yilan"]?.append(cafeShop)
                case "hualien":
                    cityCafe["hualien"]?.append(cafeShop)
                case "taitung":
                    cityCafe["taitung"]?.append(cafeShop)
                case "penghu":
                    cityCafe["penghu"]?.append(cafeShop)
                default:
                    break
                }
            }
            
        } catch {
            print(error)
        }
        prioritySort()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "cityMenu":
            
            //  在 present 過去時顯示現在的城市
            let cityMenuTableViewController = segue.destination as! CityMenuTableViewController
            cityMenuTableViewController.currentCity = cityMenuButton.title!
            cityMenuTableViewController.transitioningDelegate = self.menuTransitionManager
            menuTransitionManager.delegate = self
            
        case "detail":
            
            let destinationController = segue.destination as! DetailTableViewController
            if let row = tableView.indexPathForSelectedRow?.row {
                destinationController.cafeShop = (searchController.isActive) ?searchResults[row]: cityCafe[cityName[cityIndex]]?[row]
            }
        case "priorityMenu":
            
            let destinationController = segue.destination
            destinationController.popoverPresentationController?.delegate = self
            
        case "mapView":
            
            let navigationController = segue.destination as! UINavigationController
            let destinationController = navigationController.topViewController as! MapViewController
            
            destinationController.cityIndex = cityIndex
            destinationController.allCafeShops = allCafeShops
            //  水平翻轉動畫
            navigationController.modalTransitionStyle = .flipHorizontal
            
        default:
            break
        }

    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
        //  城市選單 unwind
        if segue.identifier == "unwindCityMenu" {
            //  在 unwind 拿到所選擇的城市參數、及相對應城市索引值
            let sourceController = segue.source as! CityMenuTableViewController
            cityMenuButton.title = sourceController.currentCity
            cityIndex = sourceController.selectedIndex
            prioritySort()
            
        //  偏好排序選單 unwind
        } else if segue.identifier == "unwindPriorityMenu" {
            let sourceController = segue.source as! PriorityMenuViewController
            priorityItem = sourceController.currentPriorityItem
        }
    }
    
    //  手勢觸碰 snapshot dismiss
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //  告訴系統不檢查使用者裝置，無論是 iPhone 或是 ipad 都呈現 popover
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    //  依照偏好設定做排序
    func prioritySort() {
        switch priorityItem {
        case "網路穩定":
            cityCafe[cityName[cityIndex]] = cityCafe[cityName[cityIndex]]?.sorted(by: {($0.wifi > $1.wifi)})
        case "通常有位":
            cityCafe[cityName[cityIndex]] = cityCafe[cityName[cityIndex]]?.sorted(by: {($0.seat > $1.seat)})
        case "安靜程度":
            cityCafe[cityName[cityIndex]] = cityCafe[cityName[cityIndex]]?.sorted(by: {($0.quiet > $1.quiet)})
        case "咖啡好喝":
            cityCafe[cityName[cityIndex]] = cityCafe[cityName[cityIndex]]?.sorted(by: {($0.tasty > $1.tasty)})
        case "價格便宜":
            cityCafe[cityName[cityIndex]] = cityCafe[cityName[cityIndex]]?.sorted(by: {($0.cheap > $1.cheap)})
        case "裝潢音樂":
            cityCafe[cityName[cityIndex]] = cityCafe[cityName[cityIndex]]?.sorted(by: {($0.music > $1.music)})
        default:
            break
        }
    }
    
    func presentToMapView() {
        performSegue(withIdentifier: "mapView", sender: AnyObject.self)
    }

    // MARK: -  Search func
    //  依照使用者輸入的字串進行過濾
    func filterContent(for searchText: String) {
        searchResults = allCafeShops.filter({ (cafeShop) -> Bool in
            //  case insensitive 為不區分大小寫
            if cafeShop.name.localizedCaseInsensitiveContains(searchText) || cafeShop.address.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            return false
        })
    }
    
    //  當使用者選取搜尋列、輸入關鍵字時，此方法就會被呼叫
    func updateSearchResults(for searchController: UISearchController) {
        //  如果有成功取得到使用者輸入的字串，呼叫 filterContext 方法進行內容過濾
        //  最後重新 reload，顯示過濾完的結果
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
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
