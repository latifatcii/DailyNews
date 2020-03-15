
import UIKit

class MenuViewController : BaseListController , UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let menuItems = ["Featured","Business","Sports","Technology","Science","Entertainment","Health"]
    let menuBar : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .blue
        setupViews()
    }
    
    func setupViews() {
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        collectionView.showsHorizontalScrollIndicator = false
        
        
        
        view.addSubview(menuBar)
        menuBar.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil,size: .init(width: 0, height: 5))
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.label.text = menuItems[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width/4, height: view.frame.height)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let offset = x/7
        print(offset)
        
        collectionView.transform = CGAffineTransform(translationX: -offset, y: 0)
        menuBar.transform = CGAffineTransform(translationX: -offset-30, y: 0)
    }
}
