import UIKit
import SnapKit

// 이미지 사이즈 조절을 위한 확장. UIImage
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        self.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

class ViewController: UIViewController, UICollectionViewDelegate {
    // 메뉴 카테고리를 위한 UICollectionView 생성
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        return view
    }()
    
    // 메뉴 카테고리 배열
    private let categories = ["추천메뉴", "커피(ICED)", "커피(HOT)", "음료(ICED)", "음료(HOT)", "디저트"]
    
    private let coffeeBrandButton: UIButton = {
        let button = UIButton()
        let targetSize = CGSize(width: 200, height: 100)
        let resizedImage = UIImage(named: "megaLogo")?.resize(targetSize: targetSize)
        
        button.setImage(resizedImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.showsMenuAsPrimaryAction = true // 버튼 누르면 Menu 바로 표시
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        coffeeBrandMenu()
    }
    
    private func setupUI() {
        view.addSubview(coffeeBrandButton)
        
        coffeeBrandButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
        
        view.addSubview(categoryCollectionView)
        
        categoryCollectionView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.top.equalTo(coffeeBrandButton.snp.bottom)
            $0.height.equalTo(50)
        }
    }
    
    // "메가커피", "빽다방", "더벤티" 선택하는 UIMenu
    private func coffeeBrandMenu() {
        let coffeeBrandItems = [
            UIAction(title: "메가커피", handler: { _ in print("메가커피")}),
            UIAction(title: "빽다방", handler: { _ in print("빽다방")}),
            UIAction(title: "더벤티", handler: { _ in print("더벤티")})
        ]
        
        let menu = UIMenu(title: "커피 브랜드를 선택해주세요.", children: coffeeBrandItems)
        // coffeeBrandButton에 메뉴 연결
        coffeeBrandButton.menu = menu
    }

}

extension ViewController: UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return categories.count // 카테고리 개수 반환
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCell.identifier,
                    for: indexPath
                ) as? CategoryCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(title: categories[indexPath.item]) // 셀에 데이터 전달
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("\(categories[indexPath.item]) 선택됨") // 실행되는지 테스트
    }
    
    // 셀 크기 설정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 100, height: 40) // 각 셀의 크기 설정
    }
}

// CategoryCell
class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
