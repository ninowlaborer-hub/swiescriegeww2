import 'dart:convert';
import 'package:dio/dio.dart';
import '../logging/logger.dart';

/// Claude AI integration service for Swisscierge
///
/// Provides privacy-first AI assistance with optional Claude API integration.
/// Follows Swisscierge privacy principles:
/// - User provides their own API key (no server-side storage)
/// - Optional service (works without it using on-device ML)
/// - Transparent about API calls and data sent
///
/// Features:
/// - Routine generation enhancement (optional cloud AI)
/// - Natural language schedule parsing
/// - Personalized suggestions based on patterns
/// - Biometric and weather-aware recommendations
class ClaudeAIService {
  ClaudeAIService({
    required this.apiKey,
    this.baseUrl = 'https://api.anthropic.com/v1',
    this.model = 'claude-3-5-haiku-20241022',
    this.maxTokens = 2048,
  });

  final String apiKey;
  final String baseUrl;
  final String model;
  final int maxTokens;

  /// Generate an enhanced daily routine using Claude AI
  ///
  /// Input data includes:
  /// - Calendar events for the day
  /// - Sleep quality and duration
  /// - Weather forecast
  /// - User preferences (work hours, activity preferences)
  /// - Historical routine patterns
  ///
  /// Returns a structured routine with time blocks and explanations
  Future<ClaudeRoutineResponse> generateRoutine({
    required List<Map<String, dynamic>> calendarEvents,
    required Map<String, dynamic> weatherData,
    required Map<String, dynamic> userPreferences,
    List<Map<String, dynamic>>? historicalPatterns,
    String? userFeedback,
    List<Map<String, dynamic>>? currentTimeBlocks,
    List<Map<String, dynamic>>? blocksToChange,
  }) async {
    AppLogger.info('🤖 ClaudeAIService.generateRoutine called');
    AppLogger.info('📅 Calendar events: ${calendarEvents.length} events');
    AppLogger.info(
      '🌤️ Weather: ${weatherData['temperature']}°C, ${weatherData['conditions']}',
    );
    AppLogger.info('⚙️ User preferences: ${userPreferences.keys.join(", ")}');

    if (userFeedback != null) {
      AppLogger.info('💬 User feedback: "$userFeedback"');
    }
    if (currentTimeBlocks != null) {
      AppLogger.info(
        '🔄 Regeneration mode with ${currentTimeBlocks.length} existing blocks',
      );
    }
    if (blocksToChange != null) {
      AppLogger.info(
        '🎯 Targeting ${blocksToChange.length} blocks for changes',
      );
    }

    final prompt = _buildRoutinePrompt(
      calendarEvents: calendarEvents,
      weatherData: weatherData,
      userPreferences: userPreferences,
      historicalPatterns: historicalPatterns,
      userFeedback: userFeedback,
      currentTimeBlocks: currentTimeBlocks,
      blocksToChange: blocksToChange,
    );

    AppLogger.info('📝 Prompt built, length: ${prompt.length} characters');
    AppLogger.info('🔑 Using API key: ${apiKey.substring(0, 20)}...');
    AppLogger.info('🤖 Model: $model, Max tokens: $maxTokens');

    final response = await _callClaudeAPI(
      systemPrompt: _getSwissciergeSystemPrompt(),
      userMessage: prompt,
    );

    AppLogger.info('✅ Received response from Claude API');
    AppLogger.info(
      '📊 Response content length: ${response['content'].toString().length} chars',
    );

    final routineResponse = ClaudeRoutineResponse.fromJson(response);
    AppLogger.info(
      '✨ Parsed routine: ${routineResponse.timeBlocks.length} blocks',
    );
    AppLogger.info('🎯 Confidence: ${routineResponse.confidenceScore}%');

    return routineResponse;
  }

  /// Parse natural language into schedule items
  ///
  /// Example: "I need to exercise for 30 minutes and have lunch with John at 1pm"
  /// Returns structured time blocks
  Future<List<Map<String, dynamic>>> parseNaturalLanguage(String text) async {
    final prompt =
        '''
Parse this natural language schedule into structured time blocks.
Return JSON array of blocks with: title, startTime, duration, activityType, description.

User input: "$text"
''';

    final response = await _callClaudeAPI(
      systemPrompt:
          'You are a Swiss precision schedule parser. Extract time-based activities accurately.',
      userMessage: prompt,
    );

    return List<Map<String, dynamic>>.from(json.decode(response['content']));
  }

  /// Get personalized routine suggestions based on patterns
  Future<List<String>> getSuggestions({
    required Map<String, dynamic> currentRoutine,
    required List<Map<String, dynamic>> historicalData,
  }) async {
    final prompt =
        '''
Analyze the user's routine patterns and suggest improvements.
Focus on: Swiss efficiency, work-life balance, health optimization.

Current routine: ${json.encode(currentRoutine)}
Historical patterns: ${json.encode(historicalData)}

Provide 3-5 actionable suggestions.
''';

    final response = await _callClaudeAPI(
      systemPrompt: _getSwissciergeSystemPrompt(),
      userMessage: prompt,
    );

    final suggestions = response['content'] as String;
    return suggestions.split('\n').where((s) => s.trim().isNotEmpty).toList();
  }

  /// Private method to call Claude API
  Future<Map<String, dynamic>> _callClaudeAPI({
    required String systemPrompt,
    required String userMessage,
  }) async {
    AppLogger.info('🌐 Calling Claude API at $baseUrl/messages');

    final dio = Dio();

    // Log request details
    final requestData = {
      'model': model,
      'max_tokens': maxTokens,
      'system': '${systemPrompt.substring(0, 100)}...', // First 100 chars only
      'messages': [
        {
          'role': 'user',
          'content':
              '${userMessage.substring(0, 200)}...', // First 200 chars only
        },
      ],
    };
    AppLogger.info('📤 Request data: ${json.encode(requestData)}');

    try {
      AppLogger.info('⏳ Sending POST request to Claude API...');
      final startTime = DateTime.now();

      final response = await dio.post(
        '$baseUrl/messages',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
          },
        ),
        data: {
          'model': model,
          'max_tokens': maxTokens,
          'system': systemPrompt,
          'messages': [
            {'role': 'user', 'content': userMessage},
          ],
        },
      );

      final duration = DateTime.now().difference(startTime);
      AppLogger.info('✅ API call completed in ${duration.inMilliseconds}ms');
      AppLogger.info('📥 Response status: ${response.statusCode}');

      final data = response.data as Map<String, dynamic>;
      AppLogger.info('📊 Response data keys: ${data.keys.join(", ")}');

      // Log usage stats
      if (data['usage'] != null) {
        final usage = data['usage'] as Map<String, dynamic>;
        AppLogger.info(
          '📈 Token usage: Input=${usage['input_tokens']}, Output=${usage['output_tokens']}',
        );
      }

      // Extract text content from response
      final content = data['content'] as List;
      AppLogger.info('📝 Content blocks: ${content.length}');

      final textContent = content.firstWhere(
        (block) => block['type'] == 'text',
        orElse: () {
          AppLogger.warning('⚠️ No text block found in response!');
          return {'text': ''};
        },
      );

      final extractedText = textContent['text'] as String;
      AppLogger.info(
        '📄 Extracted text length: ${extractedText.length} characters',
      );
      AppLogger.info(
        '📄 First 200 chars: ${extractedText.substring(0, extractedText.length < 200 ? extractedText.length : 200)}',
      );

      return {
        'content': extractedText,
        'usage': data['usage'],
        'model': data['model'],
      };
    } on DioException catch (e) {
      AppLogger.error('❌ Claude API request failed', error: e);
      AppLogger.error('❌ Error type: ${e.type}');
      AppLogger.error('❌ Status code: ${e.response?.statusCode}');
      AppLogger.error('❌ Response data: ${e.response?.data}');
      AppLogger.error('❌ Error message: ${e.message}');

      throw ClaudeAIException(
        'Claude API request failed: ${e.message}',
        statusCode: e.response?.statusCode,
        responseBody: e.response?.data?.toString(),
      );
    } catch (e, stack) {
      AppLogger.error('❌ Unexpected error in Claude API call', error: e);
      AppLogger.error('❌ Stack trace: $stack');
      throw ClaudeAIException('Unexpected error: $e');
    }
  }

  /// Build the system prompt for Swisscierge AI assistant
  String _getSwissciergeSystemPrompt() {
    return '''
You are the Swisscierge AI assistant - a Swiss precision daily routine planner.

Core Values:
- Swiss precision: Exact timing, efficient scheduling, no wasted time
- Swiss quality: High-quality suggestions that respect work-life balance
- Swiss reliability: Consistent, predictable, dependable routines
- Privacy-first: All processing respects user privacy

Your role:
- Generate optimal daily routines based on user data
- Consider calendar events, weather, and preferences
- Create time blocks that maximize productivity and wellbeing
- Explain reasoning in clear, concise terms
- Adapt to Swiss cultural values (punctuality, efficiency, quality)

Output Format:
- Always return valid JSON for routine generation
- Include time blocks with: title, startTime, endTime, activityType, description
- Add an explanation field describing the routine's logic
- Confidence score (0-100) for the routine quality
''';
  }

  /// Build the prompt for routine generation
  String _buildRoutinePrompt({
    required List<Map<String, dynamic>> calendarEvents,
    required Map<String, dynamic> weatherData,
    required Map<String, dynamic> userPreferences,
    List<Map<String, dynamic>>? historicalPatterns,
    String? userFeedback,
    List<Map<String, dynamic>>? currentTimeBlocks,
    List<Map<String, dynamic>>? blocksToChange,
  }) {
    final isRegeneration = userFeedback != null || currentTimeBlocks != null;

    return '''
${isRegeneration ? 'REGENERATE and IMPROVE the daily routine based on user feedback.' : 'Generate an optimal daily routine for today.'}

CALENDAR EVENTS:
${json.encode(calendarEvents)}

WEATHER:
- Temperature: ${weatherData['temperature']}°C
- Conditions: ${weatherData['conditions']}
- Precipitation: ${weatherData['precipitation']}%

USER PREFERENCES:
- Work hours: ${userPreferences['workHours']}
- Quiet hours: ${userPreferences['quietHours']}
- Activities: ${userPreferences['preferredActivities']}

${historicalPatterns != null ? 'HISTORICAL PATTERNS:\n${json.encode(historicalPatterns)}\n\n' : ''}${currentTimeBlocks != null ? '''
CURRENT ROUTINE (for reference):
${json.encode(currentTimeBlocks)}

''' : ''}${blocksToChange != null && blocksToChange.isNotEmpty ? '''
BLOCKS TO CHANGE (focus on these):
${json.encode(blocksToChange)}

''' : ''}${userFeedback != null ? '''
USER FEEDBACK & REQUESTS:
"$userFeedback"

IMPORTANT: Address the user's feedback directly. Make the specific changes they requested.
''' : ''}
Generate a comprehensive daily routine with time blocks that:
1. Works around calendar events
2. Considers weather for outdoor activities
3. Follows user preferences and work schedule
4. Maximizes Swiss efficiency and precision
${isRegeneration ? '6. ADDRESSES the user feedback and improves upon the current routine\n7. Focuses changes on the selected blocks while keeping other blocks if they work well' : ''}

Return JSON format:
{
  "routine": {
    "title": "Daily Routine for [date]",
    "timeBlocks": [
      {
        "title": "Morning Exercise",
        "startTime": "07:00",
        "endTime": "07:30",
        "activityType": "exercise",
        "description": "Light cardio to energize"
      }
      // ... more blocks
    ],
    "explanation": "${isRegeneration ? 'This improved routine addresses your feedback by...' : 'This routine prioritizes...'}",
    "confidenceScore": 95
  }
}
''';
  }
}

/// Response model for Claude routine generation
class ClaudeRoutineResponse {
  ClaudeRoutineResponse({
    required this.title,
    required this.timeBlocks,
    required this.explanation,
    required this.confidenceScore,
  });

  final String title;
  final List<ClaudeTimeBlock> timeBlocks;
  final String explanation;
  final int confidenceScore;

  factory ClaudeRoutineResponse.fromJson(Map<String, dynamic> json) {
    try {
      AppLogger.info('🔧 Parsing Claude response...');
      AppLogger.info('📝 JSON keys: ${json.keys.join(", ")}');

      final content = json['content'] as String;
      AppLogger.info('📄 Content length: ${content.length} chars');

      // Extract JSON from content (Claude may include explanation before JSON)
      String jsonString = content.trim();

      // Find JSON object boundaries
      final jsonStart = jsonString.indexOf('{');
      final jsonEnd = jsonString.lastIndexOf('}') + 1;

      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        jsonString = jsonString.substring(jsonStart, jsonEnd);
        AppLogger.info(
          '📄 Extracted JSON: ${jsonString.substring(0, jsonString.length < 200 ? jsonString.length : 200)}...',
        );
      }

      final routineData = jsonDecode(jsonString) as Map<String, dynamic>;
      AppLogger.info('✅ JSON decoded successfully');
      AppLogger.info('🔑 Routine data keys: ${routineData.keys.join(", ")}');

      final routine = routineData['routine'] as Map<String, dynamic>;
      AppLogger.info('📋 Routine keys: ${routine.keys.join(", ")}');

      final timeBlocksList = routine['timeBlocks'] as List;
      AppLogger.info('⏰ Found ${timeBlocksList.length} time blocks');

      final blocks = timeBlocksList
          .map((block) => ClaudeTimeBlock.fromJson(block))
          .toList();

      AppLogger.info('✨ Successfully parsed routine response');

      return ClaudeRoutineResponse(
        title: routine['title'] as String,
        timeBlocks: blocks,
        explanation: routine['explanation'] as String,
        confidenceScore: routine['confidenceScore'] as int,
      );
    } catch (e, stack) {
      AppLogger.error('❌ Failed to parse Claude response', error: e);
      AppLogger.error('❌ Stack trace: $stack');
      AppLogger.error('❌ Raw JSON: ${json.toString()}');
      rethrow;
    }
  }
}

/// Time block model from Claude response
class ClaudeTimeBlock {
  ClaudeTimeBlock({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.activityType,
    this.description,
  });

  final String title;
  final String startTime;
  final String endTime;
  final String activityType;
  final String? description;

  factory ClaudeTimeBlock.fromJson(Map<String, dynamic> json) {
    return ClaudeTimeBlock(
      title: json['title'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      activityType: json['activityType'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'activityType': activityType,
      if (description != null) 'description': description,
    };
  }
}

/// Exception thrown when Claude AI API calls fail
class ClaudeAIException implements Exception {
  ClaudeAIException(this.message, {this.statusCode, this.responseBody});

  final String message;
  final int? statusCode;
  final String? responseBody;

  @override
  String toString() {
    final buffer = StringBuffer('ClaudeAIException: $message');
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    if (responseBody != null) {
      buffer.write('\nResponse: $responseBody');
    }
    return buffer.toString();
  }
}
