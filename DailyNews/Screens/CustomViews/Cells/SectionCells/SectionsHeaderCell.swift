import UIKit
import TinyConstraints

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
                    if newsImageUrl != "null" {
                        newsImageView.sd_setImage(with: URL(string: newsImageUrl))
                    } else {
                        newsImageView.image = UIImage(named: "placeholderNews")
                    }
                }
                headerLabel.text = news.title
            }
        }
    }
    var newsEverything: EverythingPresentation? {
        didSet {
            if let newsEverything = newsEverything {
                if let newsImageUrl = newsEverything.urlToImage {
                    if newsImageUrl != "null" {
                        newsImageView.sd_setImage(with: URL(string: newsImageUrl))
                    } else {
                        newsImageView.image = UIImage(named: "placeholderNews")
                    }
                }
                headerLabel.text = newsEverything.title
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

        stackView.edgesToSuperview(excluding: .top)
        stackView.topToBottom(of: newsImageView)
        newsImageView.edgesToSuperview(excluding: .bottom)
        newsImageView.height(250)
    }
}
