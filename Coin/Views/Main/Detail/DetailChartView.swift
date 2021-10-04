//
//  DetailChartView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/07.
//

import UIKit
import WebKit

final class DetailChartView: UIView {

    private let chartWebView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .systemBackground
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        addSubview(chartWebView)
        addSubview(loadingView)
        
        NSLayoutConstraint.activate([
        chartWebView.topAnchor.constraint(equalTo: topAnchor),
        chartWebView.leadingAnchor.constraint(equalTo: leadingAnchor),
        chartWebView.trailingAnchor.constraint(equalTo: trailingAnchor),
        chartWebView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        loadingView.topAnchor.constraint(equalTo: topAnchor),
        loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
        loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
        loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
        
        chartWebView.navigationDelegate = self
    }
    
    func configure(url: URL?) {
        guard let url = url else {
            return
        }
        let urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalCacheData,
                                    timeoutInterval: 15)
        chartWebView.load(urlRequest)
    }
}

extension DetailChartView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loadingView.isHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.isHidden = true
    }
}
