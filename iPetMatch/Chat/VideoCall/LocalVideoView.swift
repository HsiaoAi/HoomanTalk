//
//  LocalVedioView.swift
//  iPetMatch
//
//  Created by Hsiao Ai LEE on 16/12/2017.
//  Copyright © 2017 Hsiao Ai LEE. All rights reserved.
//

import UIKit

class LocalVideoView: UIView {

    override init(frame: CGRect) {

        super.init(frame: frame)

        setupVideoLayer()

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        setupVideoLayer()
    }

    func setupVideoLayer() {

        self.backgroundColor = UIColor.clear

        let videoLayer = AVCaptureVideoPreviewLayer()

        videoLayer.videoGravity = .resizeAspect

        self.layer.insertSublayer(videoLayer, at: 0)

        self.layer.frame = self.bounds

    }

}
