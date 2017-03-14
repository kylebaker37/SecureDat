//
//  VideoContainerView.swift
//  SecureDat
//
//  Created by Markus Notti on 3/13/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class VideoContainerView: UIView {

    var playerLayer: CALayer?
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        playerLayer?.frame = self.bounds
    }

}
