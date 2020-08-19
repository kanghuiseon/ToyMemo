//
//  ComposeViewController.swift
//  ToyMemo
//
//  Created by 강희선 on 2020/08/17.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    var editTarget: Memo?
    //편집 이전의 메모 내용
    var originalMemoContent: String?
    @IBOutlet var memoTextView: UITextView!
    
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    deinit {
        if let token = willShowToken{
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken{
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 널이 아니면
        if let memo = editTarget{
            navigationItem.title = "Edit Memo"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        }
        else{
            navigationItem.title = "New Memo"
            memoTextView.text = ""
        }
        memoTextView.delegate = self
        // 키보드 올라갈때 텍스트뷰도 올라가기
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: {
            [weak self] (noti) in
            guard let strongSelf = self else{ return }
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                inset = strongSelf.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using:{ [weak self] (noti) in
            guard let strongSelf = self else{ return }
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
            
        })
    }
    // 나타나기 전
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //화면 열자마자 키보드 뜨게
        memoTextView.becomeFirstResponder()
        navigationController?.presentationController?.delegate = self
        
    }
    // 사라지기 직전
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //키보드 사라지기
        memoTextView.resignFirstResponder()
        navigationController?.presentationController?.delegate = nil
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else{
            alert(message: "메모를 입력하세요")
            return
        }
        //제대로 메모가 쓰여있다면 guard문 아래로 실행됨
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget{
            target.content = memo
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
            DataManager.shared.saveContext()
        }else{
            //방송국에서 브로드캐스팅하는것과 같다.
            //앱을 구성하는 모든 객체로 전달됨.
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
            DataManager.shared.addNewMemo(memo)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
extension ComposeViewController: UITextViewDelegate{
    // textview가 편집될 때마다 반복적으로 호출됨
    
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


extension ComposeViewController: UIAdaptivePresentationControllerDelegate{
    // isModalInPresentation이 true이면 이 메소드가 실행됨
    // modal 이 안내려감
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 추가할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {
            (action) in
            self.save(action)
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (action) in
            self.close(action)
        })
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
extension ComposeViewController{
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
