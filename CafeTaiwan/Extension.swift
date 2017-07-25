//
//  Extension.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/7/21.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SafariServices

extension UIViewController {
    
    func customDeepBrown() -> UIColor {
        return  UIColor(red: 100 / 255, green: 58 / 255, blue: 44 / 255, alpha: 1)
    }
    
    //  背景 ImageView
    func creatBackgroundView(with viewFrame: CGRect) -> UIImageView {
        let backgroundView = UIImageView(image: UIImage(named: "CafePhoto"))
        backgroundView.contentMode = .scaleAspectFill
        return backgroundView
    }
 
    //  網路無法連線的 Alert
    func networkDisconnected() {
        
        let alertController = UIAlertController(title: "網路尚未連線", message: "請至設定開啟 Wi-Fi 或是 行動服務", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
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
    
    //  設定 UISearchBar 外觀
    func setSearchControllerAppearance(with searchController: UISearchController) {
        
        
        //  searchBar 啟動時，內容不會轉為黯淡顏色
        searchController.dimsBackgroundDuringPresentation = false
        //  searchBar 啟動時，不要隱藏 navigationBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        //  searchBar 外框顏色
        searchController.searchBar.barTintColor = UIColor(red: 100 / 255, green: 58 / 255, blue: 44 / 255, alpha: 1)
        
        //  改變 searchBar 內框的背景、文字、Icon顏色
        for subview in searchController.searchBar.subviews {
            for view in subview.subviews {
                if view.isKind(of: UITextField.self) {
                    let searchBarTextField = view as! UITextField
                    
                    //  背景
                    searchBarTextField.backgroundColor = UIColor(red: 46 / 255, green: 31 / 255, blue: 26 / 255, alpha: 1)
                    
                    //  文字
                    searchBarTextField.textColor = UIColor.white
                    
                    //  Placeholder
                    searchBarTextField.attributedPlaceholder = NSAttributedString(string: "請輸入店名或地址...", attributes: [NSForegroundColorAttributeName: UIColor.white])
                    
                    // Icon
                    let searchIconView = searchBarTextField.leftView as! UIImageView
                    searchIconView.image = searchIconView.image?.withRenderingMode(.alwaysTemplate)
                    searchIconView.tintColor = UIColor.white
                }
            }
        }
    }
}
