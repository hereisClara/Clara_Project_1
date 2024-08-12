import UIKit
import Kingfisher
import IQKeyboardManagerSwift
import TPDirect

class BillViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var billCartItem = [CartItem]()
    
    let header = ["結帳商品", "收件資訊", "付款詳情"]
    
    var userName = String()
    var userEmail = String()
    var userPhoneNumber = String()
    var userAddress = String()
    var userShipTime = String()
    
    var textFieldHasContent: Bool?
    var useCreditCard: Bool?
    var verifyCode: String?
    var prime: String?
    
    var productPriceInt = Int()
    var productCount = Int()
    var list = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tableView = tableView else {
            return
        }
        
        calculateTotalPrice()
        
        setupNavigationitem()
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.lk_registerCellWithNib(identifier: String(describing: STOrderProductCell.self), bundle: nil)
        
        tableView.lk_registerCellWithNib(identifier: String(describing: STOrderUserInputCell.self), bundle: nil)
        
        tableView.lk_registerCellWithNib(identifier: String(describing: STPaymentInfoTableViewCell.self), bundle: nil)
        
        let headerXib = UINib(nibName: String(describing: STOrderHeaderView.self), bundle: nil)
        
        tableView.register(headerXib, forHeaderFooterViewReuseIdentifier: String(describing: STOrderHeaderView.self))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupNavigationitem(){
        
        self.navigationItem.title = "結帳"
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Icons_24px_Back02"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension BillViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: STOrderHeaderView.self)) as? STOrderHeaderView else {
            return nil
        }
        
        headerView.titleLabel.text = header[section]
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        
        footerView.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: "cccccc")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return billCartItem.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Todo
        
        /*
         
         所有的 cell 都還沒有餵資料進去，請把購物車的資料，適當的傳遞到 Cell 當中
         
         */
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderProductCell.self), for: indexPath) as? STOrderProductCell else {
                fatalError("Unable to dequeue STOrderProductCell")
            }
            
            cell.productImageView.kf.setImage(with: URL(string: billCartItem[indexPath.row].image ?? ""))
            cell.productTitleLabel.text = billCartItem[indexPath.row].title
            cell.productSizeLabel.text = billCartItem[indexPath.row].size
            cell.colorView.backgroundColor = UIColor.hexStringToUIColor(hex: billCartItem[indexPath.row].color ?? "")
            cell.priceLabel.text = billCartItem[indexPath.row].price
            cell.orderNumberLabel.text = "x\(billCartItem[indexPath.row].cartNumber ?? "")"
            
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STOrderUserInputCell.self), for: indexPath) as? STOrderUserInputCell else {
                fatalError("Unable to dequeue STOrderInputCell")
            }
            
            cell.delegate = self
            
            return cell
            
            //Todo
            
            /*
             請適當的安排 STOrderUserInputCell，讓 ViewController 可以收到使用者的輸入
             */
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: STPaymentInfoTableViewCell.self), for: indexPath) as? STPaymentInfoTableViewCell else {
                fatalError("Unable to dequeue STOrderInfoTableViewCell")
            }
            
            cell.layoutCellWith(productPrice: productPriceInt, shipPrice: 60, productCount: productCount)
            
            cell.delegate = self
            verifyCode = "貨到付款"
            
            cell.tpdForm = TPDForm.setup(withContainer: cell.creditView)
            
            cell.tpdForm.setErrorColor(UIColor.red)
            cell.tpdForm.setOkColor(UIColor.green)
            cell.tpdForm.setNormalColor(UIColor.black)
            
            cell.tpdForm.onFormUpdated { (status) in
                if (status.isCanGetPrime()) {
                    cell.payButton.isEnabled = true
                } else {
                    cell.payButton.isEnabled = false
                }
            }
            
            cell.tpdCard = TPDCard.setup(cell.tpdForm)
            return cell
        }
    }
    
    func calculateTotalPrice() {
        
        for i in 0 ..< billCartItem.count {
            let productPrice = Int(billCartItem[i].price ?? "") ?? 0
            productPriceInt += productPrice
        }
        
        productCount = billCartItem.count
    }
    
    func getAllItemsInfo() {
        
        for i in 0 ..< billCartItem.count {
            
            let product = CheckOutData.shared.createListJSON(
                name: billCartItem[i].title ?? "",
                stock: billCartItem[i].stock ?? "",
                price: Int(billCartItem[i].price ?? "") ?? 0,
                colorCode: billCartItem[i].color ?? "",
                colorName: billCartItem[i].colorName ?? "",
                size: billCartItem[i].size ?? "",
                cartNumber: Int(billCartItem[i].cartNumber ?? "") ?? 0,
                id: billCartItem[i].id ?? ""
            )
            
            list.append(product)
            
        }
    }
}

extension BillViewController: STPaymentInfoTableViewCellDelegate {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell) {
        
        tableView.reloadData()
    }
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        verifyCode: String
    ) {
        
        self.verifyCode = verifyCode
        
        if verifyCode == "信用卡付款" {
            useCreditCard = true
        } else if verifyCode == "貨到付款" {
            useCreditCard = false
        }
    }
    
    func checkout(_ cell:STPaymentInfoTableViewCell) {
        
        cell.payButton.isUserInteractionEnabled = true
        
        if textFieldHasContent == true {
            
            if useCreditCard == false {
                cell.payButton.isUserInteractionEnabled = true
                performSegue(withIdentifier: "toCheckOutPage", sender: nil)
                
            } else if useCreditCard == true {
                if prime != "" {
                    cell.payButton.isUserInteractionEnabled = true
                    performSegue(withIdentifier: "toCheckOutPage", sender: nil)
                    getAllItemsInfo()
                } else {
                    
                }
            } else {
                verifyCode = "貨到付款"
                cell.payButton.isUserInteractionEnabled = true
            }
        } else {
            cell.payButton.isUserInteractionEnabled = false
        }
        
        cell.tpdCard.onSuccessCallback { (prime, cardInfo, cardIdentifier, merchantReferenceInfo) in
            
            self.prime = prime
            CheckOutData.shared.postOrder(
                prime: prime!,
                subtotal: self.productPriceInt,
                total: self.productPriceInt + 60,
                name: self.userName,
                phone: self.userPhoneNumber,
                email: self.userEmail,
                address: self.userAddress,
                time: self.userShipTime,
                list: self.list
            )
            
        }.onFailureCallback { (status, message) in
            self.prime = ""
        }.getPrime()
    }
}

extension BillViewController: STOrderUserInputCellDelegate {
    
    func didChangeUserData(_ cell: STOrderUserInputCell, username: String, email: String, phoneNumber: String, address: String, shipTime: String) {
        self.userName = username
        self.userEmail = email
        self.userPhoneNumber = phoneNumber
        self.userAddress = address
        self.userShipTime = shipTime
        
        if !(username.isEmpty) && !(email.isEmpty) && !(phoneNumber.isEmpty) && !(address.isEmpty){
            textFieldHasContent = true
        } else {
            textFieldHasContent = false
        }
    }
}
