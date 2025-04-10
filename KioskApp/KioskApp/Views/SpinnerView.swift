import UIKit
import SnapKit

class SpinnerView: UIView {
    
    private let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = .clear
        view.style = .large
        view.color = .black
        return view
    }()
    
    private lazy var failureView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        label.text = "⚠️"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.text = "데이터를 불러오는데 실패하였습니다."
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" 재시도 ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = .white
        failureView.addSubview(titleLabel)
        failureView.addSubview(retryButton)
        failureView.addSubview(descriptionLabel)
        self.addSubview(failureView)
        self.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        failureView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        retryButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
        }
        
        indicatorView.isHidden = true
        failureView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        self.indicatorView.startAnimating()
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
