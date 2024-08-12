//
//  ViewController.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/17.
//

import UIKit
import Kingfisher
import MJRefresh

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MarketManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var models = [CartItem]()
    var modelsCount = Int()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var marketingHot = [Item]()
    var marketManager = MarketManager()
    
    var refreshControl: UIRefreshControl!
    
    func manager(_ manager: MarketManager, didGet marketingHots: MarketResponse) {
        
        self.marketingHot = marketingHots.data
        self.tableView?.reloadData()
        self.tableView?.mj_header?.endRefreshing()
    }
    
    func manager(_ manager: MarketManager, didFailWith error: any Error) {
        
        self.tableView?.mj_header?.endRefreshing()
        return
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView?.dataSource = self
        tableView?.delegate = self
        marketManager.delegate = self
        
        marketManager.getMarketingHots()
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
        tableView?.mj_header = header
        
        header.setTitle("Pull down to refresh", for: .idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
        
        MJRefreshConfig.default.languageCode = "en"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateBadge()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        marketingHot.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        marketingHot[section].products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellEvenIdentifier = "cellEven"
        let cellOddIdentifier = "cellOdd"
        
        if indexPath.row % 2 == 0 {
            
            let cellEven = tableView.dequeueReusableCell(withIdentifier: cellEvenIdentifier, for: indexPath) as! EvenTableViewCell
            cellEven.evenLabel1?.text = marketingHot[indexPath.section].products[indexPath.row].title
            cellEven.evenLabel2?.text = marketingHot[indexPath.section].products[indexPath.row].description
            
            let evenImageUrl = URL(string: marketingHot[indexPath.section].products[indexPath.row].mainImage)
            cellEven.evenImage.kf.setImage(with: evenImageUrl)
            
            return cellEven
            
        } else {
            
            let cellOdd = tableView.dequeueReusableCell(withIdentifier: cellOddIdentifier, for: indexPath) as! OddTableViewCell
            cellOdd.oddLabel1?.text = marketingHot[indexPath.section].products[indexPath.row].title
            cellOdd.oddLabel2?.text = marketingHot[indexPath.section].products[indexPath.row].description
            
            let oddImage1Url = URL(string: marketingHot[indexPath.section].products[indexPath.row].mainImage)
            cellOdd.oddImage1.kf.setImage(with: oddImage1Url)
            
            let oddImage2Url = URL(string: marketingHot[indexPath.section].products[indexPath.row].images[indexPath.row])
            cellOdd.oddImage2.kf.setImage(with: oddImage2Url)
            
            let oddImage3Url = URL(string: marketingHot[indexPath.section].products[indexPath.row].images[indexPath.row])
            cellOdd.oddImage3.kf.setImage(with: oddImage3Url)
            
            let oddImage4Url = URL(string: marketingHot[indexPath.section].products[indexPath.row].images[indexPath.row])
            cellOdd.oddImage4.kf.setImage(with: oddImage4Url)
            
            return cellOdd
            
        }
    }
    //    MARK: send data in home page.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = DetailPageViewController()
        let selectedProduct = marketingHot[indexPath.section].products[indexPath.row]
        detailVC.selectedProduct = selectedProduct
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        marketingHot[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let view = view as! UITableViewHeaderFooterView
        view.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.textLabel?.textColor = UIColor.darkGray
    }
    
    @objc func refreshData() {
        marketManager.getMarketingHots()
    }
    
    func updateBadge() {
        
        do {
            models = try context.fetch(CartItem.fetchRequest())
            modelsCount = models.count
        } catch {
            
        }
        DispatchQueue.main.async {
            
            self.tabBarController?.tabBar.items?[2].badgeValue = self.modelsCount > 0 ? "\(self.modelsCount)" : nil
            self.tabBarController?.tabBar.items?[2].badgeColor = .brown
        }
    }
    
}
