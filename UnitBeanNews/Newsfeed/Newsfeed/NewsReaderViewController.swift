//
//  NewsReaderViewController.swift
//  UnitBeanNews
//
//  Created by ar_ko on 25.12.2020.
//

import UIKit
import WebKit

class NewsReaderViewController: UIViewController, WKUIDelegate {
    
    static func instantiate() -> NewsReaderViewController {
        let storyboadr = UIStoryboard(name: "Main", bundle: .main)
        let controller = storyboadr.instantiateViewController(withIdentifier: "NewsReaderViewController") as! NewsReaderViewController
        return controller
    }
    
    private var webView: WKWebView!
    var urlString: String?
    

    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        navigationItem.title = "Статья"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

}
