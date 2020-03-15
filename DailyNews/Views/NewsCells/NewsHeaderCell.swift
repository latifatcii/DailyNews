import UIKit

class NewsHeaderCell: UICollectionViewCell {
    
    let newsImageView = UIImageView(frame: .zero)
    let headerLabel = UILabel(frame: .zero)
    let timeLabel = UILabel(frame: .zero)
    lazy var scrollIndicator = UIPageControl()
    
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
        
        scrollIndicator.translatesAutoresizingMaskIntoConstraints = false
        scrollIndicator.currentPage = 0
        scrollIndicator.numberOfPages = 5
        scrollIndicator.currentPageIndicatorTintColor = .green
        scrollIndicator.pageIndicatorTintColor = .lightGray
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        newsImageView.image = UIImage(named: "austin")
        
        
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor ),
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -20),
            
            scrollIndicator.topAnchor.constraint(equalTo: newsImageView.bottomAnchor),
            scrollIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollIndicator.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
        
    }
}
