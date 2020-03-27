
import Foundation
import WebKit


class NewsDetailsViewController : UIViewController , WKUIDelegate , WKNavigationDelegate {
    
    var webView : WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    var bottomView : UIView = {
        let bv = UIView(frame: .zero)
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.backgroundColor = .white
        return bv
    }()
    
    var topView : UIView = {
        let tv = UIView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        return tv
    }()
    
    var url : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        setupUI()
        configureBottomView()
        configureTopView()
        
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(bottomView)
        view.addSubview(topView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 35),
            webView.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -35),
            webView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
        ])
        
        bottomView.anchor(top: webView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 35))
        
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size: .init(width: 0, height: 35))
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
        
        
        
        
    }
    
    
    
    private func configureBottomView() {
        let closeButton = UIButton(frame: .zero)
        bottomView.addSubview(closeButton)
        closeButton.anchor(top: bottomView.topAnchor, leading: bottomView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: nil, size: .init(width: 60, height: 0))
        closeButton.addTarget(self, action: #selector(closeWebWiew), for: .touchUpInside)
        closeButton.backgroundColor = .white
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.imageView?.tintColor = .darkGray
        
        let refreshButton = UIButton(frame: .zero)
        bottomView.addSubview(refreshButton)
        refreshButton.anchor(top: bottomView.topAnchor, leading: nil, bottom: bottomView.bottomAnchor, trailing: bottomView.trailingAnchor, size: .init(width: 60, height: 0))
        
        refreshButton.addTarget(self, action: #selector(refreshWebView), for: .touchUpInside)
        refreshButton.backgroundColor = .white
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.imageView?.tintColor = .darkGray
        
    }
    
    private func configureTopView() {
        let backButton = UIButton(frame: .zero)
        topView.addSubview(backButton)
        
        backButton.anchor(top: topView.topAnchor, leading: topView.leadingAnchor, bottom: topView.bottomAnchor, trailing: nil, size: .init(width: 60, height: 0))
        backButton.addTarget(self, action: #selector(goBackWebView), for: .touchUpInside)
        backButton.backgroundColor = .white

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.imageView?.tintColor = .darkGray
        
        let forwardButton = UIButton(frame: .zero)
        topView.addSubview(forwardButton)
        
        forwardButton.anchor(top: topView.topAnchor, leading: nil, bottom: topView.bottomAnchor, trailing: topView.trailingAnchor, size: .init(width: 60, height: 0))
        forwardButton.addTarget(self, action: #selector(goForwardWebView), for: .touchUpInside)
        forwardButton.backgroundColor = .white
        forwardButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        forwardButton.imageView?.tintColor = .darkGray
    }
    
    @objc func goForwardWebView() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func goBackWebView() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    
    
    @objc func closeWebWiew() {
        webView.stopLoading()
        dismiss(animated: true)
    }
    
    @objc func refreshWebView() {
        webView.reload()
    }
    
}
