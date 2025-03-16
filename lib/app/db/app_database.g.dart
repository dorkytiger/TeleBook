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

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
      $converterlocalPaths = const StringListConverter();
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
      $converterimageUrls = const StringListConverter();
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
      localPaths: $BookTableTable.$converterlocalPaths
          .fromJson(serializer.fromJson<List<dynamic>>(json['localPaths'])),
      downloadCount: serializer.fromJson<int>(json['downloadCount']),
      isDownload: serializer.fromJson<bool>(json['isDownload']),
      imageUrls: $BookTableTable.$converterimageUrls
          .fromJson(serializer.fromJson<List<dynamic>>(json['imageUrls'])),
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
      'localPaths': serializer.toJson<List<dynamic>>(
          $BookTableTable.$converterlocalPaths.toJson(localPaths)),
      'downloadCount': serializer.toJson<int>(downloadCount),
      'isDownload': serializer.toJson<bool>(isDownload),
      'imageUrls': serializer.toJson<List<dynamic>>(
          $BookTableTable.$converterimageUrls.toJson(imageUrls)),
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
      defaultValue: Constant(BookPageLayout.row.name));
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
      'host', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("192.168.1.1"));
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
      'port', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(22));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("root"));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("root"));
  static const VerificationMeta _dataPathMeta =
      const VerificationMeta('dataPath');
  @override
  late final GeneratedColumn<String> dataPath = GeneratedColumn<String>(
      'data_path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("~/data"));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant("~/image"));
  @override
  List<GeneratedColumn> get $columns =>
      [id, pageLayout, host, port, username, password, dataPath, imagePath];
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
    if (data.containsKey('host')) {
      context.handle(
          _hostMeta, host.isAcceptableOrUnknown(data['host']!, _hostMeta));
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    }
    if (data.containsKey('data_path')) {
      context.handle(_dataPathMeta,
          dataPath.isAcceptableOrUnknown(data['data_path']!, _dataPathMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
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
      host: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}host'])!,
      port: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}port'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      dataPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_path'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
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
  final String host;
  final int port;
  final String username;
  final String password;
  final String dataPath;
  final String imagePath;
  const SettingTableData(
      {required this.id,
      required this.pageLayout,
      required this.host,
      required this.port,
      required this.username,
      required this.password,
      required this.dataPath,
      required this.imagePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['page_layout'] = Variable<String>(pageLayout);
    map['host'] = Variable<String>(host);
    map['port'] = Variable<int>(port);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['data_path'] = Variable<String>(dataPath);
    map['image_path'] = Variable<String>(imagePath);
    return map;
  }

  SettingTableCompanion toCompanion(bool nullToAbsent) {
    return SettingTableCompanion(
      id: Value(id),
      pageLayout: Value(pageLayout),
      host: Value(host),
      port: Value(port),
      username: Value(username),
      password: Value(password),
      dataPath: Value(dataPath),
      imagePath: Value(imagePath),
    );
  }

  factory SettingTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingTableData(
      id: serializer.fromJson<int>(json['id']),
      pageLayout: serializer.fromJson<String>(json['pageLayout']),
      host: serializer.fromJson<String>(json['host']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      dataPath: serializer.fromJson<String>(json['dataPath']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pageLayout': serializer.toJson<String>(pageLayout),
      'host': serializer.toJson<String>(host),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'dataPath': serializer.toJson<String>(dataPath),
      'imagePath': serializer.toJson<String>(imagePath),
    };
  }

  SettingTableData copyWith(
          {int? id,
          String? pageLayout,
          String? host,
          int? port,
          String? username,
          String? password,
          String? dataPath,
          String? imagePath}) =>
      SettingTableData(
        id: id ?? this.id,
        pageLayout: pageLayout ?? this.pageLayout,
        host: host ?? this.host,
        port: port ?? this.port,
        username: username ?? this.username,
        password: password ?? this.password,
        dataPath: dataPath ?? this.dataPath,
        imagePath: imagePath ?? this.imagePath,
      );
  SettingTableData copyWithCompanion(SettingTableCompanion data) {
    return SettingTableData(
      id: data.id.present ? data.id.value : this.id,
      pageLayout:
          data.pageLayout.present ? data.pageLayout.value : this.pageLayout,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      dataPath: data.dataPath.present ? data.dataPath.value : this.dataPath,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingTableData(')
          ..write('id: $id, ')
          ..write('pageLayout: $pageLayout, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('dataPath: $dataPath, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, pageLayout, host, port, username, password, dataPath, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingTableData &&
          other.id == this.id &&
          other.pageLayout == this.pageLayout &&
          other.host == this.host &&
          other.port == this.port &&
          other.username == this.username &&
          other.password == this.password &&
          other.dataPath == this.dataPath &&
          other.imagePath == this.imagePath);
}

class SettingTableCompanion extends UpdateCompanion<SettingTableData> {
  final Value<int> id;
  final Value<String> pageLayout;
  final Value<String> host;
  final Value<int> port;
  final Value<String> username;
  final Value<String> password;
  final Value<String> dataPath;
  final Value<String> imagePath;
  const SettingTableCompanion({
    this.id = const Value.absent(),
    this.pageLayout = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.dataPath = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  SettingTableCompanion.insert({
    this.id = const Value.absent(),
    this.pageLayout = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.dataPath = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  static Insertable<SettingTableData> custom({
    Expression<int>? id,
    Expression<String>? pageLayout,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? dataPath,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pageLayout != null) 'page_layout': pageLayout,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (dataPath != null) 'data_path': dataPath,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  SettingTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? pageLayout,
      Value<String>? host,
      Value<int>? port,
      Value<String>? username,
      Value<String>? password,
      Value<String>? dataPath,
      Value<String>? imagePath}) {
    return SettingTableCompanion(
      id: id ?? this.id,
      pageLayout: pageLayout ?? this.pageLayout,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      dataPath: dataPath ?? this.dataPath,
      imagePath: imagePath ?? this.imagePath,
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
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (dataPath.present) {
      map['data_path'] = Variable<String>(dataPath.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingTableCompanion(')
          ..write('id: $id, ')
          ..write('pageLayout: $pageLayout, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('dataPath: $dataPath, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class $DownloadTableTable extends DownloadTable
    with TableInfo<$DownloadTableTable, DownloadTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'book_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> localPaths =
      GeneratedColumn<String>('local_paths', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $DownloadTableTable.$converterlocalPaths);
  static const VerificationMeta _downloadCountMeta =
      const VerificationMeta('downloadCount');
  @override
  late final GeneratedColumn<int> downloadCount = GeneratedColumn<int>(
      'download_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> imageUrls =
      GeneratedColumn<String>('image_urls', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($DownloadTableTable.$converterimageUrls);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookId, name, localPaths, downloadCount, imageUrls];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_table';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('download_count')) {
      context.handle(
          _downloadCountMeta,
          downloadCount.isAcceptableOrUnknown(
              data['download_count']!, _downloadCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      localPaths: $DownloadTableTable.$converterlocalPaths.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}local_paths'])!),
      downloadCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}download_count'])!,
      imageUrls: $DownloadTableTable.$converterimageUrls.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}image_urls'])!),
    );
  }

  @override
  $DownloadTableTable createAlias(String alias) {
    return $DownloadTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
      $converterlocalPaths = const StringListConverter();
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
      $converterimageUrls = const StringListConverter();
}

class DownloadTableData extends DataClass
    implements Insertable<DownloadTableData> {
  final int id;
  final int bookId;
  final String name;
  final List<String> localPaths;
  final int downloadCount;
  final List<String> imageUrls;
  const DownloadTableData(
      {required this.id,
      required this.bookId,
      required this.name,
      required this.localPaths,
      required this.downloadCount,
      required this.imageUrls});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['name'] = Variable<String>(name);
    {
      map['local_paths'] = Variable<String>(
          $DownloadTableTable.$converterlocalPaths.toSql(localPaths));
    }
    map['download_count'] = Variable<int>(downloadCount);
    {
      map['image_urls'] = Variable<String>(
          $DownloadTableTable.$converterimageUrls.toSql(imageUrls));
    }
    return map;
  }

  DownloadTableCompanion toCompanion(bool nullToAbsent) {
    return DownloadTableCompanion(
      id: Value(id),
      bookId: Value(bookId),
      name: Value(name),
      localPaths: Value(localPaths),
      downloadCount: Value(downloadCount),
      imageUrls: Value(imageUrls),
    );
  }

  factory DownloadTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadTableData(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      name: serializer.fromJson<String>(json['name']),
      localPaths: $DownloadTableTable.$converterlocalPaths
          .fromJson(serializer.fromJson<List<dynamic>>(json['localPaths'])),
      downloadCount: serializer.fromJson<int>(json['downloadCount']),
      imageUrls: $DownloadTableTable.$converterimageUrls
          .fromJson(serializer.fromJson<List<dynamic>>(json['imageUrls'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'name': serializer.toJson<String>(name),
      'localPaths': serializer.toJson<List<dynamic>>(
          $DownloadTableTable.$converterlocalPaths.toJson(localPaths)),
      'downloadCount': serializer.toJson<int>(downloadCount),
      'imageUrls': serializer.toJson<List<dynamic>>(
          $DownloadTableTable.$converterimageUrls.toJson(imageUrls)),
    };
  }

  DownloadTableData copyWith(
          {int? id,
          int? bookId,
          String? name,
          List<String>? localPaths,
          int? downloadCount,
          List<String>? imageUrls}) =>
      DownloadTableData(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        name: name ?? this.name,
        localPaths: localPaths ?? this.localPaths,
        downloadCount: downloadCount ?? this.downloadCount,
        imageUrls: imageUrls ?? this.imageUrls,
      );
  DownloadTableData copyWithCompanion(DownloadTableCompanion data) {
    return DownloadTableData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      name: data.name.present ? data.name.value : this.name,
      localPaths:
          data.localPaths.present ? data.localPaths.value : this.localPaths,
      downloadCount: data.downloadCount.present
          ? data.downloadCount.value
          : this.downloadCount,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTableData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('name: $name, ')
          ..write('localPaths: $localPaths, ')
          ..write('downloadCount: $downloadCount, ')
          ..write('imageUrls: $imageUrls')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, name, localPaths, downloadCount, imageUrls);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadTableData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.name == this.name &&
          other.localPaths == this.localPaths &&
          other.downloadCount == this.downloadCount &&
          other.imageUrls == this.imageUrls);
}

class DownloadTableCompanion extends UpdateCompanion<DownloadTableData> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<String> name;
  final Value<List<String>> localPaths;
  final Value<int> downloadCount;
  final Value<List<String>> imageUrls;
  const DownloadTableCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.name = const Value.absent(),
    this.localPaths = const Value.absent(),
    this.downloadCount = const Value.absent(),
    this.imageUrls = const Value.absent(),
  });
  DownloadTableCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required String name,
    required List<String> localPaths,
    this.downloadCount = const Value.absent(),
    required List<String> imageUrls,
  })  : bookId = Value(bookId),
        name = Value(name),
        localPaths = Value(localPaths),
        imageUrls = Value(imageUrls);
  static Insertable<DownloadTableData> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<String>? name,
    Expression<String>? localPaths,
    Expression<int>? downloadCount,
    Expression<String>? imageUrls,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (name != null) 'name': name,
      if (localPaths != null) 'local_paths': localPaths,
      if (downloadCount != null) 'download_count': downloadCount,
      if (imageUrls != null) 'image_urls': imageUrls,
    });
  }

  DownloadTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? bookId,
      Value<String>? name,
      Value<List<String>>? localPaths,
      Value<int>? downloadCount,
      Value<List<String>>? imageUrls}) {
    return DownloadTableCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      localPaths: localPaths ?? this.localPaths,
      downloadCount: downloadCount ?? this.downloadCount,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (localPaths.present) {
      map['local_paths'] = Variable<String>(
          $DownloadTableTable.$converterlocalPaths.toSql(localPaths.value));
    }
    if (downloadCount.present) {
      map['download_count'] = Variable<int>(downloadCount.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(
          $DownloadTableTable.$converterimageUrls.toSql(imageUrls.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTableCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('name: $name, ')
          ..write('localPaths: $localPaths, ')
          ..write('downloadCount: $downloadCount, ')
          ..write('imageUrls: $imageUrls')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookTableTable bookTable = $BookTableTable(this);
  late final $SettingTableTable settingTable = $SettingTableTable(this);
  late final $DownloadTableTable downloadTable = $DownloadTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [bookTable, settingTable, downloadTable];
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
  Value<String> host,
  Value<int> port,
  Value<String> username,
  Value<String> password,
  Value<String> dataPath,
  Value<String> imagePath,
});
typedef $$SettingTableTableUpdateCompanionBuilder = SettingTableCompanion
    Function({
  Value<int> id,
  Value<String> pageLayout,
  Value<String> host,
  Value<int> port,
  Value<String> username,
  Value<String> password,
  Value<String> dataPath,
  Value<String> imagePath,
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

  ColumnFilters<String> get host => $composableBuilder(
      column: $table.host, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get port => $composableBuilder(
      column: $table.port, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dataPath => $composableBuilder(
      column: $table.dataPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get host => $composableBuilder(
      column: $table.host, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get port => $composableBuilder(
      column: $table.port, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataPath => $composableBuilder(
      column: $table.dataPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get dataPath =>
      $composableBuilder(column: $table.dataPath, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);
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
            Value<String> host = const Value.absent(),
            Value<int> port = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> dataPath = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
          }) =>
              SettingTableCompanion(
            id: id,
            pageLayout: pageLayout,
            host: host,
            port: port,
            username: username,
            password: password,
            dataPath: dataPath,
            imagePath: imagePath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pageLayout = const Value.absent(),
            Value<String> host = const Value.absent(),
            Value<int> port = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> dataPath = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
          }) =>
              SettingTableCompanion.insert(
            id: id,
            pageLayout: pageLayout,
            host: host,
            port: port,
            username: username,
            password: password,
            dataPath: dataPath,
            imagePath: imagePath,
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
typedef $$DownloadTableTableCreateCompanionBuilder = DownloadTableCompanion
    Function({
  Value<int> id,
  required int bookId,
  required String name,
  required List<String> localPaths,
  Value<int> downloadCount,
  required List<String> imageUrls,
});
typedef $$DownloadTableTableUpdateCompanionBuilder = DownloadTableCompanion
    Function({
  Value<int> id,
  Value<int> bookId,
  Value<String> name,
  Value<List<String>> localPaths,
  Value<int> downloadCount,
  Value<List<String>> imageUrls,
});

class $$DownloadTableTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadTableTable> {
  $$DownloadTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get localPaths => $composableBuilder(
          column: $table.localPaths,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get imageUrls => $composableBuilder(
          column: $table.imageUrls,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$DownloadTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadTableTable> {
  $$DownloadTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPaths => $composableBuilder(
      column: $table.localPaths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrls => $composableBuilder(
      column: $table.imageUrls, builder: (column) => ColumnOrderings(column));
}

class $$DownloadTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadTableTable> {
  $$DownloadTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get localPaths =>
      $composableBuilder(
          column: $table.localPaths, builder: (column) => column);

  GeneratedColumn<int> get downloadCount => $composableBuilder(
      column: $table.downloadCount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);
}

class $$DownloadTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadTableTable,
    DownloadTableData,
    $$DownloadTableTableFilterComposer,
    $$DownloadTableTableOrderingComposer,
    $$DownloadTableTableAnnotationComposer,
    $$DownloadTableTableCreateCompanionBuilder,
    $$DownloadTableTableUpdateCompanionBuilder,
    (
      DownloadTableData,
      BaseReferences<_$AppDatabase, $DownloadTableTable, DownloadTableData>
    ),
    DownloadTableData,
    PrefetchHooks Function()> {
  $$DownloadTableTableTableManager(_$AppDatabase db, $DownloadTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<List<String>> localPaths = const Value.absent(),
            Value<int> downloadCount = const Value.absent(),
            Value<List<String>> imageUrls = const Value.absent(),
          }) =>
              DownloadTableCompanion(
            id: id,
            bookId: bookId,
            name: name,
            localPaths: localPaths,
            downloadCount: downloadCount,
            imageUrls: imageUrls,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bookId,
            required String name,
            required List<String> localPaths,
            Value<int> downloadCount = const Value.absent(),
            required List<String> imageUrls,
          }) =>
              DownloadTableCompanion.insert(
            id: id,
            bookId: bookId,
            name: name,
            localPaths: localPaths,
            downloadCount: downloadCount,
            imageUrls: imageUrls,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadTableTable,
    DownloadTableData,
    $$DownloadTableTableFilterComposer,
    $$DownloadTableTableOrderingComposer,
    $$DownloadTableTableAnnotationComposer,
    $$DownloadTableTableCreateCompanionBuilder,
    $$DownloadTableTableUpdateCompanionBuilder,
    (
      DownloadTableData,
      BaseReferences<_$AppDatabase, $DownloadTableTable, DownloadTableData>
    ),
    DownloadTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookTableTableTableManager get bookTable =>
      $$BookTableTableTableManager(_db, _db.bookTable);
  $$SettingTableTableTableManager get settingTable =>
      $$SettingTableTableTableManager(_db, _db.settingTable);
  $$DownloadTableTableTableManager get downloadTable =>
      $$DownloadTableTableTableManager(_db, _db.downloadTable);
}
