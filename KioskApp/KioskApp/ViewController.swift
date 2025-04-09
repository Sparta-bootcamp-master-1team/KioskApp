import UIKit
import SnapKit

class ViewController: UIViewController {
   
    private var testModel: [Beverage] = []
    
    private let coffeeBrandButtonView = CoffeeBrandButtonView()
    private let coffeeCategoryView = CoffeeCategoryCollectionView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let productGirdView = ProductGridView()
    private let orderListView = OrderListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        setAddSubView()
        setupUI()
        fetchTestModel()
    }
    
    private func setAddSubView() {
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
            $0.height.equalTo(80)
        }
        
        coffeeCategoryView.snp.makeConstraints {
            $0.top.equalTo(coffeeBrandButtonView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
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
    
    private func fetchTestModel() {
        DataService.fetchData { result in
            switch result {
            case .success(let data):
                self.testModel = data.baiksProduct
                self.configureUI()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureUI() {
        productGirdView.configure(items: testModel)
    }
    
}
