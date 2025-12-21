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
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> localPaths =
      GeneratedColumn<String>('local_paths', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($BookTableTable.$converterlocalPaths);
  static const VerificationMeta _readCountMeta =
      const VerificationMeta('readCount');
  @override
  late final GeneratedColumn<int> readCount = GeneratedColumn<int>(
      'read_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, localPaths, readCount, createdAt];
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
    if (data.containsKey('read_count')) {
      context.handle(_readCountMeta,
          readCount.isAcceptableOrUnknown(data['read_count']!, _readCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
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
      localPaths: $BookTableTable.$converterlocalPaths.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_paths'])!),
      readCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}read_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BookTableTable createAlias(String alias) {
    return $BookTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
      $converterlocalPaths = const StringListConverter();
}

class BookTableData extends DataClass implements Insertable<BookTableData> {
  final int id;
  final String name;
  final List<String> localPaths;
  final int readCount;
  final DateTime createdAt;
  const BookTableData(
      {required this.id,
      required this.name,
      required this.localPaths,
      required this.readCount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['local_paths'] = Variable<String>(
          $BookTableTable.$converterlocalPaths.toSql(localPaths));
    }
    map['read_count'] = Variable<int>(readCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookTableCompanion toCompanion(bool nullToAbsent) {
    return BookTableCompanion(
      id: Value(id),
      name: Value(name),
      localPaths: Value(localPaths),
      readCount: Value(readCount),
      createdAt: Value(createdAt),
    );
  }

  factory BookTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      localPaths: $BookTableTable.$converterlocalPaths
          .fromJson(serializer.fromJson<List<dynamic>>(json['localPaths'])),
      readCount: serializer.fromJson<int>(json['readCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'localPaths': serializer.toJson<List<dynamic>>(
          $BookTableTable.$converterlocalPaths.toJson(localPaths)),
      'readCount': serializer.toJson<int>(readCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BookTableData copyWith(
          {int? id,
          String? name,
          List<String>? localPaths,
          int? readCount,
          DateTime? createdAt}) =>
      BookTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        localPaths: localPaths ?? this.localPaths,
        readCount: readCount ?? this.readCount,
        createdAt: createdAt ?? this.createdAt,
      );
  BookTableData copyWithCompanion(BookTableCompanion data) {
    return BookTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      localPaths:
          data.localPaths.present ? data.localPaths.value : this.localPaths,
      readCount: data.readCount.present ? data.readCount.value : this.readCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('localPaths: $localPaths, ')
          ..write('readCount: $readCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, localPaths, readCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.localPaths == this.localPaths &&
          other.readCount == this.readCount &&
          other.createdAt == this.createdAt);
}

class BookTableCompanion extends UpdateCompanion<BookTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<List<String>> localPaths;
  final Value<int> readCount;
  final Value<DateTime> createdAt;
  const BookTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.localPaths = const Value.absent(),
    this.readCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BookTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required List<String> localPaths,
    this.readCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        localPaths = Value(localPaths);
  static Insertable<BookTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? localPaths,
    Expression<int>? readCount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (localPaths != null) 'local_paths': localPaths,
      if (readCount != null) 'read_count': readCount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BookTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<List<String>>? localPaths,
      Value<int>? readCount,
      Value<DateTime>? createdAt}) {
    return BookTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      localPaths: localPaths ?? this.localPaths,
      readCount: readCount ?? this.readCount,
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
    if (localPaths.present) {
      map['local_paths'] = Variable<String>(
          $BookTableTable.$converterlocalPaths.toSql(localPaths.value));
    }
    if (readCount.present) {
      map['read_count'] = Variable<int>(readCount.value);
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
          ..write('localPaths: $localPaths, ')
          ..write('readCount: $readCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DownloadTaskTableTable extends DownloadTaskTable
    with TableInfo<$DownloadTaskTableTable, DownloadTaskTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadTaskTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, url, fileName, filePath, status, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_task_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DownloadTaskTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadTaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadTaskTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DownloadTaskTableTable createAlias(String alias) {
    return $DownloadTaskTableTable(attachedDatabase, alias);
  }
}

class DownloadTaskTableData extends DataClass
    implements Insertable<DownloadTaskTableData> {
  final String id;
  final String? groupId;
  final String url;
  final String fileName;
  final String filePath;
  final String status;
  final DateTime createdAt;
  const DownloadTaskTableData(
      {required this.id,
      this.groupId,
      required this.url,
      required this.fileName,
      required this.filePath,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['url'] = Variable<String>(url);
    map['file_name'] = Variable<String>(fileName);
    map['file_path'] = Variable<String>(filePath);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DownloadTaskTableCompanion toCompanion(bool nullToAbsent) {
    return DownloadTaskTableCompanion(
      id: Value(id),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      url: Value(url),
      fileName: Value(fileName),
      filePath: Value(filePath),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory DownloadTaskTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadTaskTableData(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      url: serializer.fromJson<String>(json['url']),
      fileName: serializer.fromJson<String>(json['fileName']),
      filePath: serializer.fromJson<String>(json['filePath']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String?>(groupId),
      'url': serializer.toJson<String>(url),
      'fileName': serializer.toJson<String>(fileName),
      'filePath': serializer.toJson<String>(filePath),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DownloadTaskTableData copyWith(
          {String? id,
          Value<String?> groupId = const Value.absent(),
          String? url,
          String? fileName,
          String? filePath,
          String? status,
          DateTime? createdAt}) =>
      DownloadTaskTableData(
        id: id ?? this.id,
        groupId: groupId.present ? groupId.value : this.groupId,
        url: url ?? this.url,
        fileName: fileName ?? this.fileName,
        filePath: filePath ?? this.filePath,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  DownloadTaskTableData copyWithCompanion(DownloadTaskTableCompanion data) {
    return DownloadTaskTableData(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      url: data.url.present ? data.url.value : this.url,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTaskTableData(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('url: $url, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, url, fileName, filePath, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadTaskTableData &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.url == this.url &&
          other.fileName == this.fileName &&
          other.filePath == this.filePath &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class DownloadTaskTableCompanion
    extends UpdateCompanion<DownloadTaskTableData> {
  final Value<String> id;
  final Value<String?> groupId;
  final Value<String> url;
  final Value<String> fileName;
  final Value<String> filePath;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DownloadTaskTableCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.url = const Value.absent(),
    this.fileName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadTaskTableCompanion.insert({
    required String id,
    this.groupId = const Value.absent(),
    required String url,
    required String fileName,
    required String filePath,
    required String status,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        url = Value(url),
        fileName = Value(fileName),
        filePath = Value(filePath),
        status = Value(status);
  static Insertable<DownloadTaskTableData> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? url,
    Expression<String>? fileName,
    Expression<String>? filePath,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (url != null) 'url': url,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadTaskTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? groupId,
      Value<String>? url,
      Value<String>? fileName,
      Value<String>? filePath,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return DownloadTaskTableCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
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
    return (StringBuffer('DownloadTaskTableCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('url: $url, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadGroupTableTable extends DownloadGroupTable
    with TableInfo<$DownloadGroupTableTable, DownloadGroupTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadGroupTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalCountMeta =
      const VerificationMeta('totalCount');
  @override
  late final GeneratedColumn<int> totalCount = GeneratedColumn<int>(
      'total_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedCountMeta =
      const VerificationMeta('completedCount');
  @override
  late final GeneratedColumn<int> completedCount = GeneratedColumn<int>(
      'completed_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _failedCountMeta =
      const VerificationMeta('failedCount');
  @override
  late final GeneratedColumn<int> failedCount = GeneratedColumn<int>(
      'failed_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _runningCountMeta =
      const VerificationMeta('runningCount');
  @override
  late final GeneratedColumn<int> runningCount = GeneratedColumn<int>(
      'running_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _groupProgressMeta =
      const VerificationMeta('groupProgress');
  @override
  late final GeneratedColumn<double> groupProgress = GeneratedColumn<double>(
      'group_progress', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        totalCount,
        completedCount,
        failedCount,
        runningCount,
        groupProgress,
        createdAt,
        updatedAt,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_group_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DownloadGroupTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('total_count')) {
      context.handle(
          _totalCountMeta,
          totalCount.isAcceptableOrUnknown(
              data['total_count']!, _totalCountMeta));
    }
    if (data.containsKey('completed_count')) {
      context.handle(
          _completedCountMeta,
          completedCount.isAcceptableOrUnknown(
              data['completed_count']!, _completedCountMeta));
    }
    if (data.containsKey('failed_count')) {
      context.handle(
          _failedCountMeta,
          failedCount.isAcceptableOrUnknown(
              data['failed_count']!, _failedCountMeta));
    }
    if (data.containsKey('running_count')) {
      context.handle(
          _runningCountMeta,
          runningCount.isAcceptableOrUnknown(
              data['running_count']!, _runningCountMeta));
    }
    if (data.containsKey('group_progress')) {
      context.handle(
          _groupProgressMeta,
          groupProgress.isAcceptableOrUnknown(
              data['group_progress']!, _groupProgressMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadGroupTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadGroupTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      totalCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_count'])!,
      completedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_count'])!,
      failedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failed_count'])!,
      runningCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}running_count'])!,
      groupProgress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}group_progress'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $DownloadGroupTableTable createAlias(String alias) {
    return $DownloadGroupTableTable(attachedDatabase, alias);
  }
}

class DownloadGroupTableData extends DataClass
    implements Insertable<DownloadGroupTableData> {
  final String id;
  final String name;
  final int totalCount;
  final int completedCount;
  final int failedCount;
  final int runningCount;
  final double groupProgress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  const DownloadGroupTableData(
      {required this.id,
      required this.name,
      required this.totalCount,
      required this.completedCount,
      required this.failedCount,
      required this.runningCount,
      required this.groupProgress,
      required this.createdAt,
      required this.updatedAt,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['total_count'] = Variable<int>(totalCount);
    map['completed_count'] = Variable<int>(completedCount);
    map['failed_count'] = Variable<int>(failedCount);
    map['running_count'] = Variable<int>(runningCount);
    map['group_progress'] = Variable<double>(groupProgress);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  DownloadGroupTableCompanion toCompanion(bool nullToAbsent) {
    return DownloadGroupTableCompanion(
      id: Value(id),
      name: Value(name),
      totalCount: Value(totalCount),
      completedCount: Value(completedCount),
      failedCount: Value(failedCount),
      runningCount: Value(runningCount),
      groupProgress: Value(groupProgress),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory DownloadGroupTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadGroupTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      totalCount: serializer.fromJson<int>(json['totalCount']),
      completedCount: serializer.fromJson<int>(json['completedCount']),
      failedCount: serializer.fromJson<int>(json['failedCount']),
      runningCount: serializer.fromJson<int>(json['runningCount']),
      groupProgress: serializer.fromJson<double>(json['groupProgress']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'totalCount': serializer.toJson<int>(totalCount),
      'completedCount': serializer.toJson<int>(completedCount),
      'failedCount': serializer.toJson<int>(failedCount),
      'runningCount': serializer.toJson<int>(runningCount),
      'groupProgress': serializer.toJson<double>(groupProgress),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  DownloadGroupTableData copyWith(
          {String? id,
          String? name,
          int? totalCount,
          int? completedCount,
          int? failedCount,
          int? runningCount,
          double? groupProgress,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      DownloadGroupTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        totalCount: totalCount ?? this.totalCount,
        completedCount: completedCount ?? this.completedCount,
        failedCount: failedCount ?? this.failedCount,
        runningCount: runningCount ?? this.runningCount,
        groupProgress: groupProgress ?? this.groupProgress,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  DownloadGroupTableData copyWithCompanion(DownloadGroupTableCompanion data) {
    return DownloadGroupTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      totalCount:
          data.totalCount.present ? data.totalCount.value : this.totalCount,
      completedCount: data.completedCount.present
          ? data.completedCount.value
          : this.completedCount,
      failedCount:
          data.failedCount.present ? data.failedCount.value : this.failedCount,
      runningCount: data.runningCount.present
          ? data.runningCount.value
          : this.runningCount,
      groupProgress: data.groupProgress.present
          ? data.groupProgress.value
          : this.groupProgress,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadGroupTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('totalCount: $totalCount, ')
          ..write('completedCount: $completedCount, ')
          ..write('failedCount: $failedCount, ')
          ..write('runningCount: $runningCount, ')
          ..write('groupProgress: $groupProgress, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      totalCount,
      completedCount,
      failedCount,
      runningCount,
      groupProgress,
      createdAt,
      updatedAt,
      completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadGroupTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.totalCount == this.totalCount &&
          other.completedCount == this.completedCount &&
          other.failedCount == this.failedCount &&
          other.runningCount == this.runningCount &&
          other.groupProgress == this.groupProgress &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class DownloadGroupTableCompanion
    extends UpdateCompanion<DownloadGroupTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> totalCount;
  final Value<int> completedCount;
  final Value<int> failedCount;
  final Value<int> runningCount;
  final Value<double> groupProgress;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const DownloadGroupTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.completedCount = const Value.absent(),
    this.failedCount = const Value.absent(),
    this.runningCount = const Value.absent(),
    this.groupProgress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadGroupTableCompanion.insert({
    required String id,
    required String name,
    this.totalCount = const Value.absent(),
    this.completedCount = const Value.absent(),
    this.failedCount = const Value.absent(),
    this.runningCount = const Value.absent(),
    this.groupProgress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<DownloadGroupTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? totalCount,
    Expression<int>? completedCount,
    Expression<int>? failedCount,
    Expression<int>? runningCount,
    Expression<double>? groupProgress,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (totalCount != null) 'total_count': totalCount,
      if (completedCount != null) 'completed_count': completedCount,
      if (failedCount != null) 'failed_count': failedCount,
      if (runningCount != null) 'running_count': runningCount,
      if (groupProgress != null) 'group_progress': groupProgress,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadGroupTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? totalCount,
      Value<int>? completedCount,
      Value<int>? failedCount,
      Value<int>? runningCount,
      Value<double>? groupProgress,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return DownloadGroupTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      totalCount: totalCount ?? this.totalCount,
      completedCount: completedCount ?? this.completedCount,
      failedCount: failedCount ?? this.failedCount,
      runningCount: runningCount ?? this.runningCount,
      groupProgress: groupProgress ?? this.groupProgress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (totalCount.present) {
      map['total_count'] = Variable<int>(totalCount.value);
    }
    if (completedCount.present) {
      map['completed_count'] = Variable<int>(completedCount.value);
    }
    if (failedCount.present) {
      map['failed_count'] = Variable<int>(failedCount.value);
    }
    if (runningCount.present) {
      map['running_count'] = Variable<int>(runningCount.value);
    }
    if (groupProgress.present) {
      map['group_progress'] = Variable<double>(groupProgress.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadGroupTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('totalCount: $totalCount, ')
          ..write('completedCount: $completedCount, ')
          ..write('failedCount: $failedCount, ')
          ..write('runningCount: $runningCount, ')
          ..write('groupProgress: $groupProgress, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookTableTable bookTable = $BookTableTable(this);
  late final $DownloadTaskTableTable downloadTaskTable =
      $DownloadTaskTableTable(this);
  late final $DownloadGroupTableTable downloadGroupTable =
      $DownloadGroupTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [bookTable, downloadTaskTable, downloadGroupTable];
}

typedef $$BookTableTableCreateCompanionBuilder = BookTableCompanion Function({
  Value<int> id,
  required String name,
  required List<String> localPaths,
  Value<int> readCount,
  Value<DateTime> createdAt,
});
typedef $$BookTableTableUpdateCompanionBuilder = BookTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<List<String>> localPaths,
  Value<int> readCount,
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
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get localPaths => $composableBuilder(
          column: $table.localPaths,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get readCount => $composableBuilder(
      column: $table.readCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get localPaths => $composableBuilder(
      column: $table.localPaths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get readCount => $composableBuilder(
      column: $table.readCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumnWithTypeConverter<List<String>, String> get localPaths =>
      $composableBuilder(
          column: $table.localPaths, builder: (column) => column);

  GeneratedColumn<int> get readCount =>
      $composableBuilder(column: $table.readCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
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
            Value<List<String>> localPaths = const Value.absent(),
            Value<int> readCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BookTableCompanion(
            id: id,
            name: name,
            localPaths: localPaths,
            readCount: readCount,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required List<String> localPaths,
            Value<int> readCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BookTableCompanion.insert(
            id: id,
            name: name,
            localPaths: localPaths,
            readCount: readCount,
            createdAt: createdAt,
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
typedef $$DownloadTaskTableTableCreateCompanionBuilder
    = DownloadTaskTableCompanion Function({
  required String id,
  Value<String?> groupId,
  required String url,
  required String fileName,
  required String filePath,
  required String status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$DownloadTaskTableTableUpdateCompanionBuilder
    = DownloadTaskTableCompanion Function({
  Value<String> id,
  Value<String?> groupId,
  Value<String> url,
  Value<String> fileName,
  Value<String> filePath,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$DownloadTaskTableTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadTaskTableTable> {
  $$DownloadTaskTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DownloadTaskTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadTaskTableTable> {
  $$DownloadTaskTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DownloadTaskTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadTaskTableTable> {
  $$DownloadTaskTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DownloadTaskTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadTaskTableTable,
    DownloadTaskTableData,
    $$DownloadTaskTableTableFilterComposer,
    $$DownloadTaskTableTableOrderingComposer,
    $$DownloadTaskTableTableAnnotationComposer,
    $$DownloadTaskTableTableCreateCompanionBuilder,
    $$DownloadTaskTableTableUpdateCompanionBuilder,
    (
      DownloadTaskTableData,
      BaseReferences<_$AppDatabase, $DownloadTaskTableTable,
          DownloadTaskTableData>
    ),
    DownloadTaskTableData,
    PrefetchHooks Function()> {
  $$DownloadTaskTableTableTableManager(
      _$AppDatabase db, $DownloadTaskTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadTaskTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadTaskTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadTaskTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadTaskTableCompanion(
            id: id,
            groupId: groupId,
            url: url,
            fileName: fileName,
            filePath: filePath,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> groupId = const Value.absent(),
            required String url,
            required String fileName,
            required String filePath,
            required String status,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadTaskTableCompanion.insert(
            id: id,
            groupId: groupId,
            url: url,
            fileName: fileName,
            filePath: filePath,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadTaskTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadTaskTableTable,
    DownloadTaskTableData,
    $$DownloadTaskTableTableFilterComposer,
    $$DownloadTaskTableTableOrderingComposer,
    $$DownloadTaskTableTableAnnotationComposer,
    $$DownloadTaskTableTableCreateCompanionBuilder,
    $$DownloadTaskTableTableUpdateCompanionBuilder,
    (
      DownloadTaskTableData,
      BaseReferences<_$AppDatabase, $DownloadTaskTableTable,
          DownloadTaskTableData>
    ),
    DownloadTaskTableData,
    PrefetchHooks Function()>;
typedef $$DownloadGroupTableTableCreateCompanionBuilder
    = DownloadGroupTableCompanion Function({
  required String id,
  required String name,
  Value<int> totalCount,
  Value<int> completedCount,
  Value<int> failedCount,
  Value<int> runningCount,
  Value<double> groupProgress,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$DownloadGroupTableTableUpdateCompanionBuilder
    = DownloadGroupTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> totalCount,
  Value<int> completedCount,
  Value<int> failedCount,
  Value<int> runningCount,
  Value<double> groupProgress,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$DownloadGroupTableTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadGroupTableTable> {
  $$DownloadGroupTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCount => $composableBuilder(
      column: $table.totalCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedCount => $composableBuilder(
      column: $table.completedCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failedCount => $composableBuilder(
      column: $table.failedCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runningCount => $composableBuilder(
      column: $table.runningCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get groupProgress => $composableBuilder(
      column: $table.groupProgress, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$DownloadGroupTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadGroupTableTable> {
  $$DownloadGroupTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCount => $composableBuilder(
      column: $table.totalCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedCount => $composableBuilder(
      column: $table.completedCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failedCount => $composableBuilder(
      column: $table.failedCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runningCount => $composableBuilder(
      column: $table.runningCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get groupProgress => $composableBuilder(
      column: $table.groupProgress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$DownloadGroupTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadGroupTableTable> {
  $$DownloadGroupTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get totalCount => $composableBuilder(
      column: $table.totalCount, builder: (column) => column);

  GeneratedColumn<int> get completedCount => $composableBuilder(
      column: $table.completedCount, builder: (column) => column);

  GeneratedColumn<int> get failedCount => $composableBuilder(
      column: $table.failedCount, builder: (column) => column);

  GeneratedColumn<int> get runningCount => $composableBuilder(
      column: $table.runningCount, builder: (column) => column);

  GeneratedColumn<double> get groupProgress => $composableBuilder(
      column: $table.groupProgress, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$DownloadGroupTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadGroupTableTable,
    DownloadGroupTableData,
    $$DownloadGroupTableTableFilterComposer,
    $$DownloadGroupTableTableOrderingComposer,
    $$DownloadGroupTableTableAnnotationComposer,
    $$DownloadGroupTableTableCreateCompanionBuilder,
    $$DownloadGroupTableTableUpdateCompanionBuilder,
    (
      DownloadGroupTableData,
      BaseReferences<_$AppDatabase, $DownloadGroupTableTable,
          DownloadGroupTableData>
    ),
    DownloadGroupTableData,
    PrefetchHooks Function()> {
  $$DownloadGroupTableTableTableManager(
      _$AppDatabase db, $DownloadGroupTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadGroupTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadGroupTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadGroupTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> totalCount = const Value.absent(),
            Value<int> completedCount = const Value.absent(),
            Value<int> failedCount = const Value.absent(),
            Value<int> runningCount = const Value.absent(),
            Value<double> groupProgress = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadGroupTableCompanion(
            id: id,
            name: name,
            totalCount: totalCount,
            completedCount: completedCount,
            failedCount: failedCount,
            runningCount: runningCount,
            groupProgress: groupProgress,
            createdAt: createdAt,
            updatedAt: updatedAt,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> totalCount = const Value.absent(),
            Value<int> completedCount = const Value.absent(),
            Value<int> failedCount = const Value.absent(),
            Value<int> runningCount = const Value.absent(),
            Value<double> groupProgress = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadGroupTableCompanion.insert(
            id: id,
            name: name,
            totalCount: totalCount,
            completedCount: completedCount,
            failedCount: failedCount,
            runningCount: runningCount,
            groupProgress: groupProgress,
            createdAt: createdAt,
            updatedAt: updatedAt,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadGroupTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadGroupTableTable,
    DownloadGroupTableData,
    $$DownloadGroupTableTableFilterComposer,
    $$DownloadGroupTableTableOrderingComposer,
    $$DownloadGroupTableTableAnnotationComposer,
    $$DownloadGroupTableTableCreateCompanionBuilder,
    $$DownloadGroupTableTableUpdateCompanionBuilder,
    (
      DownloadGroupTableData,
      BaseReferences<_$AppDatabase, $DownloadGroupTableTable,
          DownloadGroupTableData>
    ),
    DownloadGroupTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db, _db.bookTable);
  $$DownloadTaskTableTableTableManager get downloadTaskTable =>
      $$DownloadTaskTableTableTableManager(_db, _db.downloadTaskTable);
  $$DownloadGroupTableTableTableManager get downloadGroupTable =>
      $$DownloadGroupTableTableTableManager(_db, _db.downloadGroupTable);
}
