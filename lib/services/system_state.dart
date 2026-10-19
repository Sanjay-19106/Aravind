import 'package:flutter/material.dart';
import '../models/attribute.dart';
import '../models/quest.dart';
import '../models/penalty.dart';
import '../models/log_entry.dart';
import '../models/user_profile.dart';
import 'storage_service.dart';

class SystemState extends ChangeNotifier {
  final StorageService _storage = StorageService();

  late UserProfile _profile;
  late List<Attribute> _attributes;
  late List<Quest> _quests;
  late PenaltyConfig _penalty;
  late List<LogEntry> _logs;

  int _currentTabIndex = 0;
  String? _toastMessage;

  UserProfile get profile => _profile;
  List<Attribute> get attributes => _attributes;
  List<Quest> get quests => _quests;
  PenaltyConfig get penalty => _penalty;
  List<LogEntry> get logs => _logs;
  int get currentTabIndex => _currentTabIndex;
  String? get toastMessage => _toastMessage;

  int get completedQuestsCount => _quests.where((q) => q.isCompleted).length;
  int get totalQuestsCount => _quests.length;
  double get completionPercentage =>
      totalQuestsCount == 0 ? 0 : (completedQuestsCount / totalQuestsCount);

  int get totalAttributePoints =>
      _attributes.fold(0, (sum, item) => sum + item.currentValue);

  Future<void> initialize() async {
    await _storage.init();
    _profile = _storage.loadProfile();
    _attributes = _storage.loadAttributes();
    _quests = _storage.loadQuests();
    _penalty = _storage.loadPenalty();
    _logs = _storage.loadLogs();

    _checkDailyCycle();
    notifyListeners();
  }

  void _checkDailyCycle() {
    final now = DateTime.now();
    final lastReset = _storage.loadLastResetDate();

    if (lastReset != null) {
      final isDifferentDay = now.year != lastReset.year ||
          now.month != lastReset.month ||
          now.day != lastReset.day;

      if (isDifferentDay) {
        final missedCount = _quests.where((q) => !q.isCompleted).length;
        if (missedCount > 0 && _penalty.isPledgeActive) {
          _penalty.isUnderPenalty = true;
          _penalty.breachCount += 1;
          _penalty.penaltyTriggeredDate = now;
          _profile.streakDays = 0;

          _logs.insert(
            0,
            LogEntry(
              id: 'log_${DateTime.now().millisecondsSinceEpoch}',
              timestamp: now,
              title: 'PENALTY PROTOCOL ACTIVATED.',
              description:
                  'Daily quota breached ($missedCount incomplete). Mandatory Leverage applied: ${_penalty.penaltyText}.',
              type: 'PENALTY',
            ),
          );
        } else if (missedCount == 0 && _quests.isNotEmpty) {
          _profile.streakDays += 1;
          _logs.insert(
            0,
            LogEntry(
              id: 'log_${DateTime.now().millisecondsSinceEpoch}',
              timestamp: now,
              title: 'Daily cycle cleared.',
              description: '100% compliance maintained. Streak incremented to ${_profile.streakDays}.',
              type: 'PROTOCOL',
            ),
          );
        }

        // Reset quest completions for the fresh day
        for (var q in _quests) {
          q.isCompleted = false;
          q.completedAt = null;
        }

        _storage.saveQuests(_quests);
        _storage.savePenalty(_penalty);
        _storage.saveProfile(_profile);
        _storage.saveLogs(_logs);
      }
    }

    _storage.saveLastResetDate(now);
  }

  void switchTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void showToast(String message) {
    _toastMessage = message;
    notifyListeners();
  }

  void clearToast() {
    _toastMessage = null;
    notifyListeners();
  }

  void toggleQuest(String questId) {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) return;

    final quest = _quests[index];
    final wasCompleted = quest.isCompleted;
    quest.isCompleted = !wasCompleted;
    quest.completedAt = quest.isCompleted ? DateTime.now() : null;

    final attrIndex = _attributes.indexWhere((a) => a.code == quest.attributeCode);

    if (quest.isCompleted) {
      // Award Attribute
      if (attrIndex != -1) {
        _attributes[attrIndex].currentValue =
            (_attributes[attrIndex].currentValue + quest.attributeGain)
                .clamp(0, _attributes[attrIndex].maxValue);
      }

      // Award EXP & check Level Up
      _profile.totalCompletedQuests += 1;
      _profile.totalAccumulatedExp += quest.expGain;
      _profile.currentExp += quest.expGain;

      _checkLevelUp();

      // Log entry
      _logs.insert(
        0,
        LogEntry(
          id: 'log_${DateTime.now().millisecondsSinceEpoch}',
          timestamp: DateTime.now(),
          title: 'Quest Completed: ${quest.title}',
          description: '+${quest.expGain} EXP • +${quest.attributeGain} ${quest.attributeCode}',
          type: 'QUEST_COMPLETE',
          expEarned: quest.expGain,
        ),
      );

      showToast('Quest complete +${quest.expGain} EXP');
    } else {
      // Revert Attribute
      if (attrIndex != -1) {
        _attributes[attrIndex].currentValue =
            (_attributes[attrIndex].currentValue - quest.attributeGain)
                .clamp(0, _attributes[attrIndex].maxValue);
      }

      // Revert EXP
      _profile.totalCompletedQuests = (_profile.totalCompletedQuests - 1).clamp(0, 999999);
      _profile.totalAccumulatedExp = (_profile.totalAccumulatedExp - quest.expGain).clamp(0, 999999);
      _profile.currentExp = (_profile.currentExp - quest.expGain).clamp(0, 999999);

      showToast('Quest uncompleted');
    }

    _storage.saveQuests(_quests);
    _storage.saveAttributes(_attributes);
    _storage.saveProfile(_profile);
    _storage.saveLogs(_logs);

    notifyListeners();
  }

  void _checkLevelUp() {
    while (_profile.currentExp >= _profile.maxExpPerLevel) {
      _profile.currentExp -= _profile.maxExpPerLevel;
      _profile.level += 1;

      // Update Rank
      final oldRank = _profile.rank;
      if (_profile.level >= 75) {
        _profile.rank = 'Rank S';
      } else if (_profile.level >= 50) {
        _profile.rank = 'Rank A';
      } else if (_profile.level >= 30) {
        _profile.rank = 'Rank B';
      } else if (_profile.level >= 15) {
        _profile.rank = 'Rank C';
      } else if (_profile.level >= 5) {
        _profile.rank = 'Rank D';
      }

      if (_profile.rank != oldRank) {
        _logs.insert(
          0,
          LogEntry(
            id: 'log_ascend_${DateTime.now().millisecondsSinceEpoch}',
            timestamp: DateTime.now(),
            title: 'HUNTER ASCENSION: ${_profile.rank}',
            description: 'Level ${_profile.level} reached. Alter Ego integration advancing.',
            type: 'ASCENSION',
          ),
        );
      }
    }
  }

  void addCustomQuest({
    required String title,
    required String duration,
    required String attributeCode,
    required int attributeGain,
    required int expGain,
  }) {
    final newQuest = Quest(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      duration: duration,
      attributeCode: attributeCode,
      attributeGain: attributeGain,
      expGain: expGain,
      isCustom: true,
    );

    _quests.add(newQuest);
    _logs.insert(
      0,
      LogEntry(
        id: 'log_qadd_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        title: 'New Protocol Enforced: $title',
        description: '+$attributeGain $attributeCode reward assigned.',
        type: 'PROTOCOL',
      ),
    );

    _storage.saveQuests(_quests);
    _storage.saveLogs(_logs);
    showToast('New protocol integrated');
    notifyListeners();
  }

  void updatePenaltyConfig(String text, bool pledgeActive) {
    _penalty.penaltyText = text;
    _penalty.isPledgeActive = pledgeActive;
    _storage.savePenalty(_penalty);
    showToast('Enforcement rules updated');
    notifyListeners();
  }

  void clearPenaltyFulfillment() {
    _penalty.isUnderPenalty = false;
    _logs.insert(
      0,
      LogEntry(
        id: 'log_cleared_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        title: 'Penalty Cleared & Atoned.',
        description: 'Physical friction executed: ${_penalty.penaltyText}. Baseline restored.',
        type: 'PROTOCOL',
      ),
    );

    _storage.savePenalty(_penalty);
    _storage.saveLogs(_logs);
    showToast('Penalty atoned. Discipline restored.');
    notifyListeners();
  }

  void triggerRoutineStart() {
    _profile.totalAccumulatedExp += 25;
    _profile.currentExp += 25;
    _checkLevelUp();

    _logs.insert(
      0,
      LogEntry(
        id: 'log_routine_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        title: 'Routine Sequence Initiated.',
        description: 'Active morning mobilization triggered. +25 EXP.',
        type: 'PROTOCOL',
        expEarned: 25,
      ),
    );

    _storage.saveProfile(_profile);
    _storage.saveLogs(_logs);

    showToast('Routine sequence initiated (+25 EXP)');
    _currentTabIndex = 1; // Jump to Daily Quests tab
    notifyListeners();
  }

  void updateAttributeValues(Map<String, int> newValues) {
    for (var attr in _attributes) {
      if (newValues.containsKey(attr.code)) {
        attr.currentValue = newValues[attr.code]!.clamp(0, attr.maxValue);
      }
    }
    _storage.saveAttributes(_attributes);
    showToast('Attributes updated');
    notifyListeners();
  }

  Future<void> resetAllData() async {
    await _storage.clearAll();
    _profile = UserProfile();
    _attributes = Attribute.defaultAttributes();
    _quests = Quest.defaultProtocols();
    _penalty = PenaltyConfig();
    _logs = LogEntry.defaultEntries();

    _storage.saveProfile(_profile);
    _storage.saveAttributes(_attributes);
    _storage.saveQuests(_quests);
    _storage.savePenalty(_penalty);
    _storage.saveLogs(_logs);

    showToast('All progress reset to Day 0 Novice baseline');
    _currentTabIndex = 0;
    notifyListeners();
  }
}
