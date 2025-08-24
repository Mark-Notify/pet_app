class Animal {
  final String id;
  final String name;
  final String species;
  final int perFeedTokens; // เช่น 20 ต่อครั้ง
  final int hourlyQuota;   // โควตาต่อชั่วโมง (แสดงผลใน UI)
  Animal({
    required this.id,
    required this.name,
    required this.species,
    required this.perFeedTokens,
    required this.hourlyQuota,
  });

  factory Animal.mock() => Animal(
    id: 'a1',
    name: 'Mochi',
    species: 'Raccoon',
    perFeedTokens: 20,
    hourlyQuota: 30,
  );
}
