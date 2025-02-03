
import 'package:flutter/material.dart';
import 'package:sportsapp/data/sports.dart';


class Sports extends StatefulWidget {
  const Sports({super.key});

  @override
  State<Sports> createState() => _SportsState();
}

class _SportsState extends State<Sports> {
  List<Sport> sports = [];
  TextEditingController _textEditing = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    _textEditing.dispose();
    super.dispose();
  }

  void addSignature() {
    showProcess(context);
  }


  void showProcess(BuildContext context, {Sport? sport, int? id}) {
    String title = sport == null ? "Nuevo deporte" : "Editar ${sport.name}";
    _textEditing.text = sport?.name ?? "";  // Asigna el valor actual si existe

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _textEditing,
            onChanged: (data) {
              setState(() {
                _validate = data.isEmpty;
              });
            },
            decoration: InputDecoration(
              labelText: 'Nombre del deporte',
              errorText: _validate ? "No puede ser un valor vacío" : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _textEditing.clear();
                Navigator.pop(context);
              },
              child: Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                String newSportName = _textEditing.text.trim();
                if (newSportName.isNotEmpty) {
                  setState(() {
                    if (sport != null && id != null) {
                      // Editar deporte existente
                      sports[id] = Sport(name: newSportName);
                    } else {
                      // Agregar nuevo deporte
                      sports.add(Sport(name: newSportName));
                    }
                  });

                  Navigator.pop(context); // Cerrar diálogo
                } else {
                  setState(() {
                    _validate = true;
                  });
                }
              },
              child: Text("Aceptar", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }



  void delete(int id) {
    if (id >= 0 && id < sports.length) {
      setState(() {
        sports.removeAt(id);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de deportes",
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          IconButton(
            onPressed: addSignature,
            icon: Icon(Icons.add),
            color: Colors.blue,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Column(
          children: [
            if (sports.isEmpty)
              Center(
                    child: Text(
                      "No hay datos disponibles",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
            if (sports.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: sports.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Color(0xFFEDE7F6),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              sports[idx].name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _textEditing.text = sports[idx].name; // Asigna el valor antes de abrir
                                  showProcess(context, sport: sports[idx], id: idx);
                                },
                                icon: Icon(Icons.edit),
                                color: Colors.orange,
                              ),
                              IconButton(
                                onPressed: () {
                                  delete(idx);
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}