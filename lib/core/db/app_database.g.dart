// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BookTableTable extends BookTable
    with TableInfo<$BookTableTable, BookTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  localSubPaths = GeneratedColumn<String>(
    'local_sub_paths',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($BookTableTable.$converterlocalSubPaths);
  static const VerificationMeta _coverSubPathMeta = const VerificationMeta(
    'coverSubPath',
  );
  @override
  late final GeneratedColumn<String> coverSubPath = GeneratedColumn<String>(
    'cover_sub_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
  previewSubPaths = GeneratedColumn<String>(
    'preview_sub_paths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<String>?>($BookTableTable.$converterpreviewSubPathsn);
  static const VerificationMeta _readCountMeta = const VerificationMeta(
    'readCount',
  );
  @override
  late final GeneratedColumn<int> readCount = GeneratedColumn<int>(
    'read_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentPageMeta = const VerificationMeta(
    'currentPage',
  );
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
    'current_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    localSubPaths,
    coverSubPath,
    previewSubPaths,
    readCount,
    currentPage,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cover_sub_path')) {
      context.handle(
        _coverSubPathMeta,
        coverSubPath.isAcceptableOrUnknown(
          data['cover_sub_path']!,
          _coverSubPathMeta,
        ),
      );
    }
    if (data.containsKey('read_count')) {
      context.handle(
        _readCountMeta,
        readCount.isAcceptableOrUnknown(data['read_count']!, _readCountMeta),
      );
    }
    if (data.containsKey('current_page')) {
      context.handle(
        _currentPageMeta,
        currentPage.isAcceptableOrUnknown(
          data['current_page']!,
          _currentPageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      localSubPaths: $BookTableTable.$converterlocalSubPaths.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}local_sub_paths'],
        )!,
      ),
      coverSubPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_sub_path'],
      ),
      previewSubPaths: $BookTableTable.$converterpreviewSubPathsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}preview_sub_paths'],
        ),
      ),
      readCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}read_count'],
      )!,
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookTableTable createAlias(String alias) {
    return $BookTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterlocalSubPaths = const StringListConverter();
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterpreviewSubPaths = const StringListConverter();
  static JsonTypeConverter2<List<String>?, String?, List<dynamic>?>
  $converterpreviewSubPathsn = JsonTypeConverter2.asNullable(
    $converterpreviewSubPaths,
  );
}

class BookTableData extends DataClass implements Insertable<BookTableData> {
  final int id;
  final String name;
  final List<String> localSubPaths;
  final String? coverSubPath;
  final List<String>? previewSubPaths;
  final int readCount;
  final int currentPage;
  final DateTime createdAt;
  const BookTableData({
    required this.id,
    required this.name,
    required this.localSubPaths,
    this.coverSubPath,
    this.previewSubPaths,
    required this.readCount,
    required this.currentPage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['local_sub_paths'] = Variable<String>(
        $BookTableTable.$converterlocalSubPaths.toSql(localSubPaths),
      );
    }
    if (!nullToAbsent || coverSubPath != null) {
      map['cover_sub_path'] = Variable<String>(coverSubPath);
    }
    if (!nullToAbsent || previewSubPaths != null) {
      map['preview_sub_paths'] = Variable<String>(
        $BookTableTable.$converterpreviewSubPathsn.toSql(previewSubPaths),
      );
    }
    map['read_count'] = Variable<int>(readCount);
    map['current_page'] = Variable<int>(currentPage);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookTableCompanion toCompanion(bool nullToAbsent) {
    return BookTableCompanion(
      id: Value(id),
      name: Value(name),
      localSubPaths: Value(localSubPaths),
      coverSubPath: coverSubPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverSubPath),
      previewSubPaths: previewSubPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(previewSubPaths),
      readCount: Value(readCount),
      currentPage: Value(currentPage),
      createdAt: Value(createdAt),
    );
  }

  factory BookTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      localSubPaths: $BookTableTable.$converterlocalSubPaths.fromJson(
        serializer.fromJson<List<dynamic>>(json['localSubPaths']),
      ),
      coverSubPath: serializer.fromJson<String?>(json['coverSubPath']),
      previewSubPaths: $BookTableTable.$converterpreviewSubPathsn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['previewSubPaths']),
      ),
      readCount: serializer.fromJson<int>(json['readCount']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'localSubPaths': serializer.toJson<List<dynamic>>(
        $BookTableTable.$converterlocalSubPaths.toJson(localSubPaths),
      ),
      'coverSubPath': serializer.toJson<String?>(coverSubPath),
      'previewSubPaths': serializer.toJson<List<dynamic>?>(
        $BookTableTable.$converterpreviewSubPathsn.toJson(previewSubPaths),
      ),
      'readCount': serializer.toJson<int>(readCount),
      'currentPage': serializer.toJson<int>(currentPage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BookTableData copyWith({
    int? id,
    String? name,
    List<String>? localSubPaths,
    Value<String?> coverSubPath = const Value.absent(),
    Value<List<String>?> previewSubPaths = const Value.absent(),
    int? readCount,
    int? currentPage,
    DateTime? createdAt,
  }) => BookTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    localSubPaths: localSubPaths ?? this.localSubPaths,
    coverSubPath: coverSubPath.present ? coverSubPath.value : this.coverSubPath,
    previewSubPaths: previewSubPaths.present
        ? previewSubPaths.value
        : this.previewSubPaths,
    readCount: readCount ?? this.readCount,
    currentPage: currentPage ?? this.currentPage,
    createdAt: createdAt ?? this.createdAt,
  );
  BookTableData copyWithCompanion(BookTableCompanion data) {
    return BookTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      localSubPaths: data.localSubPaths.present
          ? data.localSubPaths.value
          : this.localSubPaths,
      coverSubPath: data.coverSubPath.present
          ? data.coverSubPath.value
          : this.coverSubPath,
      previewSubPaths: data.previewSubPaths.present
          ? data.previewSubPaths.value
          : this.previewSubPaths,
      readCount: data.readCount.present ? data.readCount.value : this.readCount,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('localSubPaths: $localSubPaths, ')
          ..write('coverSubPath: $coverSubPath, ')
          ..write('previewSubPaths: $previewSubPaths, ')
          ..write('readCount: $readCount, ')
          ..write('currentPage: $currentPage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    localSubPaths,
    coverSubPath,
    previewSubPaths,
    readCount,
    currentPage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.localSubPaths == this.localSubPaths &&
          other.coverSubPath == this.coverSubPath &&
          other.previewSubPaths == this.previewSubPaths &&
          other.readCount == this.readCount &&
          other.currentPage == this.currentPage &&
          other.createdAt == this.createdAt);
}

class BookTableCompanion extends UpdateCompanion<BookTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<List<String>> localSubPaths;
  final Value<String?> coverSubPath;
  final Value<List<String>?> previewSubPaths;
  final Value<int> readCount;
  final Value<int> currentPage;
  final Value<DateTime> createdAt;
  const BookTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.localSubPaths = const Value.absent(),
    this.coverSubPath = const Value.absent(),
    this.previewSubPaths = const Value.absent(),
    this.readCount = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BookTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required List<String> localSubPaths,
    this.coverSubPath = const Value.absent(),
    this.previewSubPaths = const Value.absent(),
    this.readCount = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       localSubPaths = Value(localSubPaths);
  static Insertable<BookTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? localSubPaths,
    Expression<String>? coverSubPath,
    Expression<String>? previewSubPaths,
    Expression<int>? readCount,
    Expression<int>? currentPage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (localSubPaths != null) 'local_sub_paths': localSubPaths,
      if (coverSubPath != null) 'cover_sub_path': coverSubPath,
      if (previewSubPaths != null) 'preview_sub_paths': previewSubPaths,
      if (readCount != null) 'read_count': readCount,
      if (currentPage != null) 'current_page': currentPage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BookTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<List<String>>? localSubPaths,
    Value<String?>? coverSubPath,
    Value<List<String>?>? previewSubPaths,
    Value<int>? readCount,
    Value<int>? currentPage,
    Value<DateTime>? createdAt,
  }) {
    return BookTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      localSubPaths: localSubPaths ?? this.localSubPaths,
      coverSubPath: coverSubPath ?? this.coverSubPath,
      previewSubPaths: previewSubPaths ?? this.previewSubPaths,
      readCount: readCount ?? this.readCount,
      currentPage: currentPage ?? this.currentPage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (localSubPaths.present) {
      map['local_sub_paths'] = Variable<String>(
        $BookTableTable.$converterlocalSubPaths.toSql(localSubPaths.value),
      );
    }
    if (coverSubPath.present) {
      map['cover_sub_path'] = Variable<String>(coverSubPath.value);
    }
    if (previewSubPaths.present) {
      map['preview_sub_paths'] = Variable<String>(
        $BookTableTable.$converterpreviewSubPathsn.toSql(previewSubPaths.value),
      );
    }
    if (readCount.present) {
      map['read_count'] = Variable<int>(readCount.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('localSubPaths: $localSubPaths, ')
          ..write('coverSubPath: $coverSubPath, ')
          ..write('previewSubPaths: $previewSubPaths, ')
          ..write('readCount: $readCount, ')
          ..write('currentPage: $currentPage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CollectionTableTable extends CollectionTable
    with TableInfo<$CollectionTableTable, CollectionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
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
  static const VerificationMeta _coverImageSubPathMeta = const VerificationMeta(
    'coverImageSubPath',
  );
  @override
  late final GeneratedColumn<String> coverImageSubPath =
      GeneratedColumn<String>(
        'cover_image_sub_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    coverImageSubPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('cover_image_sub_path')) {
      context.handle(
        _coverImageSubPathMeta,
        coverImageSubPath.isAcceptableOrUnknown(
          data['cover_image_sub_path']!,
          _coverImageSubPathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollectionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      coverImageSubPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image_sub_path'],
      ),
    );
  }

  @override
  $CollectionTableTable createAlias(String alias) {
    return $CollectionTableTable(attachedDatabase, alias);
  }
}

class CollectionTableData extends DataClass
    implements Insertable<CollectionTableData> {
  final int id;
  final String name;
  final String? description;
  final String? coverImageSubPath;
  const CollectionTableData({
    required this.id,
    required this.name,
    this.description,
    this.coverImageSubPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverImageSubPath != null) {
      map['cover_image_sub_path'] = Variable<String>(coverImageSubPath);
    }
    return map;
  }

  CollectionTableCompanion toCompanion(bool nullToAbsent) {
    return CollectionTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverImageSubPath: coverImageSubPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImageSubPath),
    );
  }

  factory CollectionTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      coverImageSubPath: serializer.fromJson<String?>(
        json['coverImageSubPath'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'coverImageSubPath': serializer.toJson<String?>(coverImageSubPath),
    };
  }

  CollectionTableData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> coverImageSubPath = const Value.absent(),
  }) => CollectionTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    coverImageSubPath: coverImageSubPath.present
        ? coverImageSubPath.value
        : this.coverImageSubPath,
  );
  CollectionTableData copyWithCompanion(CollectionTableCompanion data) {
    return CollectionTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      coverImageSubPath: data.coverImageSubPath.present
          ? data.coverImageSubPath.value
          : this.coverImageSubPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('coverImageSubPath: $coverImageSubPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, coverImageSubPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.coverImageSubPath == this.coverImageSubPath);
}

class CollectionTableCompanion extends UpdateCompanion<CollectionTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> coverImageSubPath;
  const CollectionTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.coverImageSubPath = const Value.absent(),
  });
  CollectionTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.coverImageSubPath = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CollectionTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? coverImageSubPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (coverImageSubPath != null) 'cover_image_sub_path': coverImageSubPath,
    });
  }

  CollectionTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? coverImageSubPath,
  }) {
    return CollectionTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImageSubPath: coverImageSubPath ?? this.coverImageSubPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverImageSubPath.present) {
      map['cover_image_sub_path'] = Variable<String>(coverImageSubPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('coverImageSubPath: $coverImageSubPath')
          ..write(')'))
        .toString();
  }
}

class $CollectionBookTableTable extends CollectionBookTable
    with TableInfo<$CollectionBookTableTable, CollectionBookTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionBookTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, collectionId, bookId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_book_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionBookTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollectionBookTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionBookTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
    );
  }

  @override
  $CollectionBookTableTable createAlias(String alias) {
    return $CollectionBookTableTable(attachedDatabase, alias);
  }
}

class CollectionBookTableData extends DataClass
    implements Insertable<CollectionBookTableData> {
  final int id;
  final int collectionId;
  final int bookId;
  const CollectionBookTableData({
    required this.id,
    required this.collectionId,
    required this.bookId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['collection_id'] = Variable<int>(collectionId);
    map['book_id'] = Variable<int>(bookId);
    return map;
  }

  CollectionBookTableCompanion toCompanion(bool nullToAbsent) {
    return CollectionBookTableCompanion(
      id: Value(id),
      collectionId: Value(collectionId),
      bookId: Value(bookId),
    );
  }

  factory CollectionBookTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionBookTableData(
      id: serializer.fromJson<int>(json['id']),
      collectionId: serializer.fromJson<int>(json['collectionId']),
      bookId: serializer.fromJson<int>(json['bookId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'collectionId': serializer.toJson<int>(collectionId),
      'bookId': serializer.toJson<int>(bookId),
    };
  }

  CollectionBookTableData copyWith({int? id, int? collectionId, int? bookId}) =>
      CollectionBookTableData(
        id: id ?? this.id,
        collectionId: collectionId ?? this.collectionId,
        bookId: bookId ?? this.bookId,
      );
  CollectionBookTableData copyWithCompanion(CollectionBookTableCompanion data) {
    return CollectionBookTableData(
      id: data.id.present ? data.id.value : this.id,
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionBookTableData(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('bookId: $bookId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, collectionId, bookId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionBookTableData &&
          other.id == this.id &&
          other.collectionId == this.collectionId &&
          other.bookId == this.bookId);
}

class CollectionBookTableCompanion
    extends UpdateCompanion<CollectionBookTableData> {
  final Value<int> id;
  final Value<int> collectionId;
  final Value<int> bookId;
  const CollectionBookTableCompanion({
    this.id = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.bookId = const Value.absent(),
  });
  CollectionBookTableCompanion.insert({
    this.id = const Value.absent(),
    required int collectionId,
    required int bookId,
  }) : collectionId = Value(collectionId),
       bookId = Value(bookId);
  static Insertable<CollectionBookTableData> custom({
    Expression<int>? id,
    Expression<int>? collectionId,
    Expression<int>? bookId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (collectionId != null) 'collection_id': collectionId,
      if (bookId != null) 'book_id': bookId,
    });
  }

  CollectionBookTableCompanion copyWith({
    Value<int>? id,
    Value<int>? collectionId,
    Value<int>? bookId,
  }) {
    return CollectionBookTableCompanion(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      bookId: bookId ?? this.bookId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionBookTableCompanion(')
          ..write('id: $id, ')
          ..write('collectionId: $collectionId, ')
          ..write('bookId: $bookId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookTableTable bookTable = $BookTableTable(this);
  late final $CollectionTableTable collectionTable = $CollectionTableTable(
    this,
  );
  late final $CollectionBookTableTable collectionBookTable =
      $CollectionBookTableTable(this);
  late final BookLocalDatasource bookLocalDatasource = BookLocalDatasource(
    this as AppDatabase,
  );
  late final CollectionLocalDatasource collectionLocalDatasource =
      CollectionLocalDatasource(this as AppDatabase);
  late final CollectionBookLocalDatasource collectionBookLocalDatasource =
      CollectionBookLocalDatasource(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bookTable,
    collectionTable,
    collectionBookTable,
  ];
}

typedef $$BookTableTableCreateCompanionBuilder =
    BookTableCompanion Function({
      Value<int> id,
      required String name,
      required List<String> localSubPaths,
      Value<String?> coverSubPath,
      Value<List<String>?> previewSubPaths,
      Value<int> readCount,
      Value<int> currentPage,
      Value<DateTime> createdAt,
    });
typedef $$BookTableTableUpdateCompanionBuilder =
    BookTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<List<String>> localSubPaths,
      Value<String?> coverSubPath,
      Value<List<String>?> previewSubPaths,
      Value<int> readCount,
      Value<int> currentPage,
      Value<DateTime> createdAt,
    });

class $$BookTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookTableTable> {
  $$BookTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get localSubPaths => $composableBuilder(
    column: $table.localSubPaths,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get coverSubPath => $composableBuilder(
    column: $table.coverSubPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get previewSubPaths => $composableBuilder(
    column: $table.previewSubPaths,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get readCount => $composableBuilder(
    column: $table.readCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookTableTable> {
  $$BookTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localSubPaths => $composableBuilder(
    column: $table.localSubPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverSubPath => $composableBuilder(
    column: $table.coverSubPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previewSubPaths => $composableBuilder(
    column: $table.previewSubPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readCount => $composableBuilder(
    column: $table.readCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookTableTable> {
  $$BookTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get localSubPaths =>
      $composableBuilder(
        column: $table.localSubPaths,
        builder: (column) => column,
      );

  GeneratedColumn<String> get coverSubPath => $composableBuilder(
    column: $table.coverSubPath,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>?, String> get previewSubPaths =>
      $composableBuilder(
        column: $table.previewSubPaths,
        builder: (column) => column,
      );

  GeneratedColumn<int> get readCount =>
      $composableBuilder(column: $table.readCount, builder: (column) => column);

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookTableTable,
          BookTableData,
          $$BookTableTableFilterComposer,
          $$BookTableTableOrderingComposer,
          $$BookTableTableAnnotationComposer,
          $$BookTableTableCreateCompanionBuilder,
          $$BookTableTableUpdateCompanionBuilder,
          (
            BookTableData,
            BaseReferences<_$AppDatabase, $BookTableTable, BookTableData>,
          ),
          BookTableData,
          PrefetchHooks Function()
        > {
  $$BookTableTableTableManager(_$AppDatabase db, $BookTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<List<String>> localSubPaths = const Value.absent(),
                Value<String?> coverSubPath = const Value.absent(),
                Value<List<String>?> previewSubPaths = const Value.absent(),
                Value<int> readCount = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookTableCompanion(
                id: id,
                name: name,
                localSubPaths: localSubPaths,
                coverSubPath: coverSubPath,
                previewSubPaths: previewSubPaths,
                readCount: readCount,
                currentPage: currentPage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required List<String> localSubPaths,
                Value<String?> coverSubPath = const Value.absent(),
                Value<List<String>?> previewSubPaths = const Value.absent(),
                Value<int> readCount = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookTableCompanion.insert(
                id: id,
                name: name,
                localSubPaths: localSubPaths,
                coverSubPath: coverSubPath,
                previewSubPaths: previewSubPaths,
                readCount: readCount,
                currentPage: currentPage,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookTableTable,
      BookTableData,
      $$BookTableTableFilterComposer,
      $$BookTableTableOrderingComposer,
      $$BookTableTableAnnotationComposer,
      $$BookTableTableCreateCompanionBuilder,
      $$BookTableTableUpdateCompanionBuilder,
      (
        BookTableData,
        BaseReferences<_$AppDatabase, $BookTableTable, BookTableData>,
      ),
      BookTableData,
      PrefetchHooks Function()
    >;
typedef $$CollectionTableTableCreateCompanionBuilder =
    CollectionTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<String?> coverImageSubPath,
    });
typedef $$CollectionTableTableUpdateCompanionBuilder =
    CollectionTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> coverImageSubPath,
    });

class $$CollectionTableTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionTableTable> {
  $$CollectionTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImageSubPath => $composableBuilder(
    column: $table.coverImageSubPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CollectionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionTableTable> {
  $$CollectionTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImageSubPath => $composableBuilder(
    column: $table.coverImageSubPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionTableTable> {
  $$CollectionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverImageSubPath => $composableBuilder(
    column: $table.coverImageSubPath,
    builder: (column) => column,
  );
}

class $$CollectionTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionTableTable,
          CollectionTableData,
          $$CollectionTableTableFilterComposer,
          $$CollectionTableTableOrderingComposer,
          $$CollectionTableTableAnnotationComposer,
          $$CollectionTableTableCreateCompanionBuilder,
          $$CollectionTableTableUpdateCompanionBuilder,
          (
            CollectionTableData,
            BaseReferences<
              _$AppDatabase,
              $CollectionTableTable,
              CollectionTableData
            >,
          ),
          CollectionTableData,
          PrefetchHooks Function()
        > {
  $$CollectionTableTableTableManager(
    _$AppDatabase db,
    $CollectionTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> coverImageSubPath = const Value.absent(),
              }) => CollectionTableCompanion(
                id: id,
                name: name,
                description: description,
                coverImageSubPath: coverImageSubPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> coverImageSubPath = const Value.absent(),
              }) => CollectionTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                coverImageSubPath: coverImageSubPath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CollectionTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionTableTable,
      CollectionTableData,
      $$CollectionTableTableFilterComposer,
      $$CollectionTableTableOrderingComposer,
      $$CollectionTableTableAnnotationComposer,
      $$CollectionTableTableCreateCompanionBuilder,
      $$CollectionTableTableUpdateCompanionBuilder,
      (
        CollectionTableData,
        BaseReferences<
          _$AppDatabase,
          $CollectionTableTable,
          CollectionTableData
        >,
      ),
      CollectionTableData,
      PrefetchHooks Function()
    >;
typedef $$CollectionBookTableTableCreateCompanionBuilder =
    CollectionBookTableCompanion Function({
      Value<int> id,
      required int collectionId,
      required int bookId,
    });
typedef $$CollectionBookTableTableUpdateCompanionBuilder =
    CollectionBookTableCompanion Function({
      Value<int> id,
      Value<int> collectionId,
      Value<int> bookId,
    });

class $$CollectionBookTableTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionBookTableTable> {
  $$CollectionBookTableTableFilterComposer({
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

  ColumnFilters<int> get collectionId => $composableBuilder(
    column: $table.collectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CollectionBookTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionBookTableTable> {
  $$CollectionBookTableTableOrderingComposer({
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

  ColumnOrderings<int> get collectionId => $composableBuilder(
    column: $table.collectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionBookTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionBookTableTable> {
  $$CollectionBookTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get collectionId => $composableBuilder(
    column: $table.collectionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);
}

class $$CollectionBookTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionBookTableTable,
          CollectionBookTableData,
          $$CollectionBookTableTableFilterComposer,
          $$CollectionBookTableTableOrderingComposer,
          $$CollectionBookTableTableAnnotationComposer,
          $$CollectionBookTableTableCreateCompanionBuilder,
          $$CollectionBookTableTableUpdateCompanionBuilder,
          (
            CollectionBookTableData,
            BaseReferences<
              _$AppDatabase,
              $CollectionBookTableTable,
              CollectionBookTableData
            >,
          ),
          CollectionBookTableData,
          PrefetchHooks Function()
        > {
  $$CollectionBookTableTableTableManager(
    _$AppDatabase db,
    $CollectionBookTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionBookTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionBookTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CollectionBookTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> collectionId = const Value.absent(),
                Value<int> bookId = const Value.absent(),
              }) => CollectionBookTableCompanion(
                id: id,
                collectionId: collectionId,
                bookId: bookId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int collectionId,
                required int bookId,
              }) => CollectionBookTableCompanion.insert(
                id: id,
                collectionId: collectionId,
                bookId: bookId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CollectionBookTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionBookTableTable,
      CollectionBookTableData,
      $$CollectionBookTableTableFilterComposer,
      $$CollectionBookTableTableOrderingComposer,
      $$CollectionBookTableTableAnnotationComposer,
      $$CollectionBookTableTableCreateCompanionBuilder,
      $$CollectionBookTableTableUpdateCompanionBuilder,
      (
        CollectionBookTableData,
        BaseReferences<
          _$AppDatabase,
          $CollectionBookTableTable,
          CollectionBookTableData
        >,
      ),
      CollectionBookTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db, _db.bookTable);
  $$CollectionTableTableTableManager get collectionTable =>
      $$CollectionTableTableTableManager(_db, _db.collectionTable);
  $$CollectionBookTableTableTableManager get collectionBookTable =>
      $$CollectionBookTableTableTableManager(_db, _db.collectionBookTable);
}
