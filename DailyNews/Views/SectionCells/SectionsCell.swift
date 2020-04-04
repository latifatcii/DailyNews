import UIKit

class SectionsCell : UICollectionViewCell {
    
    let newsImageView = UIImageView(frame: .zero)
    let headerLabel = UILabel(frame: .zero)
    let timeLabel = UILabel(frame: .zero)
    let sourceLabel = UILabel(frame: .zero)
    
    var news : THArticle? {
        didSet {
            if let news = news {
                let time = news.publishedAt.getTimeAgo()
                headerLabel.text = news.title
                timeLabel.text = time
                sourceLabel.text = news.source.name
                newsImageView.sd_setImage(with: URL(string: news.urlToImage ?? ""))
            }
        }
    }
    
    var newsEverything : EArticle? {
        didSet {
            if let newsEverything = newsEverything {
                let time = newsEverything.publishedAt.getTimeAgo()
                headerLabel.text = newsEverything.title
                timeLabel.text = time
                sourceLabel.text = newsEverything.source.name
                newsImageView.sd_setImage(with: URL(string: newsEverything.urlToImage ?? ""))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(headerLabel)
        addSubview(newsImageView)
        addSubview(timeLabel)
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 10
        

        headerLabel.textColor = .darkGray
        headerLabel.font = .systemFont(ofSize: 22)
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.numberOfLines = 0
        
        
        timeLabel.textColor = .lightGray
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.font = .systemFont(ofSize: 12)
        
        sourceLabel.textColor = .systemGray
        sourceLabel.adjustsFontSizeToFitWidth = true
        sourceLabel.font = .systemFont(ofSize: 13)
        
        
        let horizontalStackView = UIStackView(arrangedSubviews: [timeLabel,sourceLabel])
        horizontalStackView.distribution = .equalSpacing
        
        let labelStackView = UIStackView()
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(headerLabel)
        labelStackView.addArrangedSubview(horizontalStackView)
        labelStackView.axis = .vertical
        
        
        newsImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 5, left: 5, bottom: 5, right: 5),size: .init(width: 0, height: 240))
        
        labelStackView.anchor(top: newsImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        
    }
}

