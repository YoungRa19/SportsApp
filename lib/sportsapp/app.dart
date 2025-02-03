import 'package:flutter/material.dart';
import 'package:sportsapp/data/sports.dart';

class Sports extends StatefulWidget {
  const Sports({super.key});

  @override
  State<Sports> createState() => _SportsState();
}

class _SportsState extends State<Sports> {
  List<Sport> sports = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _playersController = TextEditingController();
  bool _validateName = false;
  bool _validatePlayers = false;

  @override
  void dispose() {
    _nameController.dispose();
    _playersController.dispose();
    super.dispose();
  }

  void addSignature() {
    showProcess(context);
  }

  void showProcess(BuildContext context, {Sport? sport, int? id}) {
    String title = sport == null ? "Nuevo deporte" : "Editar ${sport.name}";
    _nameController.text = sport?.name ?? "";
    _playersController.text = sport?.numPlayers.toString() ?? "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del deporte',
                  errorText: _validateName ? "No puede estar vacío" : null,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _playersController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de jugadores',
                  errorText: _validatePlayers ? "Debe ser un número válido" : null,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _playersController.clear();
                Navigator.pop(context);
              },
              child: Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                String newSportName = _nameController.text.trim();
                int? newPlayers = int.tryParse(_playersController.text.trim());

                if (newSportName.isNotEmpty && newPlayers != null && newPlayers > 0) {
                  setState(() {
                    if (sport != null && id != null) {
                      // Editar deporte existente
                      sports[id] = Sport(name: newSportName, numPlayers: newPlayers);
                    } else {
                      // Agregar nuevo deporte
                      sports.add(Sport(name: newSportName, numPlayers: newPlayers));
                    }
                  });

                  _nameController.clear();
                  _playersController.clear();
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _validateName = newSportName.isEmpty;
                    _validatePlayers = newPlayers == null || newPlayers <= 0;
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

  void showInfoDialog(BuildContext context, Sport sport) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Detalles de ${sport.name}"),
          content: Text("Número de jugadores: ${sport.numPlayers}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cerrar", style: TextStyle(color: Colors.blue)),
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
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
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
                                  _nameController.text = sports[idx].name;
                                  _playersController.text = sports[idx].numPlayers.toString();
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
                              IconButton(
                                onPressed: () {
                                  showInfoDialog(context, sports[idx]);
                                },
                                icon: Icon(Icons.info),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}