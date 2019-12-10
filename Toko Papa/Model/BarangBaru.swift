//
//  BarangBaru.swift
//  Toko Papa
//
//  Created by Louis  Valen on 09/12/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation

class BarangBaru{
    var namaBarang: String
    var stock: Int
    var tokoID: String
    var tanggal: Int
    var bulan: Int
    var Tahun: Int
    init(namabarang: String, stock:Int, tokoid: String, tanggal:Int,bulan:Int,Tahun:Int) {
        self.namaBarang = namabarang
        self.stock = stock
        self.tokoID = tokoid
        self.tanggal = tanggal
        self.bulan = bulan
        self.Tahun = Tahun
    }
}
