//
//  UIViewController+Alert.swift
//  ToyMemo
//
//  Created by 강희선 on 2020/08/17.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit

extension UIViewController{
    func alert(title: String = "알림", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    
    }
}
