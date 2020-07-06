//
//  FineDustView.swift
//  ARDust
//
//  Created by youngjun goo on 2020/06/29.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FineDustView: UIView {
    
    @IBOutlet weak var testLabel: UILabel?
    
    var viewModel: FineDustViewModel?
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        bind()
    }
    
    private func setupView() {
        guard let view = loadView(nibName: String(describing: type(of: self))) else { return }
        view.frame = self.bounds
        view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        
        addSubview(view)
    }
    
    func bind() {
        self.disposeBag = DisposeBag()
        self.viewModel = FineDustViewModel(coordinate: LatLng(latitude: 37.359255, longitude: 127.105046))
        
        viewModel?.fineDust
            .emit(to: self.rx.setData)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: FineDustView {
    var setData: Binder<FineDust> {
        return Binder(base) { base, data in
            base.testLabel?.text = data.stationName
        }
    }
}
