// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppMetaTable extends AppMeta with TableInfo<$AppMetaTable, AppMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetaTable createAlias(String alias) {
    return $AppMetaTable(attachedDatabase, alias);
  }
}

class AppMetaData extends DataClass implements Insertable<AppMetaData> {
  final String key;
  final String value;
  const AppMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetaCompanion toCompanion(bool nullToAbsent) {
    return AppMetaCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetaData copyWith({String? key, String? value}) =>
      AppMetaData(key: key ?? this.key, value: value ?? this.value);
  AppMetaData copyWithCompanion(AppMetaCompanion data) {
    return AppMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetaCompanion extends UpdateCompanion<AppMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomesTable extends Incomes with TableInfo<$IncomesTable, Income> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, source, amountCents, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incomes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Income> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Income map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Income(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $IncomesTable createAlias(String alias) {
    return $IncomesTable(attachedDatabase, alias);
  }
}

class Income extends DataClass implements Insertable<Income> {
  final int id;
  final String source;
  final int amountCents;
  final bool active;
  const Income({
    required this.id,
    required this.source,
    required this.amountCents,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source'] = Variable<String>(source);
    map['amount_cents'] = Variable<int>(amountCents);
    map['active'] = Variable<bool>(active);
    return map;
  }

  IncomesCompanion toCompanion(bool nullToAbsent) {
    return IncomesCompanion(
      id: Value(id),
      source: Value(source),
      amountCents: Value(amountCents),
      active: Value(active),
    );
  }

  factory Income.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Income(
      id: serializer.fromJson<int>(json['id']),
      source: serializer.fromJson<String>(json['source']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'source': serializer.toJson<String>(source),
      'amountCents': serializer.toJson<int>(amountCents),
      'active': serializer.toJson<bool>(active),
    };
  }

  Income copyWith({int? id, String? source, int? amountCents, bool? active}) =>
      Income(
        id: id ?? this.id,
        source: source ?? this.source,
        amountCents: amountCents ?? this.amountCents,
        active: active ?? this.active,
      );
  Income copyWithCompanion(IncomesCompanion data) {
    return Income(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Income(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('amountCents: $amountCents, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, source, amountCents, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Income &&
          other.id == this.id &&
          other.source == this.source &&
          other.amountCents == this.amountCents &&
          other.active == this.active);
}

class IncomesCompanion extends UpdateCompanion<Income> {
  final Value<int> id;
  final Value<String> source;
  final Value<int> amountCents;
  final Value<bool> active;
  const IncomesCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.active = const Value.absent(),
  });
  IncomesCompanion.insert({
    this.id = const Value.absent(),
    required String source,
    required int amountCents,
    this.active = const Value.absent(),
  }) : source = Value(source),
       amountCents = Value(amountCents);
  static Insertable<Income> custom({
    Expression<int>? id,
    Expression<String>? source,
    Expression<int>? amountCents,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (amountCents != null) 'amount_cents': amountCents,
      if (active != null) 'active': active,
    });
  }

  IncomesCompanion copyWith({
    Value<int>? id,
    Value<String>? source,
    Value<int>? amountCents,
    Value<bool>? active,
  }) {
    return IncomesCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      amountCents: amountCents ?? this.amountCents,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomesCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('amountCents: $amountCents, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $FixedExpensesTable extends FixedExpenses
    with TableInfo<$FixedExpensesTable, FixedExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FixedExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _conceptMeta = const VerificationMeta(
    'concept',
  );
  @override
  late final GeneratedColumn<String> concept = GeneratedColumn<String>(
    'concept',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, concept, amountCents, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fixed_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<FixedExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concept')) {
      context.handle(
        _conceptMeta,
        concept.isAcceptableOrUnknown(data['concept']!, _conceptMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FixedExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FixedExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      concept: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $FixedExpensesTable createAlias(String alias) {
    return $FixedExpensesTable(attachedDatabase, alias);
  }
}

class FixedExpense extends DataClass implements Insertable<FixedExpense> {
  final int id;
  final String concept;
  final int amountCents;
  final bool active;
  const FixedExpense({
    required this.id,
    required this.concept,
    required this.amountCents,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concept'] = Variable<String>(concept);
    map['amount_cents'] = Variable<int>(amountCents);
    map['active'] = Variable<bool>(active);
    return map;
  }

  FixedExpensesCompanion toCompanion(bool nullToAbsent) {
    return FixedExpensesCompanion(
      id: Value(id),
      concept: Value(concept),
      amountCents: Value(amountCents),
      active: Value(active),
    );
  }

  factory FixedExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FixedExpense(
      id: serializer.fromJson<int>(json['id']),
      concept: serializer.fromJson<String>(json['concept']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'concept': serializer.toJson<String>(concept),
      'amountCents': serializer.toJson<int>(amountCents),
      'active': serializer.toJson<bool>(active),
    };
  }

  FixedExpense copyWith({
    int? id,
    String? concept,
    int? amountCents,
    bool? active,
  }) => FixedExpense(
    id: id ?? this.id,
    concept: concept ?? this.concept,
    amountCents: amountCents ?? this.amountCents,
    active: active ?? this.active,
  );
  FixedExpense copyWithCompanion(FixedExpensesCompanion data) {
    return FixedExpense(
      id: data.id.present ? data.id.value : this.id,
      concept: data.concept.present ? data.concept.value : this.concept,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FixedExpense(')
          ..write('id: $id, ')
          ..write('concept: $concept, ')
          ..write('amountCents: $amountCents, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, concept, amountCents, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FixedExpense &&
          other.id == this.id &&
          other.concept == this.concept &&
          other.amountCents == this.amountCents &&
          other.active == this.active);
}

class FixedExpensesCompanion extends UpdateCompanion<FixedExpense> {
  final Value<int> id;
  final Value<String> concept;
  final Value<int> amountCents;
  final Value<bool> active;
  const FixedExpensesCompanion({
    this.id = const Value.absent(),
    this.concept = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.active = const Value.absent(),
  });
  FixedExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String concept,
    required int amountCents,
    this.active = const Value.absent(),
  }) : concept = Value(concept),
       amountCents = Value(amountCents);
  static Insertable<FixedExpense> custom({
    Expression<int>? id,
    Expression<String>? concept,
    Expression<int>? amountCents,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concept != null) 'concept': concept,
      if (amountCents != null) 'amount_cents': amountCents,
      if (active != null) 'active': active,
    });
  }

  FixedExpensesCompanion copyWith({
    Value<int>? id,
    Value<String>? concept,
    Value<int>? amountCents,
    Value<bool>? active,
  }) {
    return FixedExpensesCompanion(
      id: id ?? this.id,
      concept: concept ?? this.concept,
      amountCents: amountCents ?? this.amountCents,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (concept.present) {
      map['concept'] = Variable<String>(concept.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FixedExpensesCompanion(')
          ..write('id: $id, ')
          ..write('concept: $concept, ')
          ..write('amountCents: $amountCents, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $InstallmentsTable extends Installments
    with TableInfo<$InstallmentsTable, Installment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _conceptMeta = const VerificationMeta(
    'concept',
  );
  @override
  late final GeneratedColumn<String> concept = GeneratedColumn<String>(
    'concept',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    concept,
    amountCents,
    startDate,
    endDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Installment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concept')) {
      context.handle(
        _conceptMeta,
        concept.isAcceptableOrUnknown(data['concept']!, _conceptMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Installment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Installment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      concept: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
    );
  }

  @override
  $InstallmentsTable createAlias(String alias) {
    return $InstallmentsTable(attachedDatabase, alias);
  }
}

class Installment extends DataClass implements Insertable<Installment> {
  final int id;
  final String concept;
  final int amountCents;
  final DateTime startDate;
  final DateTime endDate;
  const Installment({
    required this.id,
    required this.concept,
    required this.amountCents,
    required this.startDate,
    required this.endDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concept'] = Variable<String>(concept);
    map['amount_cents'] = Variable<int>(amountCents);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    return map;
  }

  InstallmentsCompanion toCompanion(bool nullToAbsent) {
    return InstallmentsCompanion(
      id: Value(id),
      concept: Value(concept),
      amountCents: Value(amountCents),
      startDate: Value(startDate),
      endDate: Value(endDate),
    );
  }

  factory Installment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Installment(
      id: serializer.fromJson<int>(json['id']),
      concept: serializer.fromJson<String>(json['concept']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'concept': serializer.toJson<String>(concept),
      'amountCents': serializer.toJson<int>(amountCents),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
    };
  }

  Installment copyWith({
    int? id,
    String? concept,
    int? amountCents,
    DateTime? startDate,
    DateTime? endDate,
  }) => Installment(
    id: id ?? this.id,
    concept: concept ?? this.concept,
    amountCents: amountCents ?? this.amountCents,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
  );
  Installment copyWithCompanion(InstallmentsCompanion data) {
    return Installment(
      id: data.id.present ? data.id.value : this.id,
      concept: data.concept.present ? data.concept.value : this.concept,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Installment(')
          ..write('id: $id, ')
          ..write('concept: $concept, ')
          ..write('amountCents: $amountCents, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, concept, amountCents, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Installment &&
          other.id == this.id &&
          other.concept == this.concept &&
          other.amountCents == this.amountCents &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class InstallmentsCompanion extends UpdateCompanion<Installment> {
  final Value<int> id;
  final Value<String> concept;
  final Value<int> amountCents;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  const InstallmentsCompanion({
    this.id = const Value.absent(),
    this.concept = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  InstallmentsCompanion.insert({
    this.id = const Value.absent(),
    required String concept,
    required int amountCents,
    required DateTime startDate,
    required DateTime endDate,
  }) : concept = Value(concept),
       amountCents = Value(amountCents),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Installment> custom({
    Expression<int>? id,
    Expression<String>? concept,
    Expression<int>? amountCents,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concept != null) 'concept': concept,
      if (amountCents != null) 'amount_cents': amountCents,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  InstallmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? concept,
    Value<int>? amountCents,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
  }) {
    return InstallmentsCompanion(
      id: id ?? this.id,
      concept: concept ?? this.concept,
      amountCents: amountCents ?? this.amountCents,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (concept.present) {
      map['concept'] = Variable<String>(concept.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentsCompanion(')
          ..write('id: $id, ')
          ..write('concept: $concept, ')
          ..write('amountCents: $amountCents, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseCategory, int> category =
      GeneratedColumn<int>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ExpenseCategory>($ExpensesTable.$convertercategory);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 60),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    category,
    description,
    amountCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
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
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      category: $ExpensesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExpenseCategory, int, int> $convertercategory =
      const EnumIndexConverter<ExpenseCategory>(ExpenseCategory.values);
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final DateTime date;
  final ExpenseCategory category;
  final String? description;
  final int amountCents;
  const Expense({
    required this.id,
    required this.date,
    required this.category,
    this.description,
    required this.amountCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    {
      map['category'] = Variable<int>(
        $ExpensesTable.$convertercategory.toSql(category),
      );
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['amount_cents'] = Variable<int>(amountCents);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      amountCents: Value(amountCents),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: $ExpensesTable.$convertercategory.fromJson(
        serializer.fromJson<int>(json['category']),
      ),
      description: serializer.fromJson<String?>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<int>(
        $ExpensesTable.$convertercategory.toJson(category),
      ),
      'description': serializer.toJson<String?>(description),
      'amountCents': serializer.toJson<int>(amountCents),
    };
  }

  Expense copyWith({
    int? id,
    DateTime? date,
    ExpenseCategory? category,
    Value<String?> description = const Value.absent(),
    int? amountCents,
  }) => Expense(
    id: id ?? this.id,
    date: date ?? this.date,
    category: category ?? this.category,
    description: description.present ? description.value : this.description,
    amountCents: amountCents ?? this.amountCents,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, category, description, amountCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.category == this.category &&
          other.description == this.description &&
          other.amountCents == this.amountCents);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<ExpenseCategory> category;
  final Value<String?> description;
  final Value<int> amountCents;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required ExpenseCategory category,
    this.description = const Value.absent(),
    required int amountCents,
  }) : date = Value(date),
       category = Value(category),
       amountCents = Value(amountCents);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? category,
    Expression<String>? description,
    Expression<int>? amountCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<ExpenseCategory>? category,
    Value<String?>? description,
    Value<int>? amountCents,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $ExpensesTable.$convertercategory.toSql(category.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents')
          ..write(')'))
        .toString();
  }
}

class $MonthClosuresTable extends MonthClosures
    with TableInfo<$MonthClosuresTable, MonthClosure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthClosuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _periodKeyMeta = const VerificationMeta(
    'periodKey',
  );
  @override
  late final GeneratedColumn<String> periodKey = GeneratedColumn<String>(
    'period_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savingsCentsMeta = const VerificationMeta(
    'savingsCents',
  );
  @override
  late final GeneratedColumn<int> savingsCents = GeneratedColumn<int>(
    'savings_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netRemainderCentsMeta = const VerificationMeta(
    'netRemainderCents',
  );
  @override
  late final GeneratedColumn<int> netRemainderCents = GeneratedColumn<int>(
    'net_remainder_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalContributionCentsMeta =
      const VerificationMeta('totalContributionCents');
  @override
  late final GeneratedColumn<int> totalContributionCents = GeneratedColumn<int>(
    'total_contribution_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    periodKey,
    savingsCents,
    netRemainderCents,
    totalContributionCents,
    closedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'month_closures';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthClosure> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('period_key')) {
      context.handle(
        _periodKeyMeta,
        periodKey.isAcceptableOrUnknown(data['period_key']!, _periodKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_periodKeyMeta);
    }
    if (data.containsKey('savings_cents')) {
      context.handle(
        _savingsCentsMeta,
        savingsCents.isAcceptableOrUnknown(
          data['savings_cents']!,
          _savingsCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_savingsCentsMeta);
    }
    if (data.containsKey('net_remainder_cents')) {
      context.handle(
        _netRemainderCentsMeta,
        netRemainderCents.isAcceptableOrUnknown(
          data['net_remainder_cents']!,
          _netRemainderCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_netRemainderCentsMeta);
    }
    if (data.containsKey('total_contribution_cents')) {
      context.handle(
        _totalContributionCentsMeta,
        totalContributionCents.isAcceptableOrUnknown(
          data['total_contribution_cents']!,
          _totalContributionCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalContributionCentsMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_closedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {periodKey};
  @override
  MonthClosure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthClosure(
      periodKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_key'],
      )!,
      savingsCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_cents'],
      )!,
      netRemainderCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net_remainder_cents'],
      )!,
      totalContributionCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_contribution_cents'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      )!,
    );
  }

  @override
  $MonthClosuresTable createAlias(String alias) {
    return $MonthClosuresTable(attachedDatabase, alias);
  }
}

class MonthClosure extends DataClass implements Insertable<MonthClosure> {
  final String periodKey;
  final int savingsCents;
  final int netRemainderCents;
  final int totalContributionCents;
  final DateTime closedAt;
  const MonthClosure({
    required this.periodKey,
    required this.savingsCents,
    required this.netRemainderCents,
    required this.totalContributionCents,
    required this.closedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['period_key'] = Variable<String>(periodKey);
    map['savings_cents'] = Variable<int>(savingsCents);
    map['net_remainder_cents'] = Variable<int>(netRemainderCents);
    map['total_contribution_cents'] = Variable<int>(totalContributionCents);
    map['closed_at'] = Variable<DateTime>(closedAt);
    return map;
  }

  MonthClosuresCompanion toCompanion(bool nullToAbsent) {
    return MonthClosuresCompanion(
      periodKey: Value(periodKey),
      savingsCents: Value(savingsCents),
      netRemainderCents: Value(netRemainderCents),
      totalContributionCents: Value(totalContributionCents),
      closedAt: Value(closedAt),
    );
  }

  factory MonthClosure.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthClosure(
      periodKey: serializer.fromJson<String>(json['periodKey']),
      savingsCents: serializer.fromJson<int>(json['savingsCents']),
      netRemainderCents: serializer.fromJson<int>(json['netRemainderCents']),
      totalContributionCents: serializer.fromJson<int>(
        json['totalContributionCents'],
      ),
      closedAt: serializer.fromJson<DateTime>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'periodKey': serializer.toJson<String>(periodKey),
      'savingsCents': serializer.toJson<int>(savingsCents),
      'netRemainderCents': serializer.toJson<int>(netRemainderCents),
      'totalContributionCents': serializer.toJson<int>(totalContributionCents),
      'closedAt': serializer.toJson<DateTime>(closedAt),
    };
  }

  MonthClosure copyWith({
    String? periodKey,
    int? savingsCents,
    int? netRemainderCents,
    int? totalContributionCents,
    DateTime? closedAt,
  }) => MonthClosure(
    periodKey: periodKey ?? this.periodKey,
    savingsCents: savingsCents ?? this.savingsCents,
    netRemainderCents: netRemainderCents ?? this.netRemainderCents,
    totalContributionCents:
        totalContributionCents ?? this.totalContributionCents,
    closedAt: closedAt ?? this.closedAt,
  );
  MonthClosure copyWithCompanion(MonthClosuresCompanion data) {
    return MonthClosure(
      periodKey: data.periodKey.present ? data.periodKey.value : this.periodKey,
      savingsCents: data.savingsCents.present
          ? data.savingsCents.value
          : this.savingsCents,
      netRemainderCents: data.netRemainderCents.present
          ? data.netRemainderCents.value
          : this.netRemainderCents,
      totalContributionCents: data.totalContributionCents.present
          ? data.totalContributionCents.value
          : this.totalContributionCents,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthClosure(')
          ..write('periodKey: $periodKey, ')
          ..write('savingsCents: $savingsCents, ')
          ..write('netRemainderCents: $netRemainderCents, ')
          ..write('totalContributionCents: $totalContributionCents, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    periodKey,
    savingsCents,
    netRemainderCents,
    totalContributionCents,
    closedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthClosure &&
          other.periodKey == this.periodKey &&
          other.savingsCents == this.savingsCents &&
          other.netRemainderCents == this.netRemainderCents &&
          other.totalContributionCents == this.totalContributionCents &&
          other.closedAt == this.closedAt);
}

class MonthClosuresCompanion extends UpdateCompanion<MonthClosure> {
  final Value<String> periodKey;
  final Value<int> savingsCents;
  final Value<int> netRemainderCents;
  final Value<int> totalContributionCents;
  final Value<DateTime> closedAt;
  final Value<int> rowid;
  const MonthClosuresCompanion({
    this.periodKey = const Value.absent(),
    this.savingsCents = const Value.absent(),
    this.netRemainderCents = const Value.absent(),
    this.totalContributionCents = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthClosuresCompanion.insert({
    required String periodKey,
    required int savingsCents,
    required int netRemainderCents,
    required int totalContributionCents,
    required DateTime closedAt,
    this.rowid = const Value.absent(),
  }) : periodKey = Value(periodKey),
       savingsCents = Value(savingsCents),
       netRemainderCents = Value(netRemainderCents),
       totalContributionCents = Value(totalContributionCents),
       closedAt = Value(closedAt);
  static Insertable<MonthClosure> custom({
    Expression<String>? periodKey,
    Expression<int>? savingsCents,
    Expression<int>? netRemainderCents,
    Expression<int>? totalContributionCents,
    Expression<DateTime>? closedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (periodKey != null) 'period_key': periodKey,
      if (savingsCents != null) 'savings_cents': savingsCents,
      if (netRemainderCents != null) 'net_remainder_cents': netRemainderCents,
      if (totalContributionCents != null)
        'total_contribution_cents': totalContributionCents,
      if (closedAt != null) 'closed_at': closedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthClosuresCompanion copyWith({
    Value<String>? periodKey,
    Value<int>? savingsCents,
    Value<int>? netRemainderCents,
    Value<int>? totalContributionCents,
    Value<DateTime>? closedAt,
    Value<int>? rowid,
  }) {
    return MonthClosuresCompanion(
      periodKey: periodKey ?? this.periodKey,
      savingsCents: savingsCents ?? this.savingsCents,
      netRemainderCents: netRemainderCents ?? this.netRemainderCents,
      totalContributionCents:
          totalContributionCents ?? this.totalContributionCents,
      closedAt: closedAt ?? this.closedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (periodKey.present) {
      map['period_key'] = Variable<String>(periodKey.value);
    }
    if (savingsCents.present) {
      map['savings_cents'] = Variable<int>(savingsCents.value);
    }
    if (netRemainderCents.present) {
      map['net_remainder_cents'] = Variable<int>(netRemainderCents.value);
    }
    if (totalContributionCents.present) {
      map['total_contribution_cents'] = Variable<int>(
        totalContributionCents.value,
      );
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthClosuresCompanion(')
          ..write('periodKey: $periodKey, ')
          ..write('savingsCents: $savingsCents, ')
          ..write('netRemainderCents: $netRemainderCents, ')
          ..write('totalContributionCents: $totalContributionCents, ')
          ..write('closedAt: $closedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsMethodsTable extends SavingsMethods
    with TableInfo<$SavingsMethodsTable, SavingsMethod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsMethodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _periodKeyMeta = const VerificationMeta(
    'periodKey',
  );
  @override
  late final GeneratedColumn<String> periodKey = GeneratedColumn<String>(
    'period_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gastoMensualPctMeta = const VerificationMeta(
    'gastoMensualPct',
  );
  @override
  late final GeneratedColumn<int> gastoMensualPct = GeneratedColumn<int>(
    'gasto_mensual_pct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entretenimientoPctMeta =
      const VerificationMeta('entretenimientoPct');
  @override
  late final GeneratedColumn<int> entretenimientoPct = GeneratedColumn<int>(
    'entretenimiento_pct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ahorroPctMeta = const VerificationMeta(
    'ahorroPct',
  );
  @override
  late final GeneratedColumn<int> ahorroPct = GeneratedColumn<int>(
    'ahorro_pct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    periodKey,
    gastoMensualPct,
    entretenimientoPct,
    ahorroPct,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_methods';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsMethod> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('period_key')) {
      context.handle(
        _periodKeyMeta,
        periodKey.isAcceptableOrUnknown(data['period_key']!, _periodKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_periodKeyMeta);
    }
    if (data.containsKey('gasto_mensual_pct')) {
      context.handle(
        _gastoMensualPctMeta,
        gastoMensualPct.isAcceptableOrUnknown(
          data['gasto_mensual_pct']!,
          _gastoMensualPctMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gastoMensualPctMeta);
    }
    if (data.containsKey('entretenimiento_pct')) {
      context.handle(
        _entretenimientoPctMeta,
        entretenimientoPct.isAcceptableOrUnknown(
          data['entretenimiento_pct']!,
          _entretenimientoPctMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entretenimientoPctMeta);
    }
    if (data.containsKey('ahorro_pct')) {
      context.handle(
        _ahorroPctMeta,
        ahorroPct.isAcceptableOrUnknown(data['ahorro_pct']!, _ahorroPctMeta),
      );
    } else if (isInserting) {
      context.missing(_ahorroPctMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {periodKey};
  @override
  SavingsMethod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsMethod(
      periodKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_key'],
      )!,
      gastoMensualPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gasto_mensual_pct'],
      )!,
      entretenimientoPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entretenimiento_pct'],
      )!,
      ahorroPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ahorro_pct'],
      )!,
    );
  }

  @override
  $SavingsMethodsTable createAlias(String alias) {
    return $SavingsMethodsTable(attachedDatabase, alias);
  }
}

class SavingsMethod extends DataClass implements Insertable<SavingsMethod> {
  final String periodKey;
  final int gastoMensualPct;
  final int entretenimientoPct;
  final int ahorroPct;
  const SavingsMethod({
    required this.periodKey,
    required this.gastoMensualPct,
    required this.entretenimientoPct,
    required this.ahorroPct,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['period_key'] = Variable<String>(periodKey);
    map['gasto_mensual_pct'] = Variable<int>(gastoMensualPct);
    map['entretenimiento_pct'] = Variable<int>(entretenimientoPct);
    map['ahorro_pct'] = Variable<int>(ahorroPct);
    return map;
  }

  SavingsMethodsCompanion toCompanion(bool nullToAbsent) {
    return SavingsMethodsCompanion(
      periodKey: Value(periodKey),
      gastoMensualPct: Value(gastoMensualPct),
      entretenimientoPct: Value(entretenimientoPct),
      ahorroPct: Value(ahorroPct),
    );
  }

  factory SavingsMethod.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsMethod(
      periodKey: serializer.fromJson<String>(json['periodKey']),
      gastoMensualPct: serializer.fromJson<int>(json['gastoMensualPct']),
      entretenimientoPct: serializer.fromJson<int>(json['entretenimientoPct']),
      ahorroPct: serializer.fromJson<int>(json['ahorroPct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'periodKey': serializer.toJson<String>(periodKey),
      'gastoMensualPct': serializer.toJson<int>(gastoMensualPct),
      'entretenimientoPct': serializer.toJson<int>(entretenimientoPct),
      'ahorroPct': serializer.toJson<int>(ahorroPct),
    };
  }

  SavingsMethod copyWith({
    String? periodKey,
    int? gastoMensualPct,
    int? entretenimientoPct,
    int? ahorroPct,
  }) => SavingsMethod(
    periodKey: periodKey ?? this.periodKey,
    gastoMensualPct: gastoMensualPct ?? this.gastoMensualPct,
    entretenimientoPct: entretenimientoPct ?? this.entretenimientoPct,
    ahorroPct: ahorroPct ?? this.ahorroPct,
  );
  SavingsMethod copyWithCompanion(SavingsMethodsCompanion data) {
    return SavingsMethod(
      periodKey: data.periodKey.present ? data.periodKey.value : this.periodKey,
      gastoMensualPct: data.gastoMensualPct.present
          ? data.gastoMensualPct.value
          : this.gastoMensualPct,
      entretenimientoPct: data.entretenimientoPct.present
          ? data.entretenimientoPct.value
          : this.entretenimientoPct,
      ahorroPct: data.ahorroPct.present ? data.ahorroPct.value : this.ahorroPct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsMethod(')
          ..write('periodKey: $periodKey, ')
          ..write('gastoMensualPct: $gastoMensualPct, ')
          ..write('entretenimientoPct: $entretenimientoPct, ')
          ..write('ahorroPct: $ahorroPct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(periodKey, gastoMensualPct, entretenimientoPct, ahorroPct);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsMethod &&
          other.periodKey == this.periodKey &&
          other.gastoMensualPct == this.gastoMensualPct &&
          other.entretenimientoPct == this.entretenimientoPct &&
          other.ahorroPct == this.ahorroPct);
}

class SavingsMethodsCompanion extends UpdateCompanion<SavingsMethod> {
  final Value<String> periodKey;
  final Value<int> gastoMensualPct;
  final Value<int> entretenimientoPct;
  final Value<int> ahorroPct;
  final Value<int> rowid;
  const SavingsMethodsCompanion({
    this.periodKey = const Value.absent(),
    this.gastoMensualPct = const Value.absent(),
    this.entretenimientoPct = const Value.absent(),
    this.ahorroPct = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsMethodsCompanion.insert({
    required String periodKey,
    required int gastoMensualPct,
    required int entretenimientoPct,
    required int ahorroPct,
    this.rowid = const Value.absent(),
  }) : periodKey = Value(periodKey),
       gastoMensualPct = Value(gastoMensualPct),
       entretenimientoPct = Value(entretenimientoPct),
       ahorroPct = Value(ahorroPct);
  static Insertable<SavingsMethod> custom({
    Expression<String>? periodKey,
    Expression<int>? gastoMensualPct,
    Expression<int>? entretenimientoPct,
    Expression<int>? ahorroPct,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (periodKey != null) 'period_key': periodKey,
      if (gastoMensualPct != null) 'gasto_mensual_pct': gastoMensualPct,
      if (entretenimientoPct != null) 'entretenimiento_pct': entretenimientoPct,
      if (ahorroPct != null) 'ahorro_pct': ahorroPct,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsMethodsCompanion copyWith({
    Value<String>? periodKey,
    Value<int>? gastoMensualPct,
    Value<int>? entretenimientoPct,
    Value<int>? ahorroPct,
    Value<int>? rowid,
  }) {
    return SavingsMethodsCompanion(
      periodKey: periodKey ?? this.periodKey,
      gastoMensualPct: gastoMensualPct ?? this.gastoMensualPct,
      entretenimientoPct: entretenimientoPct ?? this.entretenimientoPct,
      ahorroPct: ahorroPct ?? this.ahorroPct,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (periodKey.present) {
      map['period_key'] = Variable<String>(periodKey.value);
    }
    if (gastoMensualPct.present) {
      map['gasto_mensual_pct'] = Variable<int>(gastoMensualPct.value);
    }
    if (entretenimientoPct.present) {
      map['entretenimiento_pct'] = Variable<int>(entretenimientoPct.value);
    }
    if (ahorroPct.present) {
      map['ahorro_pct'] = Variable<int>(ahorroPct.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsMethodsCompanion(')
          ..write('periodKey: $periodKey, ')
          ..write('gastoMensualPct: $gastoMensualPct, ')
          ..write('entretenimientoPct: $entretenimientoPct, ')
          ..write('ahorroPct: $ahorroPct, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetaTable appMeta = $AppMetaTable(this);
  late final $IncomesTable incomes = $IncomesTable(this);
  late final $FixedExpensesTable fixedExpenses = $FixedExpensesTable(this);
  late final $InstallmentsTable installments = $InstallmentsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $MonthClosuresTable monthClosures = $MonthClosuresTable(this);
  late final $SavingsMethodsTable savingsMethods = $SavingsMethodsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMeta,
    incomes,
    fixedExpenses,
    installments,
    expenses,
    monthClosures,
    savingsMethods,
  ];
}

typedef $$AppMetaTableCreateCompanionBuilder =
    AppMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetaTableUpdateCompanionBuilder =
    AppMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetaTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetaTable> {
  $$AppMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetaTable,
          AppMetaData,
          $$AppMetaTableFilterComposer,
          $$AppMetaTableOrderingComposer,
          $$AppMetaTableAnnotationComposer,
          $$AppMetaTableCreateCompanionBuilder,
          $$AppMetaTableUpdateCompanionBuilder,
          (
            AppMetaData,
            BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>,
          ),
          AppMetaData,
          PrefetchHooks Function()
        > {
  $$AppMetaTableTableManager(_$AppDatabase db, $AppMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) =>
                  AppMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetaTable,
      AppMetaData,
      $$AppMetaTableFilterComposer,
      $$AppMetaTableOrderingComposer,
      $$AppMetaTableAnnotationComposer,
      $$AppMetaTableCreateCompanionBuilder,
      $$AppMetaTableUpdateCompanionBuilder,
      (AppMetaData, BaseReferences<_$AppDatabase, $AppMetaTable, AppMetaData>),
      AppMetaData,
      PrefetchHooks Function()
    >;
typedef $$IncomesTableCreateCompanionBuilder =
    IncomesCompanion Function({
      Value<int> id,
      required String source,
      required int amountCents,
      Value<bool> active,
    });
typedef $$IncomesTableUpdateCompanionBuilder =
    IncomesCompanion Function({
      Value<int> id,
      Value<String> source,
      Value<int> amountCents,
      Value<bool> active,
    });

class $$IncomesTableFilterComposer
    extends Composer<_$AppDatabase, $IncomesTable> {
  $$IncomesTableFilterComposer({
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

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IncomesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomesTable> {
  $$IncomesTableOrderingComposer({
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

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncomesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomesTable> {
  $$IncomesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$IncomesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomesTable,
          Income,
          $$IncomesTableFilterComposer,
          $$IncomesTableOrderingComposer,
          $$IncomesTableAnnotationComposer,
          $$IncomesTableCreateCompanionBuilder,
          $$IncomesTableUpdateCompanionBuilder,
          (Income, BaseReferences<_$AppDatabase, $IncomesTable, Income>),
          Income,
          PrefetchHooks Function()
        > {
  $$IncomesTableTableManager(_$AppDatabase db, $IncomesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => IncomesCompanion(
                id: id,
                source: source,
                amountCents: amountCents,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String source,
                required int amountCents,
                Value<bool> active = const Value.absent(),
              }) => IncomesCompanion.insert(
                id: id,
                source: source,
                amountCents: amountCents,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IncomesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomesTable,
      Income,
      $$IncomesTableFilterComposer,
      $$IncomesTableOrderingComposer,
      $$IncomesTableAnnotationComposer,
      $$IncomesTableCreateCompanionBuilder,
      $$IncomesTableUpdateCompanionBuilder,
      (Income, BaseReferences<_$AppDatabase, $IncomesTable, Income>),
      Income,
      PrefetchHooks Function()
    >;
typedef $$FixedExpensesTableCreateCompanionBuilder =
    FixedExpensesCompanion Function({
      Value<int> id,
      required String concept,
      required int amountCents,
      Value<bool> active,
    });
typedef $$FixedExpensesTableUpdateCompanionBuilder =
    FixedExpensesCompanion Function({
      Value<int> id,
      Value<String> concept,
      Value<int> amountCents,
      Value<bool> active,
    });

class $$FixedExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $FixedExpensesTable> {
  $$FixedExpensesTableFilterComposer({
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

  ColumnFilters<String> get concept => $composableBuilder(
    column: $table.concept,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FixedExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $FixedExpensesTable> {
  $$FixedExpensesTableOrderingComposer({
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

  ColumnOrderings<String> get concept => $composableBuilder(
    column: $table.concept,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FixedExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FixedExpensesTable> {
  $$FixedExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get concept =>
      $composableBuilder(column: $table.concept, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$FixedExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FixedExpensesTable,
          FixedExpense,
          $$FixedExpensesTableFilterComposer,
          $$FixedExpensesTableOrderingComposer,
          $$FixedExpensesTableAnnotationComposer,
          $$FixedExpensesTableCreateCompanionBuilder,
          $$FixedExpensesTableUpdateCompanionBuilder,
          (
            FixedExpense,
            BaseReferences<_$AppDatabase, $FixedExpensesTable, FixedExpense>,
          ),
          FixedExpense,
          PrefetchHooks Function()
        > {
  $$FixedExpensesTableTableManager(_$AppDatabase db, $FixedExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FixedExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FixedExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FixedExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> concept = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => FixedExpensesCompanion(
                id: id,
                concept: concept,
                amountCents: amountCents,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String concept,
                required int amountCents,
                Value<bool> active = const Value.absent(),
              }) => FixedExpensesCompanion.insert(
                id: id,
                concept: concept,
                amountCents: amountCents,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FixedExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FixedExpensesTable,
      FixedExpense,
      $$FixedExpensesTableFilterComposer,
      $$FixedExpensesTableOrderingComposer,
      $$FixedExpensesTableAnnotationComposer,
      $$FixedExpensesTableCreateCompanionBuilder,
      $$FixedExpensesTableUpdateCompanionBuilder,
      (
        FixedExpense,
        BaseReferences<_$AppDatabase, $FixedExpensesTable, FixedExpense>,
      ),
      FixedExpense,
      PrefetchHooks Function()
    >;
typedef $$InstallmentsTableCreateCompanionBuilder =
    InstallmentsCompanion Function({
      Value<int> id,
      required String concept,
      required int amountCents,
      required DateTime startDate,
      required DateTime endDate,
    });
typedef $$InstallmentsTableUpdateCompanionBuilder =
    InstallmentsCompanion Function({
      Value<int> id,
      Value<String> concept,
      Value<int> amountCents,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
    });

class $$InstallmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InstallmentsTable> {
  $$InstallmentsTableFilterComposer({
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

  ColumnFilters<String> get concept => $composableBuilder(
    column: $table.concept,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstallmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InstallmentsTable> {
  $$InstallmentsTableOrderingComposer({
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

  ColumnOrderings<String> get concept => $composableBuilder(
    column: $table.concept,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstallmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstallmentsTable> {
  $$InstallmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get concept =>
      $composableBuilder(column: $table.concept, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);
}

class $$InstallmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstallmentsTable,
          Installment,
          $$InstallmentsTableFilterComposer,
          $$InstallmentsTableOrderingComposer,
          $$InstallmentsTableAnnotationComposer,
          $$InstallmentsTableCreateCompanionBuilder,
          $$InstallmentsTableUpdateCompanionBuilder,
          (
            Installment,
            BaseReferences<_$AppDatabase, $InstallmentsTable, Installment>,
          ),
          Installment,
          PrefetchHooks Function()
        > {
  $$InstallmentsTableTableManager(_$AppDatabase db, $InstallmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstallmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstallmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstallmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> concept = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
              }) => InstallmentsCompanion(
                id: id,
                concept: concept,
                amountCents: amountCents,
                startDate: startDate,
                endDate: endDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String concept,
                required int amountCents,
                required DateTime startDate,
                required DateTime endDate,
              }) => InstallmentsCompanion.insert(
                id: id,
                concept: concept,
                amountCents: amountCents,
                startDate: startDate,
                endDate: endDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstallmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstallmentsTable,
      Installment,
      $$InstallmentsTableFilterComposer,
      $$InstallmentsTableOrderingComposer,
      $$InstallmentsTableAnnotationComposer,
      $$InstallmentsTableCreateCompanionBuilder,
      $$InstallmentsTableUpdateCompanionBuilder,
      (
        Installment,
        BaseReferences<_$AppDatabase, $InstallmentsTable, Installment>,
      ),
      Installment,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required DateTime date,
      required ExpenseCategory category,
      Value<String?> description,
      required int amountCents,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<ExpenseCategory> category,
      Value<String?> description,
      Value<int> amountCents,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExpenseCategory, ExpenseCategory, int>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExpenseCategory, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<ExpenseCategory> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                date: date,
                category: category,
                description: description,
                amountCents: amountCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required ExpenseCategory category,
                Value<String?> description = const Value.absent(),
                required int amountCents,
              }) => ExpensesCompanion.insert(
                id: id,
                date: date,
                category: category,
                description: description,
                amountCents: amountCents,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$MonthClosuresTableCreateCompanionBuilder =
    MonthClosuresCompanion Function({
      required String periodKey,
      required int savingsCents,
      required int netRemainderCents,
      required int totalContributionCents,
      required DateTime closedAt,
      Value<int> rowid,
    });
typedef $$MonthClosuresTableUpdateCompanionBuilder =
    MonthClosuresCompanion Function({
      Value<String> periodKey,
      Value<int> savingsCents,
      Value<int> netRemainderCents,
      Value<int> totalContributionCents,
      Value<DateTime> closedAt,
      Value<int> rowid,
    });

class $$MonthClosuresTableFilterComposer
    extends Composer<_$AppDatabase, $MonthClosuresTable> {
  $$MonthClosuresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get periodKey => $composableBuilder(
    column: $table.periodKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsCents => $composableBuilder(
    column: $table.savingsCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get netRemainderCents => $composableBuilder(
    column: $table.netRemainderCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalContributionCents => $composableBuilder(
    column: $table.totalContributionCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthClosuresTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthClosuresTable> {
  $$MonthClosuresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get periodKey => $composableBuilder(
    column: $table.periodKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsCents => $composableBuilder(
    column: $table.savingsCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get netRemainderCents => $composableBuilder(
    column: $table.netRemainderCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalContributionCents => $composableBuilder(
    column: $table.totalContributionCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthClosuresTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthClosuresTable> {
  $$MonthClosuresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get periodKey =>
      $composableBuilder(column: $table.periodKey, builder: (column) => column);

  GeneratedColumn<int> get savingsCents => $composableBuilder(
    column: $table.savingsCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get netRemainderCents => $composableBuilder(
    column: $table.netRemainderCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalContributionCents => $composableBuilder(
    column: $table.totalContributionCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);
}

class $$MonthClosuresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthClosuresTable,
          MonthClosure,
          $$MonthClosuresTableFilterComposer,
          $$MonthClosuresTableOrderingComposer,
          $$MonthClosuresTableAnnotationComposer,
          $$MonthClosuresTableCreateCompanionBuilder,
          $$MonthClosuresTableUpdateCompanionBuilder,
          (
            MonthClosure,
            BaseReferences<_$AppDatabase, $MonthClosuresTable, MonthClosure>,
          ),
          MonthClosure,
          PrefetchHooks Function()
        > {
  $$MonthClosuresTableTableManager(_$AppDatabase db, $MonthClosuresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthClosuresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthClosuresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthClosuresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> periodKey = const Value.absent(),
                Value<int> savingsCents = const Value.absent(),
                Value<int> netRemainderCents = const Value.absent(),
                Value<int> totalContributionCents = const Value.absent(),
                Value<DateTime> closedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonthClosuresCompanion(
                periodKey: periodKey,
                savingsCents: savingsCents,
                netRemainderCents: netRemainderCents,
                totalContributionCents: totalContributionCents,
                closedAt: closedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String periodKey,
                required int savingsCents,
                required int netRemainderCents,
                required int totalContributionCents,
                required DateTime closedAt,
                Value<int> rowid = const Value.absent(),
              }) => MonthClosuresCompanion.insert(
                periodKey: periodKey,
                savingsCents: savingsCents,
                netRemainderCents: netRemainderCents,
                totalContributionCents: totalContributionCents,
                closedAt: closedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthClosuresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthClosuresTable,
      MonthClosure,
      $$MonthClosuresTableFilterComposer,
      $$MonthClosuresTableOrderingComposer,
      $$MonthClosuresTableAnnotationComposer,
      $$MonthClosuresTableCreateCompanionBuilder,
      $$MonthClosuresTableUpdateCompanionBuilder,
      (
        MonthClosure,
        BaseReferences<_$AppDatabase, $MonthClosuresTable, MonthClosure>,
      ),
      MonthClosure,
      PrefetchHooks Function()
    >;
typedef $$SavingsMethodsTableCreateCompanionBuilder =
    SavingsMethodsCompanion Function({
      required String periodKey,
      required int gastoMensualPct,
      required int entretenimientoPct,
      required int ahorroPct,
      Value<int> rowid,
    });
typedef $$SavingsMethodsTableUpdateCompanionBuilder =
    SavingsMethodsCompanion Function({
      Value<String> periodKey,
      Value<int> gastoMensualPct,
      Value<int> entretenimientoPct,
      Value<int> ahorroPct,
      Value<int> rowid,
    });

class $$SavingsMethodsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsMethodsTable> {
  $$SavingsMethodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get periodKey => $composableBuilder(
    column: $table.periodKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gastoMensualPct => $composableBuilder(
    column: $table.gastoMensualPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entretenimientoPct => $composableBuilder(
    column: $table.entretenimientoPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ahorroPct => $composableBuilder(
    column: $table.ahorroPct,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsMethodsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsMethodsTable> {
  $$SavingsMethodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get periodKey => $composableBuilder(
    column: $table.periodKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gastoMensualPct => $composableBuilder(
    column: $table.gastoMensualPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entretenimientoPct => $composableBuilder(
    column: $table.entretenimientoPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ahorroPct => $composableBuilder(
    column: $table.ahorroPct,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsMethodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsMethodsTable> {
  $$SavingsMethodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get periodKey =>
      $composableBuilder(column: $table.periodKey, builder: (column) => column);

  GeneratedColumn<int> get gastoMensualPct => $composableBuilder(
    column: $table.gastoMensualPct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entretenimientoPct => $composableBuilder(
    column: $table.entretenimientoPct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ahorroPct =>
      $composableBuilder(column: $table.ahorroPct, builder: (column) => column);
}

class $$SavingsMethodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsMethodsTable,
          SavingsMethod,
          $$SavingsMethodsTableFilterComposer,
          $$SavingsMethodsTableOrderingComposer,
          $$SavingsMethodsTableAnnotationComposer,
          $$SavingsMethodsTableCreateCompanionBuilder,
          $$SavingsMethodsTableUpdateCompanionBuilder,
          (
            SavingsMethod,
            BaseReferences<_$AppDatabase, $SavingsMethodsTable, SavingsMethod>,
          ),
          SavingsMethod,
          PrefetchHooks Function()
        > {
  $$SavingsMethodsTableTableManager(
    _$AppDatabase db,
    $SavingsMethodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsMethodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsMethodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsMethodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> periodKey = const Value.absent(),
                Value<int> gastoMensualPct = const Value.absent(),
                Value<int> entretenimientoPct = const Value.absent(),
                Value<int> ahorroPct = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavingsMethodsCompanion(
                periodKey: periodKey,
                gastoMensualPct: gastoMensualPct,
                entretenimientoPct: entretenimientoPct,
                ahorroPct: ahorroPct,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String periodKey,
                required int gastoMensualPct,
                required int entretenimientoPct,
                required int ahorroPct,
                Value<int> rowid = const Value.absent(),
              }) => SavingsMethodsCompanion.insert(
                periodKey: periodKey,
                gastoMensualPct: gastoMensualPct,
                entretenimientoPct: entretenimientoPct,
                ahorroPct: ahorroPct,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsMethodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsMethodsTable,
      SavingsMethod,
      $$SavingsMethodsTableFilterComposer,
      $$SavingsMethodsTableOrderingComposer,
      $$SavingsMethodsTableAnnotationComposer,
      $$SavingsMethodsTableCreateCompanionBuilder,
      $$SavingsMethodsTableUpdateCompanionBuilder,
      (
        SavingsMethod,
        BaseReferences<_$AppDatabase, $SavingsMethodsTable, SavingsMethod>,
      ),
      SavingsMethod,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMetaTableTableManager get appMeta =>
      $$AppMetaTableTableManager(_db, _db.appMeta);
  $$IncomesTableTableManager get incomes =>
      $$IncomesTableTableManager(_db, _db.incomes);
  $$FixedExpensesTableTableManager get fixedExpenses =>
      $$FixedExpensesTableTableManager(_db, _db.fixedExpenses);
  $$InstallmentsTableTableManager get installments =>
      $$InstallmentsTableTableManager(_db, _db.installments);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$MonthClosuresTableTableManager get monthClosures =>
      $$MonthClosuresTableTableManager(_db, _db.monthClosures);
  $$SavingsMethodsTableTableManager get savingsMethods =>
      $$SavingsMethodsTableTableManager(_db, _db.savingsMethods);
}
