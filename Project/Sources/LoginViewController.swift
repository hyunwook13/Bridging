//
//  LoginViewController.swift
//  Bridging
//
//  Created by 이현욱 on 4/25/25.
//

import UIKit
import AuthenticationServices

import GoogleSignIn
import Supabase


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func googleSignIn() async throws {
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
        guard let idToken = result.user.idToken?.tokenString else {
          print("No idToken found.")
          return
        }
        let accessToken = result.user.accessToken.tokenString
        try await supabase.auth.signInWithIdToken(
          credentials: OpenIDConnectCredentials(
            provider: .google,
            idToken: idToken,
            accessToken: accessToken
          )
        )
      }

}
