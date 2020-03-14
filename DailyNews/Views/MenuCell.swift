
import UIKit

class MenuCell : UICollectionViewCell {
    
    let label = UILabel(text: "Magazin", font: .boldSystemFont(ofSize: 16))
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        backgroundColor = .systemBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(label)
        label.fillSuperview()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
    }
}
