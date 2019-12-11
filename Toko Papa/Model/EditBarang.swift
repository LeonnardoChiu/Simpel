//
//  EditBarang.swift
//  Toko Papa
//
//  Created by Louis  Valen on 10/12/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation

class EditBarang{
    
    var inventoryID: String
    var profilID: String
    var tokoID: String
    var alasan: String
    var bulan: Int
    var kategori: String
    var tahun: Int
    var tanggal: Int
    var value: String
    
    
    init(inventoryId: String, profilID: String, tokoID: String, alasan: String, tanggal: Int, bulan: Int, tahun: Int, kategori: String, value: String) {
        self.inventoryID = inventoryId
        self.profilID = profilID
        self.tokoID = tokoID
        self.alasan = alasan
        self.tanggal = tanggal
        self.bulan = bulan
        self.tahun = tahun
        self.kategori = kategori
        self.value = value
    }
}
