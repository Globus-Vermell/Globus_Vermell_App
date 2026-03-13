// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBuildingCollection on Isar {
  IsarCollection<Building> get buildings => this.collection();
}

const BuildingSchema = CollectionSchema(
  name: r'Building',
  id: 199638258626961957,
  properties: {
    r'architects': PropertySchema(
      id: 0,
      name: r'architects',
      type: IsarType.stringList,
    ),
    r'constructionYear': PropertySchema(
      id: 1,
      name: r'constructionYear',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'idProtection': PropertySchema(
      id: 3,
      name: r'idProtection',
      type: IsarType.long,
    ),
    r'idTypology': PropertySchema(
      id: 4,
      name: r'idTypology',
      type: IsarType.long,
    ),
    r'images': PropertySchema(
      id: 5,
      name: r'images',
      type: IsarType.stringList,
    ),
    r'latitude': PropertySchema(
      id: 6,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'location': PropertySchema(
      id: 7,
      name: r'location',
      type: IsarType.string,
    ),
    r'longitude': PropertySchema(
      id: 8,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 9,
      name: r'name',
      type: IsarType.string,
    ),
    r'prizes': PropertySchema(
      id: 10,
      name: r'prizes',
      type: IsarType.stringList,
    ),
    r'protectionName': PropertySchema(
      id: 11,
      name: r'protectionName',
      type: IsarType.string,
    ),
    r'publications': PropertySchema(
      id: 12,
      name: r'publications',
      type: IsarType.stringList,
    ),
    r'reforms': PropertySchema(
      id: 13,
      name: r'reforms',
      type: IsarType.stringList,
    ),
    r'surfaceArea': PropertySchema(
      id: 14,
      name: r'surfaceArea',
      type: IsarType.long,
    ),
    r'typologyName': PropertySchema(
      id: 15,
      name: r'typologyName',
      type: IsarType.string,
    ),
    r'uses': PropertySchema(
      id: 16,
      name: r'uses',
      type: IsarType.stringList,
    ),
    r'validate': PropertySchema(
      id: 17,
      name: r'validate',
      type: IsarType.bool,
    )
  },
  estimateSize: _buildingEstimateSize,
  serialize: _buildingSerialize,
  deserialize: _buildingDeserialize,
  deserializeProp: _buildingDeserializeProp,
  idName: r'idBuilding',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _buildingGetId,
  getLinks: _buildingGetLinks,
  attach: _buildingAttach,
  version: '3.1.0+1',
);

int _buildingEstimateSize(
  Building object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.architects.length * 3;
  {
    for (var i = 0; i < object.architects.length; i++) {
      final value = object.architects[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.images.length * 3;
  {
    for (var i = 0; i < object.images.length; i++) {
      final value = object.images[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.prizes.length * 3;
  {
    for (var i = 0; i < object.prizes.length; i++) {
      final value = object.prizes[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.protectionName.length * 3;
  bytesCount += 3 + object.publications.length * 3;
  {
    for (var i = 0; i < object.publications.length; i++) {
      final value = object.publications[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.reforms.length * 3;
  {
    for (var i = 0; i < object.reforms.length; i++) {
      final value = object.reforms[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.typologyName.length * 3;
  bytesCount += 3 + object.uses.length * 3;
  {
    for (var i = 0; i < object.uses.length; i++) {
      final value = object.uses[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _buildingSerialize(
  Building object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.architects);
  writer.writeLong(offsets[1], object.constructionYear);
  writer.writeString(offsets[2], object.description);
  writer.writeLong(offsets[3], object.idProtection);
  writer.writeLong(offsets[4], object.idTypology);
  writer.writeStringList(offsets[5], object.images);
  writer.writeDouble(offsets[6], object.latitude);
  writer.writeString(offsets[7], object.location);
  writer.writeDouble(offsets[8], object.longitude);
  writer.writeString(offsets[9], object.name);
  writer.writeStringList(offsets[10], object.prizes);
  writer.writeString(offsets[11], object.protectionName);
  writer.writeStringList(offsets[12], object.publications);
  writer.writeStringList(offsets[13], object.reforms);
  writer.writeLong(offsets[14], object.surfaceArea);
  writer.writeString(offsets[15], object.typologyName);
  writer.writeStringList(offsets[16], object.uses);
  writer.writeBool(offsets[17], object.validate);
}

Building _buildingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Building(
    architects: reader.readStringList(offsets[0]) ?? const [],
    constructionYear: reader.readLong(offsets[1]),
    description: reader.readString(offsets[2]),
    idBuilding: id,
    idProtection: reader.readLong(offsets[3]),
    idTypology: reader.readLong(offsets[4]),
    images: reader.readStringList(offsets[5]) ?? const [],
    latitude: reader.readDoubleOrNull(offsets[6]) ?? 0.0,
    location: reader.readString(offsets[7]),
    longitude: reader.readDoubleOrNull(offsets[8]) ?? 0.0,
    name: reader.readString(offsets[9]),
    prizes: reader.readStringList(offsets[10]) ?? const [],
    protectionName: reader.readStringOrNull(offsets[11]) ?? '',
    publications: reader.readStringList(offsets[12]) ?? const [],
    reforms: reader.readStringList(offsets[13]) ?? const [],
    surfaceArea: reader.readLong(offsets[14]),
    typologyName: reader.readStringOrNull(offsets[15]) ?? '',
    uses: reader.readStringList(offsets[16]) ?? const [],
    validate: reader.readBool(offsets[17]),
  );
  return object;
}

P _buildingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? const []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? const []) as P;
    case 6:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringList(offset) ?? const []) as P;
    case 11:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 12:
      return (reader.readStringList(offset) ?? const []) as P;
    case 13:
      return (reader.readStringList(offset) ?? const []) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 16:
      return (reader.readStringList(offset) ?? const []) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _buildingGetId(Building object) {
  return object.idBuilding;
}

List<IsarLinkBase<dynamic>> _buildingGetLinks(Building object) {
  return [];
}

void _buildingAttach(IsarCollection<dynamic> col, Id id, Building object) {
  object.idBuilding = id;
}

extension BuildingQueryWhereSort on QueryBuilder<Building, Building, QWhere> {
  QueryBuilder<Building, Building, QAfterWhere> anyIdBuilding() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BuildingQueryWhere on QueryBuilder<Building, Building, QWhereClause> {
  QueryBuilder<Building, Building, QAfterWhereClause> idBuildingEqualTo(
      Id idBuilding) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: idBuilding,
        upper: idBuilding,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterWhereClause> idBuildingNotEqualTo(
      Id idBuilding) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: idBuilding, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: idBuilding, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: idBuilding, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: idBuilding, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Building, Building, QAfterWhereClause> idBuildingGreaterThan(
      Id idBuilding,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: idBuilding, includeLower: include),
      );
    });
  }

  QueryBuilder<Building, Building, QAfterWhereClause> idBuildingLessThan(
      Id idBuilding,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: idBuilding, includeUpper: include),
      );
    });
  }

  QueryBuilder<Building, Building, QAfterWhereClause> idBuildingBetween(
    Id lowerIdBuilding,
    Id upperIdBuilding, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIdBuilding,
        includeLower: includeLower,
        upper: upperIdBuilding,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BuildingQueryFilter
    on QueryBuilder<Building, Building, QFilterCondition> {
  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'architects',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'architects',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'architects',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'architects',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'architects',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'architects',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'architects',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'architects',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'architects',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'architects',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'architects',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> architectsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'architects',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'architects',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'architects',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'architects',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      architectsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'architects',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      constructionYearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'constructionYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      constructionYearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'constructionYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      constructionYearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'constructionYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      constructionYearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'constructionYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idBuildingEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idBuilding',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idBuildingGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idBuilding',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idBuildingLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idBuilding',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idBuildingBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idBuilding',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idProtectionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idProtection',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      idProtectionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idProtection',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idProtectionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idProtection',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idProtectionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idProtection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idTypologyEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idTypology',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idTypologyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idTypology',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idTypologyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idTypology',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> idTypologyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idTypology',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'images',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      imagesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'images',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'images',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'images',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      imagesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'images',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'images',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'images',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'images',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      imagesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'images',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      imagesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'images',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'images',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'images',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'images',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'images',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      imagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'images',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> imagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'images',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'location',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prizes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      prizesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prizes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prizes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prizes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      prizesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prizes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prizes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prizes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prizes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      prizesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prizes',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      prizesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prizes',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prizes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prizes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prizes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prizes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      prizesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prizes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> prizesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'prizes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> protectionNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      protectionNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      protectionNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> protectionNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protectionName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      protectionNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'protectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      protectionNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'protectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      protectionNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'protectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> protectionNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'protectionName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      protectionNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protectionName',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      protectionNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'protectionName',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publications',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'publications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'publications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'publications',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'publications',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publications',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'publications',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'publications',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'publications',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'publications',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'publications',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'publications',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      publicationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'publications',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> reformsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reforms',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      reformsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reforms',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      reformsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reforms',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> reformsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reforms',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      reformsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reforms',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      reformsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reforms',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      reformsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reforms',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> reformsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reforms',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      reformsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reforms',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      reformsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reforms',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> reformsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reforms',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> reformsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reforms',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> reformsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reforms',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> reformsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reforms',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      reformsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reforms',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> reformsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reforms',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> surfaceAreaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surfaceArea',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      surfaceAreaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surfaceArea',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> surfaceAreaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surfaceArea',
        value: value,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> surfaceAreaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surfaceArea',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> typologyNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typologyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      typologyNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typologyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> typologyNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typologyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> typologyNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typologyName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      typologyNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typologyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> typologyNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typologyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> typologyNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typologyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> typologyNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typologyName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      typologyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typologyName',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      typologyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typologyName',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      usesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uses',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uses',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition>
      usesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uses',
        value: '',
      ));
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uses',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uses',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uses',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uses',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uses',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> usesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'uses',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Building, Building, QAfterFilterCondition> validateEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'validate',
        value: value,
      ));
    });
  }
}

extension BuildingQueryObject
    on QueryBuilder<Building, Building, QFilterCondition> {}

extension BuildingQueryLinks
    on QueryBuilder<Building, Building, QFilterCondition> {}

extension BuildingQuerySortBy on QueryBuilder<Building, Building, QSortBy> {
  QueryBuilder<Building, Building, QAfterSortBy> sortByConstructionYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'constructionYear', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByConstructionYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'constructionYear', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByIdProtection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProtection', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByIdProtectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProtection', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByIdTypology() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idTypology', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByIdTypologyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idTypology', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByProtectionName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protectionName', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByProtectionNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protectionName', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortBySurfaceArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceArea', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortBySurfaceAreaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceArea', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByTypologyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typologyName', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByTypologyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typologyName', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByValidate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validate', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> sortByValidateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validate', Sort.desc);
    });
  }
}

extension BuildingQuerySortThenBy
    on QueryBuilder<Building, Building, QSortThenBy> {
  QueryBuilder<Building, Building, QAfterSortBy> thenByConstructionYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'constructionYear', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByConstructionYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'constructionYear', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByIdBuilding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idBuilding', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByIdBuildingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idBuilding', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByIdProtection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProtection', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByIdProtectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProtection', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByIdTypology() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idTypology', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByIdTypologyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idTypology', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByProtectionName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protectionName', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByProtectionNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protectionName', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenBySurfaceArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceArea', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenBySurfaceAreaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceArea', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByTypologyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typologyName', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByTypologyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typologyName', Sort.desc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByValidate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validate', Sort.asc);
    });
  }

  QueryBuilder<Building, Building, QAfterSortBy> thenByValidateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validate', Sort.desc);
    });
  }
}

extension BuildingQueryWhereDistinct
    on QueryBuilder<Building, Building, QDistinct> {
  QueryBuilder<Building, Building, QDistinct> distinctByArchitects() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'architects');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByConstructionYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'constructionYear');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByIdProtection() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idProtection');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByIdTypology() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idTypology');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByImages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'images');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByLocation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByPrizes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prizes');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByProtectionName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protectionName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByPublications() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publications');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByReforms() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reforms');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctBySurfaceArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surfaceArea');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByTypologyName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typologyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uses');
    });
  }

  QueryBuilder<Building, Building, QDistinct> distinctByValidate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'validate');
    });
  }
}

extension BuildingQueryProperty
    on QueryBuilder<Building, Building, QQueryProperty> {
  QueryBuilder<Building, int, QQueryOperations> idBuildingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idBuilding');
    });
  }

  QueryBuilder<Building, List<String>, QQueryOperations> architectsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'architects');
    });
  }

  QueryBuilder<Building, int, QQueryOperations> constructionYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'constructionYear');
    });
  }

  QueryBuilder<Building, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Building, int, QQueryOperations> idProtectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idProtection');
    });
  }

  QueryBuilder<Building, int, QQueryOperations> idTypologyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idTypology');
    });
  }

  QueryBuilder<Building, List<String>, QQueryOperations> imagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'images');
    });
  }

  QueryBuilder<Building, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<Building, String, QQueryOperations> locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<Building, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<Building, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Building, List<String>, QQueryOperations> prizesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prizes');
    });
  }

  QueryBuilder<Building, String, QQueryOperations> protectionNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protectionName');
    });
  }

  QueryBuilder<Building, List<String>, QQueryOperations>
      publicationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publications');
    });
  }

  QueryBuilder<Building, List<String>, QQueryOperations> reformsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reforms');
    });
  }

  QueryBuilder<Building, int, QQueryOperations> surfaceAreaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surfaceArea');
    });
  }

  QueryBuilder<Building, String, QQueryOperations> typologyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typologyName');
    });
  }

  QueryBuilder<Building, List<String>, QQueryOperations> usesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uses');
    });
  }

  QueryBuilder<Building, bool, QQueryOperations> validateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'validate');
    });
  }
}
