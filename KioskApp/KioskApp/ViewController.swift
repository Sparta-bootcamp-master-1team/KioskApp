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
        setupAddSubView()
        setupUI()
        setupDelegate()
        bindViewModel()
        viewModel.fetchProducts()
    }
    
    private func setupAddSubView() {
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
    
    private func setupDelegate() {
        coffeeBrandButtonView.delegate = self
        coffeeCategoryView.delegate = self
        productGirdView.delegate = self
        orderListView.orderListTableView.tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.brandChanged = { [weak self] brand in
            switch brand {
            case .mega:
                self?.view.backgroundColor = #colorLiteral(red: 0.9614067674, green: 0.8476976752, blue: 0.2546326518, alpha: 1)
            case .paik:
                self?.view.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.2470588235, blue: 0.5215686275, alpha: 1)
            case .theVenti:
                self?.view.backgroundColor = #colorLiteral(red: 0.168627451, green: 0, blue: 0.2235294118, alpha: 1)
            }
            
            self?.coffeeBrandImageChange(brand: brand)
        }
        
        viewModel.categoryChanged = { [weak self] in
            self?.configureUI()
        }
        
        viewModel.orderProductsChanged = { [weak self] in
            self?.orderListView.reloadTable()
        }
    }
    
    private func coffeeBrandImageChange(brand: Brand) {
        let imageName = "\(brand.rawValue)" + "Logo"
        coffeeBrandButtonView.coffeeBrandImageChange(imageName: imageName)
    }
    
    private func categoryChanged(index: Int) {
        
    }
    
    private func configureUI() {
        guard let beverage = viewModel.beverage else { return }
        productGirdView.configure(items: beverage)
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
        case 1:
            viewModel.changeCategory(.coffee)
            viewModel.changeOption(.ice)
        case 2:
            viewModel.changeCategory(.coffee)
            viewModel.changeOption(.hot)
        case 3:
            viewModel.changeCategory(.beverage)
            viewModel.changeOption(.ice)
        case 4:
            viewModel.changeCategory(.beverage)
            viewModel.changeOption(.hot)
        default:
            viewModel.changeCategory(.dessert)
            viewModel.changeOption(nil)
        }
    }
}

extension ViewController: productGridViewDelegate {
    func collectionViewCellDidTap(item: Beverage) {
        viewModel.addOrder(item)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
        cell.configure(with: viewModel.orderList[indexPath.row])
        return cell
    }
}
