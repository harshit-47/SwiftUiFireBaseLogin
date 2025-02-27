import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUpPresented: Bool = false
    @State private var isForgotPasswordPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.orange
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("ManifestYourDreams")
                        .foregroundColor(.white)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .offset(y: -50)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(20)
                        .textInputAutocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .foregroundColor(.white)
                        
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        login()
                    }) {
                        Text("Login")
                            .foregroundColor(.orange)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    
                    HStack {
                        Button(action: {
                            isSignUpPresented.toggle()
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                        }
                        .fullScreenCover(isPresented: $isSignUpPresented) {
                            SignUpView(isPresented: $isSignUpPresented)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isForgotPasswordPresented.toggle()
                        }) {
                            Text("Forgot Password?")
                                .foregroundColor(.white)
                        }
                        .fullScreenCover(isPresented: $isForgotPasswordPresented) {
                            ForgotPasswordView(isPresented: $isForgotPasswordPresented)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
            } else {
                print("Login successful")
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        window.rootViewController = UIHostingController(rootView: NotesView())
                        window.makeKeyAndVisible()
                    }
                }            }
        }
    }
}

struct SignUpView: View {
    @Binding var isPresented: Bool
    @State private var newEmail: String = ""
    @State private var newPassword: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            TextField("Email", text: $newEmail)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .textInputAutocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $newPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Button(action: {
                isPresented = false
            }) {
                Text("Back")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: newEmail, password: newPassword) { authResult, error in
            if let error = error {
                alertMessage = "Sign-up failed: \(error.localizedDescription)"
            } else {
                alertMessage = "Sign-up successful!"
            }
            showAlert = true
        }
    }
}

struct ForgotPasswordView: View {
    @Binding var isPresented: Bool
    @State private var resetEmail: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Forgot Password")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            TextField("Enter your email", text: $resetEmail)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .textInputAutocapitalization(.none)
                .keyboardType(.emailAddress)
            
            Button(action: {
                resetPassword()
            }) {
                Text("Reset Password")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                isPresented = false
            }) {
                Text("Back")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: resetEmail) { error in
            if let error = error {
                print("Password reset failed: \(error.localizedDescription)")
            } else {
                print("Password reset email sent")
            }
        }
    }
}

#Preview {
    ContentView()
}

