abstract class ValueObject<T> {
  T value;

  String? get validate;

  ValueObject(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueObject<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return '$runtimeType($value)';
  }
}
