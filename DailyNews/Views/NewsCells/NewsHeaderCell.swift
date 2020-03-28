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
        addSubview(scrollIndicator)
        addSubview(newsImageView)
        newsImageView.addSubview(headerLabel)
        
        scrollIndicator.currentPage = 0
        scrollIndicator.numberOfPages = 5
        scrollIndicator.currentPageIndicatorTintColor = .green
        scrollIndicator.pageIndicatorTintColor = .lightGray
        
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true        
        
        headerLabel.textColor = .systemBlue
        headerLabel.font = .systemFont(ofSize: 30)
        headerLabel.numberOfLines = 0
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.textAlignment = .center
        
        
        headerLabel.anchor(top: nil, leading: newsImageView.leadingAnchor, bottom: newsImageView.bottomAnchor, trailing: newsImageView.trailingAnchor, size: .init(width: 0, height: 100))
        
        newsImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 0))
        
        scrollIndicator.anchor(top: newsImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        
    }
}
