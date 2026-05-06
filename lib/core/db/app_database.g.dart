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
}

class BookTableData extends DataClass implements Insertable<BookTableData> {
  final int id;
  final String name;
  final List<String> localSubPaths;
  final int readCount;
  final int currentPage;
  final DateTime createdAt;
  const BookTableData({
    required this.id,
    required this.name,
    required this.localSubPaths,
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
      'readCount': serializer.toJson<int>(readCount),
      'currentPage': serializer.toJson<int>(currentPage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BookTableData copyWith({
    int? id,
    String? name,
    List<String>? localSubPaths,
    int? readCount,
    int? currentPage,
    DateTime? createdAt,
  }) => BookTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    localSubPaths: localSubPaths ?? this.localSubPaths,
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
          ..write('readCount: $readCount, ')
          ..write('currentPage: $currentPage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, localSubPaths, readCount, currentPage, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.localSubPaths == this.localSubPaths &&
          other.readCount == this.readCount &&
          other.currentPage == this.currentPage &&
          other.createdAt == this.createdAt);
}

class BookTableCompanion extends UpdateCompanion<BookTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<List<String>> localSubPaths;
  final Value<int> readCount;
  final Value<int> currentPage;
  final Value<DateTime> createdAt;
  const BookTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.localSubPaths = const Value.absent(),
    this.readCount = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BookTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required List<String> localSubPaths,
    this.readCount = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       localSubPaths = Value(localSubPaths);
  static Insertable<BookTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? localSubPaths,
    Expression<int>? readCount,
    Expression<int>? currentPage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (localSubPaths != null) 'local_sub_paths': localSubPaths,
      if (readCount != null) 'read_count': readCount,
      if (currentPage != null) 'current_page': currentPage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BookTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<List<String>>? localSubPaths,
    Value<int>? readCount,
    Value<int>? currentPage,
    Value<DateTime>? createdAt,
  }) {
    return BookTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      localSubPaths: localSubPaths ?? this.localSubPaths,
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
          ..write('readCount: $readCount, ')
          ..write('currentPage: $currentPage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookTableTable bookTable = $BookTableTable(this);
  late final BookLocalDatasource bookLocalDatasource = BookLocalDatasource(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [bookTable];
}

typedef $$BookTableTableCreateCompanionBuilder =
    BookTableCompanion Function({
      Value<int> id,
      required String name,
      required List<String> localSubPaths,
      Value<int> readCount,
      Value<int> currentPage,
      Value<DateTime> createdAt,
    });
typedef $$BookTableTableUpdateCompanionBuilder =
    BookTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<List<String>> localSubPaths,
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
                Value<int> readCount = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookTableCompanion(
                id: id,
                name: name,
                localSubPaths: localSubPaths,
                readCount: readCount,
                currentPage: currentPage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required List<String> localSubPaths,
                Value<int> readCount = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookTableCompanion.insert(
                id: id,
                name: name,
                localSubPaths: localSubPaths,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db, _db.bookTable);
}
