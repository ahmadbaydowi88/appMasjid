import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:apppengelolaan/agenda/api/api_dataAgenda.dart';
import 'package:apppengelolaan/auth/api/apiLogin.dart';
import 'package:apppengelolaan/main.dart';
import 'package:apppengelolaan/src/api/api.dart';
import 'package:apppengelolaan/src/api/apiUrl.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:table_calendar/table_calendar.dart';

class ViewCalendar extends StatefulWidget {
  ViewCalendar({Key key}) : super(key: key);
  void test() {}
  @override
  ViewCalendarState createState() => ViewCalendarState();
}

class ViewCalendarState extends State<ViewCalendar>
    with AfterLayoutMixin<ViewCalendar>, TickerProviderStateMixin {
  Map<DateTime, List<dynamic>> _agenda = Map<DateTime, List<dynamic>>();
  List<dynamic> _selectedAgenda;
  AnimationController _animationController;
  CalendarController _calendarController;
  DataAgenda _dataAgenda;
  Future<void> getAgenda() async {
    await getData(
      url: urlApi.dataAgenda,
      params: {"id": dataLogin.data.id, "limit": ""},
      onComplete: (data, statusCode) {
        print(data);
        _agenda.clear();
        // print(dataLogin.data.unitId);
        if (statusCode == 200) {
          setState(() {
            _dataAgenda = DataAgenda.fromJson(jsonDecode(data));
            _dataAgenda.data.tKegiatan.forEach((element) {
              print(element.idKegiatan);
              DateTime startDate =
                  DateTime.parse(element.tglAwal.split(" ")[0]);
              DateTime endDate = DateTime.parse(element.tglAkhir.split(" ")[0]);
              int dif = endDate.difference(startDate).inDays;
              for (int i = 0; i < dif.abs() + 1; i++) {
                if (dif < 0) {
                  _addAgenda(startDate.subtract(Duration(days: i)), element);
                } else {
                  _addAgenda(startDate.add(Duration(days: i)), element);
                }
              }
            });
          });
          _calendarController.setSelectedDay(DateTime.now(),
              animate: true, isProgrammatic: true, runCallback: true);
        }
      },
      onError: (error) {},
    );
  }

  void _addAgenda(DateTime date, TKegiatan agenda) {
    bool ada = false;
    List<dynamic> ta = List();
    _agenda.forEach((key, value) {
      if (key == date) {
        value.add(agenda);
        ada = true;
      }
    });
    if (!ada) {
      ta.add(agenda);
      _agenda.addAll({date: ta});
    }
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _selectedAgenda = _agenda[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List<dynamic> agenda) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedAgenda = agenda;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          TableCalendar(
            locale: 'id_ID',
            calendarController: _calendarController,
            events: _agenda,
            initialCalendarFormat: CalendarFormat.month,
            formatAnimation: FormatAnimation.scale,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.horizontalSwipe,
            availableCalendarFormats: const {
              CalendarFormat.month: '',
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
              weekendStyle: TextStyle().copyWith(color: Colors.red),
              weekdayStyle: TextStyle().copyWith(color: Colors.white),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle().copyWith(color: Colors.white),
              weekendStyle: TextStyle().copyWith(color: Colors.red),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle().copyWith(color: Colors.white),
              centerHeaderTitle: true,
              formatButtonVisible: false,
            ),
            builders: CalendarBuilders(
              selectedDayBuilder: (context, date, _) {
                return FadeTransition(
                  opacity:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    width: 100,
                    height: 100,
                    child: Text(
                      '${date.day}',
                      style: TextStyle()
                          .copyWith(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                );
              },
              todayDayBuilder: (context, date, _) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(4.0),
                  width: 100,
                  height: 100,
                  child: Text('${date.day}',
                      style: TextStyle().copyWith(
                          fontSize: 16.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                );
              },
              markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];

                if (events.isNotEmpty) {
                  children.add(
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _calendarController.isSelected(date)
                              ? Colors.pink[500]
                              : _calendarController.isToday(date)
                                  ? Colors.pink[300]
                                  : Colors.blue[400],
                        ),
                        width: 16.0,
                        height: 16.0,
                        child: Center(
                          child: Text(
                            '${events.length}',
                            style: TextStyle().copyWith(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return children;
              },
            ),
            onDaySelected: (date, events, holidays) {
              _onDaySelected(date, events);
              _animationController.forward(from: 0.0);
            },
            onVisibleDaysChanged: _onVisibleDaysChanged,
            onCalendarCreated: _onCalendarCreated,
          ),
          Expanded(
            child: _buildEventList(),
          )
        ],
      ),
    );
  }

  Widget _buildEventList() {
    if (_selectedAgenda.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          child: Text(
            "Tidak ada agenda",
            style: TextStyle().copyWith(color: Colors.grey),
          ),
        ),
      );
    } else {
      return ListView(
        children: _selectedAgenda
            .map((event) => ListTile(
                  leading: Container(
                    color: Colors.blue, //Hexcolor(event.color),
                    width: 5,
                  ),
                  title: Text(
                    event.namaKegiatan,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    event.tglAwal + "\n" + event.tglAkhir,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    event.keterangan,
                    style: TextStyle(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.all(3),
                  onTap: () {
                    Alert(
                      context: context,
                      title: event.namaKegiatan,
                      desc: event.keterangan,
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Oke",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  },
                  // print('$event tapped!'),
                ))
            .toList(),
      );
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getAgenda();
  }
}
