//
//  SearchFooter.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 14/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class SearchFooter: UIView {

    let label = UILabel()
    
    let searchBar = CashierItemListViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        configureView()
    }

    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }
    
    func setNotFiltering() {
        label.text = ""
        hideFooter()
    }
    
    func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
        if (filteredItemCount == totalItemCount) {
            setNotFiltering()
        } else if /*(filteredItemCount == 0) &&*/ searchBar.searchController.searchBar.text == "" {
            label.text = "Tidak ada barang sesuai pencarian"
            showFooter()
        } else {
            label.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
            showFooter()
        }
    }
    
    func showText(text: String) {
        label.text = text
    }
    
    func hideFooter() {
        UIView.animate(withDuration: 0.7) {
            self.alpha = 0.0
        }
    }
    
    func showFooter() {
        UIView.animate(withDuration: 0.7) {
            self.alpha = 1.0
        }
    }
    
    func configureView() {
        backgroundColor = UIColor.lightGray
        alpha = 0.0
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
    }
}
