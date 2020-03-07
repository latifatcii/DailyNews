import UIKit

class FeedHeaderCell: UICollectionViewCell {
    
    let newsImageView = UIImageView(frame: .zero)
    let headerLabel = UILabel(frame: .zero)
    let timeLabel = UILabel(frame: .zero)
    let scrollIndicator = UIView()
    
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
        scrollIndicator.backgroundColor = .black
        scrollIndicator.clipsToBounds = true
        scrollIndicator.layer.cornerRadius = 6
        
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        newsImageView.image = UIImage(named: "austin")
        
        
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor ),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -20),
            
            scrollIndicator.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 3),
            scrollIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 10),
            scrollIndicator.widthAnchor.constraint(equalToConstant: 10),
            scrollIndicator.heightAnchor.constraint(equalToConstant: 10)
        ])
        
    }
}
