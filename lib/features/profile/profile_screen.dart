import 'package:flutter/material.dart';
import '../../data/models/animal.dart';

class AnimalProfileScreen extends StatelessWidget {
  const AnimalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animal = Animal.mock();
    return Scaffold(
      appBar: AppBar(title: Text('โปรไฟล์ ${animal.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const CircleAvatar(radius: 32, child: Icon(Icons.pets)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(animal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(animal.species),
            ])
          ]),
          const SizedBox(height: 12),
          const Text('ตารางให้อาหารที่ปลอดภัย: 09:00 / 13:00 / 18:00 (ตัวอย่าง)'),
          const SizedBox(height: 8),
          Text('โควตาต่อชั่วโมง: ${animal.hourlyQuota} ครั้ง'),
          const SizedBox(height: 12),
          const Text('คำแนะนำสัตวแพทย์: หลีกเลี่ยงการให้อาหารเกินจำเป็น'),
        ]),
      ),
    );
  }
}
