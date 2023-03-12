abstract class AsyncJsonStringConverter<T> {
  Future<T> fromJson(String jsonString);

  Future<String> toJson(T object);
}
