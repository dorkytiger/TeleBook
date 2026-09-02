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
    uuid,
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
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
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
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
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

  /// 跨设备稳定 ID（UUID，同步用）；本地 id 是 SQLite rowid。
  final String uuid;
  final String name;
  final List<String> localSubPaths;
  final String? coverSubPath;
  final List<String>? previewSubPaths;
  final int readCount;
  final int currentPage;
  final DateTime createdAt;
  const BookTableData({
    required this.id,
    required this.uuid,
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
    map['uuid'] = Variable<String>(uuid);
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
      uuid: Value(uuid),
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
      uuid: serializer.fromJson<String>(json['uuid']),
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
      'uuid': serializer.toJson<String>(uuid),
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
    String? uuid,
    String? name,
    List<String>? localSubPaths,
    Value<String?> coverSubPath = const Value.absent(),
    Value<List<String>?> previewSubPaths = const Value.absent(),
    int? readCount,
    int? currentPage,
    DateTime? createdAt,
  }) => BookTableData(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
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
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
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
          ..write('uuid: $uuid, ')
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
    uuid,
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
          other.uuid == this.uuid &&
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
  final Value<String> uuid;
  final Value<String> name;
  final Value<List<String>> localSubPaths;
  final Value<String?> coverSubPath;
  final Value<List<String>?> previewSubPaths;
  final Value<int> readCount;
  final Value<int> currentPage;
  final Value<DateTime> createdAt;
  const BookTableCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
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
    required String uuid,
    required String name,
    required List<String> localSubPaths,
    this.coverSubPath = const Value.absent(),
    this.previewSubPaths = const Value.absent(),
    this.readCount = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : uuid = Value(uuid),
       name = Value(name),
       localSubPaths = Value(localSubPaths);
  static Insertable<BookTableData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
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
      if (uuid != null) 'uuid': uuid,
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
    Value<String>? uuid,
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
      uuid: uuid ?? this.uuid,
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
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
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
          ..write('uuid: $uuid, ')
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

class $SettingTableTable extends SettingTable
    with TableInfo<$SettingTableTable, SettingTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingTableTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'setting_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingTableData> instance, {
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
  SettingTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingTableData(
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
  $SettingTableTable createAlias(String alias) {
    return $SettingTableTable(attachedDatabase, alias);
  }
}

class SettingTableData extends DataClass
    implements Insertable<SettingTableData> {
  final String key;
  final String value;
  const SettingTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingTableCompanion toCompanion(bool nullToAbsent) {
    return SettingTableCompanion(key: Value(key), value: Value(value));
  }

  factory SettingTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingTableData(
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

  SettingTableData copyWith({String? key, String? value}) =>
      SettingTableData(key: key ?? this.key, value: value ?? this.value);
  SettingTableData copyWithCompanion(SettingTableCompanion data) {
    return SettingTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingTableData(')
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
      (other is SettingTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingTableCompanion extends UpdateCompanion<SettingTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingTableData> custom({
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

  SettingTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingTableCompanion(
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
    return (StringBuffer('SettingTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntitySyncStateTableTable extends EntitySyncStateTable
    with TableInfo<$EntitySyncStateTableTable, EntitySyncStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitySyncStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverRevisionMeta = const VerificationMeta(
    'serverRevision',
  );
  @override
  late final GeneratedColumn<int> serverRevision = GeneratedColumn<int>(
    'server_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [entityType, entityId, serverRevision];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_sync_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntitySyncStateTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('server_revision')) {
      context.handle(
        _serverRevisionMeta,
        serverRevision.isAcceptableOrUnknown(
          data['server_revision']!,
          _serverRevisionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityType, entityId};
  @override
  EntitySyncStateTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntitySyncStateTableData(
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      serverRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_revision'],
      )!,
    );
  }

  @override
  $EntitySyncStateTableTable createAlias(String alias) {
    return $EntitySyncStateTableTable(attachedDatabase, alias);
  }
}

class EntitySyncStateTableData extends DataClass
    implements Insertable<EntitySyncStateTableData> {
  final String entityType;
  final String entityId;
  final int serverRevision;
  const EntitySyncStateTableData({
    required this.entityType,
    required this.entityId,
    required this.serverRevision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['server_revision'] = Variable<int>(serverRevision);
    return map;
  }

  EntitySyncStateTableCompanion toCompanion(bool nullToAbsent) {
    return EntitySyncStateTableCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      serverRevision: Value(serverRevision),
    );
  }

  factory EntitySyncStateTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntitySyncStateTableData(
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      serverRevision: serializer.fromJson<int>(json['serverRevision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'serverRevision': serializer.toJson<int>(serverRevision),
    };
  }

  EntitySyncStateTableData copyWith({
    String? entityType,
    String? entityId,
    int? serverRevision,
  }) => EntitySyncStateTableData(
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    serverRevision: serverRevision ?? this.serverRevision,
  );
  EntitySyncStateTableData copyWithCompanion(
    EntitySyncStateTableCompanion data,
  ) {
    return EntitySyncStateTableData(
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      serverRevision: data.serverRevision.present
          ? data.serverRevision.value
          : this.serverRevision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntitySyncStateTableData(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('serverRevision: $serverRevision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, entityId, serverRevision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntitySyncStateTableData &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.serverRevision == this.serverRevision);
}

class EntitySyncStateTableCompanion
    extends UpdateCompanion<EntitySyncStateTableData> {
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<int> serverRevision;
  final Value<int> rowid;
  const EntitySyncStateTableCompanion({
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.serverRevision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitySyncStateTableCompanion.insert({
    required String entityType,
    required String entityId,
    this.serverRevision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId);
  static Insertable<EntitySyncStateTableData> custom({
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<int>? serverRevision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (serverRevision != null) 'server_revision': serverRevision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitySyncStateTableCompanion copyWith({
    Value<String>? entityType,
    Value<String>? entityId,
    Value<int>? serverRevision,
    Value<int>? rowid,
  }) {
    return EntitySyncStateTableCompanion(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      serverRevision: serverRevision ?? this.serverRevision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (serverRevision.present) {
      map['server_revision'] = Variable<int>(serverRevision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitySyncStateTableCompanion(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('serverRevision: $serverRevision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncTaskTableTable extends SyncTaskTable
    with TableInfo<$SyncTaskTableTable, SyncTaskTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncTaskTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _changeIdMeta = const VerificationMeta(
    'changeId',
  );
  @override
  late final GeneratedColumn<String> changeId = GeneratedColumn<String>(
    'change_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
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
    changeId,
    entityType,
    entityId,
    op,
    payload,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_task_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncTaskTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('change_id')) {
      context.handle(
        _changeIdMeta,
        changeId.isAcceptableOrUnknown(data['change_id']!, _changeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_changeIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
  SyncTaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncTaskTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      changeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncTaskTableTable createAlias(String alias) {
    return $SyncTaskTableTable(attachedDatabase, alias);
  }
}

class SyncTaskTableData extends DataClass
    implements Insertable<SyncTaskTableData> {
  final int id;
  final String changeId;
  final String entityType;
  final String entityId;
  final String op;
  final String? payload;
  final String status;
  final DateTime createdAt;
  const SyncTaskTableData({
    required this.id,
    required this.changeId,
    required this.entityType,
    required this.entityId,
    required this.op,
    this.payload,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['change_id'] = Variable<String>(changeId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncTaskTableCompanion toCompanion(bool nullToAbsent) {
    return SyncTaskTableCompanion(
      id: Value(id),
      changeId: Value(changeId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      op: Value(op),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory SyncTaskTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncTaskTableData(
      id: serializer.fromJson<int>(json['id']),
      changeId: serializer.fromJson<String>(json['changeId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      payload: serializer.fromJson<String?>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'changeId': serializer.toJson<String>(changeId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'payload': serializer.toJson<String?>(payload),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncTaskTableData copyWith({
    int? id,
    String? changeId,
    String? entityType,
    String? entityId,
    String? op,
    Value<String?> payload = const Value.absent(),
    String? status,
    DateTime? createdAt,
  }) => SyncTaskTableData(
    id: id ?? this.id,
    changeId: changeId ?? this.changeId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    payload: payload.present ? payload.value : this.payload,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncTaskTableData copyWithCompanion(SyncTaskTableCompanion data) {
    return SyncTaskTableData(
      id: data.id.present ? data.id.value : this.id,
      changeId: data.changeId.present ? data.changeId.value : this.changeId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncTaskTableData(')
          ..write('id: $id, ')
          ..write('changeId: $changeId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    changeId,
    entityType,
    entityId,
    op,
    payload,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncTaskTableData &&
          other.id == this.id &&
          other.changeId == this.changeId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SyncTaskTableCompanion extends UpdateCompanion<SyncTaskTableData> {
  final Value<int> id;
  final Value<String> changeId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String?> payload;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const SyncTaskTableCompanion({
    this.id = const Value.absent(),
    this.changeId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncTaskTableCompanion.insert({
    this.id = const Value.absent(),
    required String changeId,
    required String entityType,
    required String entityId,
    required String op,
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : changeId = Value(changeId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       op = Value(op);
  static Insertable<SyncTaskTableData> custom({
    Expression<int>? id,
    Expression<String>? changeId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (changeId != null) 'change_id': changeId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncTaskTableCompanion copyWith({
    Value<int>? id,
    Value<String>? changeId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? op,
    Value<String?>? payload,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return SyncTaskTableCompanion(
      id: id ?? this.id,
      changeId: changeId ?? this.changeId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (changeId.present) {
      map['change_id'] = Variable<String>(changeId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncTaskTableCompanion(')
          ..write('id: $id, ')
          ..write('changeId: $changeId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncOpTableTable extends SyncOpTable
    with TableInfo<$SyncOpTableTable, SyncOpTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOpTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('waiting'),
  );
  static const VerificationMeta _totalBooksMeta = const VerificationMeta(
    'totalBooks',
  );
  @override
  late final GeneratedColumn<int> totalBooks = GeneratedColumn<int>(
    'total_books',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _doneBooksMeta = const VerificationMeta(
    'doneBooks',
  );
  @override
  late final GeneratedColumn<int> doneBooks = GeneratedColumn<int>(
    'done_books',
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
  static const VerificationMeta _totalPagesMeta = const VerificationMeta(
    'totalPages',
  );
  @override
  late final GeneratedColumn<int> totalPages = GeneratedColumn<int>(
    'total_pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    status,
    totalBooks,
    doneBooks,
    currentPage,
    totalPages,
    error,
    title,
    payload,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_op_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOpTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total_books')) {
      context.handle(
        _totalBooksMeta,
        totalBooks.isAcceptableOrUnknown(data['total_books']!, _totalBooksMeta),
      );
    }
    if (data.containsKey('done_books')) {
      context.handle(
        _doneBooksMeta,
        doneBooks.isAcceptableOrUnknown(data['done_books']!, _doneBooksMeta),
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
    if (data.containsKey('total_pages')) {
      context.handle(
        _totalPagesMeta,
        totalPages.isAcceptableOrUnknown(data['total_pages']!, _totalPagesMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOpTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOpTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalBooks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_books'],
      )!,
      doneBooks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_books'],
      )!,
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      )!,
      totalPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pages'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
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
  $SyncOpTableTable createAlias(String alias) {
    return $SyncOpTableTable(attachedDatabase, alias);
  }
}

class SyncOpTableData extends DataClass implements Insertable<SyncOpTableData> {
  /// 主键 + 队列顺序（FIFO，串行执行）。
  final int id;

  /// 任务类型：init(初始化) / refresh(刷新) / upload_snapshot(上传快照) / manual(手动同步)。
  final String type;

  /// 状态：running(进行中) / waiting(等待中) / done(成功) / failed(失败) / interrupted(中断)。
  final String status;

  /// 进度：总书数 / 已完成书数。
  final int totalBooks;
  final int doneBooks;

  /// 当前书进度（页 a / 页 b）。
  final int currentPage;
  final int totalPages;

  /// 错误信息（失败时）。
  final String? error;

  /// 用户可见的任务名称（如「初始化同步」「刷新同步」）。
  final String title;

  /// 组任务规格（v10 起）：内容型变更等任务的执行数据（如本地变更推送的
  /// 书清单 JSON）。落库后重启可据此重建执行（§8.0 恢复，替代纯闭包）。
  final String? payload;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncOpTableData({
    required this.id,
    required this.type,
    required this.status,
    required this.totalBooks,
    required this.doneBooks,
    required this.currentPage,
    required this.totalPages,
    this.error,
    required this.title,
    this.payload,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['total_books'] = Variable<int>(totalBooks);
    map['done_books'] = Variable<int>(doneBooks);
    map['current_page'] = Variable<int>(currentPage);
    map['total_pages'] = Variable<int>(totalPages);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncOpTableCompanion toCompanion(bool nullToAbsent) {
    return SyncOpTableCompanion(
      id: Value(id),
      type: Value(type),
      status: Value(status),
      totalBooks: Value(totalBooks),
      doneBooks: Value(doneBooks),
      currentPage: Value(currentPage),
      totalPages: Value(totalPages),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      title: Value(title),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncOpTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOpTableData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      totalBooks: serializer.fromJson<int>(json['totalBooks']),
      doneBooks: serializer.fromJson<int>(json['doneBooks']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
      totalPages: serializer.fromJson<int>(json['totalPages']),
      error: serializer.fromJson<String?>(json['error']),
      title: serializer.fromJson<String>(json['title']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'totalBooks': serializer.toJson<int>(totalBooks),
      'doneBooks': serializer.toJson<int>(doneBooks),
      'currentPage': serializer.toJson<int>(currentPage),
      'totalPages': serializer.toJson<int>(totalPages),
      'error': serializer.toJson<String?>(error),
      'title': serializer.toJson<String>(title),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncOpTableData copyWith({
    int? id,
    String? type,
    String? status,
    int? totalBooks,
    int? doneBooks,
    int? currentPage,
    int? totalPages,
    Value<String?> error = const Value.absent(),
    String? title,
    Value<String?> payload = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncOpTableData(
    id: id ?? this.id,
    type: type ?? this.type,
    status: status ?? this.status,
    totalBooks: totalBooks ?? this.totalBooks,
    doneBooks: doneBooks ?? this.doneBooks,
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    error: error.present ? error.value : this.error,
    title: title ?? this.title,
    payload: payload.present ? payload.value : this.payload,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncOpTableData copyWithCompanion(SyncOpTableCompanion data) {
    return SyncOpTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      totalBooks: data.totalBooks.present
          ? data.totalBooks.value
          : this.totalBooks,
      doneBooks: data.doneBooks.present ? data.doneBooks.value : this.doneBooks,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
      totalPages: data.totalPages.present
          ? data.totalPages.value
          : this.totalPages,
      error: data.error.present ? data.error.value : this.error,
      title: data.title.present ? data.title.value : this.title,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOpTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('totalBooks: $totalBooks, ')
          ..write('doneBooks: $doneBooks, ')
          ..write('currentPage: $currentPage, ')
          ..write('totalPages: $totalPages, ')
          ..write('error: $error, ')
          ..write('title: $title, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    status,
    totalBooks,
    doneBooks,
    currentPage,
    totalPages,
    error,
    title,
    payload,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOpTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.status == this.status &&
          other.totalBooks == this.totalBooks &&
          other.doneBooks == this.doneBooks &&
          other.currentPage == this.currentPage &&
          other.totalPages == this.totalPages &&
          other.error == this.error &&
          other.title == this.title &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncOpTableCompanion extends UpdateCompanion<SyncOpTableData> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> status;
  final Value<int> totalBooks;
  final Value<int> doneBooks;
  final Value<int> currentPage;
  final Value<int> totalPages;
  final Value<String?> error;
  final Value<String> title;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SyncOpTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.totalBooks = const Value.absent(),
    this.doneBooks = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.error = const Value.absent(),
    this.title = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SyncOpTableCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    this.status = const Value.absent(),
    this.totalBooks = const Value.absent(),
    this.doneBooks = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.error = const Value.absent(),
    required String title,
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : type = Value(type),
       title = Value(title);
  static Insertable<SyncOpTableData> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? status,
    Expression<int>? totalBooks,
    Expression<int>? doneBooks,
    Expression<int>? currentPage,
    Expression<int>? totalPages,
    Expression<String>? error,
    Expression<String>? title,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (totalBooks != null) 'total_books': totalBooks,
      if (doneBooks != null) 'done_books': doneBooks,
      if (currentPage != null) 'current_page': currentPage,
      if (totalPages != null) 'total_pages': totalPages,
      if (error != null) 'error': error,
      if (title != null) 'title': title,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SyncOpTableCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? status,
    Value<int>? totalBooks,
    Value<int>? doneBooks,
    Value<int>? currentPage,
    Value<int>? totalPages,
    Value<String?>? error,
    Value<String>? title,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SyncOpTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      totalBooks: totalBooks ?? this.totalBooks,
      doneBooks: doneBooks ?? this.doneBooks,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      error: error ?? this.error,
      title: title ?? this.title,
      payload: payload ?? this.payload,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalBooks.present) {
      map['total_books'] = Variable<int>(totalBooks.value);
    }
    if (doneBooks.present) {
      map['done_books'] = Variable<int>(doneBooks.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (totalPages.present) {
      map['total_pages'] = Variable<int>(totalPages.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
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
    return (StringBuffer('SyncOpTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('totalBooks: $totalBooks, ')
          ..write('doneBooks: $doneBooks, ')
          ..write('currentPage: $currentPage, ')
          ..write('totalPages: $totalPages, ')
          ..write('error: $error, ')
          ..write('title: $title, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncDownTableTable extends SyncDownTable
    with TableInfo<$SyncDownTableTable, SyncDownTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncDownTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _coverHashMeta = const VerificationMeta(
    'coverHash',
  );
  @override
  late final GeneratedColumn<String> coverHash = GeneratedColumn<String>(
    'cover_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _totalFilesMeta = const VerificationMeta(
    'totalFiles',
  );
  @override
  late final GeneratedColumn<int> totalFiles = GeneratedColumn<int>(
    'total_files',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _doneFilesMeta = const VerificationMeta(
    'doneFiles',
  );
  @override
  late final GeneratedColumn<int> doneFiles = GeneratedColumn<int>(
    'done_files',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _bookStatusMeta = const VerificationMeta(
    'bookStatus',
  );
  @override
  late final GeneratedColumn<String> bookStatus = GeneratedColumn<String>(
    'book_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('等待'),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    name,
    coverHash,
    currentPage,
    totalFiles,
    doneFiles,
    status,
    bookStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_down_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncDownTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cover_hash')) {
      context.handle(
        _coverHashMeta,
        coverHash.isAcceptableOrUnknown(data['cover_hash']!, _coverHashMeta),
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
    if (data.containsKey('total_files')) {
      context.handle(
        _totalFilesMeta,
        totalFiles.isAcceptableOrUnknown(data['total_files']!, _totalFilesMeta),
      );
    }
    if (data.containsKey('done_files')) {
      context.handle(
        _doneFilesMeta,
        doneFiles.isAcceptableOrUnknown(data['done_files']!, _doneFilesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('book_status')) {
      context.handle(
        _bookStatusMeta,
        bookStatus.isAcceptableOrUnknown(data['book_status']!, _bookStatusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  SyncDownTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncDownTableData(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      coverHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_hash'],
      ),
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      )!,
      totalFiles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_files'],
      )!,
      doneFiles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_files'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      bookStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_status'],
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
  $SyncDownTableTable createAlias(String alias) {
    return $SyncDownTableTable(attachedDatabase, alias);
  }
}

class SyncDownTableData extends DataClass
    implements Insertable<SyncDownTableData> {
  /// 书籍稳定同步 ID（服务器分配，§6）。
  final String uuid;
  final String name;
  final String? coverHash;
  final int currentPage;

  /// 文件总数 / 已下载数。
  final int totalFiles;
  final int doneFiles;

  /// 整体任务状态：pending(待下载) / downloading / done(全部完成) / failed。
  final String status;

  /// 该书的 user-facing 状态（明细面板显示）。
  final String bookStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncDownTableData({
    required this.uuid,
    required this.name,
    this.coverHash,
    required this.currentPage,
    required this.totalFiles,
    required this.doneFiles,
    required this.status,
    required this.bookStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || coverHash != null) {
      map['cover_hash'] = Variable<String>(coverHash);
    }
    map['current_page'] = Variable<int>(currentPage);
    map['total_files'] = Variable<int>(totalFiles);
    map['done_files'] = Variable<int>(doneFiles);
    map['status'] = Variable<String>(status);
    map['book_status'] = Variable<String>(bookStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncDownTableCompanion toCompanion(bool nullToAbsent) {
    return SyncDownTableCompanion(
      uuid: Value(uuid),
      name: Value(name),
      coverHash: coverHash == null && nullToAbsent
          ? const Value.absent()
          : Value(coverHash),
      currentPage: Value(currentPage),
      totalFiles: Value(totalFiles),
      doneFiles: Value(doneFiles),
      status: Value(status),
      bookStatus: Value(bookStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncDownTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncDownTableData(
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      coverHash: serializer.fromJson<String?>(json['coverHash']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
      totalFiles: serializer.fromJson<int>(json['totalFiles']),
      doneFiles: serializer.fromJson<int>(json['doneFiles']),
      status: serializer.fromJson<String>(json['status']),
      bookStatus: serializer.fromJson<String>(json['bookStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'coverHash': serializer.toJson<String?>(coverHash),
      'currentPage': serializer.toJson<int>(currentPage),
      'totalFiles': serializer.toJson<int>(totalFiles),
      'doneFiles': serializer.toJson<int>(doneFiles),
      'status': serializer.toJson<String>(status),
      'bookStatus': serializer.toJson<String>(bookStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncDownTableData copyWith({
    String? uuid,
    String? name,
    Value<String?> coverHash = const Value.absent(),
    int? currentPage,
    int? totalFiles,
    int? doneFiles,
    String? status,
    String? bookStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncDownTableData(
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    coverHash: coverHash.present ? coverHash.value : this.coverHash,
    currentPage: currentPage ?? this.currentPage,
    totalFiles: totalFiles ?? this.totalFiles,
    doneFiles: doneFiles ?? this.doneFiles,
    status: status ?? this.status,
    bookStatus: bookStatus ?? this.bookStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncDownTableData copyWithCompanion(SyncDownTableCompanion data) {
    return SyncDownTableData(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      coverHash: data.coverHash.present ? data.coverHash.value : this.coverHash,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
      totalFiles: data.totalFiles.present
          ? data.totalFiles.value
          : this.totalFiles,
      doneFiles: data.doneFiles.present ? data.doneFiles.value : this.doneFiles,
      status: data.status.present ? data.status.value : this.status,
      bookStatus: data.bookStatus.present
          ? data.bookStatus.value
          : this.bookStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncDownTableData(')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('coverHash: $coverHash, ')
          ..write('currentPage: $currentPage, ')
          ..write('totalFiles: $totalFiles, ')
          ..write('doneFiles: $doneFiles, ')
          ..write('status: $status, ')
          ..write('bookStatus: $bookStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    name,
    coverHash,
    currentPage,
    totalFiles,
    doneFiles,
    status,
    bookStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncDownTableData &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.coverHash == this.coverHash &&
          other.currentPage == this.currentPage &&
          other.totalFiles == this.totalFiles &&
          other.doneFiles == this.doneFiles &&
          other.status == this.status &&
          other.bookStatus == this.bookStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncDownTableCompanion extends UpdateCompanion<SyncDownTableData> {
  final Value<String> uuid;
  final Value<String> name;
  final Value<String?> coverHash;
  final Value<int> currentPage;
  final Value<int> totalFiles;
  final Value<int> doneFiles;
  final Value<String> status;
  final Value<String> bookStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncDownTableCompanion({
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.coverHash = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.totalFiles = const Value.absent(),
    this.doneFiles = const Value.absent(),
    this.status = const Value.absent(),
    this.bookStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncDownTableCompanion.insert({
    required String uuid,
    required String name,
    this.coverHash = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.totalFiles = const Value.absent(),
    this.doneFiles = const Value.absent(),
    this.status = const Value.absent(),
    this.bookStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       name = Value(name);
  static Insertable<SyncDownTableData> custom({
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? coverHash,
    Expression<int>? currentPage,
    Expression<int>? totalFiles,
    Expression<int>? doneFiles,
    Expression<String>? status,
    Expression<String>? bookStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (coverHash != null) 'cover_hash': coverHash,
      if (currentPage != null) 'current_page': currentPage,
      if (totalFiles != null) 'total_files': totalFiles,
      if (doneFiles != null) 'done_files': doneFiles,
      if (status != null) 'status': status,
      if (bookStatus != null) 'book_status': bookStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncDownTableCompanion copyWith({
    Value<String>? uuid,
    Value<String>? name,
    Value<String?>? coverHash,
    Value<int>? currentPage,
    Value<int>? totalFiles,
    Value<int>? doneFiles,
    Value<String>? status,
    Value<String>? bookStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncDownTableCompanion(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      coverHash: coverHash ?? this.coverHash,
      currentPage: currentPage ?? this.currentPage,
      totalFiles: totalFiles ?? this.totalFiles,
      doneFiles: doneFiles ?? this.doneFiles,
      status: status ?? this.status,
      bookStatus: bookStatus ?? this.bookStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coverHash.present) {
      map['cover_hash'] = Variable<String>(coverHash.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (totalFiles.present) {
      map['total_files'] = Variable<int>(totalFiles.value);
    }
    if (doneFiles.present) {
      map['done_files'] = Variable<int>(doneFiles.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bookStatus.present) {
      map['book_status'] = Variable<String>(bookStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncDownTableCompanion(')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('coverHash: $coverHash, ')
          ..write('currentPage: $currentPage, ')
          ..write('totalFiles: $totalFiles, ')
          ..write('doneFiles: $doneFiles, ')
          ..write('status: $status, ')
          ..write('bookStatus: $bookStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncDownFileTableTable extends SyncDownFileTable
    with TableInfo<$SyncDownFileTableTable, SyncDownFileTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncDownFileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relPathMeta = const VerificationMeta(
    'relPath',
  );
  @override
  late final GeneratedColumn<String> relPath = GeneratedColumn<String>(
    'rel_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
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
    uuid,
    relPath,
    hash,
    size,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_down_file_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncDownFileTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('rel_path')) {
      context.handle(
        _relPathMeta,
        relPath.isAcceptableOrUnknown(data['rel_path']!, _relPathMeta),
      );
    } else if (isInserting) {
      context.missing(_relPathMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
  Set<GeneratedColumn> get $primaryKey => {uuid, relPath};
  @override
  SyncDownFileTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncDownFileTableData(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      relPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rel_path'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncDownFileTableTable createAlias(String alias) {
    return $SyncDownFileTableTable(attachedDatabase, alias);
  }
}

class SyncDownFileTableData extends DataClass
    implements Insertable<SyncDownFileTableData> {
  /// 所属书 uuid。
  final String uuid;

  /// 书籍内相对路径（如 cover.jpg / original/0000000）。
  final String relPath;
  final String hash;
  final int size;

  /// 文件状态：pending(待下载) / syncing(下载中) / done(已完成) / failed(失败)。
  final String status;
  final DateTime createdAt;
  const SyncDownFileTableData({
    required this.uuid,
    required this.relPath,
    required this.hash,
    required this.size,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['rel_path'] = Variable<String>(relPath);
    map['hash'] = Variable<String>(hash);
    map['size'] = Variable<int>(size);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncDownFileTableCompanion toCompanion(bool nullToAbsent) {
    return SyncDownFileTableCompanion(
      uuid: Value(uuid),
      relPath: Value(relPath),
      hash: Value(hash),
      size: Value(size),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory SyncDownFileTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncDownFileTableData(
      uuid: serializer.fromJson<String>(json['uuid']),
      relPath: serializer.fromJson<String>(json['relPath']),
      hash: serializer.fromJson<String>(json['hash']),
      size: serializer.fromJson<int>(json['size']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'relPath': serializer.toJson<String>(relPath),
      'hash': serializer.toJson<String>(hash),
      'size': serializer.toJson<int>(size),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncDownFileTableData copyWith({
    String? uuid,
    String? relPath,
    String? hash,
    int? size,
    String? status,
    DateTime? createdAt,
  }) => SyncDownFileTableData(
    uuid: uuid ?? this.uuid,
    relPath: relPath ?? this.relPath,
    hash: hash ?? this.hash,
    size: size ?? this.size,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncDownFileTableData copyWithCompanion(SyncDownFileTableCompanion data) {
    return SyncDownFileTableData(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      relPath: data.relPath.present ? data.relPath.value : this.relPath,
      hash: data.hash.present ? data.hash.value : this.hash,
      size: data.size.present ? data.size.value : this.size,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncDownFileTableData(')
          ..write('uuid: $uuid, ')
          ..write('relPath: $relPath, ')
          ..write('hash: $hash, ')
          ..write('size: $size, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uuid, relPath, hash, size, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncDownFileTableData &&
          other.uuid == this.uuid &&
          other.relPath == this.relPath &&
          other.hash == this.hash &&
          other.size == this.size &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SyncDownFileTableCompanion
    extends UpdateCompanion<SyncDownFileTableData> {
  final Value<String> uuid;
  final Value<String> relPath;
  final Value<String> hash;
  final Value<int> size;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncDownFileTableCompanion({
    this.uuid = const Value.absent(),
    this.relPath = const Value.absent(),
    this.hash = const Value.absent(),
    this.size = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncDownFileTableCompanion.insert({
    required String uuid,
    required String relPath,
    required String hash,
    this.size = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       relPath = Value(relPath),
       hash = Value(hash);
  static Insertable<SyncDownFileTableData> custom({
    Expression<String>? uuid,
    Expression<String>? relPath,
    Expression<String>? hash,
    Expression<int>? size,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (relPath != null) 'rel_path': relPath,
      if (hash != null) 'hash': hash,
      if (size != null) 'size': size,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncDownFileTableCompanion copyWith({
    Value<String>? uuid,
    Value<String>? relPath,
    Value<String>? hash,
    Value<int>? size,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SyncDownFileTableCompanion(
      uuid: uuid ?? this.uuid,
      relPath: relPath ?? this.relPath,
      hash: hash ?? this.hash,
      size: size ?? this.size,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (relPath.present) {
      map['rel_path'] = Variable<String>(relPath.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncDownFileTableCompanion(')
          ..write('uuid: $uuid, ')
          ..write('relPath: $relPath, ')
          ..write('hash: $hash, ')
          ..write('size: $size, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncUploadTableTable extends SyncUploadTable
    with TableInfo<$SyncUploadTableTable, SyncUploadTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncUploadTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _totalFilesMeta = const VerificationMeta(
    'totalFiles',
  );
  @override
  late final GeneratedColumn<int> totalFiles = GeneratedColumn<int>(
    'total_files',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _doneFilesMeta = const VerificationMeta(
    'doneFiles',
  );
  @override
  late final GeneratedColumn<int> doneFiles = GeneratedColumn<int>(
    'done_files',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dataVersionMeta = const VerificationMeta(
    'dataVersion',
  );
  @override
  late final GeneratedColumn<String> dataVersion = GeneratedColumn<String>(
    'data_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _bookStatusMeta = const VerificationMeta(
    'bookStatus',
  );
  @override
  late final GeneratedColumn<String> bookStatus = GeneratedColumn<String>(
    'book_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('等待'),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    name,
    totalFiles,
    doneFiles,
    dataVersion,
    status,
    bookStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_upload_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncUploadTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('total_files')) {
      context.handle(
        _totalFilesMeta,
        totalFiles.isAcceptableOrUnknown(data['total_files']!, _totalFilesMeta),
      );
    }
    if (data.containsKey('done_files')) {
      context.handle(
        _doneFilesMeta,
        doneFiles.isAcceptableOrUnknown(data['done_files']!, _doneFilesMeta),
      );
    }
    if (data.containsKey('data_version')) {
      context.handle(
        _dataVersionMeta,
        dataVersion.isAcceptableOrUnknown(
          data['data_version']!,
          _dataVersionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('book_status')) {
      context.handle(
        _bookStatusMeta,
        bookStatus.isAcceptableOrUnknown(data['book_status']!, _bookStatusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  SyncUploadTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncUploadTableData(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      totalFiles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_files'],
      )!,
      doneFiles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_files'],
      )!,
      dataVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_version'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      bookStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_status'],
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
  $SyncUploadTableTable createAlias(String alias) {
    return $SyncUploadTableTable(attachedDatabase, alias);
  }
}

class SyncUploadTableData extends DataClass
    implements Insertable<SyncUploadTableData> {
  /// 服务器分配的 uuid（§6；init 后回填）。
  final String uuid;
  final String name;

  /// 文件总数 / 已上传数。
  final int totalFiles;
  final int doneFiles;

  /// 客户端数据版本（断点续传/并发匹配，§4）。
  final String dataVersion;

  /// 整体任务状态：pending(待上传) / uploading / done(全部完成) / failed。
  final String status;

  /// 该书 user-facing 状态（明细面板显示）。
  final String bookStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncUploadTableData({
    required this.uuid,
    required this.name,
    required this.totalFiles,
    required this.doneFiles,
    required this.dataVersion,
    required this.status,
    required this.bookStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['total_files'] = Variable<int>(totalFiles);
    map['done_files'] = Variable<int>(doneFiles);
    map['data_version'] = Variable<String>(dataVersion);
    map['status'] = Variable<String>(status);
    map['book_status'] = Variable<String>(bookStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncUploadTableCompanion toCompanion(bool nullToAbsent) {
    return SyncUploadTableCompanion(
      uuid: Value(uuid),
      name: Value(name),
      totalFiles: Value(totalFiles),
      doneFiles: Value(doneFiles),
      dataVersion: Value(dataVersion),
      status: Value(status),
      bookStatus: Value(bookStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncUploadTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncUploadTableData(
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      totalFiles: serializer.fromJson<int>(json['totalFiles']),
      doneFiles: serializer.fromJson<int>(json['doneFiles']),
      dataVersion: serializer.fromJson<String>(json['dataVersion']),
      status: serializer.fromJson<String>(json['status']),
      bookStatus: serializer.fromJson<String>(json['bookStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'totalFiles': serializer.toJson<int>(totalFiles),
      'doneFiles': serializer.toJson<int>(doneFiles),
      'dataVersion': serializer.toJson<String>(dataVersion),
      'status': serializer.toJson<String>(status),
      'bookStatus': serializer.toJson<String>(bookStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncUploadTableData copyWith({
    String? uuid,
    String? name,
    int? totalFiles,
    int? doneFiles,
    String? dataVersion,
    String? status,
    String? bookStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncUploadTableData(
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    totalFiles: totalFiles ?? this.totalFiles,
    doneFiles: doneFiles ?? this.doneFiles,
    dataVersion: dataVersion ?? this.dataVersion,
    status: status ?? this.status,
    bookStatus: bookStatus ?? this.bookStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncUploadTableData copyWithCompanion(SyncUploadTableCompanion data) {
    return SyncUploadTableData(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      totalFiles: data.totalFiles.present
          ? data.totalFiles.value
          : this.totalFiles,
      doneFiles: data.doneFiles.present ? data.doneFiles.value : this.doneFiles,
      dataVersion: data.dataVersion.present
          ? data.dataVersion.value
          : this.dataVersion,
      status: data.status.present ? data.status.value : this.status,
      bookStatus: data.bookStatus.present
          ? data.bookStatus.value
          : this.bookStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncUploadTableData(')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('totalFiles: $totalFiles, ')
          ..write('doneFiles: $doneFiles, ')
          ..write('dataVersion: $dataVersion, ')
          ..write('status: $status, ')
          ..write('bookStatus: $bookStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    name,
    totalFiles,
    doneFiles,
    dataVersion,
    status,
    bookStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncUploadTableData &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.totalFiles == this.totalFiles &&
          other.doneFiles == this.doneFiles &&
          other.dataVersion == this.dataVersion &&
          other.status == this.status &&
          other.bookStatus == this.bookStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncUploadTableCompanion extends UpdateCompanion<SyncUploadTableData> {
  final Value<String> uuid;
  final Value<String> name;
  final Value<int> totalFiles;
  final Value<int> doneFiles;
  final Value<String> dataVersion;
  final Value<String> status;
  final Value<String> bookStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncUploadTableCompanion({
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.totalFiles = const Value.absent(),
    this.doneFiles = const Value.absent(),
    this.dataVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.bookStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncUploadTableCompanion.insert({
    required String uuid,
    required String name,
    this.totalFiles = const Value.absent(),
    this.doneFiles = const Value.absent(),
    this.dataVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.bookStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       name = Value(name);
  static Insertable<SyncUploadTableData> custom({
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<int>? totalFiles,
    Expression<int>? doneFiles,
    Expression<String>? dataVersion,
    Expression<String>? status,
    Expression<String>? bookStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (totalFiles != null) 'total_files': totalFiles,
      if (doneFiles != null) 'done_files': doneFiles,
      if (dataVersion != null) 'data_version': dataVersion,
      if (status != null) 'status': status,
      if (bookStatus != null) 'book_status': bookStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncUploadTableCompanion copyWith({
    Value<String>? uuid,
    Value<String>? name,
    Value<int>? totalFiles,
    Value<int>? doneFiles,
    Value<String>? dataVersion,
    Value<String>? status,
    Value<String>? bookStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncUploadTableCompanion(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      totalFiles: totalFiles ?? this.totalFiles,
      doneFiles: doneFiles ?? this.doneFiles,
      dataVersion: dataVersion ?? this.dataVersion,
      status: status ?? this.status,
      bookStatus: bookStatus ?? this.bookStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (totalFiles.present) {
      map['total_files'] = Variable<int>(totalFiles.value);
    }
    if (doneFiles.present) {
      map['done_files'] = Variable<int>(doneFiles.value);
    }
    if (dataVersion.present) {
      map['data_version'] = Variable<String>(dataVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bookStatus.present) {
      map['book_status'] = Variable<String>(bookStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncUploadTableCompanion(')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('totalFiles: $totalFiles, ')
          ..write('doneFiles: $doneFiles, ')
          ..write('dataVersion: $dataVersion, ')
          ..write('status: $status, ')
          ..write('bookStatus: $bookStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
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
  late final $SettingTableTable settingTable = $SettingTableTable(this);
  late final $EntitySyncStateTableTable entitySyncStateTable =
      $EntitySyncStateTableTable(this);
  late final $SyncTaskTableTable syncTaskTable = $SyncTaskTableTable(this);
  late final $SyncOpTableTable syncOpTable = $SyncOpTableTable(this);
  late final $SyncDownTableTable syncDownTable = $SyncDownTableTable(this);
  late final $SyncDownFileTableTable syncDownFileTable =
      $SyncDownFileTableTable(this);
  late final $SyncUploadTableTable syncUploadTable = $SyncUploadTableTable(
    this,
  );
  late final BookLocalDatasource bookLocalDatasource = BookLocalDatasource(
    this as AppDatabase,
  );
  late final CollectionLocalDatasource collectionLocalDatasource =
      CollectionLocalDatasource(this as AppDatabase);
  late final CollectionBookLocalDatasource collectionBookLocalDatasource =
      CollectionBookLocalDatasource(this as AppDatabase);
  late final SettingLocalDatasource settingLocalDatasource =
      SettingLocalDatasource(this as AppDatabase);
  late final SyncStateLocalDatasource syncStateLocalDatasource =
      SyncStateLocalDatasource(this as AppDatabase);
  late final SyncTaskLocalDatasource syncTaskLocalDatasource =
      SyncTaskLocalDatasource(this as AppDatabase);
  late final SyncOpLocalDatasource syncOpLocalDatasource =
      SyncOpLocalDatasource(this as AppDatabase);
  late final SyncDownLocalDatasource syncDownLocalDatasource =
      SyncDownLocalDatasource(this as AppDatabase);
  late final SyncUploadLocalDatasource syncUploadLocalDatasource =
      SyncUploadLocalDatasource(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bookTable,
    collectionTable,
    collectionBookTable,
    settingTable,
    entitySyncStateTable,
    syncTaskTable,
    syncOpTable,
    syncDownTable,
    syncDownFileTable,
    syncUploadTable,
  ];
}

typedef $$BookTableTableCreateCompanionBuilder =
    BookTableCompanion Function({
      Value<int> id,
      required String uuid,
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
      Value<String> uuid,
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

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
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

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
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

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

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
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<List<String>> localSubPaths = const Value.absent(),
                Value<String?> coverSubPath = const Value.absent(),
                Value<List<String>?> previewSubPaths = const Value.absent(),
                Value<int> readCount = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookTableCompanion(
                id: id,
                uuid: uuid,
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
                required String uuid,
                required String name,
                required List<String> localSubPaths,
                Value<String?> coverSubPath = const Value.absent(),
                Value<List<String>?> previewSubPaths = const Value.absent(),
                Value<int> readCount = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookTableCompanion.insert(
                id: id,
                uuid: uuid,
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
typedef $$SettingTableTableCreateCompanionBuilder =
    SettingTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingTableTableUpdateCompanionBuilder =
    SettingTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingTableTable> {
  $$SettingTableTableFilterComposer({
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

class $$SettingTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingTableTable> {
  $$SettingTableTableOrderingComposer({
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

class $$SettingTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingTableTable> {
  $$SettingTableTableAnnotationComposer({
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

class $$SettingTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingTableTable,
          SettingTableData,
          $$SettingTableTableFilterComposer,
          $$SettingTableTableOrderingComposer,
          $$SettingTableTableAnnotationComposer,
          $$SettingTableTableCreateCompanionBuilder,
          $$SettingTableTableUpdateCompanionBuilder,
          (
            SettingTableData,
            BaseReferences<_$AppDatabase, $SettingTableTable, SettingTableData>,
          ),
          SettingTableData,
          PrefetchHooks Function()
        > {
  $$SettingTableTableTableManager(_$AppDatabase db, $SettingTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingTableCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingTableTable,
      SettingTableData,
      $$SettingTableTableFilterComposer,
      $$SettingTableTableOrderingComposer,
      $$SettingTableTableAnnotationComposer,
      $$SettingTableTableCreateCompanionBuilder,
      $$SettingTableTableUpdateCompanionBuilder,
      (
        SettingTableData,
        BaseReferences<_$AppDatabase, $SettingTableTable, SettingTableData>,
      ),
      SettingTableData,
      PrefetchHooks Function()
    >;
typedef $$EntitySyncStateTableTableCreateCompanionBuilder =
    EntitySyncStateTableCompanion Function({
      required String entityType,
      required String entityId,
      Value<int> serverRevision,
      Value<int> rowid,
    });
typedef $$EntitySyncStateTableTableUpdateCompanionBuilder =
    EntitySyncStateTableCompanion Function({
      Value<String> entityType,
      Value<String> entityId,
      Value<int> serverRevision,
      Value<int> rowid,
    });

class $$EntitySyncStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $EntitySyncStateTableTable> {
  $$EntitySyncStateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverRevision => $composableBuilder(
    column: $table.serverRevision,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntitySyncStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitySyncStateTableTable> {
  $$EntitySyncStateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRevision => $composableBuilder(
    column: $table.serverRevision,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntitySyncStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitySyncStateTableTable> {
  $$EntitySyncStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<int> get serverRevision => $composableBuilder(
    column: $table.serverRevision,
    builder: (column) => column,
  );
}

class $$EntitySyncStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntitySyncStateTableTable,
          EntitySyncStateTableData,
          $$EntitySyncStateTableTableFilterComposer,
          $$EntitySyncStateTableTableOrderingComposer,
          $$EntitySyncStateTableTableAnnotationComposer,
          $$EntitySyncStateTableTableCreateCompanionBuilder,
          $$EntitySyncStateTableTableUpdateCompanionBuilder,
          (
            EntitySyncStateTableData,
            BaseReferences<
              _$AppDatabase,
              $EntitySyncStateTableTable,
              EntitySyncStateTableData
            >,
          ),
          EntitySyncStateTableData,
          PrefetchHooks Function()
        > {
  $$EntitySyncStateTableTableTableManager(
    _$AppDatabase db,
    $EntitySyncStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitySyncStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitySyncStateTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EntitySyncStateTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<int> serverRevision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitySyncStateTableCompanion(
                entityType: entityType,
                entityId: entityId,
                serverRevision: serverRevision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityType,
                required String entityId,
                Value<int> serverRevision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitySyncStateTableCompanion.insert(
                entityType: entityType,
                entityId: entityId,
                serverRevision: serverRevision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntitySyncStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntitySyncStateTableTable,
      EntitySyncStateTableData,
      $$EntitySyncStateTableTableFilterComposer,
      $$EntitySyncStateTableTableOrderingComposer,
      $$EntitySyncStateTableTableAnnotationComposer,
      $$EntitySyncStateTableTableCreateCompanionBuilder,
      $$EntitySyncStateTableTableUpdateCompanionBuilder,
      (
        EntitySyncStateTableData,
        BaseReferences<
          _$AppDatabase,
          $EntitySyncStateTableTable,
          EntitySyncStateTableData
        >,
      ),
      EntitySyncStateTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncTaskTableTableCreateCompanionBuilder =
    SyncTaskTableCompanion Function({
      Value<int> id,
      required String changeId,
      required String entityType,
      required String entityId,
      required String op,
      Value<String?> payload,
      Value<String> status,
      Value<DateTime> createdAt,
    });
typedef $$SyncTaskTableTableUpdateCompanionBuilder =
    SyncTaskTableCompanion Function({
      Value<int> id,
      Value<String> changeId,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> op,
      Value<String?> payload,
      Value<String> status,
      Value<DateTime> createdAt,
    });

class $$SyncTaskTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncTaskTableTable> {
  $$SyncTaskTableTableFilterComposer({
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

  ColumnFilters<String> get changeId => $composableBuilder(
    column: $table.changeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncTaskTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncTaskTableTable> {
  $$SyncTaskTableTableOrderingComposer({
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

  ColumnOrderings<String> get changeId => $composableBuilder(
    column: $table.changeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncTaskTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncTaskTableTable> {
  $$SyncTaskTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get changeId =>
      $composableBuilder(column: $table.changeId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncTaskTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncTaskTableTable,
          SyncTaskTableData,
          $$SyncTaskTableTableFilterComposer,
          $$SyncTaskTableTableOrderingComposer,
          $$SyncTaskTableTableAnnotationComposer,
          $$SyncTaskTableTableCreateCompanionBuilder,
          $$SyncTaskTableTableUpdateCompanionBuilder,
          (
            SyncTaskTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncTaskTableTable,
              SyncTaskTableData
            >,
          ),
          SyncTaskTableData,
          PrefetchHooks Function()
        > {
  $$SyncTaskTableTableTableManager(_$AppDatabase db, $SyncTaskTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncTaskTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncTaskTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncTaskTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> changeId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncTaskTableCompanion(
                id: id,
                changeId: changeId,
                entityType: entityType,
                entityId: entityId,
                op: op,
                payload: payload,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String changeId,
                required String entityType,
                required String entityId,
                required String op,
                Value<String?> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncTaskTableCompanion.insert(
                id: id,
                changeId: changeId,
                entityType: entityType,
                entityId: entityId,
                op: op,
                payload: payload,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncTaskTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncTaskTableTable,
      SyncTaskTableData,
      $$SyncTaskTableTableFilterComposer,
      $$SyncTaskTableTableOrderingComposer,
      $$SyncTaskTableTableAnnotationComposer,
      $$SyncTaskTableTableCreateCompanionBuilder,
      $$SyncTaskTableTableUpdateCompanionBuilder,
      (
        SyncTaskTableData,
        BaseReferences<_$AppDatabase, $SyncTaskTableTable, SyncTaskTableData>,
      ),
      SyncTaskTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncOpTableTableCreateCompanionBuilder =
    SyncOpTableCompanion Function({
      Value<int> id,
      required String type,
      Value<String> status,
      Value<int> totalBooks,
      Value<int> doneBooks,
      Value<int> currentPage,
      Value<int> totalPages,
      Value<String?> error,
      required String title,
      Value<String?> payload,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$SyncOpTableTableUpdateCompanionBuilder =
    SyncOpTableCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> status,
      Value<int> totalBooks,
      Value<int> doneBooks,
      Value<int> currentPage,
      Value<int> totalPages,
      Value<String?> error,
      Value<String> title,
      Value<String?> payload,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$SyncOpTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOpTableTable> {
  $$SyncOpTableTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalBooks => $composableBuilder(
    column: $table.totalBooks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneBooks => $composableBuilder(
    column: $table.doneBooks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
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

class $$SyncOpTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOpTableTable> {
  $$SyncOpTableTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalBooks => $composableBuilder(
    column: $table.totalBooks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneBooks => $composableBuilder(
    column: $table.doneBooks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
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

class $$SyncOpTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOpTableTable> {
  $$SyncOpTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalBooks => $composableBuilder(
    column: $table.totalBooks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get doneBooks =>
      $composableBuilder(column: $table.doneBooks, builder: (column) => column);

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncOpTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOpTableTable,
          SyncOpTableData,
          $$SyncOpTableTableFilterComposer,
          $$SyncOpTableTableOrderingComposer,
          $$SyncOpTableTableAnnotationComposer,
          $$SyncOpTableTableCreateCompanionBuilder,
          $$SyncOpTableTableUpdateCompanionBuilder,
          (
            SyncOpTableData,
            BaseReferences<_$AppDatabase, $SyncOpTableTable, SyncOpTableData>,
          ),
          SyncOpTableData,
          PrefetchHooks Function()
        > {
  $$SyncOpTableTableTableManager(_$AppDatabase db, $SyncOpTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOpTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOpTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOpTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> totalBooks = const Value.absent(),
                Value<int> doneBooks = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SyncOpTableCompanion(
                id: id,
                type: type,
                status: status,
                totalBooks: totalBooks,
                doneBooks: doneBooks,
                currentPage: currentPage,
                totalPages: totalPages,
                error: error,
                title: title,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                Value<String> status = const Value.absent(),
                Value<int> totalBooks = const Value.absent(),
                Value<int> doneBooks = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required String title,
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SyncOpTableCompanion.insert(
                id: id,
                type: type,
                status: status,
                totalBooks: totalBooks,
                doneBooks: doneBooks,
                currentPage: currentPage,
                totalPages: totalPages,
                error: error,
                title: title,
                payload: payload,
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

typedef $$SyncOpTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOpTableTable,
      SyncOpTableData,
      $$SyncOpTableTableFilterComposer,
      $$SyncOpTableTableOrderingComposer,
      $$SyncOpTableTableAnnotationComposer,
      $$SyncOpTableTableCreateCompanionBuilder,
      $$SyncOpTableTableUpdateCompanionBuilder,
      (
        SyncOpTableData,
        BaseReferences<_$AppDatabase, $SyncOpTableTable, SyncOpTableData>,
      ),
      SyncOpTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncDownTableTableCreateCompanionBuilder =
    SyncDownTableCompanion Function({
      required String uuid,
      required String name,
      Value<String?> coverHash,
      Value<int> currentPage,
      Value<int> totalFiles,
      Value<int> doneFiles,
      Value<String> status,
      Value<String> bookStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SyncDownTableTableUpdateCompanionBuilder =
    SyncDownTableCompanion Function({
      Value<String> uuid,
      Value<String> name,
      Value<String?> coverHash,
      Value<int> currentPage,
      Value<int> totalFiles,
      Value<int> doneFiles,
      Value<String> status,
      Value<String> bookStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncDownTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncDownTableTable> {
  $$SyncDownTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverHash => $composableBuilder(
    column: $table.coverHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalFiles => $composableBuilder(
    column: $table.totalFiles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneFiles => $composableBuilder(
    column: $table.doneFiles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookStatus => $composableBuilder(
    column: $table.bookStatus,
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

class $$SyncDownTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncDownTableTable> {
  $$SyncDownTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverHash => $composableBuilder(
    column: $table.coverHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalFiles => $composableBuilder(
    column: $table.totalFiles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneFiles => $composableBuilder(
    column: $table.doneFiles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookStatus => $composableBuilder(
    column: $table.bookStatus,
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

class $$SyncDownTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncDownTableTable> {
  $$SyncDownTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get coverHash =>
      $composableBuilder(column: $table.coverHash, builder: (column) => column);

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalFiles => $composableBuilder(
    column: $table.totalFiles,
    builder: (column) => column,
  );

  GeneratedColumn<int> get doneFiles =>
      $composableBuilder(column: $table.doneFiles, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get bookStatus => $composableBuilder(
    column: $table.bookStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncDownTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncDownTableTable,
          SyncDownTableData,
          $$SyncDownTableTableFilterComposer,
          $$SyncDownTableTableOrderingComposer,
          $$SyncDownTableTableAnnotationComposer,
          $$SyncDownTableTableCreateCompanionBuilder,
          $$SyncDownTableTableUpdateCompanionBuilder,
          (
            SyncDownTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncDownTableTable,
              SyncDownTableData
            >,
          ),
          SyncDownTableData,
          PrefetchHooks Function()
        > {
  $$SyncDownTableTableTableManager(_$AppDatabase db, $SyncDownTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncDownTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncDownTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncDownTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> coverHash = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<int> totalFiles = const Value.absent(),
                Value<int> doneFiles = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> bookStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncDownTableCompanion(
                uuid: uuid,
                name: name,
                coverHash: coverHash,
                currentPage: currentPage,
                totalFiles: totalFiles,
                doneFiles: doneFiles,
                status: status,
                bookStatus: bookStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String name,
                Value<String?> coverHash = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<int> totalFiles = const Value.absent(),
                Value<int> doneFiles = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> bookStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncDownTableCompanion.insert(
                uuid: uuid,
                name: name,
                coverHash: coverHash,
                currentPage: currentPage,
                totalFiles: totalFiles,
                doneFiles: doneFiles,
                status: status,
                bookStatus: bookStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncDownTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncDownTableTable,
      SyncDownTableData,
      $$SyncDownTableTableFilterComposer,
      $$SyncDownTableTableOrderingComposer,
      $$SyncDownTableTableAnnotationComposer,
      $$SyncDownTableTableCreateCompanionBuilder,
      $$SyncDownTableTableUpdateCompanionBuilder,
      (
        SyncDownTableData,
        BaseReferences<_$AppDatabase, $SyncDownTableTable, SyncDownTableData>,
      ),
      SyncDownTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncDownFileTableTableCreateCompanionBuilder =
    SyncDownFileTableCompanion Function({
      required String uuid,
      required String relPath,
      required String hash,
      Value<int> size,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SyncDownFileTableTableUpdateCompanionBuilder =
    SyncDownFileTableCompanion Function({
      Value<String> uuid,
      Value<String> relPath,
      Value<String> hash,
      Value<int> size,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SyncDownFileTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncDownFileTableTable> {
  $$SyncDownFileTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relPath => $composableBuilder(
    column: $table.relPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncDownFileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncDownFileTableTable> {
  $$SyncDownFileTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relPath => $composableBuilder(
    column: $table.relPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncDownFileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncDownFileTableTable> {
  $$SyncDownFileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get relPath =>
      $composableBuilder(column: $table.relPath, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncDownFileTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncDownFileTableTable,
          SyncDownFileTableData,
          $$SyncDownFileTableTableFilterComposer,
          $$SyncDownFileTableTableOrderingComposer,
          $$SyncDownFileTableTableAnnotationComposer,
          $$SyncDownFileTableTableCreateCompanionBuilder,
          $$SyncDownFileTableTableUpdateCompanionBuilder,
          (
            SyncDownFileTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncDownFileTableTable,
              SyncDownFileTableData
            >,
          ),
          SyncDownFileTableData,
          PrefetchHooks Function()
        > {
  $$SyncDownFileTableTableTableManager(
    _$AppDatabase db,
    $SyncDownFileTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncDownFileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncDownFileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncDownFileTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> relPath = const Value.absent(),
                Value<String> hash = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncDownFileTableCompanion(
                uuid: uuid,
                relPath: relPath,
                hash: hash,
                size: size,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String relPath,
                required String hash,
                Value<int> size = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncDownFileTableCompanion.insert(
                uuid: uuid,
                relPath: relPath,
                hash: hash,
                size: size,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncDownFileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncDownFileTableTable,
      SyncDownFileTableData,
      $$SyncDownFileTableTableFilterComposer,
      $$SyncDownFileTableTableOrderingComposer,
      $$SyncDownFileTableTableAnnotationComposer,
      $$SyncDownFileTableTableCreateCompanionBuilder,
      $$SyncDownFileTableTableUpdateCompanionBuilder,
      (
        SyncDownFileTableData,
        BaseReferences<
          _$AppDatabase,
          $SyncDownFileTableTable,
          SyncDownFileTableData
        >,
      ),
      SyncDownFileTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncUploadTableTableCreateCompanionBuilder =
    SyncUploadTableCompanion Function({
      required String uuid,
      required String name,
      Value<int> totalFiles,
      Value<int> doneFiles,
      Value<String> dataVersion,
      Value<String> status,
      Value<String> bookStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SyncUploadTableTableUpdateCompanionBuilder =
    SyncUploadTableCompanion Function({
      Value<String> uuid,
      Value<String> name,
      Value<int> totalFiles,
      Value<int> doneFiles,
      Value<String> dataVersion,
      Value<String> status,
      Value<String> bookStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncUploadTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncUploadTableTable> {
  $$SyncUploadTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalFiles => $composableBuilder(
    column: $table.totalFiles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneFiles => $composableBuilder(
    column: $table.doneFiles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookStatus => $composableBuilder(
    column: $table.bookStatus,
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

class $$SyncUploadTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncUploadTableTable> {
  $$SyncUploadTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalFiles => $composableBuilder(
    column: $table.totalFiles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneFiles => $composableBuilder(
    column: $table.doneFiles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookStatus => $composableBuilder(
    column: $table.bookStatus,
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

class $$SyncUploadTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncUploadTableTable> {
  $$SyncUploadTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get totalFiles => $composableBuilder(
    column: $table.totalFiles,
    builder: (column) => column,
  );

  GeneratedColumn<int> get doneFiles =>
      $composableBuilder(column: $table.doneFiles, builder: (column) => column);

  GeneratedColumn<String> get dataVersion => $composableBuilder(
    column: $table.dataVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get bookStatus => $composableBuilder(
    column: $table.bookStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncUploadTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncUploadTableTable,
          SyncUploadTableData,
          $$SyncUploadTableTableFilterComposer,
          $$SyncUploadTableTableOrderingComposer,
          $$SyncUploadTableTableAnnotationComposer,
          $$SyncUploadTableTableCreateCompanionBuilder,
          $$SyncUploadTableTableUpdateCompanionBuilder,
          (
            SyncUploadTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncUploadTableTable,
              SyncUploadTableData
            >,
          ),
          SyncUploadTableData,
          PrefetchHooks Function()
        > {
  $$SyncUploadTableTableTableManager(
    _$AppDatabase db,
    $SyncUploadTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncUploadTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncUploadTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncUploadTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> totalFiles = const Value.absent(),
                Value<int> doneFiles = const Value.absent(),
                Value<String> dataVersion = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> bookStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncUploadTableCompanion(
                uuid: uuid,
                name: name,
                totalFiles: totalFiles,
                doneFiles: doneFiles,
                dataVersion: dataVersion,
                status: status,
                bookStatus: bookStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String name,
                Value<int> totalFiles = const Value.absent(),
                Value<int> doneFiles = const Value.absent(),
                Value<String> dataVersion = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> bookStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncUploadTableCompanion.insert(
                uuid: uuid,
                name: name,
                totalFiles: totalFiles,
                doneFiles: doneFiles,
                dataVersion: dataVersion,
                status: status,
                bookStatus: bookStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncUploadTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncUploadTableTable,
      SyncUploadTableData,
      $$SyncUploadTableTableFilterComposer,
      $$SyncUploadTableTableOrderingComposer,
      $$SyncUploadTableTableAnnotationComposer,
      $$SyncUploadTableTableCreateCompanionBuilder,
      $$SyncUploadTableTableUpdateCompanionBuilder,
      (
        SyncUploadTableData,
        BaseReferences<
          _$AppDatabase,
          $SyncUploadTableTable,
          SyncUploadTableData
        >,
      ),
      SyncUploadTableData,
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
  $$SettingTableTableTableManager get settingTable =>
      $$SettingTableTableTableManager(_db, _db.settingTable);
  $$EntitySyncStateTableTableTableManager get entitySyncStateTable =>
      $$EntitySyncStateTableTableTableManager(_db, _db.entitySyncStateTable);
  $$SyncTaskTableTableTableManager get syncTaskTable =>
      $$SyncTaskTableTableTableManager(_db, _db.syncTaskTable);
  $$SyncOpTableTableTableManager get syncOpTable =>
      $$SyncOpTableTableTableManager(_db, _db.syncOpTable);
  $$SyncDownTableTableTableManager get syncDownTable =>
      $$SyncDownTableTableTableManager(_db, _db.syncDownTable);
  $$SyncDownFileTableTableTableManager get syncDownFileTable =>
      $$SyncDownFileTableTableTableManager(_db, _db.syncDownFileTable);
  $$SyncUploadTableTableTableManager get syncUploadTable =>
      $$SyncUploadTableTableTableManager(_db, _db.syncUploadTable);
}
