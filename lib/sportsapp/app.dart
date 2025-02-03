
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


  showProcess(BuildContext context, {Sport? sport, int? id}) {
    String title = sport == null ? "Nuevo deporte" : "Editar ${sport.name}";
    return showDialog(
        context: context,
        builder: (
            context,
            ) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  title: Text(title),
                  content: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      TextField(
                        controller: _textEditing,
                        onChanged: (data) {
                          setState(() {
                            _validate = data.isEmpty;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Nombre del deporte',
                            errorText:
                            _validate ? "No puede ser un valor vacío" : null,
                            errorStyle: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _validate = false;
                          });
                          _textEditing.clear();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () {
                          if (_textEditing.value.text.isNotEmpty) {
                            if (sport != null && id != null && id >= 0 && id < sports.length) {
                              setState(() {
                                sports[id] = Sport(name: _textEditing.value.text);
                              });
                            }

                            else {
                              _textEditing.clear();
                              Navigator.pop(context);
                              setState(() {
                                sports.add(Sport(name: _textEditing.value.text));
                                _validate = false;
                              });
                            }

                          } else {
                            setState(() {
                              _validate = _textEditing.text.isEmpty;
                            });
                          }
                        },
                        child: Text(
                          "Aceptar",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                );
              });
        });


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
                  shrinkWrap: true,
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
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _textEditing.text = sports[idx].name;
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
              ),
          ],
        ),
      ),
    );
  }
}