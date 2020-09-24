import 'package:amice/service/bloc/amice_bloc.dart';
import 'package:amice/service/models/system.dart';
import 'package:flutter/material.dart';

class AmiceStatusDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: StreamBuilder(
        stream: AmiceBloc.getInstance().systemStatus,
        builder: (BuildContext context, AsyncSnapshot<SystemStatus> snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          }

          final data = snapshot.data;
          if (data.isConnected) {
            var detectedCar = "No Stella detected";
            if (data.busStatus.systemStatus.isEra) {
              detectedCar = "Stella Era detected";
            }

            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 80, color: Theme.of(context).primaryColor),
                    SizedBox(height: 20),
                    Text("Connected to AMICE", style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 8),
                    Text(detectedCar, style: Theme.of(context).textTheme.caption, textAlign: TextAlign.center,),
                  ],
                ),
              ),
            );
          } else {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_outlined, size: 80, color: Theme.of(context).primaryColor),
                    SizedBox(height: 20),
                    Text("No connection with AMICE", style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 8),
                    Text(data.error, style: Theme.of(context).textTheme.caption, textAlign: TextAlign.center,),
                  ],
                ),
              ),
            );
          }
        }
      )
    );
  }
}
