import Foundation
import GraphQLCompiler
import IR

extension GraphQLCompiler.GraphQLType {

  var isListType: Bool {
    switch self {
    case .list: return true
    case let .nonNull(innerType): return innerType.isListType
    case .entity, .enum, .inputObject, .scalar: return false
    }
  }
  
}

extension IR.EntityField {

  /// Takes the associated `IR.EntityField` and formats it into a selection set name
  func formattedSelectionSetName(
    with pluralizer: Pluralizer
  ) -> String {
    IR.Entity.Location.FieldComponent(name: responseKey, type: type)
      .formattedSelectionSetName(with: pluralizer)
  }

}

extension IR.Entity.Location.FieldComponent {

  /// Takes the associated `IR.Entity.Location.FieldComponent` and formats it into a selection set name
  func formattedSelectionSetName(
    with pluralizer: Pluralizer
  ) -> String {
    var fieldName = name.convertToCamelCase().firstUppercased
    if type.isListType {
      fieldName = pluralizer.singularize(fieldName)
    }
    return fieldName.asSelectionSetName
  }

}

extension IR.Entity.Location.SourceDefinition {

  /// Takes the associated `IR.Entity.Location.SourceDefinition` and formats it into a selection set name
  func formattedSelectionSetName() -> String {
    switch self {
    case .operation: return "Data"
    case let .namedFragment(fragment): return fragment.generatedDefinitionName
    }
  }

}
