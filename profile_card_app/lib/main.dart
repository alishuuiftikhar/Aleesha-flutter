import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: FormScreen()));

class CardModel {
  String id, name, dob, gender, role, edu, email, phone, loc;
  List<String> skills; Uint8List? img;
  CardModel({required this.id, required this.name, required this.dob, required this.gender, required this.role, required this.edu, required this.email, required this.phone, required this.loc, required this.skills, this.img});
}
List<CardModel> savedCards = [];

class FormScreen extends StatefulWidget {
  final CardModel? editCard;
  const FormScreen({super.key, this.editCard});
  @override State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _k = GlobalKey<FormState>();
  late List<TextEditingController> ctrls;
  String _gender = 'Male'; Uint8List? _img;

  @override void initState() {
    super.initState();
    final c = widget.editCard;
    ctrls = List.generate(8, (i) => TextEditingController(text: [c?.name, c?.dob, c?.role, c?.edu, c?.email, c?.phone, c?.loc, c?.skills.join(', ')][i] ?? ''));
    if (c != null) { _gender = c.gender; _img = c.img; }
  }

  void _pickImg() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null && mounted) {
      final dec = await decodeImageFromList(await img.readAsBytes());
      showDialog(context: context, barrierDismissible: false, builder: (_) => CropDlg(rawImg: dec, onDone: (d) { setState(() => _img = d); Navigator.pop(context); }));
    }
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
          title: Text(widget.editCard == null ? "Create Profile Card" : "Edit Card", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue.shade700, centerTitle: true,
          actions: [IconButton(icon: const Icon(Icons.history, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())).then((_) => setState(() {})))]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(key: _k, child: Column(children: [
          GestureDetector(onTap: _pickImg, child: Stack(children: [CircleAvatar(radius: 40, backgroundColor: Colors.blue.shade50, backgroundImage: _img != null ? MemoryImage(_img!) : null, child: _img == null ? Icon(Icons.person, size: 40, color: Colors.blue.shade400) : null), Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade700, child: const Icon(Icons.camera_alt, color: Colors.white, size: 12)))])) ,
          TextButton(onPressed: _pickImg, child: Text("Choose Picture", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold))),
          _f("Full Name", ctrls[0], Icons.person), _dateF("Date of Birth", ctrls[1]), _dropF(),
          _f("Professional Title", ctrls[2], Icons.work), _f("Education", ctrls[3], Icons.school),
          _f("Email", ctrls[4], Icons.email), _f("Phone", ctrls[5], Icons.phone),
          _f("Location", ctrls[6], Icons.location_on), _f("Skills (Comma separated)", ctrls[7], Icons.code),
          const SizedBox(height: 5),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed: () {
              if (_k.currentState!.validate()) {
                final card = CardModel(id: widget.editCard?.id ?? DateTime.now().toString(), name: ctrls[0].text, dob: ctrls[1].text, gender: _gender, role: ctrls[2].text, edu: ctrls[3].text, email: ctrls[4].text, phone: ctrls[5].text, loc: ctrls[6].text, skills: ctrls[7].text.split(',').where((e) => e.trim().isNotEmpty).map((e) => e.trim()).toList(), img: _img);
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(card: card, isEditing: widget.editCard != null)));
              }
            },
            child: Text(widget.editCard == null ? "Generate Card ✨" : "Update Card ✨", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ))
        ])),
      ),
    );
  }

  Widget _f(String l, TextEditingController c, IconData i) => Padding(padding: const EdgeInsets.only(bottom: 8), child: TextFormField(controller: c, validator: (v) => v!.trim().isEmpty ? "$l required" : null, decoration: InputDecoration(isDense: true, labelText: l, prefixIcon: Icon(i, color: Colors.blue.shade700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))));
  Widget _dateF(String l, TextEditingController c) => Padding(padding: const EdgeInsets.only(bottom: 8), child: TextFormField(controller: c, readOnly: true, validator: (v) => v!.isEmpty ? "$l required" : null, decoration: InputDecoration(isDense: true, labelText: l, prefixIcon: Icon(Icons.cake, color: Colors.blue.shade700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))), onTap: () async { DateTime? p = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now()); if (p != null) c.text = "${p.day}/${p.month}/${p.year}"; }));
  Widget _dropF() => Padding(padding: const EdgeInsets.only(bottom: 8), child: DropdownButtonFormField<String>(value: _gender, decoration: InputDecoration(isDense: true, labelText: "Gender", prefixIcon: Icon(Icons.wc, color: Colors.blue.shade700), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))), items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(), onChanged: (v) => setState(() => _gender = v!)));
}

class CropDlg extends StatefulWidget {
  final ui.Image rawImg; final ValueChanged<Uint8List> onDone;
  const CropDlg({super.key, required this.rawImg, required this.onDone});
  @override State<CropDlg> createState() => _CropDlgState();
}
class _CropDlgState extends State<CropDlg> {
  Offset _off = Offset.zero; double _rad = 90.0; final _key = GlobalKey();
  Future<void> _crop() async {
    final box = _key.currentContext?.findRenderObject() as RenderBox?; if (box == null) return;
    double imgA = widget.rawImg.width / widget.rawImg.height, boxA = box.size.width / box.size.height, scale = imgA > boxA ? widget.rawImg.width / box.size.width : widget.rawImg.height / box.size.height;
    double offX = imgA > boxA ? 0 : (box.size.width - box.size.height * imgA) / 2, offY = imgA > boxA ? (box.size.height - box.size.width / imgA) / 2 : 0;
    double cX = (box.size.width / 2 + _off.dx - offX) * scale, cY = (box.size.height / 2 + _off.dy - offY) * scale, r = _rad * scale;
    final rec = ui.PictureRecorder(); Canvas(rec)..clipPath(Path()..addOval(Rect.fromCircle(center: Offset(r, r), radius: r)))..drawImageRect(widget.rawImg, Rect.fromLTWH(cX - r, cY - r, r * 2, r * 2), Rect.fromLTWH(0, 0, r * 2, r * 2), Paint());
    final b = await (await rec.endRecording().toImage((r * 2).toInt(), (r * 2).toInt())).toByteData(format: ui.ImageByteFormat.png);
    if (b != null) widget.onDone(b.buffer.asUint8List());
  }
  @override Widget build(BuildContext context) {
    return Dialog(child: Container(padding: const EdgeInsets.all(12), height: 480, width: 350, child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Adjust Image", style: TextStyle(fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]),
      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(key: _key, color: Colors.grey.shade100, child: Stack(alignment: Alignment.center, children: [Positioned.fill(child: RawImage(image: widget.rawImg, fit: BoxFit.contain)), Transform.translate(offset: _off, child: GestureDetector(onPanUpdate: (d) => setState(() => _off += d.delta), child: Container(width: _rad * 2, height: _rad * 2, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue.shade700, width: 2)))))])))),
      Slider(value: _rad, min: 40, max: 150, onChanged: (v) => setState(() => _rad = v)),
      Row(children: [Expanded(child: OutlinedButton(onPressed: () => setState(() { _off = Offset.zero; _rad = 90.0; }), child: const Text("Reset"))), const SizedBox(width: 8), Expanded(child: ElevatedButton(onPressed: _crop, child: const Text("Set")))])
    ])));
  }
}

class ProfileScreen extends StatelessWidget {
  final CardModel card; final bool isEditing;
  const ProfileScreen({super.key, required this.card, this.isEditing = false});
  @override Widget build(BuildContext context) {
    final d = [{'i': Icons.cake, 'l': 'DOB', 'v': card.dob}, {'i': Icons.wc, 'l': 'Gender', 'v': card.gender}, {'i': Icons.work, 'l': 'Title', 'v': card.role}, {'i': Icons.school, 'l': 'Education', 'v': card.edu}, {'i': Icons.email, 'l': 'Email', 'v': card.email}, {'i': Icons.phone, 'l': 'Phone', 'v': card.phone}, {'i': Icons.location_on, 'l': 'Location', 'v': card.loc}];
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0), extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFFE0F2FE), Colors.blue.shade100])),
        child: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(12), child: Container(width: 360, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(children: [
          SizedBox(height: 130, child: Stack(alignment: Alignment.topCenter, children: [
            Container(height: 75, decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), gradient: LinearGradient(colors: [Colors.blue.shade700, Colors.blue.shade400]))),
            Positioned(top: 30, child: GestureDetector(
                onTap: () => showDialog(context: context, builder: (_) => Dialog(backgroundColor: Colors.transparent, child: CircleAvatar(radius: 110, backgroundImage: card.img != null ? MemoryImage(card.img!) : null, child: card.img == null ? const Icon(Icons.person, size: 80) : null))),
                child: CircleAvatar(radius: 42, backgroundColor: Colors.white, child: CircleAvatar(radius: 40, backgroundColor: Colors.blue.shade50, backgroundImage: card.img != null ? MemoryImage(card.img!) : null, child: card.img == null ? Icon(Icons.person, size: 40, color: Colors.blue.shade400) : null))
            )),
          ])),
          Text(card.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icons.phone, Icons.email, Icons.message].map((ic) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: CircleAvatar(radius: 14, backgroundColor: Colors.blue.shade50, child: Icon(ic, size: 14, color: Colors.blue.shade700)))).toList()),
          const Divider(indent: 12, endIndent: 12, height: 12),
          ...d.map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)), child: Row(children: [Icon(e['i'] as IconData, size: 16, color: Colors.blue.shade700), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e['l'] as String, style: const TextStyle(fontSize: 8, color: Colors.grey)), Text(e['v'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))])])))),
          if (card.skills.isNotEmpty) ...[const SizedBox(height: 4), const Text("Skills", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), Wrap(spacing: 4, runSpacing: 0, children: card.skills.map((s) => Chip(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, label: Text(s, style: TextStyle(fontSize: 10, color: Colors.blue.shade900)), backgroundColor: Colors.blue.shade50)).toList())],
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: [
            Expanded(child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8)),
              icon: const Icon(Icons.save, size: 16),
              label: Text(isEditing ? "Update" : "Save", style: const TextStyle(fontSize: 12)),
              onPressed: () {
                int idx = savedCards.indexWhere((e) => e.id == card.id);
                if (idx != -1) savedCards[idx] = card; else savedCards.add(card);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved Successfully!")));
              },
            )),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
              icon: Icon(Icons.history, size: 16, color: Colors.blue.shade700),
              label: Text("View History", style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
            )),
          ])),
          const SizedBox(height: 12),
        ]))))),
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Card History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.blue.shade700, centerTitle: true),
      body: savedCards.isEmpty ? const Center(child: Text("No Saved Cards!")) : ListView.builder(
        padding: const EdgeInsets.all(8), itemCount: savedCards.length,
        itemBuilder: (context, i) {
          final c = savedCards[i];
          return Card(child: ListTile(
            leading: CircleAvatar(backgroundImage: c.img != null ? MemoryImage(c.img!) : null, child: c.img == null ? const Icon(Icons.person) : null),
            title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(c.role),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.visibility, color: Colors.green, size: 20), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(card: c, isEditing: true)))),
              IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FormScreen(editCard: c))).then((_) => setState(() {}))),
              IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => setState(() => savedCards.removeAt(i))),
            ]),
          ));
        },
      ),
    );
  }
}