import UIKit

class SectionsHeaderCell: UICollectionViewCell {

    var newsImageView: UIImageView = {
        let imageV = UIImageView(frame: .zero)
        imageV.layer.cornerRadius = 10
        imageV.image = UIImage(named: "placeholderNews")
        imageV.clipsToBounds = true
        return imageV
    }()
    var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    lazy var scrollIndicator: UIPageControl = {
        let indicator = UIPageControl(frame: .zero)
        indicator.currentPage = 0
        indicator.numberOfPages = 10
        indicator.currentPageIndicatorTintColor = .green
        indicator.pageIndicatorTintColor = .lightGray
        return indicator
    }()
    var news: THArticle? {
        didSet {
            if let news = news {
                if let newsImageUrl = news.urlToImage {
                    headerLabel.text = news.title
                    if newsImageUrl != "null" {
                        newsImageView.sd_setImage(with: URL(string: newsImageUrl))
                    } else {
                        newsImageView.image = UIImage(named: "placeholderNews")
                    }
                }
            }
        }
    }
    var newsEverything: EArticle? {
        didSet {
            if let newsEverything = newsEverything {
                if let newsImageUrl = newsEverything.urlToImage {
                    headerLabel.text = newsEverything.title
                    if newsImageUrl != "null" {
                        newsImageView.sd_setImage(with: URL(string: newsImageUrl))
                    } else {
                        newsImageView.image = UIImage(named: "placeholderNews")
                    }
                }
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
        let stackView = UIStackView(arrangedSubviews: [headerLabel, scrollIndicator])
        addSubview(stackView)
        addSubview(newsImageView)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        stackView.anchor(top: newsImageView.bottomAnchor, leading: leadingAnchor,
                         bottom: bottomAnchor, trailing: trailingAnchor)
        newsImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil,
                             trailing: trailingAnchor,
                             padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 250))
    }
}
