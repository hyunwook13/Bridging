//
//  FireStoreManager.swift
//  Bridging
//
//  Created by 이현욱 on 4/27/25.
//

import Foundation

import FirebaseAuth // FIXME: 지워
import FirebaseFirestore
import RxSwift
import RxCocoa

protocol UserProfileService {
    func fetchProfile(for uid: String) -> Single<UserProfile>
}

// MARK: - 함수 호출 전에 무조건 User의 로그인 상태를 검증

public class FireStoreManager {
    public static let shared = FireStoreManager()
    
    private let db = Firestore.firestore()
    
    private let disposeBag = DisposeBag()
    
    private let pageSize = 10
    private var lastDocument: DocumentSnapshot?
    
    public var newPostStream: Observable<Post> {
        Observable.create { observer in
            // ① 컬렉션 전체를 리스닝
            let listener = self.db
                .collection("posts")
                .order(by: "createdAt", descending: true)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    guard let changes = snapshot?.documentChanges else {
                        return
                    }

                    // ② .added 타입만 필터링
                    for change in changes where change.type == .added {
                        do {
                            var post = try change.document.data(as: Post.self)
                            // ③ 문서 ID와 임시 플래그 주입
                            post.uuid = change.document.documentID
                            post.isTemporaryFlag = true
                            observer.onNext(post)
                        } catch {
                            observer.onError(error)
                        }
                    }
                }

            // ④ 해제 시 리스너 제거
            return Disposables.create {
                listener.remove()
            }
        }
        // ⑤ 여러 구독자에도 하나의 리스너만 사용
        .share(replay: 1, scope: .whileConnected)
    }
    
    private init() { }
    
//    public func fetchPost(with postUUID: String?) -> Single<Post?> {
//        return Single.create { single in
//            guard let postUUID = postUUID else {
//                single(.failure(NSError(domain: "", code: 0)))
//                return Disposables.create()
//            }
//            
//            self.db.document("posts")
//                .collection(postUUID)
//                .getDocuments { snapshot, error in
//                    do {
//                        let data = try snapshot?.documents.first?.data(as: Post.self)
//                        single(.success(data))
//                    } catch {
//                        single(.failure(error))
//                    }
//                }
//            
//            return Disposables.create()
//        }
//    }
    public func saveComment(with postUUID: String?, comment: CommentDTO) -> Single<CommentDTO> {
        return Single.create { comp in
            guard let postUUID = postUUID else {
                comp(.failure(NSError(domain: "", code: 0)))
                return Disposables.create()
            }
            do {
                let docRef = try self.db
                .collection("posts")
                .document(postUUID)
                .collection("comments")
                .addDocument(from: comment)
                comp(.success(comment))
            } catch {
                comp(.failure(error))
            }
                
            return Disposables.create()
        }
    }
    
    public func fetchComments(with postUUID: String?) -> Single<[CommentDTO]> {
        return Single.create { comp in
            guard let postUUID = postUUID else {
                comp(.failure(NSError(domain: "", code: 0)))
                return Disposables.create()
            }
            Task {
                do {
                    var comments = [CommentDTO]()
                    
                    let docRef = try await self.db
                        .collection("posts")
                        .document(postUUID)
                        .collection("comments")
                        .getDocuments()
                    
                    for snapshot in docRef.documents {
                        let comment = try snapshot.data(as: CommentDTO.self)
                        comments.append(comment)
                    }
                    comp(.success(comments))
                } catch {
                    comp(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func fetchPost(with postUUID: String? ) -> Single<Post?> {
        return Single.create { single in
                        guard let postUUID = postUUID else {
                            single(.failure(NSError(domain: "", code: 0)))
                            return Disposables.create()
                        }
            let docRef = self.db
                .collection("posts")
                .document(postUUID)     // UUID가 문서 ID인 경우

            docRef.getDocument { snapshot, error in
                if let error = error {
                    single(.failure(error))
                } else {
                    do {
                        let post = try snapshot?.data(as: Post.self)
                        single(.success(post))
                    } catch {
                        single(.failure(error))
                    }
                }
            }

            return Disposables.create()
        }
    }

    public func fetchNextPage() -> Single<[Post]> {
        Single.create { single in
            var query: Query = self.db.collection("posts")
                .order(by: "createdAt", descending: true)
                .limit(to: self.pageSize)

            if let lastDoc = self.lastDocument {
                query = query.start(afterDocument: lastDoc)
            }

            // getDocuments는 Void를 반환하므로, 리스너 등록을 반환하지 않음
            query.getDocuments { snapshot, error in
                if let error = error {
                    single(.failure(error))
                } else if let snapshot = snapshot {
                    
                    let newPosts = snapshot.documents.compactMap {
                        var data = try? $0.data(as: Post.self)
                        data?.uuid = $0.documentID
                        data?.isTemporaryFlag = true
                        return data
                    }
                    
                    self.lastDocument = snapshot.documents.last
                    single(.success(newPosts))
                } else {
                    single(.success([]))
                }
            }

            // 취소 로직이 필요 없으므로 빈 Disposable 반환
            return Disposables.create()
        }
    }
    
    public func saveVote(postUUID: String?, type: VoteType) -> Completable {
        Completable.create { comp in
            guard let postUUID = postUUID else {
                comp(.error(NSError(domain: "", code: 0, userInfo: nil)))
                return Disposables.create()
            }
            
            guard let user = AuthManager.shared.userRelay.value else {
                comp(.error(NSError(domain: "", code: 0, userInfo: nil)))
                return Disposables.create()
            }
            
            guard let profile = AuthManager.shared.profileRelay.value else {
                comp(.error(NSError(domain: "", code: 0, userInfo: nil)))
                return Disposables.create()
            }
            
            let vote = Vote(vote: type, ageGroup: profile.ageGroup, createdAt: Timestamp(date: Date()))
            do {
                try self.db.collection("posts").document(postUUID)
                    .collection("votes").document(user.uid)
                    .setData(from: vote)
                comp(.completed)
            } catch {
                comp(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func addUser(_ profile: UserProfile) -> Single<Bool> {
        AuthManager.shared.userRelay
            .compactMap { $0 }
            .take(1)
            .flatMap { user in
                return self.saveProfile(uid: user!.uid, profile: profile)
                    .andThen(Single.just(true))
            }
            .catch { error in
                BridgingLogger.logEvent("fail_to_add_user", parameters: ["error": error.localizedDescription])
                return .just(false)
            }
            .do(onNext: { success in
                if success {
                    BridgingLogger.logEvent("success_to_add_user", parameters: ["uid": profile.uuid ?? ""])
                }
            })
            .asSingle()
    }
    
    private func saveProfile(uid: String, profile: UserProfile) -> Completable {
        Completable.create { single in
            do {
                try self.db.collection("users")
                    .document(uid)
                    .setData(from: profile)
                single(.completed)
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func getUser(with uuid: String) async throws -> UserProfile {
        let snapshot = try await db.collection("users").document(uuid).getDocument()
        return try snapshot.data(as: UserProfile.self)
    }
    
    public func savePost(with title: String, context: String, categories: [String], imageUUID: String?) throws {
        let uuid = UUID().uuidString
        
        guard let user = AuthManager.shared.profileRelay.value else { throw NSError(domain: "", code: 0, userInfo: nil) }
        
        let post = PostBuilder()
            .setContext(context)
            .setCreatedUserID(user.uuid!)
            .setImageURL(imageUUID)
            .setCategories(categories)
            .setTitle(title)
            .setAuthorNickName(user.nickname)
            .setAuthorGender(user.gender)
            .setAuthorAgeGroup(user.ageGroup)
            .build()
        
        try db.collection("posts").document(uuid)
            .setData(from: post)
        
        saveUserPostInfo(postuuid: uuid)
    }
    
    public func removePost(with id: String) -> Single<Void> {
        Single.create { single in
            self.db.collection("posts")
                .document(id).delete { error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        single(.success(()))
                        self.removeUserPostInfo(postuuid: id)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    private func removeUserPostInfo(postuuid: String) {
        let user = AuthManager.shared.userRelay.value!
        
        db.collection("users").document(user.uid).updateData([
            "posts": FieldValue.arrayRemove([postuuid])
        ])
    }
    
    public func fetchPosts(withTitle title: String,
                           categories cats: [String]) async throws -> [Post] {
        // 1) 베이스 컬렉션
        var query: Query = db.collection("posts")
        
        // 2) 제목이 빈 값이 아니면, prefix 범위 쿼리 추가
        if !title.isEmpty {
            // title로 오름차순 정렬 후
            // startAt: ["tit"] 부터, endAt: ["tit\uf8ff"] 까지
            query = query
                .order(by: "title")
                .start(at: [title])
                .end(at: [title + "\u{f8ff}"])
        }
        
        // 3) 카테고리 필터 (OR 조건)
        if !cats.isEmpty {
            query = query.whereField("categories", arrayContainsAny: cats)
        }
        
        // 4) Firestore 호출
        let snapshot = try await query.getDocuments()
        var posts = snapshot.documents.compactMap { try? $0.data(as: Post.self) }
        
        // 5) “모두 포함” 조건이라면 로컬 필터링
        if !cats.isEmpty {
            posts = posts.filter { post in
                Set(cats).isSubset(of: Set(post.categories))
            }
        }
        
        return posts
    }
    
    private func saveUserPostInfo(postuuid: String) {
        let user = AuthManager.shared.userRelay.value!
        
        db.collection("users").document(user.uid).updateData([
            "posts": FieldValue.arrayUnion([postuuid])
        ])
    }
    
    public func fetchVotes(postUUID: String?) -> Single<[Vote]> {
        // 1) 포스트 문서만 가져오는 작은 함수
        guard let postUUID = postUUID else {
            return Single.error(NSError(domain: "", code: 0))
        }

        // 3) 두 함수를 조합해 Post에 votes를 채워서 반환
//        return fetchPost(with: postUUID)
//            .flatMap { postOpt in
//                guard var post = postOpt else {
//                    return .just(nil)
//                }
                return self.fetchVotes(postUUID: postUUID)
//                    .map { votes in
//                        post.votes = votes
//                        return post
//                    }
//                    .map(Optional.some)
//            }
    }
    
    func fetchPost(postUUID: String) -> Single<Post?> {
        return Single.create { single in
            let docRef = self.db.collection("posts").document(postUUID)
            docRef.getDocument { snap, error in
                if let error = error {
                    single(.failure(error))
                } else {
                    do {
                        let post = try snap?.data(as: Post.self)
                        single(.success(post))
                    } catch {
                        single(.failure(error))
                    }
                }
            }
            return Disposables.create()
        }
    }

    // 2) votes 서브컬렉션만 가져오는 작은 함수
    func fetchVotes(postUUID: String) -> Single<[Vote]> {
        return Single.create { single in
            let votesRef = self.db
                .collection("posts")
                .document(postUUID)
                .collection("votes")
            votesRef.getDocuments { snap, error in
                if let error = error {
                    single(.failure(error))
                } else {
                    let votes = snap?.documents.compactMap {
                        try? $0.data(as: Vote.self)
                    } ?? []
                    single(.success(votes))
                }
            }
            return Disposables.create()
        }
    }
}

extension FireStoreManager: UserProfileService {
    func fetchProfile(for uid: String) -> Single<UserProfile> {
        return Single.create { single in
            let task = Task {
                do {
                    let profile = try await self.getUser(with: uid)
                    single(.success(profile))
                } catch {
                    
                    single(.failure(error))
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
