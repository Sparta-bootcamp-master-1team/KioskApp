import UIKit
import SnapKit

protocol SpinnerViewDelegate: AnyObject {
    func spinnerViewRetryButtonTapped()
}

class SpinnerView: UIView {
    
    weak var delegate: SpinnerViewDelegate?
    
    private let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.9)
        view.style = .large
        view.color = .black
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var failureView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.9)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "⚠️"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "데이터를 불러오는데 실패하였습니다."
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "LoadingViewImage")
        return imageView
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" 재시도 ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        failureView.addSubview(titleLabel)
        failureView.addSubview(retryButton)
        failureView.addSubview(descriptionLabel)
        self.addSubview(failureView)
        self.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        failureView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.greaterThanOrEqualTo(200)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        retryButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func retryButtonTapped() {
        delegate?.spinnerViewRetryButtonTapped()
    }
    
    func startAnimating() {
        self.indicatorView.startAnimating()
        failureView.isHidden = true
    }
    
    func stopAnimating() {
        self.indicatorView.stopAnimating()
    }
    
    func presentFailureView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.stopAnimating()
            self.failureView.isHidden = false
        }
        
    }
    
}
