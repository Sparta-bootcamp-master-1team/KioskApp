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


    private let spinnerView = SpinnerView()

    
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
        spinnerView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.brandChanged = { [weak self] brand in
            self?.updateBackgroundColor(for: brand)
            self?.coffeeBrandImageChange(for: brand)
            self?.orderListView.changeColor()
            
            self?.coffeeCategoryView.buttonBackgroundColor = self?.buttonBackgroundColor ?? .white // 브랜드 색상 업데이트
            self?.coffeeCategoryView.selectRecommendedMenu() // 추천메뉴 자동 선택 유지
        }
        
        viewModel.categoryChanged = { [weak self] beverage in
            self?.productGirdView.configure(items: beverage)
        }
        
        viewModel.orderProductsChanged = { [weak self] in
            self?.orderListView.reloadTable()
        }
        
        viewModel.dataFetchStarted = { [weak self] in
            self?.startSpinnerView()
        }
        
        viewModel.dataFetchCompleted = { [weak self] in
            self?.stopSinnerView()
        }
        
        viewModel.dataFetchFailed = { [weak self] in
            self?.spinnerView.presentFailureView()
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
    
    func startSpinnerView() {
        view.addSubview(spinnerView)
        spinnerView.startAnimating()
        spinnerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func stopSinnerView() {
        spinnerView.stopAnimating()
        spinnerView.removeFromSuperview()
    }
    
    private func configureUI() {
        guard let beverage = viewModel.beverage else { return }
        productGirdView.configure(items: beverage)
    }
    
    private func coffeeBrandImageChange(for brand: Brand) {
        let imageName = "\(brand.rawValue)" + "Logo"
        coffeeBrandButtonView.coffeeBrandImageChange(imageName: imageName)
    }
}

extension ViewController: CoffeeButtonViewDelegate {
    func brandButtonDidTap(brand: Brand) {
        viewModel.changeBrand(brand)
        
        coffeeCategoryView.buttonBackgroundColor = buttonBackgroundColor // 브랜드 색상 업데이트
        coffeeCategoryView.selectRecommendedMenu() // 추천메뉴 자동 선택 유지
    }
}


extension ViewController: CoffeeCategoryCollectionViewDelegate {
    func categoryButtonDidTap(index: Int) {
        switch index {
        case 0:
            viewModel.selectedRecommend()
        case 1:
            viewModel.changeCategory(.coffeeIce)
        case 2:
            viewModel.changeCategory(.coffeeHot)
        case 3:
            viewModel.changeCategory(.beverageIce)
        case 4:
            viewModel.changeCategory(.beverageHot)
        case 5:
            viewModel.changeCategory(.dessert)
        default:
            break
        }
    }
}

extension ViewController: productGridViewDelegate {
    func collectionViewCellDidTap(item: Beverage) {
        viewModel.addOrder(item)
    }
}

extension ViewController: OrderListViewDataSource {
    
    var orderList: [OrderItem] {
        viewModel.orderList
    }
    
    var labelColor: UIColor {
        viewModel.selectedBrand == .mega ? .black : .white
    }
    
    var buttonTitleColor: UIColor {
        viewModel.selectedBrand == .mega ? .white : .black
    }
    
    var buttonBackgroundColor: UIColor {
        switch viewModel.selectedBrand {
        case .mega:
            return #colorLiteral(red: 0.3039717376, green: 0.1641474366, blue: 0.07612364739, alpha: 1)
        case .paik:
            return #colorLiteral(red: 0.768627451, green: 0.7960784314, blue: 0.8705882353, alpha: 1)
        case .theVenti:
            return #colorLiteral(red: 0.6823529412, green: 0.6117647059, blue: 0.7098039216, alpha: 1)
        }
    }
}

extension ViewController: OrderListViewDelegate {
    
    func orderListViewCancelButtonDidTap() {
        guard !viewModel.orderList.isEmpty else { return }
        
        let alert = UIAlertController(title: "주문 취소", message: "주문을 취소하시겠어요?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "예", style: .destructive) { _ in
            self.viewModel.orderCacelAll()
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func orderListViewOrderButtonDidTap() {
        let orderList = viewModel.orderList
        
        guard !orderList.isEmpty else { return }

        let grouped = Dictionary(grouping: orderList, by: { $0.brand })

        var message = ""
        var totalPrice = 0
        for (brand, items) in grouped {
            let brandName = brand.displayName
            let count = items.reduce(0) { $0 + $1.count }
            let price = items.reduce(0) { $0 + $1.price * $1.count }
            totalPrice += price
            message += "\(brandName) \(count)개 \(price.formattedWithSeparator)원\n"
        }
        message += "\n총 \(totalPrice.formattedWithSeparator)원\n\n담으신 상품이 맞는지 확인해주세요"

        let alert = UIAlertController(title: "주문 확인", message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "예", style: .default) { _ in
            self.viewModel.orderCacelAll()
        }

        let cancelAction = UIAlertAction(title: "아니오", style: .cancel)

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
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

// MARK: - SpinnerView RetryButton Tap Delegate
extension ViewController: SpinnerViewButtonDelegate {
    func spinnerViewRetryButtonTapped() {
        viewModel.fetchProducts()
    }
}
