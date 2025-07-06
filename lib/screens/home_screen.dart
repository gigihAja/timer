import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:timer/widgets/pause.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int hours = 0;
  int minutes = 10;
  int seconds = 05;

  Timer? countdownTimer;
  bool isRunning = false;

  //logic timer
  void toggleTimer() {
    if (isRunning) {
      countdownTimer?.cancel();
    } else {
      countdownTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _decrementTime(),
      );
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  //alarm running
  Future<void> _decrementTime() async {
    if (hours == 0 && minutes == 0 && seconds == 0) {
      countdownTimer?.cancel();
      setState(() {
        isRunning = false;
      });
      return;
    }

    final totalSeconds = hours * 3600 + minutes * 60 + seconds;

    if (totalSeconds == 602) {
      AudioPlayer().play(AssetSource('audio/Bel-Ganti.mp3'));
    } else if (totalSeconds == 599) {
      AudioPlayer().play(AssetSource('audio/Waktunya-membaca.mp3'));
    }

    if (totalSeconds == 541) {
      AudioPlayer().play(AssetSource('audio/Bel-Ganti.mp3'));
    } else if (totalSeconds == 538) {
      AudioPlayer().play(AssetSource('audio/Masuk-Ruangan.mp3'));
    }

    if (totalSeconds == 301) {
      AudioPlayer().play(AssetSource('audio/5menit.mp3'));
    } else if (totalSeconds == 181) {
      AudioPlayer().play(AssetSource('audio/3menit.mp3'));
    } else if (totalSeconds == 61) {
      AudioPlayer().play(AssetSource('audio/1menit.mp3'));
    }

    if (totalSeconds == 11) {
      AudioPlayer().play(AssetSource('audio/countdown-10detik.mp3'));
    } else if (totalSeconds == 1) {
      AudioPlayer().play(AssetSource('audio/terompet.mp3'));
      Future.delayed(const Duration(seconds: 1), () {
        AudioPlayer().play(AssetSource('audio/Waktu-Habis.mp3'));
      });
    }

    setState(() {
      if (seconds > 0) {
        seconds--;
      } else {
        if (minutes > 0) {
          minutes--;
          seconds = 59;
        } else if (hours > 0) {
          hours--;
          minutes = 59;
          seconds = 59;
        }
      }
    });
  }

  //increase time
  void _increaseTime() {
    setState(() {
      minutes += 1;
      if (minutes >= 60) {
        minutes = 0;
        hours += 1;
      }
    });
  }

  //decrease time
  void _decreaseTime() {
    setState(() {
      if (minutes > 0) {
        minutes -= 1;
      } else if (hours > 0) {
        hours -= 1;
        minutes = 59;
      }
    });
  }

  //reset timer
  void resetTimer() {
    countdownTimer?.cancel();
    setState(() {
      isRunning = false;
      hours = 0;
      minutes = 10;
      seconds = 05;
    });
  }

  //edit time
  void _editTime(String unit) {
    int currentValue;
    if (unit == 'hours') {
      currentValue = hours;
    } else if (unit == 'minutes') {
      currentValue = minutes;
    } else {
      currentValue = seconds;
    }

    TextEditingController controller = TextEditingController(
      text: currentValue.toString(),
    );

    showDialog(
      context: context,
      builder:
          (_) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 20,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Change $unit',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              textStyle: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5DADE2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              textStyle: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () {
                              int newValue =
                                  int.tryParse(controller.text) ?? currentValue;
                              setState(() {
                                if (unit == 'hours') {
                                  hours = newValue.clamp(0, 99);
                                } else if (unit == 'minutes') {
                                  minutes = newValue.clamp(0, 59);
                                } else {
                                  seconds = newValue.clamp(0, 59);
                                }
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color timerColor =
        (hours * 3600 + minutes * 60 + seconds) < 11
            ? Colors.red
            : Colors.white;
    return Scaffold(
      backgroundColor: const Color(0xFFE1F0FB),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Timer',
                  style: GoogleFonts.dancingScript(
                    fontSize: 72,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeCard(
                      hours.toString().padLeft(2, '0'),
                      () => _editTime('hours'),
                      textColor: timerColor,
                    ),
                    const SizedBox(width: 8),
                    _buildColon(),
                    const SizedBox(width: 8),
                    _buildTimeCard(
                      minutes.toString().padLeft(2, '0'),
                      () => _editTime('minutes'),
                      textColor: timerColor,
                    ),
                    const SizedBox(width: 8),
                    _buildColon(),
                    const SizedBox(width: 8),
                    _buildTimeCard(
                      seconds.toString().padLeft(2, '0'),
                      () => _editTime('seconds'),
                      textColor: timerColor,
                    ),
                  ],
                ),

                // const SizedBox(height: 16),
                // Text(
                //   'SILENT',
                //   style: GoogleFonts.outfit(
                //     fontSize: 18,
                //     letterSpacing: 2,
                //     color: Colors.black54,
                //   ),
                // ),
                const SizedBox(height: 40),

                PauseButton(onPressed: toggleTimer, isRunning: isRunning),
                const SizedBox(height: 16),
                InkWell(
                  onTap: resetTimer,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 167, 208),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.shade100,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            bottom: 48,
            child: InkWell(
              onTap: _decreaseTime,
              child: Image.asset(
                'assets/Reverse-Fast-Forward-RmBg-UpS.png',
                width: 100,
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 48,
            child: InkWell(
              onTap: _increaseTime,
              child: Image.asset(
                'assets/Fast-Forward-Forward-RmBg-UpS.png',
                width: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(
    String value,
    VoidCallback onTap, {
    required Color textColor,
  }) {
    return InkWell(
      onTap: isRunning ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
        decoration: BoxDecoration(
          color: const Color(0xFFBFD5E2),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: textColor,
            shadows: const [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColon() {
    return Text(
      ':',
      style: GoogleFonts.fredoka(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: Colors.black38,
      ),
    );
  }
}
