// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';

// import '../model/ponto.dart';

// class ConteudoDialogForm extends StatefulWidget {
//   final Ponto? ponto;

//   ConteudoDialogForm({Key? key, this.ponto}) : super(key: key);

//   void init() {}

//   @override
//   State<StatefulWidget> createState() => ConteudoDialogFormState();
// }

// class ConteudoDialogFormState extends State<ConteudoDialogForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _longitudeController = TextEditingController();
//   final _latitudeController = TextEditingController();
//   final _horarioController = TextEditingController();
//   final _dateFormat = DateFormat('dd/MM/yyyy');

//   @override
//   void initState() {
//     super.initState();
//     if (widget.ponto != null) {
//       _longitudeController.text = widget.ponto!.longitude;
//       _latitudeController.text = widget.ponto!.latitude;
//       _horarioController.text = widget.ponto!.dataFormatada;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var locationData = Location().getLocation();

//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextFormField(
//             controller: _longitudeController,
//             decoration: InputDecoration(
//               labelText: 'Longitude',
//             ),
//            initialValue: locationData.longitude,
//           ),
//           TextFormField(
//             controller: _horarioController,
//             decoration: InputDecoration(
//               labelText: 'Horario',
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () => _horarioController.clear(),
//               ),
//             ),
//             readOnly: true,
//           ),
//         ],
//       ),
//     );
//   }

//   bool dadosValidos() => _formKey.currentState?.validate() == true;

//   Ponto get novoPonto => Ponto(
//     id: widget.ponto?.id,
//     longitude: _longitudeController.text,
//     latitude: _latitudeController.text,
//     horario: _horarioController.text.isEmpty
//         ? null
//         : _dateFormat.parse(_horarioController.text),
//   );
// }
