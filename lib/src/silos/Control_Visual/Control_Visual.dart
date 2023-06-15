import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class ControlVisual extends StatefulWidget {
  const ControlVisual({Key? key}) : super(key: key);

  @override
  State<ControlVisual> createState() => _ControlVisualState();
}

class _ControlVisualState extends State<ControlVisual> {
  bool valueBarredura = false;
  final PuntoDespachoController = TextEditingController();
  final DescargaController = TextEditingController();
  
  DateTime dateInicio = DateTime.now();
  DateTime dateTermino = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final hours1 = dateInicio.hour.toString().padLeft(2, '0');
    final minutes1 = dateInicio.minute.toString().padLeft(2, '0');
    final hours2 = dateTermino.hour.toString().padLeft(2, '0');
    final minutes2 = dateTermino.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Visual'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),

                        labelText: 'Placa',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        hintText: '',
                      ),
                      enabled: false,
                    ),
                  ),
                  
                  const SizedBox(width: 100,),
                  
                  Row(
                    children: [
                      Text("Barredura",
                        style: TextStyle(
                          fontSize: 20,
                          color: kColorAzul,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      const SizedBox(width: 5),
                      Switch(
                        value: valueBarredura,
                        onChanged: (value) => setState(() {
                        valueBarredura = value;
                        }),
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                  
                ],
              ),

              const SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                  labelText: 'Transporte',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                enabled: false,
              ),
              
              const SizedBox(height: 20),
              
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                  labelText: 'Tolva',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                enabled: false,
              ),

              const SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                      
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    onPressed: () {
                    }
                  ),
                  labelText: 'Descarga',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: 'Tipo de descarga'
                ),
                onChanged: (value) {
                },
                controller: PuntoDespachoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el Descarga';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                      
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    onPressed: () {
                    }
                  ),
                  labelText: 'Descarga',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: 'Elegir el Despacho'
                ),
                onChanged: (value) {
                },
                controller: PuntoDespachoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el Descarga';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                  labelText: 'Cadenero',
                  labelStyle: TextStyle(
                    color: kColorAzul,
                    fontSize: 20.0,
                  ),
                  hintText: '',
                ),
                enabled: false,
              ),

              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      "INICIO:",
                      style: TextStyle(
                          fontSize: 20,
                          color: kColorAzul,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    )
                  ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          color: kColorAzul,
                        ),
                        labelText: /* ${dateTime.day}/${dateTime.month}/${dateTime.year} */
                          '$hours1:$minutes1',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        enabled: false),
                  ),
                ),
              ]),
              const SizedBox(height: 20.0),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minWidth: double.infinity,
                height: 50.0,
                color: kColorCeleste,
                onPressed: pickDateTime1,
                child: Text(
                  "Hora - Inicio",
                  style: TextStyle(
                    fontSize: 20,
                    color: kColorAzul,
                    fontWeight: FontWeight.bold, /* letterSpacing: 1.5 */
                  ),
                )
              ),
              const SizedBox(height: 20.0),
              Row(children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      "FINAL:",
                      style: TextStyle(
                          fontSize: 20,
                          color: kColorAzul,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    )),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          color: kColorAzul,
                        ),
                        labelText: /* '${dateTime2.day}/${dateTime2.month}/${dateTime2.year}' */
                            '$hours2:$minutes2',
                        labelStyle: TextStyle(
                          color: kColorAzul,
                          fontSize: 20.0,
                        ),
                        enabled: false),
                  ),
                ),
              ]),
              const SizedBox(height: 20.0),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minWidth: double.infinity,
                height: 50.0,
                color: kColorCeleste,
                onPressed: pickDateTime2,
                child: Text(
                  "Hora - Termino",
                  style: TextStyle(
                    fontSize: 20,
                    color: kColorAzul,
                    fontWeight: FontWeight.bold, /* letterSpacing: 1.5 */
                  ),
                )
              ),

              const SizedBox(height: 20.0),

              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minWidth: double.infinity,
                height: 50.0,
                color: kColorNaranja,
                onPressed: () {
                },
                child: const Text(
                  "REGISTRAR",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5
                  ),
                ),
              ),




            ]
          )
        )
      )
                  
    );
  }

  Future pickDateTime1() async {
    DateTime? date = DateTime.now();
    //if (date == null) return;
    TimeOfDay? time = await pickTime1();
    if (time == null) return;

    final dateTime1 = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() => dateInicio = dateTime1);
  }

  Future<TimeOfDay?> pickTime1() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateInicio.hour, minute: dateInicio.minute));

/*-------------------------------------------- */
  Future pickDateTime2() async {
    DateTime? date = DateTime.now();
    //if (date == null) return;
    TimeOfDay? time = await pickTime2();
    if (time == null) return;

    final dateTime2 = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() => dateTermino = dateTime2);
  }

  Future<TimeOfDay?> pickTime2() => showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: dateTermino.hour, minute: dateTermino.minute));


}