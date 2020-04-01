import UIKit

class NewsHeaderCell: UICollectionViewCell {
    
    let newsImageView = UIImageView(frame: .zero)
    let headerLabel = UILabel(frame: .zero)
    lazy var scrollIndicator = UIPageControl()
    
    var news : THArticle? {
        didSet {
            if let news = news {
                newsImageView.sd_setImage(with: URL(string: news.urlToImage ?? ""))
                headerLabel.text = news.title
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [headerLabel,scrollIndicator])
        
        addSubview(stackView)
        addSubview(newsImageView)
        
        newsImageView.layer.cornerRadius = 10
        
        stackView.alignment = .center
        stackView.axis = .vertical
        
        
        scrollIndicator.currentPage = 0
        scrollIndicator.numberOfPages = 5
        scrollIndicator.currentPageIndicatorTintColor = .green
        scrollIndicator.pageIndicatorTintColor = .lightGray
        
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(ofSize: 20)
        headerLabel.numberOfLines = 0
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.textAlignment = .center
        
        
        stackView.anchor(top: newsImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        newsImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 280))
        
        
    }
}
