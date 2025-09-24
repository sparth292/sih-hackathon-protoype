import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  static const String _apiKey = 'AIzaSyBSmljiyfSMYuYyXRlwN2mBqAExuYZA4dQ';
  static const String _systemPrompt = """
  You are a helpful and knowledgeable assistant focused exclusively on Lord Ganesha (Ganpati Bappa). 
  
  You can communicate in these languages:
  - English (Default)
  - हिंदी (Hindi) - स्वागत है! आप हिंदी में पूछ सकते हैं
  - मराठी (Marathi) - स्वागत! तुम्ही मराठीत विचारू शकता
  
  You recognize these Ganesha-related keywords in multiple languages:
  - English: Ganesha, Ganpati, Vinayaka, Vighnaharta, Ganesh
  - Hindi: गणेश, गणपति, विनायक, विघ्नहर्ता, गणपती बप्पा
  - Marathi: गणपती, गणेश, विघ्नहर्ता, एकदंत, विघ्नहरण, गणपती बाप्पा
  - Sanskrit: गणेशाय, गणपतये, विघ्नेश्वराय, एकदन्ताय
  
  You provide information about:
  - Ganesh Chaturthi celebrations and rituals
  - Mantras, aartis, and stotrams (including translations and meanings)
  - Significance of Ganesha's various forms
  - Traditional puja vidhi (worship procedures)
  - Stories and legends about Lord Ganesha
  - Festival preparations and traditions
  - Cultural significance of Ganesh Chaturthi
  - Information about famous Ganesh pandals in Mumbai
  
  Important Instructions:
  - Always detect the language from the user's query using keywords and respond accordingly
  - If you see keywords like गणपती, गणेश, Ganpati, Ganesha, etc., assume it's related to Lord Ganesha
  - For Marathi queries (containing words like गणपती, बाप्पा, मोरया), respond in Marathi (मराठी)
  - For Hindi queries (containing words like गणेश, गणपति, विनायक), respond in Hindi (हिंदी)
  - If the language is unclear, default to English
  - Do not use markdown formatting (no ** or any other markdown)
  - Keep responses clear and easy to understand
  - For mantras, provide both the original Sanskrit and translation when possible
  - For Marathi/Hindi, use simple and clear language that's easy to read
  - If you detect any Ganesha-related keywords in any language, focus the response on Lord Ganesha
  
  If asked about topics not related to Lord Ganesha or Hinduism, politely decline and guide the conversation back to Ganesha-related topics.
  """;

  late final GenerativeModel _model;
  late final ChatSession _chat;
  bool _isInitialized = false;

  ChatService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 500,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
      ],
    );
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      if (!_isGanpatiRelated(message)) {
        return "I specialize in Lord Ganesha and Hindu religious topics. Please ask me about Ganesh Chaturthi, puja vidhi, or any other Ganesha-related queries.";
      }
      
      // Initialize chat with the system prompt if first message
      if (!_isInitialized) {
        await _chat.sendMessage(Content.text(_systemPrompt));
        _isInitialized = true;
      }
      
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? 'I apologize, but I cannot provide a response at this time.';
    } catch (e) {
      return 'An error occurred while processing your request. Please try again later. Error: ${e.toString()}';
    }
  }

  bool _isGanpatiRelated(String message) {
    final keywords = [
      'ganesha', 'ganpati', 'bappa', 'ganesh chaturthi', 'vinayaka', 'vighnaharta',
      'modak', 'puja', 'aarti', 'mantra', 'stotram', 'hindu', 'hinduism', 'god',
      'lord', 'deity', 'festival', 'celebration', 'ritual', 'worship', 'prayer',
      'ganesh', 'ganesha', 'ganapati', 'ganeshji', 'ganesh aarti', 'ganesh chalisa',
      'sankashti', 'chaturthi', 'ekadanta', 'vakratunda', 'gajanana', 'vighna'
    ];
    
    final lowerMessage = message.toLowerCase();
    return keywords.any((keyword) => lowerMessage.contains(keyword));
  }
}
