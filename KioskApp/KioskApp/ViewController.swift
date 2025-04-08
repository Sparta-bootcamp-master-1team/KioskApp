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
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
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

}

