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

class $SyncLogTableTable extends SyncLogTable
    with TableInfo<$SyncLogTableTable, SyncLogTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _syncedBooksMeta = const VerificationMeta(
    'syncedBooks',
  );
  @override
  late final GeneratedColumn<int> syncedBooks = GeneratedColumn<int>(
    'synced_books',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _failedBooksMeta = const VerificationMeta(
    'failedBooks',
  );
  @override
  late final GeneratedColumn<int> failedBooks = GeneratedColumn<int>(
    'failed_books',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    finishedAt,
    status,
    totalBooks,
    syncedBooks,
    failedBooks,
    detail,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_log_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLogTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('total_books')) {
      context.handle(
        _totalBooksMeta,
        totalBooks.isAcceptableOrUnknown(data['total_books']!, _totalBooksMeta),
      );
    }
    if (data.containsKey('synced_books')) {
      context.handle(
        _syncedBooksMeta,
        syncedBooks.isAcceptableOrUnknown(
          data['synced_books']!,
          _syncedBooksMeta,
        ),
      );
    }
    if (data.containsKey('failed_books')) {
      context.handle(
        _failedBooksMeta,
        failedBooks.isAcceptableOrUnknown(
          data['failed_books']!,
          _failedBooksMeta,
        ),
      );
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLogTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLogTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalBooks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_books'],
      )!,
      syncedBooks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}synced_books'],
      )!,
      failedBooks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_books'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      ),
    );
  }

  @override
  $SyncLogTableTable createAlias(String alias) {
    return $SyncLogTableTable(attachedDatabase, alias);
  }
}

class SyncLogTableData extends DataClass
    implements Insertable<SyncLogTableData> {
  final int id;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String status;
  final int totalBooks;
  final int syncedBooks;
  final int failedBooks;
  final String? detail;
  const SyncLogTableData({
    required this.id,
    required this.startedAt,
    this.finishedAt,
    required this.status,
    required this.totalBooks,
    required this.syncedBooks,
    required this.failedBooks,
    this.detail,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['status'] = Variable<String>(status);
    map['total_books'] = Variable<int>(totalBooks);
    map['synced_books'] = Variable<int>(syncedBooks);
    map['failed_books'] = Variable<int>(failedBooks);
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    return map;
  }

  SyncLogTableCompanion toCompanion(bool nullToAbsent) {
    return SyncLogTableCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      status: Value(status),
      totalBooks: Value(totalBooks),
      syncedBooks: Value(syncedBooks),
      failedBooks: Value(failedBooks),
      detail: detail == null && nullToAbsent
          ? const Value.absent()
          : Value(detail),
    );
  }

  factory SyncLogTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLogTableData(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      status: serializer.fromJson<String>(json['status']),
      totalBooks: serializer.fromJson<int>(json['totalBooks']),
      syncedBooks: serializer.fromJson<int>(json['syncedBooks']),
      failedBooks: serializer.fromJson<int>(json['failedBooks']),
      detail: serializer.fromJson<String?>(json['detail']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'status': serializer.toJson<String>(status),
      'totalBooks': serializer.toJson<int>(totalBooks),
      'syncedBooks': serializer.toJson<int>(syncedBooks),
      'failedBooks': serializer.toJson<int>(failedBooks),
      'detail': serializer.toJson<String?>(detail),
    };
  }

  SyncLogTableData copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    String? status,
    int? totalBooks,
    int? syncedBooks,
    int? failedBooks,
    Value<String?> detail = const Value.absent(),
  }) => SyncLogTableData(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    status: status ?? this.status,
    totalBooks: totalBooks ?? this.totalBooks,
    syncedBooks: syncedBooks ?? this.syncedBooks,
    failedBooks: failedBooks ?? this.failedBooks,
    detail: detail.present ? detail.value : this.detail,
  );
  SyncLogTableData copyWithCompanion(SyncLogTableCompanion data) {
    return SyncLogTableData(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      status: data.status.present ? data.status.value : this.status,
      totalBooks: data.totalBooks.present
          ? data.totalBooks.value
          : this.totalBooks,
      syncedBooks: data.syncedBooks.present
          ? data.syncedBooks.value
          : this.syncedBooks,
      failedBooks: data.failedBooks.present
          ? data.failedBooks.value
          : this.failedBooks,
      detail: data.detail.present ? data.detail.value : this.detail,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogTableData(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('totalBooks: $totalBooks, ')
          ..write('syncedBooks: $syncedBooks, ')
          ..write('failedBooks: $failedBooks, ')
          ..write('detail: $detail')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    finishedAt,
    status,
    totalBooks,
    syncedBooks,
    failedBooks,
    detail,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLogTableData &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.status == this.status &&
          other.totalBooks == this.totalBooks &&
          other.syncedBooks == this.syncedBooks &&
          other.failedBooks == this.failedBooks &&
          other.detail == this.detail);
}

class SyncLogTableCompanion extends UpdateCompanion<SyncLogTableData> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<String> status;
  final Value<int> totalBooks;
  final Value<int> syncedBooks;
  final Value<int> failedBooks;
  final Value<String?> detail;
  const SyncLogTableCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.totalBooks = const Value.absent(),
    this.syncedBooks = const Value.absent(),
    this.failedBooks = const Value.absent(),
    this.detail = const Value.absent(),
  });
  SyncLogTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    required String status,
    this.totalBooks = const Value.absent(),
    this.syncedBooks = const Value.absent(),
    this.failedBooks = const Value.absent(),
    this.detail = const Value.absent(),
  }) : startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<SyncLogTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<String>? status,
    Expression<int>? totalBooks,
    Expression<int>? syncedBooks,
    Expression<int>? failedBooks,
    Expression<String>? detail,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (status != null) 'status': status,
      if (totalBooks != null) 'total_books': totalBooks,
      if (syncedBooks != null) 'synced_books': syncedBooks,
      if (failedBooks != null) 'failed_books': failedBooks,
      if (detail != null) 'detail': detail,
    });
  }

  SyncLogTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<String>? status,
    Value<int>? totalBooks,
    Value<int>? syncedBooks,
    Value<int>? failedBooks,
    Value<String?>? detail,
  }) {
    return SyncLogTableCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
      totalBooks: totalBooks ?? this.totalBooks,
      syncedBooks: syncedBooks ?? this.syncedBooks,
      failedBooks: failedBooks ?? this.failedBooks,
      detail: detail ?? this.detail,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalBooks.present) {
      map['total_books'] = Variable<int>(totalBooks.value);
    }
    if (syncedBooks.present) {
      map['synced_books'] = Variable<int>(syncedBooks.value);
    }
    if (failedBooks.present) {
      map['failed_books'] = Variable<int>(failedBooks.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogTableCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('status: $status, ')
          ..write('totalBooks: $totalBooks, ')
          ..write('syncedBooks: $syncedBooks, ')
          ..write('failedBooks: $failedBooks, ')
          ..write('detail: $detail')
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
  late final $SyncLogTableTable syncLogTable = $SyncLogTableTable(this);
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
  late final SyncLogLocalDatasource syncLogLocalDatasource =
      SyncLogLocalDatasource(this as AppDatabase);
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
    syncLogTable,
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
typedef $$SyncLogTableTableCreateCompanionBuilder =
    SyncLogTableCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      required String status,
      Value<int> totalBooks,
      Value<int> syncedBooks,
      Value<int> failedBooks,
      Value<String?> detail,
    });
typedef $$SyncLogTableTableUpdateCompanionBuilder =
    SyncLogTableCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<String> status,
      Value<int> totalBooks,
      Value<int> syncedBooks,
      Value<int> failedBooks,
      Value<String?> detail,
    });

class $$SyncLogTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogTableTable> {
  $$SyncLogTableTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
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

  ColumnFilters<int> get syncedBooks => $composableBuilder(
    column: $table.syncedBooks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedBooks => $composableBuilder(
    column: $table.failedBooks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncLogTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogTableTable> {
  $$SyncLogTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
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

  ColumnOrderings<int> get syncedBooks => $composableBuilder(
    column: $table.syncedBooks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedBooks => $composableBuilder(
    column: $table.failedBooks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncLogTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogTableTable> {
  $$SyncLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalBooks => $composableBuilder(
    column: $table.totalBooks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncedBooks => $composableBuilder(
    column: $table.syncedBooks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failedBooks => $composableBuilder(
    column: $table.failedBooks,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);
}

class $$SyncLogTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncLogTableTable,
          SyncLogTableData,
          $$SyncLogTableTableFilterComposer,
          $$SyncLogTableTableOrderingComposer,
          $$SyncLogTableTableAnnotationComposer,
          $$SyncLogTableTableCreateCompanionBuilder,
          $$SyncLogTableTableUpdateCompanionBuilder,
          (
            SyncLogTableData,
            BaseReferences<_$AppDatabase, $SyncLogTableTable, SyncLogTableData>,
          ),
          SyncLogTableData,
          PrefetchHooks Function()
        > {
  $$SyncLogTableTableTableManager(_$AppDatabase db, $SyncLogTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> totalBooks = const Value.absent(),
                Value<int> syncedBooks = const Value.absent(),
                Value<int> failedBooks = const Value.absent(),
                Value<String?> detail = const Value.absent(),
              }) => SyncLogTableCompanion(
                id: id,
                startedAt: startedAt,
                finishedAt: finishedAt,
                status: status,
                totalBooks: totalBooks,
                syncedBooks: syncedBooks,
                failedBooks: failedBooks,
                detail: detail,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                required String status,
                Value<int> totalBooks = const Value.absent(),
                Value<int> syncedBooks = const Value.absent(),
                Value<int> failedBooks = const Value.absent(),
                Value<String?> detail = const Value.absent(),
              }) => SyncLogTableCompanion.insert(
                id: id,
                startedAt: startedAt,
                finishedAt: finishedAt,
                status: status,
                totalBooks: totalBooks,
                syncedBooks: syncedBooks,
                failedBooks: failedBooks,
                detail: detail,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLogTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncLogTableTable,
      SyncLogTableData,
      $$SyncLogTableTableFilterComposer,
      $$SyncLogTableTableOrderingComposer,
      $$SyncLogTableTableAnnotationComposer,
      $$SyncLogTableTableCreateCompanionBuilder,
      $$SyncLogTableTableUpdateCompanionBuilder,
      (
        SyncLogTableData,
        BaseReferences<_$AppDatabase, $SyncLogTableTable, SyncLogTableData>,
      ),
      SyncLogTableData,
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
  $$SyncLogTableTableTableManager get syncLogTable =>
      $$SyncLogTableTableTableManager(_db, _db.syncLogTable);
}
