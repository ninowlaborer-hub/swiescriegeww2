// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceScoreMeta = const VerificationMeta(
    'confidenceScore',
  );
  @override
  late final GeneratedColumn<double> confidenceScore = GeneratedColumn<double>(
    'confidence_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAcceptedMeta = const VerificationMeta(
    'isAccepted',
  );
  @override
  late final GeneratedColumn<bool> isAccepted = GeneratedColumn<bool>(
    'is_accepted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_accepted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    date,
    title,
    explanation,
    confidenceScore,
    isAccepted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('confidence_score')) {
      context.handle(
        _confidenceScoreMeta,
        confidenceScore.isAcceptableOrUnknown(
          data['confidence_score']!,
          _confidenceScoreMeta,
        ),
      );
    }
    if (data.containsKey('is_accepted')) {
      context.handle(
        _isAcceptedMeta,
        isAccepted.isAcceptableOrUnknown(data['is_accepted']!, _isAcceptedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      confidenceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence_score'],
      ),
      isAccepted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_accepted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final int id;
  final String uuid;
  final DateTime date;
  final String title;
  final String? explanation;
  final double? confidenceScore;
  final bool isAccepted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Routine({
    required this.id,
    required this.uuid,
    required this.date,
    required this.title,
    this.explanation,
    this.confidenceScore,
    required this.isAccepted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['date'] = Variable<DateTime>(date);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    if (!nullToAbsent || confidenceScore != null) {
      map['confidence_score'] = Variable<double>(confidenceScore);
    }
    map['is_accepted'] = Variable<bool>(isAccepted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      date: Value(date),
      title: Value(title),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      confidenceScore: confidenceScore == null && nullToAbsent
          ? const Value.absent()
          : Value(confidenceScore),
      isAccepted: Value(isAccepted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String>(json['title']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      confidenceScore: serializer.fromJson<double?>(json['confidenceScore']),
      isAccepted: serializer.fromJson<bool>(json['isAccepted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String>(title),
      'explanation': serializer.toJson<String?>(explanation),
      'confidenceScore': serializer.toJson<double?>(confidenceScore),
      'isAccepted': serializer.toJson<bool>(isAccepted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Routine copyWith({
    int? id,
    String? uuid,
    DateTime? date,
    String? title,
    Value<String?> explanation = const Value.absent(),
    Value<double?> confidenceScore = const Value.absent(),
    bool? isAccepted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Routine(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    date: date ?? this.date,
    title: title ?? this.title,
    explanation: explanation.present ? explanation.value : this.explanation,
    confidenceScore: confidenceScore.present
        ? confidenceScore.value
        : this.confidenceScore,
    isAccepted: isAccepted ?? this.isAccepted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      confidenceScore: data.confidenceScore.present
          ? data.confidenceScore.value
          : this.confidenceScore,
      isAccepted: data.isAccepted.present
          ? data.isAccepted.value
          : this.isAccepted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('explanation: $explanation, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('isAccepted: $isAccepted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    date,
    title,
    explanation,
    confidenceScore,
    isAccepted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.date == this.date &&
          other.title == this.title &&
          other.explanation == this.explanation &&
          other.confidenceScore == this.confidenceScore &&
          other.isAccepted == this.isAccepted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<DateTime> date;
  final Value<String> title;
  final Value<String?> explanation;
  final Value<double?> confidenceScore;
  final Value<bool> isAccepted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.explanation = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.isAccepted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required DateTime date,
    required String title,
    this.explanation = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.isAccepted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : uuid = Value(uuid),
       date = Value(date),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Routine> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<DateTime>? date,
    Expression<String>? title,
    Expression<String>? explanation,
    Expression<double>? confidenceScore,
    Expression<bool>? isAccepted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (explanation != null) 'explanation': explanation,
      if (confidenceScore != null) 'confidence_score': confidenceScore,
      if (isAccepted != null) 'is_accepted': isAccepted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RoutinesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<DateTime>? date,
    Value<String>? title,
    Value<String?>? explanation,
    Value<double?>? confidenceScore,
    Value<bool>? isAccepted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      date: date ?? this.date,
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      isAccepted: isAccepted ?? this.isAccepted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (confidenceScore.present) {
      map['confidence_score'] = Variable<double>(confidenceScore.value);
    }
    if (isAccepted.present) {
      map['is_accepted'] = Variable<bool>(isAccepted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('explanation: $explanation, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('isAccepted: $isAccepted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TimeBlocksTable extends TimeBlocks
    with TableInfo<$TimeBlocksTable, TimeBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<int> routineId = GeneratedColumn<int>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityTypeMeta = const VerificationMeta(
    'activityType',
  );
  @override
  late final GeneratedColumn<String> activityType = GeneratedColumn<String>(
    'activity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSnoozedMeta = const VerificationMeta(
    'isSnoozed',
  );
  @override
  late final GeneratedColumn<bool> isSnoozed = GeneratedColumn<bool>(
    'is_snoozed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_snoozed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _snoozedUntilMeta = const VerificationMeta(
    'snoozedUntil',
  );
  @override
  late final GeneratedColumn<DateTime> snoozedUntil = GeneratedColumn<DateTime>(
    'snoozed_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    routineId,
    title,
    description,
    startTime,
    endTime,
    activityType,
    category,
    priority,
    isSnoozed,
    snoozedUntil,
    source,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeBlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('activity_type')) {
      context.handle(
        _activityTypeMeta,
        activityType.isAcceptableOrUnknown(
          data['activity_type']!,
          _activityTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_snoozed')) {
      context.handle(
        _isSnoozedMeta,
        isSnoozed.isAcceptableOrUnknown(data['is_snoozed']!, _isSnoozedMeta),
      );
    }
    if (data.containsKey('snoozed_until')) {
      context.handle(
        _snoozedUntilMeta,
        snoozedUntil.isAcceptableOrUnknown(
          data['snoozed_until']!,
          _snoozedUntilMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeBlock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}routine_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      activityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      isSnoozed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_snoozed'],
      )!,
      snoozedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}snoozed_until'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TimeBlocksTable createAlias(String alias) {
    return $TimeBlocksTable(attachedDatabase, alias);
  }
}

class TimeBlock extends DataClass implements Insertable<TimeBlock> {
  final int id;
  final String uuid;
  final int routineId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String activityType;
  final String? category;
  final int priority;
  final bool isSnoozed;
  final DateTime? snoozedUntil;
  final String? source;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TimeBlock({
    required this.id,
    required this.uuid,
    required this.routineId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.activityType,
    this.category,
    required this.priority,
    required this.isSnoozed,
    this.snoozedUntil,
    this.source,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['routine_id'] = Variable<int>(routineId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['activity_type'] = Variable<String>(activityType);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['priority'] = Variable<int>(priority);
    map['is_snoozed'] = Variable<bool>(isSnoozed);
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TimeBlocksCompanion toCompanion(bool nullToAbsent) {
    return TimeBlocksCompanion(
      id: Value(id),
      uuid: Value(uuid),
      routineId: Value(routineId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startTime: Value(startTime),
      endTime: Value(endTime),
      activityType: Value(activityType),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      priority: Value(priority),
      isSnoozed: Value(isSnoozed),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TimeBlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeBlock(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      routineId: serializer.fromJson<int>(json['routineId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      activityType: serializer.fromJson<String>(json['activityType']),
      category: serializer.fromJson<String?>(json['category']),
      priority: serializer.fromJson<int>(json['priority']),
      isSnoozed: serializer.fromJson<bool>(json['isSnoozed']),
      snoozedUntil: serializer.fromJson<DateTime?>(json['snoozedUntil']),
      source: serializer.fromJson<String?>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'routineId': serializer.toJson<int>(routineId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'activityType': serializer.toJson<String>(activityType),
      'category': serializer.toJson<String?>(category),
      'priority': serializer.toJson<int>(priority),
      'isSnoozed': serializer.toJson<bool>(isSnoozed),
      'snoozedUntil': serializer.toJson<DateTime?>(snoozedUntil),
      'source': serializer.toJson<String?>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TimeBlock copyWith({
    int? id,
    String? uuid,
    int? routineId,
    String? title,
    Value<String?> description = const Value.absent(),
    DateTime? startTime,
    DateTime? endTime,
    String? activityType,
    Value<String?> category = const Value.absent(),
    int? priority,
    bool? isSnoozed,
    Value<DateTime?> snoozedUntil = const Value.absent(),
    Value<String?> source = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TimeBlock(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    routineId: routineId ?? this.routineId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    activityType: activityType ?? this.activityType,
    category: category.present ? category.value : this.category,
    priority: priority ?? this.priority,
    isSnoozed: isSnoozed ?? this.isSnoozed,
    snoozedUntil: snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
    source: source.present ? source.value : this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TimeBlock copyWithCompanion(TimeBlocksCompanion data) {
    return TimeBlock(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      activityType: data.activityType.present
          ? data.activityType.value
          : this.activityType,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      isSnoozed: data.isSnoozed.present ? data.isSnoozed.value : this.isSnoozed,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeBlock(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('routineId: $routineId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('activityType: $activityType, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('isSnoozed: $isSnoozed, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    routineId,
    title,
    description,
    startTime,
    endTime,
    activityType,
    category,
    priority,
    isSnoozed,
    snoozedUntil,
    source,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeBlock &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.routineId == this.routineId &&
          other.title == this.title &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.activityType == this.activityType &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.isSnoozed == this.isSnoozed &&
          other.snoozedUntil == this.snoozedUntil &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TimeBlocksCompanion extends UpdateCompanion<TimeBlock> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> routineId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String> activityType;
  final Value<String?> category;
  final Value<int> priority;
  final Value<bool> isSnoozed;
  final Value<DateTime?> snoozedUntil;
  final Value<String?> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TimeBlocksCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.routineId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.activityType = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.isSnoozed = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TimeBlocksCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int routineId,
    required String title,
    this.description = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    required String activityType,
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.isSnoozed = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.source = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : uuid = Value(uuid),
       routineId = Value(routineId),
       title = Value(title),
       startTime = Value(startTime),
       endTime = Value(endTime),
       activityType = Value(activityType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TimeBlock> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? routineId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? activityType,
    Expression<String>? category,
    Expression<int>? priority,
    Expression<bool>? isSnoozed,
    Expression<DateTime>? snoozedUntil,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (routineId != null) 'routine_id': routineId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (activityType != null) 'activity_type': activityType,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (isSnoozed != null) 'is_snoozed': isSnoozed,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TimeBlocksCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? routineId,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<String>? activityType,
    Value<String?>? category,
    Value<int>? priority,
    Value<bool>? isSnoozed,
    Value<DateTime?>? snoozedUntil,
    Value<String?>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TimeBlocksCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      routineId: routineId ?? this.routineId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      activityType: activityType ?? this.activityType,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isSnoozed: isSnoozed ?? this.isSnoozed,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<int>(routineId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<String>(activityType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isSnoozed.present) {
      map['is_snoozed'] = Variable<bool>(isSnoozed.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeBlocksCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('routineId: $routineId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('activityType: $activityType, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('isSnoozed: $isSnoozed, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarCacheTable extends CalendarCache
    with TableInfo<$CalendarCacheTable, CalendarCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _calendarIdMeta = const VerificationMeta(
    'calendarId',
  );
  @override
  late final GeneratedColumn<String> calendarId = GeneratedColumn<String>(
    'calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calendarNameMeta = const VerificationMeta(
    'calendarName',
  );
  @override
  late final GeneratedColumn<String> calendarName = GeneratedColumn<String>(
    'calendar_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAllDayMeta = const VerificationMeta(
    'isAllDay',
  );
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
    'is_all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recurrenceRuleMeta = const VerificationMeta(
    'recurrenceRule',
  );
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
    'recurrence_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRecurringMeta = const VerificationMeta(
    'isRecurring',
  );
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
    'is_recurring',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSelectedMeta = const VerificationMeta(
    'isSelected',
  );
  @override
  late final GeneratedColumn<bool> isSelected = GeneratedColumn<bool>(
    'is_selected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_selected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isReadOnlyMeta = const VerificationMeta(
    'isReadOnly',
  );
  @override
  late final GeneratedColumn<bool> isReadOnly = GeneratedColumn<bool>(
    'is_read_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read_only" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF2196F3),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    calendarId,
    calendarName,
    title,
    description,
    location,
    startTime,
    endTime,
    isAllDay,
    recurrenceRule,
    isRecurring,
    isSelected,
    isPrimary,
    isReadOnly,
    sourceType,
    accountName,
    accountType,
    color,
    metadata,
    lastSyncedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('calendar_id')) {
      context.handle(
        _calendarIdMeta,
        calendarId.isAcceptableOrUnknown(data['calendar_id']!, _calendarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_calendarIdMeta);
    }
    if (data.containsKey('calendar_name')) {
      context.handle(
        _calendarNameMeta,
        calendarName.isAcceptableOrUnknown(
          data['calendar_name']!,
          _calendarNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calendarNameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('is_all_day')) {
      context.handle(
        _isAllDayMeta,
        isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta),
      );
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
        _recurrenceRuleMeta,
        recurrenceRule.isAcceptableOrUnknown(
          data['recurrence_rule']!,
          _recurrenceRuleMeta,
        ),
      );
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
        _isRecurringMeta,
        isRecurring.isAcceptableOrUnknown(
          data['is_recurring']!,
          _isRecurringMeta,
        ),
      );
    }
    if (data.containsKey('is_selected')) {
      context.handle(
        _isSelectedMeta,
        isSelected.isAcceptableOrUnknown(data['is_selected']!, _isSelectedMeta),
      );
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('is_read_only')) {
      context.handle(
        _isReadOnlyMeta,
        isReadOnly.isAcceptableOrUnknown(
          data['is_read_only']!,
          _isReadOnlyMeta,
        ),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      calendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_id'],
      )!,
      calendarName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_name'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      isAllDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_all_day'],
      )!,
      recurrenceRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_rule'],
      ),
      isRecurring: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring'],
      )!,
      isSelected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_selected'],
      )!,
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      isReadOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read_only'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      ),
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      ),
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CalendarCacheTable createAlias(String alias) {
    return $CalendarCacheTable(attachedDatabase, alias);
  }
}

class CalendarCacheData extends DataClass
    implements Insertable<CalendarCacheData> {
  final int id;
  final String eventId;
  final String calendarId;
  final String calendarName;
  final String title;
  final String? description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final String? recurrenceRule;
  final bool isRecurring;
  final bool isSelected;
  final bool isPrimary;
  final bool isReadOnly;
  final String? sourceType;
  final String? accountName;
  final String? accountType;
  final int color;
  final String? metadata;
  final DateTime lastSyncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CalendarCacheData({
    required this.id,
    required this.eventId,
    required this.calendarId,
    required this.calendarName,
    required this.title,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    this.recurrenceRule,
    required this.isRecurring,
    required this.isSelected,
    required this.isPrimary,
    required this.isReadOnly,
    this.sourceType,
    this.accountName,
    this.accountType,
    required this.color,
    this.metadata,
    required this.lastSyncedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<String>(eventId);
    map['calendar_id'] = Variable<String>(calendarId);
    map['calendar_name'] = Variable<String>(calendarName);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['is_all_day'] = Variable<bool>(isAllDay);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    map['is_selected'] = Variable<bool>(isSelected);
    map['is_primary'] = Variable<bool>(isPrimary);
    map['is_read_only'] = Variable<bool>(isReadOnly);
    if (!nullToAbsent || sourceType != null) {
      map['source_type'] = Variable<String>(sourceType);
    }
    if (!nullToAbsent || accountName != null) {
      map['account_name'] = Variable<String>(accountName);
    }
    if (!nullToAbsent || accountType != null) {
      map['account_type'] = Variable<String>(accountType);
    }
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CalendarCacheCompanion toCompanion(bool nullToAbsent) {
    return CalendarCacheCompanion(
      id: Value(id),
      eventId: Value(eventId),
      calendarId: Value(calendarId),
      calendarName: Value(calendarName),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      startTime: Value(startTime),
      endTime: Value(endTime),
      isAllDay: Value(isAllDay),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      isRecurring: Value(isRecurring),
      isSelected: Value(isSelected),
      isPrimary: Value(isPrimary),
      isReadOnly: Value(isReadOnly),
      sourceType: sourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceType),
      accountName: accountName == null && nullToAbsent
          ? const Value.absent()
          : Value(accountName),
      accountType: accountType == null && nullToAbsent
          ? const Value.absent()
          : Value(accountType),
      color: Value(color),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      lastSyncedAt: Value(lastSyncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CalendarCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarCacheData(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      calendarId: serializer.fromJson<String>(json['calendarId']),
      calendarName: serializer.fromJson<String>(json['calendarName']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      location: serializer.fromJson<String?>(json['location']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      isSelected: serializer.fromJson<bool>(json['isSelected']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      isReadOnly: serializer.fromJson<bool>(json['isReadOnly']),
      sourceType: serializer.fromJson<String?>(json['sourceType']),
      accountName: serializer.fromJson<String?>(json['accountName']),
      accountType: serializer.fromJson<String?>(json['accountType']),
      color: serializer.fromJson<int>(json['color']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<String>(eventId),
      'calendarId': serializer.toJson<String>(calendarId),
      'calendarName': serializer.toJson<String>(calendarName),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'location': serializer.toJson<String?>(location),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'isSelected': serializer.toJson<bool>(isSelected),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'isReadOnly': serializer.toJson<bool>(isReadOnly),
      'sourceType': serializer.toJson<String?>(sourceType),
      'accountName': serializer.toJson<String?>(accountName),
      'accountType': serializer.toJson<String?>(accountType),
      'color': serializer.toJson<int>(color),
      'metadata': serializer.toJson<String?>(metadata),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CalendarCacheData copyWith({
    int? id,
    String? eventId,
    String? calendarId,
    String? calendarName,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> location = const Value.absent(),
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    Value<String?> recurrenceRule = const Value.absent(),
    bool? isRecurring,
    bool? isSelected,
    bool? isPrimary,
    bool? isReadOnly,
    Value<String?> sourceType = const Value.absent(),
    Value<String?> accountName = const Value.absent(),
    Value<String?> accountType = const Value.absent(),
    int? color,
    Value<String?> metadata = const Value.absent(),
    DateTime? lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CalendarCacheData(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    calendarId: calendarId ?? this.calendarId,
    calendarName: calendarName ?? this.calendarName,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    location: location.present ? location.value : this.location,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    isAllDay: isAllDay ?? this.isAllDay,
    recurrenceRule: recurrenceRule.present
        ? recurrenceRule.value
        : this.recurrenceRule,
    isRecurring: isRecurring ?? this.isRecurring,
    isSelected: isSelected ?? this.isSelected,
    isPrimary: isPrimary ?? this.isPrimary,
    isReadOnly: isReadOnly ?? this.isReadOnly,
    sourceType: sourceType.present ? sourceType.value : this.sourceType,
    accountName: accountName.present ? accountName.value : this.accountName,
    accountType: accountType.present ? accountType.value : this.accountType,
    color: color ?? this.color,
    metadata: metadata.present ? metadata.value : this.metadata,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CalendarCacheData copyWithCompanion(CalendarCacheCompanion data) {
    return CalendarCacheData(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      calendarId: data.calendarId.present
          ? data.calendarId.value
          : this.calendarId,
      calendarName: data.calendarName.present
          ? data.calendarName.value
          : this.calendarName,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      location: data.location.present ? data.location.value : this.location,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      isAllDay: data.isAllDay.present ? data.isAllDay.value : this.isAllDay,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      isRecurring: data.isRecurring.present
          ? data.isRecurring.value
          : this.isRecurring,
      isSelected: data.isSelected.present
          ? data.isSelected.value
          : this.isSelected,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      isReadOnly: data.isReadOnly.present
          ? data.isReadOnly.value
          : this.isReadOnly,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      accountName: data.accountName.present
          ? data.accountName.value
          : this.accountName,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      color: data.color.present ? data.color.value : this.color,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarCacheData(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('calendarId: $calendarId, ')
          ..write('calendarName: $calendarName, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('isSelected: $isSelected, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('isReadOnly: $isReadOnly, ')
          ..write('sourceType: $sourceType, ')
          ..write('accountName: $accountName, ')
          ..write('accountType: $accountType, ')
          ..write('color: $color, ')
          ..write('metadata: $metadata, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    eventId,
    calendarId,
    calendarName,
    title,
    description,
    location,
    startTime,
    endTime,
    isAllDay,
    recurrenceRule,
    isRecurring,
    isSelected,
    isPrimary,
    isReadOnly,
    sourceType,
    accountName,
    accountType,
    color,
    metadata,
    lastSyncedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarCacheData &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.calendarId == this.calendarId &&
          other.calendarName == this.calendarName &&
          other.title == this.title &&
          other.description == this.description &&
          other.location == this.location &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.isAllDay == this.isAllDay &&
          other.recurrenceRule == this.recurrenceRule &&
          other.isRecurring == this.isRecurring &&
          other.isSelected == this.isSelected &&
          other.isPrimary == this.isPrimary &&
          other.isReadOnly == this.isReadOnly &&
          other.sourceType == this.sourceType &&
          other.accountName == this.accountName &&
          other.accountType == this.accountType &&
          other.color == this.color &&
          other.metadata == this.metadata &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CalendarCacheCompanion extends UpdateCompanion<CalendarCacheData> {
  final Value<int> id;
  final Value<String> eventId;
  final Value<String> calendarId;
  final Value<String> calendarName;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> location;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<bool> isAllDay;
  final Value<String?> recurrenceRule;
  final Value<bool> isRecurring;
  final Value<bool> isSelected;
  final Value<bool> isPrimary;
  final Value<bool> isReadOnly;
  final Value<String?> sourceType;
  final Value<String?> accountName;
  final Value<String?> accountType;
  final Value<int> color;
  final Value<String?> metadata;
  final Value<DateTime> lastSyncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CalendarCacheCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.calendarId = const Value.absent(),
    this.calendarName = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.isReadOnly = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.accountName = const Value.absent(),
    this.accountType = const Value.absent(),
    this.color = const Value.absent(),
    this.metadata = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CalendarCacheCompanion.insert({
    this.id = const Value.absent(),
    required String eventId,
    required String calendarId,
    required String calendarName,
    required String title,
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    this.isAllDay = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.isReadOnly = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.accountName = const Value.absent(),
    this.accountType = const Value.absent(),
    this.color = const Value.absent(),
    this.metadata = const Value.absent(),
    required DateTime lastSyncedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : eventId = Value(eventId),
       calendarId = Value(calendarId),
       calendarName = Value(calendarName),
       title = Value(title),
       startTime = Value(startTime),
       endTime = Value(endTime),
       lastSyncedAt = Value(lastSyncedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CalendarCacheData> custom({
    Expression<int>? id,
    Expression<String>? eventId,
    Expression<String>? calendarId,
    Expression<String>? calendarName,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? location,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<bool>? isAllDay,
    Expression<String>? recurrenceRule,
    Expression<bool>? isRecurring,
    Expression<bool>? isSelected,
    Expression<bool>? isPrimary,
    Expression<bool>? isReadOnly,
    Expression<String>? sourceType,
    Expression<String>? accountName,
    Expression<String>? accountType,
    Expression<int>? color,
    Expression<String>? metadata,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (calendarId != null) 'calendar_id': calendarId,
      if (calendarName != null) 'calendar_name': calendarName,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (isSelected != null) 'is_selected': isSelected,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (isReadOnly != null) 'is_read_only': isReadOnly,
      if (sourceType != null) 'source_type': sourceType,
      if (accountName != null) 'account_name': accountName,
      if (accountType != null) 'account_type': accountType,
      if (color != null) 'color': color,
      if (metadata != null) 'metadata': metadata,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CalendarCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? eventId,
    Value<String>? calendarId,
    Value<String>? calendarName,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? location,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<bool>? isAllDay,
    Value<String?>? recurrenceRule,
    Value<bool>? isRecurring,
    Value<bool>? isSelected,
    Value<bool>? isPrimary,
    Value<bool>? isReadOnly,
    Value<String?>? sourceType,
    Value<String?>? accountName,
    Value<String?>? accountType,
    Value<int>? color,
    Value<String?>? metadata,
    Value<DateTime>? lastSyncedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CalendarCacheCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      calendarId: calendarId ?? this.calendarId,
      calendarName: calendarName ?? this.calendarName,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      isRecurring: isRecurring ?? this.isRecurring,
      isSelected: isSelected ?? this.isSelected,
      isPrimary: isPrimary ?? this.isPrimary,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      sourceType: sourceType ?? this.sourceType,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      color: color ?? this.color,
      metadata: metadata ?? this.metadata,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (calendarId.present) {
      map['calendar_id'] = Variable<String>(calendarId.value);
    }
    if (calendarName.present) {
      map['calendar_name'] = Variable<String>(calendarName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (isSelected.present) {
      map['is_selected'] = Variable<bool>(isSelected.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (isReadOnly.present) {
      map['is_read_only'] = Variable<bool>(isReadOnly.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarCacheCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('calendarId: $calendarId, ')
          ..write('calendarName: $calendarName, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('isSelected: $isSelected, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('isReadOnly: $isReadOnly, ')
          ..write('sourceType: $sourceType, ')
          ..write('accountName: $accountName, ')
          ..write('accountType: $accountType, ')
          ..write('color: $color, ')
          ..write('metadata: $metadata, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WeatherCacheTable extends WeatherCache
    with TableInfo<$WeatherCacheTable, WeatherCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _forecastDateMeta = const VerificationMeta(
    'forecastDate',
  );
  @override
  late final GeneratedColumn<DateTime> forecastDate = GeneratedColumn<DateTime>(
    'forecast_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _forecastTimeMeta = const VerificationMeta(
    'forecastTime',
  );
  @override
  late final GeneratedColumn<DateTime> forecastTime = GeneratedColumn<DateTime>(
    'forecast_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureCelsiusMeta =
      const VerificationMeta('temperatureCelsius');
  @override
  late final GeneratedColumn<double> temperatureCelsius =
      GeneratedColumn<double>(
        'temperature_celsius',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _feelsLikeCelsiusMeta = const VerificationMeta(
    'feelsLikeCelsius',
  );
  @override
  late final GeneratedColumn<double> feelsLikeCelsius = GeneratedColumn<double>(
    'feels_like_celsius',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _humidityMeta = const VerificationMeta(
    'humidity',
  );
  @override
  late final GeneratedColumn<int> humidity = GeneratedColumn<int>(
    'humidity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windSpeedKmhMeta = const VerificationMeta(
    'windSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> windSpeedKmh = GeneratedColumn<double>(
    'wind_speed_kmh',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windDirectionMeta = const VerificationMeta(
    'windDirection',
  );
  @override
  late final GeneratedColumn<String> windDirection = GeneratedColumn<String>(
    'wind_direction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precipitationChanceMeta =
      const VerificationMeta('precipitationChance');
  @override
  late final GeneratedColumn<int> precipitationChance = GeneratedColumn<int>(
    'precipitation_chance',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precipitationMmMeta = const VerificationMeta(
    'precipitationMm',
  );
  @override
  late final GeneratedColumn<double> precipitationMm = GeneratedColumn<double>(
    'precipitation_mm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uvIndexMeta = const VerificationMeta(
    'uvIndex',
  );
  @override
  late final GeneratedColumn<int> uvIndex = GeneratedColumn<int>(
    'uv_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    source,
    latitude,
    longitude,
    forecastDate,
    forecastTime,
    condition,
    temperatureCelsius,
    feelsLikeCelsius,
    humidity,
    windSpeedKmh,
    windDirection,
    precipitationChance,
    precipitationMm,
    uvIndex,
    rawJson,
    fetchedAt,
    expiresAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeatherCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('forecast_date')) {
      context.handle(
        _forecastDateMeta,
        forecastDate.isAcceptableOrUnknown(
          data['forecast_date']!,
          _forecastDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_forecastDateMeta);
    }
    if (data.containsKey('forecast_time')) {
      context.handle(
        _forecastTimeMeta,
        forecastTime.isAcceptableOrUnknown(
          data['forecast_time']!,
          _forecastTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_forecastTimeMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    } else if (isInserting) {
      context.missing(_conditionMeta);
    }
    if (data.containsKey('temperature_celsius')) {
      context.handle(
        _temperatureCelsiusMeta,
        temperatureCelsius.isAcceptableOrUnknown(
          data['temperature_celsius']!,
          _temperatureCelsiusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureCelsiusMeta);
    }
    if (data.containsKey('feels_like_celsius')) {
      context.handle(
        _feelsLikeCelsiusMeta,
        feelsLikeCelsius.isAcceptableOrUnknown(
          data['feels_like_celsius']!,
          _feelsLikeCelsiusMeta,
        ),
      );
    }
    if (data.containsKey('humidity')) {
      context.handle(
        _humidityMeta,
        humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta),
      );
    }
    if (data.containsKey('wind_speed_kmh')) {
      context.handle(
        _windSpeedKmhMeta,
        windSpeedKmh.isAcceptableOrUnknown(
          data['wind_speed_kmh']!,
          _windSpeedKmhMeta,
        ),
      );
    }
    if (data.containsKey('wind_direction')) {
      context.handle(
        _windDirectionMeta,
        windDirection.isAcceptableOrUnknown(
          data['wind_direction']!,
          _windDirectionMeta,
        ),
      );
    }
    if (data.containsKey('precipitation_chance')) {
      context.handle(
        _precipitationChanceMeta,
        precipitationChance.isAcceptableOrUnknown(
          data['precipitation_chance']!,
          _precipitationChanceMeta,
        ),
      );
    }
    if (data.containsKey('precipitation_mm')) {
      context.handle(
        _precipitationMmMeta,
        precipitationMm.isAcceptableOrUnknown(
          data['precipitation_mm']!,
          _precipitationMmMeta,
        ),
      );
    }
    if (data.containsKey('uv_index')) {
      context.handle(
        _uvIndexMeta,
        uvIndex.isAcceptableOrUnknown(data['uv_index']!, _uvIndexMeta),
      );
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeatherCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      forecastDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}forecast_date'],
      )!,
      forecastTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}forecast_time'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      temperatureCelsius: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature_celsius'],
      )!,
      feelsLikeCelsius: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}feels_like_celsius'],
      ),
      humidity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}humidity'],
      ),
      windSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}wind_speed_kmh'],
      ),
      windDirection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wind_direction'],
      ),
      precipitationChance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}precipitation_chance'],
      ),
      precipitationMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precipitation_mm'],
      ),
      uvIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uv_index'],
      ),
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeatherCacheTable createAlias(String alias) {
    return $WeatherCacheTable(attachedDatabase, alias);
  }
}

class WeatherCacheData extends DataClass
    implements Insertable<WeatherCacheData> {
  final int id;
  final String uuid;
  final String source;
  final double latitude;
  final double longitude;
  final DateTime forecastDate;
  final DateTime forecastTime;
  final String condition;
  final double temperatureCelsius;
  final double? feelsLikeCelsius;
  final int? humidity;
  final double? windSpeedKmh;
  final String? windDirection;
  final int? precipitationChance;
  final double? precipitationMm;
  final int? uvIndex;
  final String rawJson;
  final DateTime fetchedAt;
  final DateTime expiresAt;
  final DateTime createdAt;
  const WeatherCacheData({
    required this.id,
    required this.uuid,
    required this.source,
    required this.latitude,
    required this.longitude,
    required this.forecastDate,
    required this.forecastTime,
    required this.condition,
    required this.temperatureCelsius,
    this.feelsLikeCelsius,
    this.humidity,
    this.windSpeedKmh,
    this.windDirection,
    this.precipitationChance,
    this.precipitationMm,
    this.uvIndex,
    required this.rawJson,
    required this.fetchedAt,
    required this.expiresAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['source'] = Variable<String>(source);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['forecast_date'] = Variable<DateTime>(forecastDate);
    map['forecast_time'] = Variable<DateTime>(forecastTime);
    map['condition'] = Variable<String>(condition);
    map['temperature_celsius'] = Variable<double>(temperatureCelsius);
    if (!nullToAbsent || feelsLikeCelsius != null) {
      map['feels_like_celsius'] = Variable<double>(feelsLikeCelsius);
    }
    if (!nullToAbsent || humidity != null) {
      map['humidity'] = Variable<int>(humidity);
    }
    if (!nullToAbsent || windSpeedKmh != null) {
      map['wind_speed_kmh'] = Variable<double>(windSpeedKmh);
    }
    if (!nullToAbsent || windDirection != null) {
      map['wind_direction'] = Variable<String>(windDirection);
    }
    if (!nullToAbsent || precipitationChance != null) {
      map['precipitation_chance'] = Variable<int>(precipitationChance);
    }
    if (!nullToAbsent || precipitationMm != null) {
      map['precipitation_mm'] = Variable<double>(precipitationMm);
    }
    if (!nullToAbsent || uvIndex != null) {
      map['uv_index'] = Variable<int>(uvIndex);
    }
    map['raw_json'] = Variable<String>(rawJson);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WeatherCacheCompanion toCompanion(bool nullToAbsent) {
    return WeatherCacheCompanion(
      id: Value(id),
      uuid: Value(uuid),
      source: Value(source),
      latitude: Value(latitude),
      longitude: Value(longitude),
      forecastDate: Value(forecastDate),
      forecastTime: Value(forecastTime),
      condition: Value(condition),
      temperatureCelsius: Value(temperatureCelsius),
      feelsLikeCelsius: feelsLikeCelsius == null && nullToAbsent
          ? const Value.absent()
          : Value(feelsLikeCelsius),
      humidity: humidity == null && nullToAbsent
          ? const Value.absent()
          : Value(humidity),
      windSpeedKmh: windSpeedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(windSpeedKmh),
      windDirection: windDirection == null && nullToAbsent
          ? const Value.absent()
          : Value(windDirection),
      precipitationChance: precipitationChance == null && nullToAbsent
          ? const Value.absent()
          : Value(precipitationChance),
      precipitationMm: precipitationMm == null && nullToAbsent
          ? const Value.absent()
          : Value(precipitationMm),
      uvIndex: uvIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(uvIndex),
      rawJson: Value(rawJson),
      fetchedAt: Value(fetchedAt),
      expiresAt: Value(expiresAt),
      createdAt: Value(createdAt),
    );
  }

  factory WeatherCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherCacheData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      source: serializer.fromJson<String>(json['source']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      forecastDate: serializer.fromJson<DateTime>(json['forecastDate']),
      forecastTime: serializer.fromJson<DateTime>(json['forecastTime']),
      condition: serializer.fromJson<String>(json['condition']),
      temperatureCelsius: serializer.fromJson<double>(
        json['temperatureCelsius'],
      ),
      feelsLikeCelsius: serializer.fromJson<double?>(json['feelsLikeCelsius']),
      humidity: serializer.fromJson<int?>(json['humidity']),
      windSpeedKmh: serializer.fromJson<double?>(json['windSpeedKmh']),
      windDirection: serializer.fromJson<String?>(json['windDirection']),
      precipitationChance: serializer.fromJson<int?>(
        json['precipitationChance'],
      ),
      precipitationMm: serializer.fromJson<double?>(json['precipitationMm']),
      uvIndex: serializer.fromJson<int?>(json['uvIndex']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'source': serializer.toJson<String>(source),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'forecastDate': serializer.toJson<DateTime>(forecastDate),
      'forecastTime': serializer.toJson<DateTime>(forecastTime),
      'condition': serializer.toJson<String>(condition),
      'temperatureCelsius': serializer.toJson<double>(temperatureCelsius),
      'feelsLikeCelsius': serializer.toJson<double?>(feelsLikeCelsius),
      'humidity': serializer.toJson<int?>(humidity),
      'windSpeedKmh': serializer.toJson<double?>(windSpeedKmh),
      'windDirection': serializer.toJson<String?>(windDirection),
      'precipitationChance': serializer.toJson<int?>(precipitationChance),
      'precipitationMm': serializer.toJson<double?>(precipitationMm),
      'uvIndex': serializer.toJson<int?>(uvIndex),
      'rawJson': serializer.toJson<String>(rawJson),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WeatherCacheData copyWith({
    int? id,
    String? uuid,
    String? source,
    double? latitude,
    double? longitude,
    DateTime? forecastDate,
    DateTime? forecastTime,
    String? condition,
    double? temperatureCelsius,
    Value<double?> feelsLikeCelsius = const Value.absent(),
    Value<int?> humidity = const Value.absent(),
    Value<double?> windSpeedKmh = const Value.absent(),
    Value<String?> windDirection = const Value.absent(),
    Value<int?> precipitationChance = const Value.absent(),
    Value<double?> precipitationMm = const Value.absent(),
    Value<int?> uvIndex = const Value.absent(),
    String? rawJson,
    DateTime? fetchedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) => WeatherCacheData(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    source: source ?? this.source,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    forecastDate: forecastDate ?? this.forecastDate,
    forecastTime: forecastTime ?? this.forecastTime,
    condition: condition ?? this.condition,
    temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
    feelsLikeCelsius: feelsLikeCelsius.present
        ? feelsLikeCelsius.value
        : this.feelsLikeCelsius,
    humidity: humidity.present ? humidity.value : this.humidity,
    windSpeedKmh: windSpeedKmh.present ? windSpeedKmh.value : this.windSpeedKmh,
    windDirection: windDirection.present
        ? windDirection.value
        : this.windDirection,
    precipitationChance: precipitationChance.present
        ? precipitationChance.value
        : this.precipitationChance,
    precipitationMm: precipitationMm.present
        ? precipitationMm.value
        : this.precipitationMm,
    uvIndex: uvIndex.present ? uvIndex.value : this.uvIndex,
    rawJson: rawJson ?? this.rawJson,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    expiresAt: expiresAt ?? this.expiresAt,
    createdAt: createdAt ?? this.createdAt,
  );
  WeatherCacheData copyWithCompanion(WeatherCacheCompanion data) {
    return WeatherCacheData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      source: data.source.present ? data.source.value : this.source,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      forecastDate: data.forecastDate.present
          ? data.forecastDate.value
          : this.forecastDate,
      forecastTime: data.forecastTime.present
          ? data.forecastTime.value
          : this.forecastTime,
      condition: data.condition.present ? data.condition.value : this.condition,
      temperatureCelsius: data.temperatureCelsius.present
          ? data.temperatureCelsius.value
          : this.temperatureCelsius,
      feelsLikeCelsius: data.feelsLikeCelsius.present
          ? data.feelsLikeCelsius.value
          : this.feelsLikeCelsius,
      humidity: data.humidity.present ? data.humidity.value : this.humidity,
      windSpeedKmh: data.windSpeedKmh.present
          ? data.windSpeedKmh.value
          : this.windSpeedKmh,
      windDirection: data.windDirection.present
          ? data.windDirection.value
          : this.windDirection,
      precipitationChance: data.precipitationChance.present
          ? data.precipitationChance.value
          : this.precipitationChance,
      precipitationMm: data.precipitationMm.present
          ? data.precipitationMm.value
          : this.precipitationMm,
      uvIndex: data.uvIndex.present ? data.uvIndex.value : this.uvIndex,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherCacheData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('source: $source, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('forecastDate: $forecastDate, ')
          ..write('forecastTime: $forecastTime, ')
          ..write('condition: $condition, ')
          ..write('temperatureCelsius: $temperatureCelsius, ')
          ..write('feelsLikeCelsius: $feelsLikeCelsius, ')
          ..write('humidity: $humidity, ')
          ..write('windSpeedKmh: $windSpeedKmh, ')
          ..write('windDirection: $windDirection, ')
          ..write('precipitationChance: $precipitationChance, ')
          ..write('precipitationMm: $precipitationMm, ')
          ..write('uvIndex: $uvIndex, ')
          ..write('rawJson: $rawJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    source,
    latitude,
    longitude,
    forecastDate,
    forecastTime,
    condition,
    temperatureCelsius,
    feelsLikeCelsius,
    humidity,
    windSpeedKmh,
    windDirection,
    precipitationChance,
    precipitationMm,
    uvIndex,
    rawJson,
    fetchedAt,
    expiresAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherCacheData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.source == this.source &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.forecastDate == this.forecastDate &&
          other.forecastTime == this.forecastTime &&
          other.condition == this.condition &&
          other.temperatureCelsius == this.temperatureCelsius &&
          other.feelsLikeCelsius == this.feelsLikeCelsius &&
          other.humidity == this.humidity &&
          other.windSpeedKmh == this.windSpeedKmh &&
          other.windDirection == this.windDirection &&
          other.precipitationChance == this.precipitationChance &&
          other.precipitationMm == this.precipitationMm &&
          other.uvIndex == this.uvIndex &&
          other.rawJson == this.rawJson &&
          other.fetchedAt == this.fetchedAt &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt);
}

class WeatherCacheCompanion extends UpdateCompanion<WeatherCacheData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> source;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> forecastDate;
  final Value<DateTime> forecastTime;
  final Value<String> condition;
  final Value<double> temperatureCelsius;
  final Value<double?> feelsLikeCelsius;
  final Value<int?> humidity;
  final Value<double?> windSpeedKmh;
  final Value<String?> windDirection;
  final Value<int?> precipitationChance;
  final Value<double?> precipitationMm;
  final Value<int?> uvIndex;
  final Value<String> rawJson;
  final Value<DateTime> fetchedAt;
  final Value<DateTime> expiresAt;
  final Value<DateTime> createdAt;
  const WeatherCacheCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.source = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.forecastDate = const Value.absent(),
    this.forecastTime = const Value.absent(),
    this.condition = const Value.absent(),
    this.temperatureCelsius = const Value.absent(),
    this.feelsLikeCelsius = const Value.absent(),
    this.humidity = const Value.absent(),
    this.windSpeedKmh = const Value.absent(),
    this.windDirection = const Value.absent(),
    this.precipitationChance = const Value.absent(),
    this.precipitationMm = const Value.absent(),
    this.uvIndex = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WeatherCacheCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String source,
    required double latitude,
    required double longitude,
    required DateTime forecastDate,
    required DateTime forecastTime,
    required String condition,
    required double temperatureCelsius,
    this.feelsLikeCelsius = const Value.absent(),
    this.humidity = const Value.absent(),
    this.windSpeedKmh = const Value.absent(),
    this.windDirection = const Value.absent(),
    this.precipitationChance = const Value.absent(),
    this.precipitationMm = const Value.absent(),
    this.uvIndex = const Value.absent(),
    required String rawJson,
    required DateTime fetchedAt,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) : uuid = Value(uuid),
       source = Value(source),
       latitude = Value(latitude),
       longitude = Value(longitude),
       forecastDate = Value(forecastDate),
       forecastTime = Value(forecastTime),
       condition = Value(condition),
       temperatureCelsius = Value(temperatureCelsius),
       rawJson = Value(rawJson),
       fetchedAt = Value(fetchedAt),
       expiresAt = Value(expiresAt),
       createdAt = Value(createdAt);
  static Insertable<WeatherCacheData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? source,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? forecastDate,
    Expression<DateTime>? forecastTime,
    Expression<String>? condition,
    Expression<double>? temperatureCelsius,
    Expression<double>? feelsLikeCelsius,
    Expression<int>? humidity,
    Expression<double>? windSpeedKmh,
    Expression<String>? windDirection,
    Expression<int>? precipitationChance,
    Expression<double>? precipitationMm,
    Expression<int>? uvIndex,
    Expression<String>? rawJson,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (source != null) 'source': source,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (forecastDate != null) 'forecast_date': forecastDate,
      if (forecastTime != null) 'forecast_time': forecastTime,
      if (condition != null) 'condition': condition,
      if (temperatureCelsius != null) 'temperature_celsius': temperatureCelsius,
      if (feelsLikeCelsius != null) 'feels_like_celsius': feelsLikeCelsius,
      if (humidity != null) 'humidity': humidity,
      if (windSpeedKmh != null) 'wind_speed_kmh': windSpeedKmh,
      if (windDirection != null) 'wind_direction': windDirection,
      if (precipitationChance != null)
        'precipitation_chance': precipitationChance,
      if (precipitationMm != null) 'precipitation_mm': precipitationMm,
      if (uvIndex != null) 'uv_index': uvIndex,
      if (rawJson != null) 'raw_json': rawJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WeatherCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? source,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime>? forecastDate,
    Value<DateTime>? forecastTime,
    Value<String>? condition,
    Value<double>? temperatureCelsius,
    Value<double?>? feelsLikeCelsius,
    Value<int?>? humidity,
    Value<double?>? windSpeedKmh,
    Value<String?>? windDirection,
    Value<int?>? precipitationChance,
    Value<double?>? precipitationMm,
    Value<int?>? uvIndex,
    Value<String>? rawJson,
    Value<DateTime>? fetchedAt,
    Value<DateTime>? expiresAt,
    Value<DateTime>? createdAt,
  }) {
    return WeatherCacheCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      source: source ?? this.source,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      forecastDate: forecastDate ?? this.forecastDate,
      forecastTime: forecastTime ?? this.forecastTime,
      condition: condition ?? this.condition,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      feelsLikeCelsius: feelsLikeCelsius ?? this.feelsLikeCelsius,
      humidity: humidity ?? this.humidity,
      windSpeedKmh: windSpeedKmh ?? this.windSpeedKmh,
      windDirection: windDirection ?? this.windDirection,
      precipitationChance: precipitationChance ?? this.precipitationChance,
      precipitationMm: precipitationMm ?? this.precipitationMm,
      uvIndex: uvIndex ?? this.uvIndex,
      rawJson: rawJson ?? this.rawJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (forecastDate.present) {
      map['forecast_date'] = Variable<DateTime>(forecastDate.value);
    }
    if (forecastTime.present) {
      map['forecast_time'] = Variable<DateTime>(forecastTime.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (temperatureCelsius.present) {
      map['temperature_celsius'] = Variable<double>(temperatureCelsius.value);
    }
    if (feelsLikeCelsius.present) {
      map['feels_like_celsius'] = Variable<double>(feelsLikeCelsius.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<int>(humidity.value);
    }
    if (windSpeedKmh.present) {
      map['wind_speed_kmh'] = Variable<double>(windSpeedKmh.value);
    }
    if (windDirection.present) {
      map['wind_direction'] = Variable<String>(windDirection.value);
    }
    if (precipitationChance.present) {
      map['precipitation_chance'] = Variable<int>(precipitationChance.value);
    }
    if (precipitationMm.present) {
      map['precipitation_mm'] = Variable<double>(precipitationMm.value);
    }
    if (uvIndex.present) {
      map['uv_index'] = Variable<int>(uvIndex.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherCacheCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('source: $source, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('forecastDate: $forecastDate, ')
          ..write('forecastTime: $forecastTime, ')
          ..write('condition: $condition, ')
          ..write('temperatureCelsius: $temperatureCelsius, ')
          ..write('feelsLikeCelsius: $feelsLikeCelsius, ')
          ..write('humidity: $humidity, ')
          ..write('windSpeedKmh: $windSpeedKmh, ')
          ..write('windDirection: $windDirection, ')
          ..write('precipitationChance: $precipitationChance, ')
          ..write('precipitationMm: $precipitationMm, ')
          ..write('uvIndex: $uvIndex, ')
          ..write('rawJson: $rawJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    key,
    value,
    type,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  final int id;
  final String key;
  final String value;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserPreference({
    required this.id,
    required this.key,
    required this.value,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      type: Value(type),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreference copyWith({
    int? id,
    String? key,
    String? value,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserPreference(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreference(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, type, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserPreferencesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    required String type,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : key = Value(key),
       value = Value(value),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserPreference> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserPreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? value,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UserPreferencesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $TimeBlocksTable timeBlocks = $TimeBlocksTable(this);
  late final $CalendarCacheTable calendarCache = $CalendarCacheTable(this);
  late final $WeatherCacheTable weatherCache = $WeatherCacheTable(this);
  late final $UserPreferencesTable userPreferences = $UserPreferencesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    timeBlocks,
    calendarCache,
    weatherCache,
    userPreferences,
  ];
}

typedef $$RoutinesTableCreateCompanionBuilder =
    RoutinesCompanion Function({
      Value<int> id,
      required String uuid,
      required DateTime date,
      required String title,
      Value<String?> explanation,
      Value<double?> confidenceScore,
      Value<bool> isAccepted,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$RoutinesTableUpdateCompanionBuilder =
    RoutinesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<DateTime> date,
      Value<String> title,
      Value<String?> explanation,
      Value<double?> confidenceScore,
      Value<bool> isAccepted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, Routine> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TimeBlocksTable, List<TimeBlock>>
  _timeBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeBlocks,
    aliasName: $_aliasNameGenerator(db.routines.id, db.timeBlocks.routineId),
  );

  $$TimeBlocksTableProcessedTableManager get timeBlocksRefs {
    final manager = $$TimeBlocksTableTableManager(
      $_db,
      $_db.timeBlocks,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAccepted => $composableBuilder(
    column: $table.isAccepted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> timeBlocksRefs(
    Expression<bool> Function($$TimeBlocksTableFilterComposer f) f,
  ) {
    final $$TimeBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeBlocks,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeBlocksTableFilterComposer(
            $db: $db,
            $table: $db.timeBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAccepted => $composableBuilder(
    column: $table.isAccepted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidenceScore => $composableBuilder(
    column: $table.confidenceScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAccepted => $composableBuilder(
    column: $table.isAccepted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> timeBlocksRefs<T extends Object>(
    Expression<T> Function($$TimeBlocksTableAnnotationComposer a) f,
  ) {
    final $$TimeBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeBlocks,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.timeBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, $$RoutinesTableReferences),
          Routine,
          PrefetchHooks Function({bool timeBlocksRefs})
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<double?> confidenceScore = const Value.absent(),
                Value<bool> isAccepted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                uuid: uuid,
                date: date,
                title: title,
                explanation: explanation,
                confidenceScore: confidenceScore,
                isAccepted: isAccepted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required DateTime date,
                required String title,
                Value<String?> explanation = const Value.absent(),
                Value<double?> confidenceScore = const Value.absent(),
                Value<bool> isAccepted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => RoutinesCompanion.insert(
                id: id,
                uuid: uuid,
                date: date,
                title: title,
                explanation: explanation,
                confidenceScore: confidenceScore,
                isAccepted: isAccepted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({timeBlocksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (timeBlocksRefs) db.timeBlocks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (timeBlocksRefs)
                    await $_getPrefetchedData<
                      Routine,
                      $RoutinesTable,
                      TimeBlock
                    >(
                      currentTable: table,
                      referencedTable: $$RoutinesTableReferences
                          ._timeBlocksRefsTable(db),
                      managerFromTypedResult: (p0) => $$RoutinesTableReferences(
                        db,
                        table,
                        p0,
                      ).timeBlocksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.routineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, $$RoutinesTableReferences),
      Routine,
      PrefetchHooks Function({bool timeBlocksRefs})
    >;
typedef $$TimeBlocksTableCreateCompanionBuilder =
    TimeBlocksCompanion Function({
      Value<int> id,
      required String uuid,
      required int routineId,
      required String title,
      Value<String?> description,
      required DateTime startTime,
      required DateTime endTime,
      required String activityType,
      Value<String?> category,
      Value<int> priority,
      Value<bool> isSnoozed,
      Value<DateTime?> snoozedUntil,
      Value<String?> source,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$TimeBlocksTableUpdateCompanionBuilder =
    TimeBlocksCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> routineId,
      Value<String> title,
      Value<String?> description,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<String> activityType,
      Value<String?> category,
      Value<int> priority,
      Value<bool> isSnoozed,
      Value<DateTime?> snoozedUntil,
      Value<String?> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TimeBlocksTableReferences
    extends BaseReferences<_$AppDatabase, $TimeBlocksTable, TimeBlock> {
  $$TimeBlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias(
        $_aliasNameGenerator(db.timeBlocks.routineId, db.routines.id),
      );

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<int>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimeBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $TimeBlocksTable> {
  $$TimeBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSnoozed => $composableBuilder(
    column: $table.isSnoozed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeBlocksTable> {
  $$TimeBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSnoozed => $composableBuilder(
    column: $table.isSnoozed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeBlocksTable> {
  $$TimeBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isSnoozed =>
      $composableBuilder(column: $table.isSnoozed, builder: (column) => column);

  GeneratedColumn<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeBlocksTable,
          TimeBlock,
          $$TimeBlocksTableFilterComposer,
          $$TimeBlocksTableOrderingComposer,
          $$TimeBlocksTableAnnotationComposer,
          $$TimeBlocksTableCreateCompanionBuilder,
          $$TimeBlocksTableUpdateCompanionBuilder,
          (TimeBlock, $$TimeBlocksTableReferences),
          TimeBlock,
          PrefetchHooks Function({bool routineId})
        > {
  $$TimeBlocksTableTableManager(_$AppDatabase db, $TimeBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> routineId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<String> activityType = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isSnoozed = const Value.absent(),
                Value<DateTime?> snoozedUntil = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TimeBlocksCompanion(
                id: id,
                uuid: uuid,
                routineId: routineId,
                title: title,
                description: description,
                startTime: startTime,
                endTime: endTime,
                activityType: activityType,
                category: category,
                priority: priority,
                isSnoozed: isSnoozed,
                snoozedUntil: snoozedUntil,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int routineId,
                required String title,
                Value<String?> description = const Value.absent(),
                required DateTime startTime,
                required DateTime endTime,
                required String activityType,
                Value<String?> category = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isSnoozed = const Value.absent(),
                Value<DateTime?> snoozedUntil = const Value.absent(),
                Value<String?> source = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => TimeBlocksCompanion.insert(
                id: id,
                uuid: uuid,
                routineId: routineId,
                title: title,
                description: description,
                startTime: startTime,
                endTime: endTime,
                activityType: activityType,
                category: category,
                priority: priority,
                isSnoozed: isSnoozed,
                snoozedUntil: snoozedUntil,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.routineId,
                                referencedTable: $$TimeBlocksTableReferences
                                    ._routineIdTable(db),
                                referencedColumn: $$TimeBlocksTableReferences
                                    ._routineIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TimeBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeBlocksTable,
      TimeBlock,
      $$TimeBlocksTableFilterComposer,
      $$TimeBlocksTableOrderingComposer,
      $$TimeBlocksTableAnnotationComposer,
      $$TimeBlocksTableCreateCompanionBuilder,
      $$TimeBlocksTableUpdateCompanionBuilder,
      (TimeBlock, $$TimeBlocksTableReferences),
      TimeBlock,
      PrefetchHooks Function({bool routineId})
    >;
typedef $$CalendarCacheTableCreateCompanionBuilder =
    CalendarCacheCompanion Function({
      Value<int> id,
      required String eventId,
      required String calendarId,
      required String calendarName,
      required String title,
      Value<String?> description,
      Value<String?> location,
      required DateTime startTime,
      required DateTime endTime,
      Value<bool> isAllDay,
      Value<String?> recurrenceRule,
      Value<bool> isRecurring,
      Value<bool> isSelected,
      Value<bool> isPrimary,
      Value<bool> isReadOnly,
      Value<String?> sourceType,
      Value<String?> accountName,
      Value<String?> accountType,
      Value<int> color,
      Value<String?> metadata,
      required DateTime lastSyncedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$CalendarCacheTableUpdateCompanionBuilder =
    CalendarCacheCompanion Function({
      Value<int> id,
      Value<String> eventId,
      Value<String> calendarId,
      Value<String> calendarName,
      Value<String> title,
      Value<String?> description,
      Value<String?> location,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<bool> isAllDay,
      Value<String?> recurrenceRule,
      Value<bool> isRecurring,
      Value<bool> isSelected,
      Value<bool> isPrimary,
      Value<bool> isReadOnly,
      Value<String?> sourceType,
      Value<String?> accountName,
      Value<String?> accountType,
      Value<int> color,
      Value<String?> metadata,
      Value<DateTime> lastSyncedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$CalendarCacheTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarCacheTable> {
  $$CalendarCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarName => $composableBuilder(
    column: $table.calendarName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReadOnly => $composableBuilder(
    column: $table.isReadOnly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarCacheTable> {
  $$CalendarCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarName => $composableBuilder(
    column: $table.calendarName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReadOnly => $composableBuilder(
    column: $table.isReadOnly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarCacheTable> {
  $$CalendarCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calendarName => $composableBuilder(
    column: $table.calendarName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<bool> get isAllDay =>
      $composableBuilder(column: $table.isAllDay, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<bool> get isReadOnly => $composableBuilder(
    column: $table.isReadOnly,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CalendarCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarCacheTable,
          CalendarCacheData,
          $$CalendarCacheTableFilterComposer,
          $$CalendarCacheTableOrderingComposer,
          $$CalendarCacheTableAnnotationComposer,
          $$CalendarCacheTableCreateCompanionBuilder,
          $$CalendarCacheTableUpdateCompanionBuilder,
          (
            CalendarCacheData,
            BaseReferences<
              _$AppDatabase,
              $CalendarCacheTable,
              CalendarCacheData
            >,
          ),
          CalendarCacheData,
          PrefetchHooks Function()
        > {
  $$CalendarCacheTableTableManager(_$AppDatabase db, $CalendarCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> calendarId = const Value.absent(),
                Value<String> calendarName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<bool> isReadOnly = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String?> accountName = const Value.absent(),
                Value<String?> accountType = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> lastSyncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CalendarCacheCompanion(
                id: id,
                eventId: eventId,
                calendarId: calendarId,
                calendarName: calendarName,
                title: title,
                description: description,
                location: location,
                startTime: startTime,
                endTime: endTime,
                isAllDay: isAllDay,
                recurrenceRule: recurrenceRule,
                isRecurring: isRecurring,
                isSelected: isSelected,
                isPrimary: isPrimary,
                isReadOnly: isReadOnly,
                sourceType: sourceType,
                accountName: accountName,
                accountType: accountType,
                color: color,
                metadata: metadata,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventId,
                required String calendarId,
                required String calendarName,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> location = const Value.absent(),
                required DateTime startTime,
                required DateTime endTime,
                Value<bool> isAllDay = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<bool> isReadOnly = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String?> accountName = const Value.absent(),
                Value<String?> accountType = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                required DateTime lastSyncedAt,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => CalendarCacheCompanion.insert(
                id: id,
                eventId: eventId,
                calendarId: calendarId,
                calendarName: calendarName,
                title: title,
                description: description,
                location: location,
                startTime: startTime,
                endTime: endTime,
                isAllDay: isAllDay,
                recurrenceRule: recurrenceRule,
                isRecurring: isRecurring,
                isSelected: isSelected,
                isPrimary: isPrimary,
                isReadOnly: isReadOnly,
                sourceType: sourceType,
                accountName: accountName,
                accountType: accountType,
                color: color,
                metadata: metadata,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarCacheTable,
      CalendarCacheData,
      $$CalendarCacheTableFilterComposer,
      $$CalendarCacheTableOrderingComposer,
      $$CalendarCacheTableAnnotationComposer,
      $$CalendarCacheTableCreateCompanionBuilder,
      $$CalendarCacheTableUpdateCompanionBuilder,
      (
        CalendarCacheData,
        BaseReferences<_$AppDatabase, $CalendarCacheTable, CalendarCacheData>,
      ),
      CalendarCacheData,
      PrefetchHooks Function()
    >;
typedef $$WeatherCacheTableCreateCompanionBuilder =
    WeatherCacheCompanion Function({
      Value<int> id,
      required String uuid,
      required String source,
      required double latitude,
      required double longitude,
      required DateTime forecastDate,
      required DateTime forecastTime,
      required String condition,
      required double temperatureCelsius,
      Value<double?> feelsLikeCelsius,
      Value<int?> humidity,
      Value<double?> windSpeedKmh,
      Value<String?> windDirection,
      Value<int?> precipitationChance,
      Value<double?> precipitationMm,
      Value<int?> uvIndex,
      required String rawJson,
      required DateTime fetchedAt,
      required DateTime expiresAt,
      required DateTime createdAt,
    });
typedef $$WeatherCacheTableUpdateCompanionBuilder =
    WeatherCacheCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> source,
      Value<double> latitude,
      Value<double> longitude,
      Value<DateTime> forecastDate,
      Value<DateTime> forecastTime,
      Value<String> condition,
      Value<double> temperatureCelsius,
      Value<double?> feelsLikeCelsius,
      Value<int?> humidity,
      Value<double?> windSpeedKmh,
      Value<String?> windDirection,
      Value<int?> precipitationChance,
      Value<double?> precipitationMm,
      Value<int?> uvIndex,
      Value<String> rawJson,
      Value<DateTime> fetchedAt,
      Value<DateTime> expiresAt,
      Value<DateTime> createdAt,
    });

class $$WeatherCacheTableFilterComposer
    extends Composer<_$AppDatabase, $WeatherCacheTable> {
  $$WeatherCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get forecastDate => $composableBuilder(
    column: $table.forecastDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get forecastTime => $composableBuilder(
    column: $table.forecastTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperatureCelsius => $composableBuilder(
    column: $table.temperatureCelsius,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get feelsLikeCelsius => $composableBuilder(
    column: $table.feelsLikeCelsius,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get humidity => $composableBuilder(
    column: $table.humidity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get windSpeedKmh => $composableBuilder(
    column: $table.windSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get precipitationChance => $composableBuilder(
    column: $table.precipitationChance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precipitationMm => $composableBuilder(
    column: $table.precipitationMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uvIndex => $composableBuilder(
    column: $table.uvIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeatherCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $WeatherCacheTable> {
  $$WeatherCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get forecastDate => $composableBuilder(
    column: $table.forecastDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get forecastTime => $composableBuilder(
    column: $table.forecastTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperatureCelsius => $composableBuilder(
    column: $table.temperatureCelsius,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get feelsLikeCelsius => $composableBuilder(
    column: $table.feelsLikeCelsius,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get humidity => $composableBuilder(
    column: $table.humidity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get windSpeedKmh => $composableBuilder(
    column: $table.windSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get precipitationChance => $composableBuilder(
    column: $table.precipitationChance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precipitationMm => $composableBuilder(
    column: $table.precipitationMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uvIndex => $composableBuilder(
    column: $table.uvIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeatherCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeatherCacheTable> {
  $$WeatherCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get forecastDate => $composableBuilder(
    column: $table.forecastDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get forecastTime => $composableBuilder(
    column: $table.forecastTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<double> get temperatureCelsius => $composableBuilder(
    column: $table.temperatureCelsius,
    builder: (column) => column,
  );

  GeneratedColumn<double> get feelsLikeCelsius => $composableBuilder(
    column: $table.feelsLikeCelsius,
    builder: (column) => column,
  );

  GeneratedColumn<int> get humidity =>
      $composableBuilder(column: $table.humidity, builder: (column) => column);

  GeneratedColumn<double> get windSpeedKmh => $composableBuilder(
    column: $table.windSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<String> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get precipitationChance => $composableBuilder(
    column: $table.precipitationChance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precipitationMm => $composableBuilder(
    column: $table.precipitationMm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get uvIndex =>
      $composableBuilder(column: $table.uvIndex, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WeatherCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeatherCacheTable,
          WeatherCacheData,
          $$WeatherCacheTableFilterComposer,
          $$WeatherCacheTableOrderingComposer,
          $$WeatherCacheTableAnnotationComposer,
          $$WeatherCacheTableCreateCompanionBuilder,
          $$WeatherCacheTableUpdateCompanionBuilder,
          (
            WeatherCacheData,
            BaseReferences<_$AppDatabase, $WeatherCacheTable, WeatherCacheData>,
          ),
          WeatherCacheData,
          PrefetchHooks Function()
        > {
  $$WeatherCacheTableTableManager(_$AppDatabase db, $WeatherCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime> forecastDate = const Value.absent(),
                Value<DateTime> forecastTime = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<double> temperatureCelsius = const Value.absent(),
                Value<double?> feelsLikeCelsius = const Value.absent(),
                Value<int?> humidity = const Value.absent(),
                Value<double?> windSpeedKmh = const Value.absent(),
                Value<String?> windDirection = const Value.absent(),
                Value<int?> precipitationChance = const Value.absent(),
                Value<double?> precipitationMm = const Value.absent(),
                Value<int?> uvIndex = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WeatherCacheCompanion(
                id: id,
                uuid: uuid,
                source: source,
                latitude: latitude,
                longitude: longitude,
                forecastDate: forecastDate,
                forecastTime: forecastTime,
                condition: condition,
                temperatureCelsius: temperatureCelsius,
                feelsLikeCelsius: feelsLikeCelsius,
                humidity: humidity,
                windSpeedKmh: windSpeedKmh,
                windDirection: windDirection,
                precipitationChance: precipitationChance,
                precipitationMm: precipitationMm,
                uvIndex: uvIndex,
                rawJson: rawJson,
                fetchedAt: fetchedAt,
                expiresAt: expiresAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String source,
                required double latitude,
                required double longitude,
                required DateTime forecastDate,
                required DateTime forecastTime,
                required String condition,
                required double temperatureCelsius,
                Value<double?> feelsLikeCelsius = const Value.absent(),
                Value<int?> humidity = const Value.absent(),
                Value<double?> windSpeedKmh = const Value.absent(),
                Value<String?> windDirection = const Value.absent(),
                Value<int?> precipitationChance = const Value.absent(),
                Value<double?> precipitationMm = const Value.absent(),
                Value<int?> uvIndex = const Value.absent(),
                required String rawJson,
                required DateTime fetchedAt,
                required DateTime expiresAt,
                required DateTime createdAt,
              }) => WeatherCacheCompanion.insert(
                id: id,
                uuid: uuid,
                source: source,
                latitude: latitude,
                longitude: longitude,
                forecastDate: forecastDate,
                forecastTime: forecastTime,
                condition: condition,
                temperatureCelsius: temperatureCelsius,
                feelsLikeCelsius: feelsLikeCelsius,
                humidity: humidity,
                windSpeedKmh: windSpeedKmh,
                windDirection: windDirection,
                precipitationChance: precipitationChance,
                precipitationMm: precipitationMm,
                uvIndex: uvIndex,
                rawJson: rawJson,
                fetchedAt: fetchedAt,
                expiresAt: expiresAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeatherCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeatherCacheTable,
      WeatherCacheData,
      $$WeatherCacheTableFilterComposer,
      $$WeatherCacheTableOrderingComposer,
      $$WeatherCacheTableAnnotationComposer,
      $$WeatherCacheTableCreateCompanionBuilder,
      $$WeatherCacheTableUpdateCompanionBuilder,
      (
        WeatherCacheData,
        BaseReferences<_$AppDatabase, $WeatherCacheTable, WeatherCacheData>,
      ),
      WeatherCacheData,
      PrefetchHooks Function()
    >;
typedef $$UserPreferencesTableCreateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<int> id,
      required String key,
      required String value,
      required String type,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$UserPreferencesTableUpdateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> value,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTable,
          UserPreference,
          $$UserPreferencesTableFilterComposer,
          $$UserPreferencesTableOrderingComposer,
          $$UserPreferencesTableAnnotationComposer,
          $$UserPreferencesTableCreateCompanionBuilder,
          $$UserPreferencesTableUpdateCompanionBuilder,
          (
            UserPreference,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTable,
              UserPreference
            >,
          ),
          UserPreference,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserPreferencesCompanion(
                id: id,
                key: key,
                value: value,
                type: type,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String value,
                required String type,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => UserPreferencesCompanion.insert(
                id: id,
                key: key,
                value: value,
                type: type,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTable,
      UserPreference,
      $$UserPreferencesTableFilterComposer,
      $$UserPreferencesTableOrderingComposer,
      $$UserPreferencesTableAnnotationComposer,
      $$UserPreferencesTableCreateCompanionBuilder,
      $$UserPreferencesTableUpdateCompanionBuilder,
      (
        UserPreference,
        BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>,
      ),
      UserPreference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$TimeBlocksTableTableManager get timeBlocks =>
      $$TimeBlocksTableTableManager(_db, _db.timeBlocks);
  $$CalendarCacheTableTableManager get calendarCache =>
      $$CalendarCacheTableTableManager(_db, _db.calendarCache);
  $$WeatherCacheTableTableManager get weatherCache =>
      $$WeatherCacheTableTableManager(_db, _db.weatherCache);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
}
