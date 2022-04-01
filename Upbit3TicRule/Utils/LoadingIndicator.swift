//
//  LoadingIndicator.swift
//  Upbit3TicRule
//
//  Created by Taehoon Kim on 2022/03/25.
//

import UIKit

class LoadingIndicator {
    static func showLoading(with progressView: UIProgressView) {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            guard let window = UIApplication.shared.windows.last else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            let desriptionLabel = UILabel()
            desriptionLabel.text = "알림을 설정 중 입니다."
            
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .systemBlue
                window.addSubview(loadingIndicatorView)
            }
            
            loadingIndicatorView.addSubview(desriptionLabel)
            loadingIndicatorView.addSubview(progressView)
            
            desriptionLabel.anchor(top: loadingIndicatorView.centerYAnchor, paddingTop: 30)
            desriptionLabel.centerX(inView: loadingIndicatorView)
            
            progressView.anchor(top: desriptionLabel.bottomAnchor, paddingTop: 8)
            progressView.centerX(inView: loadingIndicatorView)
            progressView.setDimensions(width: window.frame.width - 150, height: 16)

            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
