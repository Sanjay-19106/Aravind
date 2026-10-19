import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attribute.dart';
import '../models/quest.dart';
import '../models/penalty.dart';
import '../models/log_entry.dart';
import '../models/user_profile.dart';

class StorageService {
  static const String keyProfile = 'aravind_profile';
  static const String keyAttributes = 'aravind_attributes';
  static const String keyQuests = 'aravind_quests';
  static const String keyPenalty = 'aravind_penalty';
  static const String keyLogs = 'aravind_logs';
  static const String keyLastReset = 'aravind_last_reset';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  UserProfile loadProfile() {
    final raw = _prefs.getString(keyProfile);
    if (raw != null) {
      try {
        return UserProfile.fromJson(jsonDecode(raw));
      } catch (_) {}
    }
    return UserProfile();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(keyProfile, jsonEncode(profile.toJson()));
  }

  List<Attribute> loadAttributes() {
    final raw = _prefs.getString(keyAttributes);
    if (raw != null) {
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => Attribute.fromJson(e)).toList();
      } catch (_) {}
    }
    return Attribute.defaultAttributes();
  }

  Future<void> saveAttributes(List<Attribute> attributes) async {
    final raw = jsonEncode(attributes.map((e) => e.toJson()).toList());
    await _prefs.setString(keyAttributes, raw);
  }

  List<Quest> loadQuests() {
    final raw = _prefs.getString(keyQuests);
    if (raw != null) {
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => Quest.fromJson(e)).toList();
      } catch (_) {}
    }
    return Quest.defaultProtocols();
  }

  Future<void> saveQuests(List<Quest> quests) async {
    final raw = jsonEncode(quests.map((e) => e.toJson()).toList());
    await _prefs.setString(keyQuests, raw);
  }

  PenaltyConfig loadPenalty() {
    final raw = _prefs.getString(keyPenalty);
    if (raw != null) {
      try {
        return PenaltyConfig.fromJson(jsonDecode(raw));
      } catch (_) {}
    }
    return PenaltyConfig();
  }

  Future<void> savePenalty(PenaltyConfig penalty) async {
    await _prefs.setString(keyPenalty, jsonEncode(penalty.toJson()));
  }

  List<LogEntry> loadLogs() {
    final raw = _prefs.getString(keyLogs);
    if (raw != null) {
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => LogEntry.fromJson(e)).toList();
      } catch (_) {}
    }
    return LogEntry.defaultEntries();
  }

  Future<void> saveLogs(List<LogEntry> logs) async {
    final raw = jsonEncode(logs.map((e) => e.toJson()).toList());
    await _prefs.setString(keyLogs, raw);
  }

  DateTime? loadLastResetDate() {
    final str = _prefs.getString(keyLastReset);
    if (str != null) {
      try {
        return DateTime.parse(str);
      } catch (_) {}
    }
    return null;
  }

  Future<void> saveLastResetDate(DateTime date) async {
    await _prefs.setString(keyLastReset, date.toIso8601String());
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
