import 'dart:async';

import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/presentation/map/bloc/match/cubit/match_request_cubit.dart';

class MatchRequestBanner extends StatefulWidget {
  final String userName;
  final String avatar;
  final VoidCallback onAccept;
  final VoidCallback onCancel;
  final int durationSeconds;

  const MatchRequestBanner({
    super.key,
    required this.userName,
    required this.avatar,
    required this.onAccept,
    required this.onCancel,
    this.durationSeconds = 30,
  });

  @override
  State<MatchRequestBanner> createState() => _MatchRequestBannerState();
}

class _MatchRequestBannerState extends State<MatchRequestBanner> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.durationSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchRequestCubit, MatchRequestState>(
      builder: (context, state) {
        final progress = _remaining / widget.durationSeconds;

        return Material(
          elevation: 6,
          color: AppColors.secondBackground,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.avatar,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state is MatchRequestLoading
                            ? 'Processing...'
                            : state is MatchRequestError
                                ? state.message
                                : 'Hey! ${widget.userName} is cycling on your route. Would you like to ride together?',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (state is! MatchRequestLoading) ...[
                      TextButton(
                        onPressed: state is MatchRequestError
                            ? widget.onCancel
                            : widget.onCancel,
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: state is MatchRequestError
                            ? widget.onAccept
                            : widget.onAccept,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: const Text("Match",
                            style: TextStyle(color: Colors.orangeAccent)),
                      ),
                    ] else
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
