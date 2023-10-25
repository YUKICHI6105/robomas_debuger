import 'dart:async';
import 'package:circular_buffer/circular_buffer.dart';
import 'package:flutter/material.dart';

class StreamListBuilder<T> extends StatefulWidget {
  const StreamListBuilder({
    super.key,
    this.max = 10,
    this.initialData,
    required this.stream,
    required this.builder,
    this.isEqual,
  });

  final Stream<T>? stream;

  final Widget? Function(BuildContext context, T data) builder;

  //if you set this, the list will only show the latest data
  final bool Function(T previous, T next)? isEqual;

  final T? initialData;

  final int max;

  AsyncSnapshot<T> initial() => initialData == null
      ? AsyncSnapshot<T>.nothing()
      : AsyncSnapshot<T>.withData(ConnectionState.none, initialData as T);

  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  AsyncSnapshot<T> afterError(
      AsyncSnapshot<T> current, Object error, StackTrace stackTrace) {
    return AsyncSnapshot<T>.withError(
        ConnectionState.active, error, stackTrace);
  }

  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);

  @override
  State<StreamListBuilder<T>> createState() => _StreamListBuilderState<T>();
}

/// State for [StreamListBuilder].
class _StreamListBuilderState<T> extends State<StreamListBuilder<T>> {
  late CircularBuffer<T> recentData = CircularBuffer<T>(widget.max);
  StreamSubscription<T>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(StreamListBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) {
    //remove old data++
    if (recentData.length > widget.max) {
      recentData.removeLast();
    }
    return ListView(
        shrinkWrap: true,
        children: recentData
            .map((element) => widget.builder(context, element))
            .whereType<Widget>()
            .toList());
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.stream != null) {
      _subscription = widget.stream!.listen((T data) {
        setState(() {
          final isEqual = widget.isEqual;
          if (isEqual != null) {
            //check same data,if so, overwrite it
            if (recentData.isFilled) {
              for (int i = 0; i < recentData.length; i++) {
                if (isEqual(recentData[i], data)) {
                  recentData[i] = data;
                  return;
                }
              }
            }
          }
          recentData.add(data);
        });
      });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }
}
