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
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseUrlMeta =
      const VerificationMeta('baseUrl');
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
      'base_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> localPaths =
      GeneratedColumn<String>('local_paths', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($BookTableTable.$converterlocalPaths);
  static const VerificationMeta _downloadCountMeta =
      const VerificationMeta('downloadCount');
  @override
  late final GeneratedColumn<int> downloadCount = GeneratedColumn<int>(
      'download_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDownloadMeta =
      const VerificationMeta('isDownload');
  @override
  late final GeneratedColumn<bool> isDownload = GeneratedColumn<bool>(
      'is_download', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_download" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> imageUrls =
      GeneratedColumn<String>('image_urls', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($BookTableTable.$converterimageUrls);
  static const VerificationMeta _readCountMeta =
      const VerificationMeta('readCount');
  @override
  late final GeneratedColumn<int> readCount = GeneratedColumn<int>(
      'read_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createTimeMeta =
      const VerificationMeta('createTime');
  @override
  late final GeneratedColumn<String> createTime = GeneratedColumn<String>(
      'create_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        baseUrl,
        localPaths,
        downloadCount,
        isDownload,
        imageUrls,
        readCount,
        createTime
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_table';
  @override
  VerificationContext validateIntegrity(Insertable<BookTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(_baseUrlMeta,
          baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta));
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('download_count')) {
      context.handle(
          _downloadCountMeta,
          downloadCount.isAcceptableOrUnknown(
              data['download_count']!, _downloadCountMeta));
    }
    if (data.containsKey('is_download')) {
      context.handle(
          _isDownloadMeta,
          isDownload.isAcceptableOrUnknown(
              data['is_download']!, _isDownloadMeta));
    }
    if (data.containsKey('read_count')) {
      context.handle(_readCountMeta,
          readCount.isAcceptableOrUnknown(data['read_count']!, _readCountMeta));
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    } else if (isInserting) {
      context.missing(_createTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      baseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_url'])!,
      localPaths: $BookTableTable.$converterlocalPaths.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_paths'])!),
      downloadCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}download_count'])!,
      isDownload: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_download'])!,
      imageUrls: $BookTableTable.$converterimageUrls.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_urls'])!),
      readCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}read_count'])!,
      createTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}create_time'])!,
    );
  }

  @override
  $BookTableTable createAlias(String alias) {
    return $BookTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterlocalPaths =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterimageUrls =
      const StringListConverter();
}

class BookTableData extends DataClass implements Insertable<BookTableData> {
  final int id;
  final String name;
  final String baseUrl;
  final List<String> localPaths;
  final int downloadCount;
  final bool isDownload;
  final List<String> imageUrls;
  final int readCount;
  final String createTime;
  const BookTableData(
      {required this.id,
      required this.name,
      required this.baseUrl,
      required this.localPaths,
      required this.downloadCount,
      required this.isDownload,
      required this.imageUrls,
      required this.readCount,
      required this.createTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['base_url'] = Variable<String>(baseUrl);
    {
      map['local_paths'] = Variable<String>(
          $BookTableTable.$converterlocalPaths.toSql(localPaths));
    }
    map['download_count'] = Variable<int>(downloadCount);
    map['is_download'] = Variable<bool>(isDownload);
    {
      map['image_urls'] = Variable<String>(
          $BookTableTable.$converterimageUrls.toSql(imageUrls));
    }
    map['read_count'] = Variable<int>(readCount);
    map['create_time'] = Variable<String>(createTime);
    return map;
  }

  BookTableCompanion toCompanion(bool nullToAbsent) {
    return BookTableCompanion(
      id: Value(id),
      name: Value(name),
      baseUrl: Value(baseUrl),
      localPaths: Value(localPaths),
      downloadCount: Value(downloadCount),
      isDownload: Value(isDownload),
      imageUrls: Value(imageUrls),
      readCount: Value(readCount),
      createTime: Value(createTime),
    );
  }

  factory BookTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      localPaths: serializer.fromJson<List<String>>(json['localPaths']),
      downloadCount: serializer.fromJson<int>(json['downloadCount']),
      isDownload: serializer.fromJson<bool>(json['isDownload']),
      imageUrls: serializer.fromJson<List<String>>(json['imageUrls']),
      readCount: serializer.fromJson<int>(json['readCount']),
      createTime: serializer.fromJson<String>(json['createTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'localPaths': serializer.toJson<List<String>>(localPaths),
      'downloadCount': serializer.toJson<int>(downloadCount),
      'isDownload': serializer.toJson<bool>(isDownload),
      'imageUrls': serializer.toJson<List<String>>(imageUrls),
      'readCount': serializer.toJson<int>(readCount),
      'createTime': serializer.toJson<String>(createTime),
    };
  }

  BookTableData copyWith(
          {int? id,
          String? name,
          String? baseUrl,
          List<String>? localPaths,
          int? downloadCount,
          bool? isDownload,
          List<String>? imageUrls,
          int? readCount,
          String? createTime}) =>
      BookTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        baseUrl: baseUrl ?? this.baseUrl,
        localPaths: localPaths ?? this.localPaths,
        downloadCount: downloadCount ?? this.downloadCount,
        isDownload: isDownload ?? this.isDownload,
        imageUrls: imageUrls ?? this.imageUrls,
        readCount: readCount ?? this.readCount,
        createTime: createTime ?? this.createTime,
      );
  BookTableData copyWithCompanion(BookTableCompanion data) {
    return BookTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      localPaths:
          data.localPaths.present ? data.localPaths.value : this.localPaths,
      downloadCount: data.downloadCount.present
          ? data.downloadCount.value
          : this.downloadCount,
      isDownload:
          data.isDownload.present ? data.isDownload.value : this.isDownload,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      readCount: data.readCount.present ? data.readCount.value : this.readCount,
      createTime:
          data.createTime.present ? data.createTime.value : this.createTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('localPaths: $localPaths, ')
          ..write('downloadCount: $downloadCount, ')
          ..write('isDownload: $isDownload, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('readCount: $readCount, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, baseUrl, localPaths, downloadCount,
      isDownload, imageUrls, readCount, createTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.baseUrl == this.baseUrl &&
          other.localPaths == this.localPaths &&
          other.downloadCount == this.downloadCount &&
          other.isDownload == this.isDownload &&
          other.imageUrls == this.imageUrls &&
          other.readCount == this.readCount &&
          other.createTime == this.createTime);
}

class BookTableCompanion extends UpdateCompanion<BookTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> baseUrl;
  final Value<List<String>> localPaths;
  final Value<int> downloadCount;
  final Value<bool> isDownload;
  final Value<List<String>> imageUrls;
  final Value<int> readCount;
  final Value<String> createTime;
  const BookTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.localPaths = const Value.absent(),
    this.downloadCount = const Value.absent(),
    this.isDownload = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.readCount = const Value.absent(),
    this.createTime = const Value.absent(),
  });
  BookTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String baseUrl,
    required List<String> localPaths,
    this.downloadCount = const Value.absent(),
    this.isDownload = const Value.absent(),
    required List<String> imageUrls,
    this.readCount = const Value.absent(),
    required String createTime,
  })  : name = Value(name),
        baseUrl = Value(baseUrl),
        localPaths = Value(localPaths),
        imageUrls = Value(imageUrls),
        createTime = Value(createTime);
  static Insertable<BookTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? baseUrl,
    Expression<String>? localPaths,
    Expression<int>? downloadCount,
    Expression<bool>? isDownload,
    Expression<String>? imageUrls,
    Expression<int>? readCount,
    Expression<String>? createTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (baseUrl != null) 'base_url': baseUrl,
      if (localPaths != null) 'local_paths': localPaths,
      if (downloadCount != null) 'download_count': downloadCount,
      if (isDownload != null) 'is_download': isDownload,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (readCount != null) 'read_count': readCount,
      if (createTime != null) 'create_time': createTime,
    });
  }

  BookTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? baseUrl,
      Value<List<String>>? localPaths,
      Value<int>? downloadCount,
      Value<bool>? isDownload,
      Value<List<String>>? imageUrls,
      Value<int>? readCount,
      Value<String>? createTime}) {
    return BookTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      localPaths: localPaths ?? this.localPaths,
      downloadCount: downloadCount ?? this.downloadCount,
      isDownload: isDownload ?? this.isDownload,
      imageUrls: imageUrls ?? this.imageUrls,
      readCount: readCount ?? this.readCount,
      createTime: createTime ?? this.createTime,
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
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (localPaths.present) {
      map['local_paths'] = Variable<String>(
          $BookTableTable.$converterlocalPaths.toSql(localPaths.value));
    }
    if (downloadCount.present) {
      map['download_count'] = Variable<int>(downloadCount.value);
    }
    if (isDownload.present) {
      map['is_download'] = Variable<bool>(isDownload.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(
          $BookTableTable.$converterimageUrls.toSql(imageUrls.value));
    }
    if (readCount.present) {
      map['read_count'] = Variable<int>(readCount.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<String>(createTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('localPaths: $localPaths, ')
          ..write('downloadCount: $downloadCount, ')
          ..write('isDownload: $isDownload, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('readCount: $readCount, ')
          ..write('createTime: $createTime')
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pageLayoutMeta =
      const VerificationMeta('pageLayout');
  @override
  late final GeneratedColumn<String> pageLayout = GeneratedColumn<String>(
      'page_layout', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('page'));
  @override
  List<GeneratedColumn> get $columns => [id, pageLayout];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setting_table';
  @override
  VerificationContext validateIntegrity(Insertable<SettingTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('page_layout')) {
      context.handle(
          _pageLayoutMeta,
          pageLayout.isAcceptableOrUnknown(
              data['page_layout']!, _pageLayoutMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pageLayout: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}page_layout'])!,
    );
  }

  @override
  $SettingTableTable createAlias(String alias) {
    return $SettingTableTable(attachedDatabase, alias);
  }
}

class SettingTableData extends DataClass
    implements Insertable<SettingTableData> {
  final int id;
  final String pageLayout;
  const SettingTableData({required this.id, required this.pageLayout});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['page_layout'] = Variable<String>(pageLayout);
    return map;
  }

  SettingTableCompanion toCompanion(bool nullToAbsent) {
    return SettingTableCompanion(
      id: Value(id),
      pageLayout: Value(pageLayout),
    );
  }

  factory SettingTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingTableData(
      id: serializer.fromJson<int>(json['id']),
      pageLayout: serializer.fromJson<String>(json['pageLayout']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pageLayout': serializer.toJson<String>(pageLayout),
    };
  }

  SettingTableData copyWith({int? id, String? pageLayout}) => SettingTableData(
        id: id ?? this.id,
        pageLayout: pageLayout ?? this.pageLayout,
      );
  SettingTableData copyWithCompanion(SettingTableCompanion data) {
    return SettingTableData(
      id: data.id.present ? data.id.value : this.id,
      pageLayout:
          data.pageLayout.present ? data.pageLayout.value : this.pageLayout,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingTableData(')
          ..write('id: $id, ')
          ..write('pageLayout: $pageLayout')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pageLayout);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingTableData &&
          other.id == this.id &&
          other.pageLayout == this.pageLayout);
}

class SettingTableCompanion extends UpdateCompanion<SettingTableData> {
  final Value<int> id;
  final Value<String> pageLayout;
  const SettingTableCompanion({
    this.id = const Value.absent(),
    this.pageLayout = const Value.absent(),
  });
  SettingTableCompanion.insert({
    this.id = const Value.absent(),
    this.pageLayout = const Value.absent(),
  });
  static Insertable<SettingTableData> custom({
    Expression<int>? id,
    Expression<String>? pageLayout,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pageLayout != null) 'page_layout': pageLayout,
    });
  }

  SettingTableCompanion copyWith({Value<int>? id, Value<String>? pageLayout}) {
    return SettingTableCompanion(
      id: id ?? this.id,
      pageLayout: pageLayout ?? this.pageLayout,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pageLayout.present) {
      map['page_layout'] = Variable<String>(pageLayout.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingTableCompanion(')
          ..write('id: $id, ')
          ..write('pageLayout: $pageLayout')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookTableTable bookTable = $BookTableTable(this);
  late final $SettingTableTable settingTable = $SettingTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [bookTable, settingTable];
}

typedef $$BookTableTableCreateCompanionBuilder = BookTableCompanion Function({
  Value<int> id,
  required String name,
  required String baseUrl,
  required List<String> localPaths,
  Value<int> downloadCount,
  Value<bool> isDownload,
  required List<String> imageUrls,
  Value<int> readCount,
  required String createTime,
});
typedef $$BookTableTableUpdateCompanionBuilder = BookTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> baseUrl,
  Value<List<String>> localPaths,
  Value<int> downloadCount,
  Value<bool> isDownload,
  Value<List<String>> imageUrls,
  Value<int> readCount,
  Value<String> createTime,
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
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get localPaths => $composableBuilder(
          column: $table.localPaths,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDownload => $composableBuilder(
      column: $table.isDownload, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get imageUrls => $composableBuilder(
          column: $table.imageUrls,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get readCount => $composableBuilder(
      column: $table.readCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => ColumnFilters(column));
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
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPaths => $composableBuilder(
      column: $table.localPaths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDownload => $composableBuilder(
      column: $table.isDownload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrls => $composableBuilder(
      column: $table.imageUrls, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get readCount => $composableBuilder(
      column: $table.readCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get localPaths =>
      $composableBuilder(
          column: $table.localPaths, builder: (column) => column);

  GeneratedColumn<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount, builder: (column) => column);

  GeneratedColumn<bool> get isDownload => $composableBuilder(
      column: $table.isDownload, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<int> get readCount =>
      $composableBuilder(column: $table.readCount, builder: (column) => column);

  GeneratedColumn<String> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => column);
}

class $$BookTableTableTableManager extends RootTableManager<
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
      BaseReferences<_$AppDatabase, $BookTableTable, BookTableData>
    ),
    BookTableData,
    PrefetchHooks Function()> {
  $$BookTableTableTableManager(_$AppDatabase db, $BookTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> baseUrl = const Value.absent(),
            Value<List<String>> localPaths = const Value.absent(),
            Value<int> downloadCount = const Value.absent(),
            Value<bool> isDownload = const Value.absent(),
            Value<List<String>> imageUrls = const Value.absent(),
            Value<int> readCount = const Value.absent(),
            Value<String> createTime = const Value.absent(),
          }) =>
              BookTableCompanion(
            id: id,
            name: name,
            baseUrl: baseUrl,
            localPaths: localPaths,
            downloadCount: downloadCount,
            isDownload: isDownload,
            imageUrls: imageUrls,
            readCount: readCount,
            createTime: createTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String baseUrl,
            required List<String> localPaths,
            Value<int> downloadCount = const Value.absent(),
            Value<bool> isDownload = const Value.absent(),
            required List<String> imageUrls,
            Value<int> readCount = const Value.absent(),
            required String createTime,
          }) =>
              BookTableCompanion.insert(
            id: id,
            name: name,
            baseUrl: baseUrl,
            localPaths: localPaths,
            downloadCount: downloadCount,
            isDownload: isDownload,
            imageUrls: imageUrls,
            readCount: readCount,
            createTime: createTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookTableTableProcessedTableManager = ProcessedTableManager<
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
      BaseReferences<_$AppDatabase, $BookTableTable, BookTableData>
    ),
    BookTableData,
    PrefetchHooks Function()>;
typedef $$SettingTableTableCreateCompanionBuilder = SettingTableCompanion
    Function({
  Value<int> id,
  Value<String> pageLayout,
});
typedef $$SettingTableTableUpdateCompanionBuilder = SettingTableCompanion
    Function({
  Value<int> id,
  Value<String> pageLayout,
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
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pageLayout => $composableBuilder(
      column: $table.pageLayout, builder: (column) => ColumnFilters(column));
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
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pageLayout => $composableBuilder(
      column: $table.pageLayout, builder: (column) => ColumnOrderings(column));
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pageLayout => $composableBuilder(
      column: $table.pageLayout, builder: (column) => column);
}

class $$SettingTableTableTableManager extends RootTableManager<
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
      BaseReferences<_$AppDatabase, $SettingTableTable, SettingTableData>
    ),
    SettingTableData,
    PrefetchHooks Function()> {
  $$SettingTableTableTableManager(_$AppDatabase db, $SettingTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pageLayout = const Value.absent(),
          }) =>
              SettingTableCompanion(
            id: id,
            pageLayout: pageLayout,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pageLayout = const Value.absent(),
          }) =>
              SettingTableCompanion.insert(
            id: id,
            pageLayout: pageLayout,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingTableTableProcessedTableManager = ProcessedTableManager<
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
      BaseReferences<_$AppDatabase, $SettingTableTable, SettingTableData>
    ),
    SettingTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db, _db.bookTable);
  $$SettingTableTableTableManager get settingTable =>
      $$SettingTableTableTableManager(_db, _db.settingTable);
}
