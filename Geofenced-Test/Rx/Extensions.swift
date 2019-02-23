//
//  UIKit+Rx.swift
//  Geofenced-Test
//
//  Created by Nour on 2/23/19.
//  Copyright © 2019 Nour. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UILabel {
    var textColor: Binder<UIColor> {
        return Binder(self.base) { label, textColor in
            label.textColor = textColor
        }
    }
}
