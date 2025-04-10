import UIKit
import SnapKit

class ViewController: UIViewController {
   
    private let viewModel = OrderViewModel()
    
    private let coffeeBrandButtonView = CoffeeBrandButtonView()
    private let coffeeCategoryView = CoffeeCategoryCollectionView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let productGirdView = ProductGridView()
    private let orderListView = OrderListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.8235294118, blue: 0.2, alpha: 1)
        addSubViews()
        setupUI()
        configureSubViews()
        bindViewModel()
        viewModel.fetchProducts()
    }
    
    private func addSubViews() {
        [coffeeBrandButtonView, coffeeCategoryView, scrollView]
            .forEach { self.view.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [productGirdView, orderListView]
            .forEach { self.contentView.addSubview($0) }
    }
    
    private func setupUI() {
        coffeeBrandButtonView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        coffeeCategoryView.snp.makeConstraints {
            $0.top.equalTo(coffeeBrandButtonView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(coffeeCategoryView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollView.contentLayoutGuide)
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
        
        productGirdView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(productGirdView.snp.width).multipliedBy(1.4)
        }
        
        orderListView.snp.makeConstraints {
            $0.top.equalTo(productGirdView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureSubViews() {
        coffeeBrandButtonView.delegate = self
        coffeeCategoryView.delegate = self
        productGirdView.delegate = self
        orderListView.dataSource = self
        orderListView.delegate = self
        orderListView.orderListTableView.tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.brandChanged = { [weak self] brand in
            self?.updateBackgroundColor(for: brand)
            self?.coffeeBrandImageChange(for: brand)
            self?.orderListView.changeColor()
        }
        
        viewModel.categoryChanged = { [weak self] beverage in
            self?.productGirdView.configure(items: beverage)
        }
        
        viewModel.orderProductsChanged = { [weak self] in
            self?.orderListView.reloadTable()
        }
    }
    
    private func updateBackgroundColor(for brand: Brand) {
        switch brand {
        case .mega:
            self.view.backgroundColor = #colorLiteral(red: 0.9614067674, green: 0.8476976752, blue: 0.2546326518, alpha: 1)
        case .paik:
            self.view.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.2470588235, blue: 0.5215686275, alpha: 1)
        case .theVenti:
            self.view.backgroundColor = #colorLiteral(red: 0.168627451, green: 0, blue: 0.2235294118, alpha: 1)
        }
    }
    
    private func coffeeBrandImageChange(for brand: Brand) {
        let imageName = "\(brand.rawValue)" + "Logo"
        coffeeBrandButtonView.coffeeBrandImageChange(imageName: imageName)
    }
}

extension ViewController: CoffeeButtonViewDelegate {
    func brandButtonDidTap(brand: Brand) {
        viewModel.changeBrand(brand)
    }
}


extension ViewController: CoffeeCategoryCollectionViewDelegate {
    func categoryButtonDidTap(index: Int) {
        switch index {
        case 0:
            viewModel.changeCategory(.beverageHot)
        case 1:
            viewModel.changeCategory(.coffeeIce)
        case 2:
            viewModel.changeCategory(.coffeeHot)
        case 3:
            viewModel.changeCategory(.beverageIce)
        case 4:
            viewModel.changeCategory(.beverageHot)
        default:
            viewModel.changeCategory(.dessert)
        }
    }
}

extension ViewController: productGridViewDelegate {
    func collectionViewCellDidTap(item: Beverage) {
        viewModel.addOrder(item)
    }
}

extension ViewController: OrderListViewDataSource, OrderListViewDelegate {
    var labelColor: UIColor {
        viewModel.selectedBrand == .mega ? .white : .black
    }
    
    var buttonColor: UIColor {
        switch viewModel.selectedBrand {
        case .mega:
            return #colorLiteral(red: 0.3039717376, green: 0.1641474366, blue: 0.07612364739, alpha: 1)
        case .paik:
            return #colorLiteral(red: 0.768627451, green: 0.7960784314, blue: 0.8705882353, alpha: 1)
        case .theVenti:
            return #colorLiteral(red: 0.6823529412, green: 0.6117647059, blue: 0.7098039216, alpha: 1)
        }
    }

    var orderList: [OrderItem] {
        viewModel.orderList
    }
    
    func orderListViewCancelButtonDidTap() {
        viewModel.orderCacelAll()
    }
    
    func orderListViewOrderButtonDidTap() {
        print("주문버튼 탭")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
        cell.configure(with: viewModel.orderList[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ViewController: OrderItemCellDelegate {
    func orderItemCellDidTapIncrement(_ cell: OrderItemCell) {
        guard let orderItem = cell.orderItem else { return }
        viewModel.orderCountIncreament(orderItem)
    }
    
    func orderItemCellDidTapDecrement(_ cell: OrderItemCell) {
        guard let orderItem = cell.orderItem else { return }
        viewModel.orderCountDecreament(orderItem)
    }
    
    func orderItemCellDidTapRemove(_ cell: OrderItemCell) {
        guard let orderItem = cell.orderItem else { return }
        viewModel.removeOrder(orderItem)
    }
}
