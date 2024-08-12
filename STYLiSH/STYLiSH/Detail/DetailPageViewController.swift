//
//  DetailPage.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/25.
//

import Foundation
import UIKit
import Kingfisher
import IQKeyboardManagerSwift
import StatusAlert
import CoreData

class DetailPageViewController: UIViewController, MarketManagerDelegate {
    
    func manager(_ manager: MarketManager, didGet marketingHots: MarketResponse) {
        
        self.marketingHot = marketingHots.data
        self.detailPageTableView?.reloadData()
    }
    
    func manager(_ manager: MarketManager, didFailWith error: any Error) {
        
        return
    }
    
    var detailPageTableView: UITableView!
    var imageScrollView: UIScrollView!
    var pageControl: UIPageControl!
    var shoppingButton = DetailPageShoppingButton()
    var addToCartPage = UIView()
    var addToCartTableView = UITableView()
    var addToCartBottomConstraint: NSLayoutConstraint?
    var maskOfDetailPage = UIView()
    
    var selectedProduct: ProductProtocol?
    var marketingHot = [Item]()
    var marketManager = MarketManager()
    var isAddToCartVisible = false
    
    var sizeResultArray: [String] = []
    var colorResultArray: [String] = []
    
    var rawColorCode = String()
    var fitColorCode = String()
    var rawColorName = String()
    var sizeDisableToChoose = String()
    var sizeButtonTitle = String()
    var indexOfSizeDisableToChoose: Int?
    var rawSize = String()
    
    var rawCart = "1"
    var stockData = Int()
    
    var models = [CartItem]()
    var modelsCount = Int()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var newItem: CartItem?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupTableView()
        setUpScrollView()
        setupShoppingButton()
        setupAddToCartTableView()
        setupMaskForDetailPage()
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        setupNavigationController()
        updateBadge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

//MARK: TableView
extension DetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        detailPageTableView = UITableView(frame: view.bounds, style: .plain)
        detailPageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaLayoutGuide.layoutFrame.height * 0.1, right: 0)
        
        detailPageTableView.delegate = self
        detailPageTableView.dataSource = self
        
        detailPageTableView.register(DetailPageTitleCell.self, forCellReuseIdentifier: "titleCell")
        detailPageTableView.register(DetailPageStoryCell.self, forCellReuseIdentifier: "storyCell")
        detailPageTableView.register(DetailPageColorCell.self, forCellReuseIdentifier: "colorCell")
        detailPageTableView.register(DetailPageInformationCell.self, forCellReuseIdentifier: "informationCell")
        
        detailPageTableView.backgroundColor = .secondarySystemFill
        detailPageTableView.separatorStyle = .none
        view.addSubview(detailPageTableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == addToCartTableView {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == detailPageTableView {
            return 9
        } else {
            if section == 0 {
                return 1
            } else {
                return 3
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == detailPageTableView {
            
            if indexPath.row == 0 {
                return 90
            } else if indexPath.row == 1 {
                return UITableView.automaticDimension
            } else {
                return 50
            }
        } else {
            if indexPath.section == 0 {
                return 100
            } else {
                return 115
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == detailPageTableView {
            
            if indexPath.row == 0 {
                let titleCell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! DetailPageTitleCell
                if let selectedProduct = selectedProduct {
                    titleCell.updateUI(product: selectedProduct)}
                return titleCell
                
            } else if indexPath.row == 1 {
                
                let storyCell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! DetailPageStoryCell
                if let selectedProduct = selectedProduct {
                    storyCell.updateUI(product: selectedProduct) }
                return storyCell
                
            } else if indexPath.row == 2 {
                
                let colorCell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! DetailPageColorCell
                if let selectedProduct = selectedProduct {
                    colorCell.updateUI(product: selectedProduct) }
                return colorCell
                
            } else {
                
                let informationCell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! DetailPageInformationCell
                
                if let selectedProduct = selectedProduct {
                    switch indexPath.row {
                    case 3: informationCell.updateUI(product: selectedProduct, indexPath: 3)
                    case 4: informationCell.updateUI(product: selectedProduct, indexPath: 4)
                    case 5: informationCell.updateUI(product: selectedProduct, indexPath: 5)
                    case 6: informationCell.updateUI(product: selectedProduct, indexPath: 6)
                    case 7: informationCell.updateUI(product: selectedProduct, indexPath: 7)
                    case 8: informationCell.updateUI(product: selectedProduct, indexPath: 8)
                    default: return UITableViewCell()
                    }
                }
                return informationCell
            }
            
        } else {
            
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    
                    let cartTitleCell = tableView.dequeueReusableCell(withIdentifier: "addToCartTitleCell", for: indexPath) as! AddToCartTitleCell
                    if let selectedProduct = selectedProduct {
                        cartTitleCell.updateUI(product: selectedProduct)
                    }
                    cartTitleCell.exitButton.addTarget(self, action: #selector(tapExitButton), for: .touchUpInside)
                    
                    return cartTitleCell
                }
            } else {
                if indexPath.row == 0 {
                    let cartColorCell = tableView.dequeueReusableCell(withIdentifier: "addToCartColorCell", for: indexPath) as! AddToCartColorCell
                    cartColorCell.delegate = self
                    if let selectedProduct = selectedProduct {
                        cartColorCell.updateUI(product: selectedProduct)
                    } else {
                    }
                    return cartColorCell
                    
                } else if indexPath.row == 1 {
                    
                    let cartSizeCell = tableView.dequeueReusableCell(withIdentifier: "addToCartSizeCell", for: indexPath) as! AddToCartSizeCell
                    cartSizeCell.delegate = self
                    if let selectedProduct = selectedProduct {
                        cartSizeCell.updateUI(product: selectedProduct)
                        if cartSizeCell.addToCartSizeButton.tag == indexOfSizeDisableToChoose {
                            cartSizeCell.addToCartSizeButton.isUserInteractionEnabled = false
                            cartSizeCell.addToCartSizeButton.isEnabled = false
                        }
                    }
                    return cartSizeCell
                    
                } else {
                    let cartAmountCell = tableView.dequeueReusableCell(withIdentifier: "addToCartAmountCell", for: indexPath) as! AddToCartAmountCell
                    cartAmountCell.delegate = self
                    return cartAmountCell
                }
            }
            return UITableViewCell()
        }
    }
    
    @objc func tapExitButton() {
        
        addToCartTableView.isHidden = true
        maskOfDetailPage.isHidden = true
        addToCartBottomConstraint?.constant = 700
        shoppingButton.shoppingButton.backgroundColor = colorWithHexString(hex: "3F3A3A")
        
        fitColorCode = ""
        rawColorCode = ""
        rawSize = ""
        rawCart = "1"
        
        if let colorCell = addToCartTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AddToCartColorCell {
            colorCell.resetColorSelection()
        }
        
        if let sizeCell = addToCartTableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? AddToCartSizeCell {
            sizeCell.resetSizeSelection()
            
            if let selectedProduct = selectedProduct {
                sizeCell.updateButtonUI(fitColorCode: fitColorCode, product: selectedProduct)
            }
        }
        view.layoutIfNeeded()
    }
}

//MARK: ScrollView
extension DetailPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
    
    func setUpScrollView() {
        
        if let selectedProduct = selectedProduct {
            imageScrollView = UIScrollView()
            imageScrollView.frame = CGRect(x: 0, y: -100, width: view.frame.width, height: 600)
            imageScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(selectedProduct.images.count + 1), height: 600)
            imageScrollView.isPagingEnabled = true
            imageScrollView.showsHorizontalScrollIndicator = false
            imageScrollView.delegate = self
            
            for i in 0 ... selectedProduct.images.count {
                
                let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * view.frame.width, y: 0, width: view.frame.width, height: 600))
                
                if i == 0 {
                    imageView.kf.setImage(with: URL(string: selectedProduct.mainImage))
                } else {
                    imageView.kf.setImage(with: URL(string: selectedProduct.images[i-1]))
                }
                
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                
                imageScrollView.addSubview(imageView)
            }
            
            pageControl = UIPageControl()
            pageControl.frame = CGRect(x: -100, y: 460, width: view.frame.width, height: 20)
            pageControl.numberOfPages = selectedProduct.images.count
            pageControl.currentPage = getCurrentPageNumber()
            pageControl.pageIndicatorTintColor = .black
            pageControl.currentPageIndicatorTintColor = .white
            pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 500))
            headerView.addSubview(imageScrollView)
            headerView.addSubview(pageControl)
            headerView.backgroundColor = .clear
            
            detailPageTableView.tableHeaderView = headerView
        }
    }
    
    @objc func pageControlChanged(_ sender: UIPageControl) {
        
        let page = sender.currentPage
        let offset = CGPoint(x: CGFloat(page) * imageScrollView.frame.width, y: 0)
        imageScrollView.setContentOffset(offset, animated: true)
    }
    
    func getCurrentPageNumber() -> Int {
        
        let page = imageScrollView.contentOffset.x / imageScrollView.bounds.width
        return Int(page)
    }
}

extension DetailPageViewController: AddToCartColorCellDelegate, AddToCartSizeCellDelegate, AddToCartAmountCellDelegate {
    
    func didUpdateTextfieldValue(_ text: String) {
        
        self.rawCart = text
    }
    
    func didTapButtonInCell(colorCode: String?) {
        
        self.rawColorCode = ""
        self.rawSize = ""
        self.rawColorCode = colorCode ?? ""
        self.fitColorCode = rawColorCode.uppercased()
        self.fitColorCode = fitColorCode.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        
        if let selectedProduct = selectedProduct {
            indexOfSizeDisableToChoose = nil
            
            if let sizeCell = addToCartTableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? AddToCartSizeCell {
                
                sizeCell.resetSizeSelection()
                sizeCell.updateButtonUI(fitColorCode: fitColorCode, product: selectedProduct)
            }
            
            if let amountCell = addToCartTableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? AddToCartAmountCell{
                amountCell.addToCartStockLabel.text = nil
                amountCell.addToCartStockLabel.isHidden = true
                amountCell.addToCartAmountTextField.text = "1"
            }
        }
    }
    
    func didTapSizeButton(_ button: UIButton?, size: String?, colorName: String?) {
        
        self.rawSize = size ?? ""
        self.rawColorName = colorName ?? ""
        
        if let amountCell = addToCartTableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? AddToCartAmountCell {
            
            if let selectedProduct = selectedProduct {
                amountCell.updateStockLabel(fitColorCode: fitColorCode, product: selectedProduct, size: rawSize)
                stockData = amountCell.stockInt
                amountCell.getStockData(with: stockData)
                amountCell.addToCartAmountTextField.text = "1"
                
                amountCell.addToCartAmountMinusButton.isUserInteractionEnabled = true
                amountCell.addToCartAmountPlusButton.isUserInteractionEnabled = true
                amountCell.addToCartAmountTextField.isUserInteractionEnabled = true
                
                amountCell.updateButtonStyle(button: amountCell.addToCartAmountPlusButton, borderColor: .darkGray, borderAlpha: 1, imageAlpha: 1)
                amountCell.updateButtonStyle(button: amountCell.addToCartAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
                amountCell.updateTextfieldStyle(textfield: amountCell.addToCartAmountTextField, borderColor: .darkGray, alpha: 1)
                
                shoppingButton.shoppingButton.backgroundColor = colorWithHexString(hex: "3F3A3A")
            }
        }
    }
}


//MARK: ShoppingButton
extension DetailPageViewController {
    
    func setupShoppingButton() {
        
        shoppingButton = DetailPageShoppingButton()
        shoppingButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(shoppingButton)
        
        NSLayoutConstraint.activate([
            shoppingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            shoppingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shoppingButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0.5),
            shoppingButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14)
        ])
        
        shoppingButton.layer.borderWidth = 0.5
        shoppingButton.layer.borderColor = UIColor.lightGray.cgColor
        shoppingButton.shoppingButton.addTarget(self, action: #selector(shoppingButtonTapped), for: .touchUpInside)
    }
}

//MARK: NavigationItem
extension DetailPageViewController {
    
    func setupNavigationController() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.view.backgroundColor = .clear
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Icons_44px_Back01"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: Cart tableView
extension DetailPageViewController {
    
    func setupAddToCartTableView() {
        
        addToCartTableView = UITableView()
        addToCartTableView.translatesAutoresizingMaskIntoConstraints = false
        addToCartTableView.backgroundColor = .white
        addToCartTableView.layer.cornerRadius = 20
        addToCartTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addToCartTableView.separatorStyle = .none
        
        addToCartTableView.delegate = self
        addToCartTableView.dataSource = self
        addToCartTableView.isScrollEnabled = true
        addToCartTableView.isHidden = true
        
        view.addSubview(addToCartTableView)
        //        MARK: constraint
        addToCartBottomConstraint = addToCartTableView.bottomAnchor.constraint(equalTo: shoppingButton.topAnchor, constant: 700)
        
        if let addToCartBottomConstraint = addToCartBottomConstraint {
            NSLayoutConstraint.activate([
                addToCartTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                addToCartTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
                addToCartTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                addToCartBottomConstraint
            ])
        }
        
        addToCartTableView.register(AddToCartTitleCell.self, forCellReuseIdentifier: "addToCartTitleCell")
        addToCartTableView.register(AddToCartColorCell.self, forCellReuseIdentifier: "addToCartColorCell")
        addToCartTableView.register(AddToCartSizeCell.self, forCellReuseIdentifier: "addToCartSizeCell")
        addToCartTableView.register(AddToCartAmountCell.self, forCellReuseIdentifier: "addToCartAmountCell")
    }
    
    func setupMaskForDetailPage() {
        
        maskOfDetailPage.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        maskOfDetailPage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(maskOfDetailPage)
        view.layer.insertSublayer(maskOfDetailPage.layer, below: addToCartTableView.layer)
        
        NSLayoutConstraint.activate([
            maskOfDetailPage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            maskOfDetailPage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            maskOfDetailPage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            maskOfDetailPage.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        maskOfDetailPage.isHidden = addToCartTableView.isHidden
    }
    
    @objc func shoppingButtonTapped() {
        
        if addToCartTableView.isHidden == true {
            
            addToCartTableView.isHidden = false
            maskOfDetailPage.isHidden = addToCartTableView.isHidden
            shoppingButton.shoppingButton.backgroundColor = colorWithHexString(hex: "999999")
            
            let layerForShoppingButton = shoppingButton.layer
            let layerForAddToCartTableView = addToCartTableView.layer
            
            view.layer.insertSublayer(layerForAddToCartTableView, below: layerForShoppingButton)
            view.layer.insertSublayer(maskOfDetailPage.layer, below: layerForAddToCartTableView)
            
            addToCartBottomConstraint?.constant = addToCartTableView.isHidden ? 700 : 0
            UIView.animate(withDuration: 0.5, delay: 0, animations: { self.view.layoutIfNeeded()})
            
        } else {
            
            if let selectedProduct = selectedProduct {
                
                if rawSize != "" && rawColorCode != "" && rawCart != "" {
                    
                    showAddToCartAlert()
                    shoppingButton.shoppingButton.isUserInteractionEnabled = true
                    
                    addToCartTableView.isHidden = true
                    maskOfDetailPage.isHidden = true
                    
                    shoppingButton.shoppingButton.backgroundColor = colorWithHexString(hex: "3F3A3A")
                    getCartitem(product: selectedProduct)
                    NotificationCenter.default.post(name: NSNotification.Name("reloadCartItem"), object: nil)
                    
                } else {
                    
                    return
                    
                }
            }
        }
    }
    
    func getCartitem(product: ProductProtocol) {
        
        newItem = CartItem(context: context)
        if let newItem = newItem {
            newItem.title = product.title
            newItem.color = fitColorCode
            newItem.image = product.mainImage
            newItem.price = String(product.price)
            newItem.size = rawSize
            newItem.stock = String(stockData)
            newItem.cartNumber = String(rawCart)
            newItem.id = String(product.id)
            newItem.colorName = rawColorName
        }
        
        do {
            try context.save()
        } catch { }
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

func showAddToCartAlert() {
    
    let addToCartAlert = StatusAlert()
    addToCartAlert.title = "Success"
    addToCartAlert.appearance.backgroundColor = .gray
    addToCartAlert.appearance.tintColor = .white
    addToCartAlert.image = UIImage(named: "Icons_44px_Success01")
    addToCartAlert.canBePickedOrDismissed = true
    DispatchQueue.main.async {
        addToCartAlert.showInKeyWindow()
    }
}

func colorWithHexString(hex: String) -> UIColor {
    
    var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if hexString.hasPrefix("#") {
        hexString.remove(at: hexString.startIndex)
    }
    
    guard hexString.count == 6 else {
        return UIColor.black
    }
    
    var rgbValue: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgbValue)
    
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}







