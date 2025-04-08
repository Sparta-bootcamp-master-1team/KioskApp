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

class ViewController: UIViewController {
    
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
    }
    
    // "메가커피", "빽다방", "더벤티" 선택하는 UIMenu
    func coffeeBrandMenu() {
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

