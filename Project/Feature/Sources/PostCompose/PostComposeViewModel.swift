//
//  PostComposeViewModel.swift
//  Bridging
//
//  Created by 이현욱 on 4/29/25.
//

import UIKit

import RxSwift
import RxCocoa

/// ViewModel 프로토콜: 입력(AnyObserver)과 출력(Observable)을 정의합니다.
protocol PostComposeViewModelType {
    // MARK: Inputs
    /// 제목 입력 스트림
    var title: AnyObserver<String> { get }
    /// 내용 입력 스트림
    var context: AnyObserver<String> { get }
    /// 선택된 이미지 입력 스트림
    var image: AnyObserver<UIImage?> { get }
    /// 완료 버튼 탭 이벤트 스트림
    var doneButtonTap: AnyObserver<Void> { get }
    
    // MARK: Outputs
    /// 제목과 내용이 모두 채워졌는지 여부
    var isDoneEnabled: Observable<Bool> { get }
    /// 완료 버튼 탭 시 현재 입력 상태(제목, 내용, 이미지)
    //    var didFinishPost: Observable<(title: String, context: String, image: UIImage?)> { get }
}

/// ViewModel 구현체
final class PostComposeViewModel: PostComposeViewModelType {
    // Inputs
    let title: AnyObserver<String>
    let context: AnyObserver<String>
    let image: AnyObserver<UIImage?>
    let doneButtonTap: AnyObserver<Void>
    
    // Outputs
    let isDoneEnabled: Observable<Bool>
    //    let didFinishPost: Observable<(title: String, context: String, image: UIImage?)>
    
    // 내부 Subjects
    private let _title = PublishSubject<String>()
    private let _context = PublishSubject<String>()
    private let _image = BehaviorSubject<UIImage?>(value: nil)
    private let _doneTap = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        // Inputs: Subjects를 Observer로 노출
        title = _title.asObserver()
        context = _context.asObserver()
        image = _image.asObserver()
        doneButtonTap = _doneTap.asObserver()
        
        // Outputs
        // 제목/내용이 빈 문자열이 아닐 때만 완료 버튼 활성화
        isDoneEnabled = Observable
            .combineLatest(_title, _context)
            .map { !$0.isEmpty && !$1.isEmpty }
            .distinctUntilChanged()
        
        // 완료 탭 시점에 최신 입력값(title, context, image) 발행
        //        didFinishPost =
//        _doneTap
//            .flatMap {
//                if AuthManager.shared.isLoggedIn {
//                    
//                } else {
//                    
//                }
//            }
//            .flatMapLatest {
//                AuthManager.shared.userRelay
//            }.filter { $0 != nil }
//            .withLatestFrom(Observable.combineLatest(_title, _context, _image)) { (user: $0, title: $1.0, context: $1.1, image: $1.2) }
//            .map { }
//            .filter { $0.user != nil }
        //            .map { (title: $0.0, context: $0.1, image: $0.2) }
        //            .share(replay: 1)
    }
}
