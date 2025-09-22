import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static const String supabaseUrl = 'https://hjkugnfqyalynegnhkti.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhqa3VnbmZxeWFseW5lZ25oa3RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg1MTM5MjgsImV4cCI6MjA3NDA4OTkyOH0.4_71Squ5jU0-q5J3CzcuYfTK7jhY3SONXFZtqYVoQVQ';
  
  late final SupabaseClient client;
  late final GoTrueClient auth;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    
    client = Supabase.instance.client;
    auth = client.auth;
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'email': email,
      },
    );
    return response;
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  // Get current user
  User? get currentUser => auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Get auth state changes stream
  Stream<AuthState> get onAuthStateChange => auth.onAuthStateChange;
}
