//
//  DetailViewController.swift
//  ToyMemo
//
//  Created by 강희선 on 2020/08/18.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var memo: Memo?
    @IBOutlet var memoTableView: UITableView!
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController{
            vc.editTarget = memo
        }
    }
    var token: NSObjectProtocol?
    deinit {
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: {
            (noti) in
            self.memoTableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "확인", style: .destructive, handler: {(action) in
            DataManager.shared.deleteMemo(self.memo)
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(deleteAction)
         
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func share(_ sender: UIBarButtonItem) {
        guard let memo = memo?.content else {
            return
        }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        if let pc = vc.popoverPresentationController{
            pc.barButtonItem = sender
            
        }
        present(vc, animated: true, completion: nil)
    }
    
    
}

extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            cell.textLabel?.text = memo?.content
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            return cell
        default:
            fatalError()
        }
    }
    
    
}
