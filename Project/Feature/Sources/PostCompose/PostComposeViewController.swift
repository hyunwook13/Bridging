import UIKit
import PhotosUI
import Core

import PinLayout
import RxSwift
import RxCocoa

final class PostComposeViewController: UIViewController {
    
    private var post: Post?
    
    private let disposeBag = DisposeBag()
    
    private let placeholder = "내용을 입력하세요..."
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "게시물 작성"
        lbl.font = .systemFont(ofSize: 17, weight: .semibold)
        lbl.textColor = .black
        return lbl
    }()
    
    private let doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.setTitleColor(UIColor(hex: "E76F51"), for: .normal)
        btn.isEnabled = false
        return btn
    }()
    private let separatorLine = UIView()
    
    private let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "제목을 입력하세요"
        tf.font = .systemFont(ofSize: 17, weight: .semibold)
        tf.textColor = UIColor(hex: "222222")
        return tf
    }()
    
    private let titleBottomLine = UIView()
    
    private let titleCounterLabel: UILabel = {
        let lbl = UILabel(); lbl.font = .systemFont(ofSize: 12); lbl.textColor = .lightGray; lbl.text = "0/50"
        lbl.textAlignment = .right
        return lbl
    }()
    
    private lazy var contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.textColor = UIColor(hex: "333333")
        tv.text = self.placeholder
        tv.textColor = .lightGray
        return tv
    }()
    
    private let separatorLine2 = UIView()
    
    private let categorySectionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "카테고리 선택"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .label
        return lbl
    }()
    
    private let categoryControl = CategoryFilterView()
    
    // Section title above image area
    private let imageSectionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "이미지 선택"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .label
        return lbl
    }()
    
    private let imageAddButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.setTitle("📷 이미지 추가", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitleColor(.darkGray, for: .highlighted)
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    private let addedImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.isHidden = true
        return imgView
    }()
    private let removeImageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("✕", for: .normal)
        btn.backgroundColor = UIColor(white: 0, alpha: 0.5)
        btn.tintColor = .white
        btn.layer.cornerRadius = 12
        btn.isHidden = true
        return btn
    }()
    
    init(post: Post? = nil) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        setupDismissKeyboardGesture()
        bindActions()
        populateIfEditing()
    }
    
    private func configureSubviews() {
        view.backgroundColor = .systemBackground
        categoryControl.delegate = self
        self.title = "게시물 작성"
        [titleField, titleBottomLine, titleCounterLabel,
         contentTextView, separatorLine2, categorySectionLabel, categoryControl,
         imageSectionLabel, imageAddButton, addedImageView, removeImageButton].forEach { view.addSubview($0) }
        
        separatorLine.backgroundColor = UIColor(hex: "EEEEEE")
        separatorLine2.backgroundColor = UIColor(hex: "EEEEEE")
        titleBottomLine.backgroundColor = UIColor(hex: "EEEEEE")
        
        titleField.becomeFirstResponder()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.isNavigationBarHidden = false
        
        // Title Input
        titleField.pin.top(view.pin.safeArea).horizontally(16).height(60)
        titleBottomLine.pin.below(of: titleField).horizontally(16).height(1)
        titleCounterLabel.pin.below(of: titleBottomLine, aligned: .right).marginTop(4).width(50).height(13)
        
        // Content Input
        let contentHeight = max(150, contentTextView.contentSize.height)
        contentTextView.pin.below(of: titleCounterLabel).horizontally(16).marginTop(12).height(contentHeight)
        separatorLine2.pin.below(of: contentTextView).horizontally(16).height(1)
        
        // Category Control
        categorySectionLabel.pin.below(of: separatorLine2).horizontally(16).marginTop(24).sizeToFit()
        categoryControl.pin.below(of: categorySectionLabel).horizontally().marginTop(8).height(32)
        
        // Image Section Title
        imageSectionLabel.pin.below(of: categoryControl).horizontally(16).marginTop(24).sizeToFit()
        
        // Image Area
        if let _ = addedImageView.image {
            addedImageView.isHidden = false
            removeImageButton.isHidden = false
            imageAddButton.isHidden = true
            addedImageView.pin.below(of: imageSectionLabel).horizontally(16).marginTop(12).height(180)
            removeImageButton.pin.size(24).top(to: addedImageView.edge.top).right(to: addedImageView.edge.right).margin(8)
        } else {
            addedImageView.isHidden = true
            removeImageButton.isHidden = true
            imageAddButton.isHidden = false
            imageAddButton.pin.below(of: imageSectionLabel).horizontally(16).marginTop(12).height(60)
        }
    }
    
    private func bindActions() {
        imageAddButton.rx.tap
            .bind { [weak self] in self?.check() }
            .disposed(by: disposeBag)
        
        titleField.rx.text
            .orEmpty
            .map { String($0.prefix(50)) }
            .bind(to: titleField.rx.text)
            .disposed(by: disposeBag)
        
        titleField.rx.text
            .orEmpty
            .map { "\($0.count)/50" }
            .bind(to: titleCounterLabel.rx.text)
            .disposed(by: disposeBag)
        
        contentTextView.rx.didBeginEditing
          .subscribe(onNext: { [weak self] in
            guard let tv = self?.contentTextView else { return }
            if tv.text == self?.placeholder {
              tv.text = ""
              tv.textColor = UIColor(hex: "333333")  // 실제 입력 텍스트 컬러
            }
          })
          .disposed(by: disposeBag)

        // 편집 종료 시
        contentTextView.rx.didEndEditing
          .subscribe(onNext: { [weak self] in
            guard let tv = self?.contentTextView else { return }
            if tv.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
              tv.text = self?.placeholder
              tv.textColor = .lightGray
            }
          })
          .disposed(by: disposeBag)
        
        let titleContent = Observable
            .combineLatest(
                titleField.rx.text.orEmpty,
                contentTextView.rx.text.orEmpty
            )
            .share(replay: 1)
        
        let isCompleted: Observable<Bool> =
        titleContent
            .map { title, content in
                // 제목, 내용 모두 한 글자 이상 있어야 true
                return !title.isEmpty && !content.isEmpty
            }
            .share(replay: 1) // 여러 번 구독해도 최신 값을 재사용
        
        // 2) 버튼 활성화 바인딩
        isCompleted
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)

        // 2) 이미지 업로드를 Single<String?>로 래핑
        func uploadImageUUID() -> Single<String?> {
          guard let image = self.addedImageView.image else {
            return .just(nil)
          }
            
            let resized = image.resized(to: CGSize(width: 400, height: 300))
            
          return Single<String?>.create { single in
            Task {
              do {
                let result = try await StorageManager.shared.uploadImage(image)
                single(.success(result.uuid))
              } catch {
                single(.success(nil))   // 실패 시에도 nil 넘겨주거나 single(.failure(error)) 선택
              }
            }
            return Disposables.create()
          }
        }

        // 3) 탭 스트림에 requireLogin, withLatestFrom, flatMap 연결
        doneButton.rx.tap
          .requireLogin()                         // 로그인 확인
          .withLatestFrom(titleContent)           // 제목·내용과 묶기
          .flatMapLatest { pair in
              let (title, content) = pair
              
              return uploadImageUUID()
                  .flatMap { imageUUID -> Single<Void> in
                      do {
                          let categories = self.categoryControl.getSelectedCategories().values.flatMap { $0 }
                          
                          try FireStoreManager.shared.savePost(
                            with: title,
                            context: content,
                            categories: categories,
                            imageUUID: imageUUID
                          )
                          return .just(())
                      } catch {
                          return .error(error)
                      }
                  }
                  .asObservable()
              
          }.subscribe(onNext: { _ in
              self.navigationController?.popViewController(animated: true)
          }, onCompleted: {
              self.navigationController?.popViewController(animated: true)
          }, onDisposed: {
              
          }).disposed(by: disposeBag)
        
        removeImageButton.rx.tap
            .bind { [weak self] in self?.resetImageSection() }
            .disposed(by: disposeBag)
    }
    
    private func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func resetImageSection() {
        addedImageView.image = nil
        addedImageView.isHidden = true
        removeImageButton.isHidden = true
        imageAddButton.isHidden = false
        view.setNeedsLayout()
    }
    
    /// post가 non-nil(=수정 모드)이면 UI를 미리 채워줍니다.
       private func populateIfEditing() {
           guard let post = post else { return }

           // 1) 제목
           titleField.text = post.title
           titleCounterLabel.text = "\(post.title.count)/50"

           // 2) 내용
           contentTextView.text = post.content
           contentTextView.textColor = UIColor(hex: "333333")

           // 3) 카테고리
           // CategoryFilterView에 '기존 선택'을 전달
           categoryControl.preSelected(categories: post.categories)

           // 4) 이미지
           if let imageUUID = post.imageURL {
               imageAddButton.isHidden = true
               addedImageView.isHidden = false
               removeImageButton.isHidden = false

               // 예: Storage에서 불러오거나 URL->UIImage 변환
               Task {
                   do {
                       let image = try await StorageManager.shared.fetchPostImage(uuid: imageUUID)
                       DispatchQueue.main.async {
                           self.addedImageView.image = image
                           self.view.setNeedsLayout()
                       }
                   } catch {
                       
                   }
               }
           }

           // 5) '완료' 버튼 활성화
           doneButton.isEnabled = true
       }
}

extension PostComposeViewController: CategoryFilterViewDelegate {
    func categoryFilterView(didTapParent type: CategoryType) {
        pushDetail(for: type)
    }
    
    private func pushDetail(for type: CategoryType) {
        let allCategories = categoryControl.getAllCategories()
        let selected = categoryControl.getSelectedCategories()
        
        let vc = FilterDetailViewController(
            type: type,
            items: allCategories[type] ?? [],
            selected: selected[type] ?? []
        )
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PostComposeViewController: FilterDetailDelegate {
    func filterDetail(_ vc: FilterDetailViewController, didSelect items: [String], for category: CategoryType) {
        categoryControl.update(selected: [category:items])
    }
}

extension PostComposeViewController: PHPickerViewControllerDelegate {
    private func check() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            switch status {
            case .authorized, .limited:
                DispatchQueue.main.async { self?.presentImagePicker() }
            default:
                BridgingLogger.logEvent("fail_to_get_permission_for_image")
            }
        }
    }
    
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .any(of: [.images, .depthEffectPhotos, .panoramas, .screenshots])
        configuration.selection = .ordered
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        defer { picker.dismiss(animated: true) }
        
        guard let provider = results.first?.itemProvider else {
            BridgingLogger.logEvent("cancel_select_image")
            return
        }
        
        guard provider.canLoadObject(ofClass: UIImage.self) else {
            BridgingLogger.logEvent("fail_to_load_image")
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            DispatchQueue.main.async {
                if let error = error {
                    BridgingLogger.logEvent(
                        "fail_to_loading_image",
                        parameters: ["error": error.localizedDescription]
                    )
                } else if let image = object as? UIImage {
                    self?.addedImageView.image = image
                    self?.view.setNeedsLayout()
                } else {
                    BridgingLogger.logEvent("type_error_not_image")
                }
            }
        }
    }
}

