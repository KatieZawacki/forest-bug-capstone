import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingStep> _steps = [
    _OnboardingStep(
      title: 'A Journey Begins',
      description:
          'The train pulls up to your cottage, and the woods whisper that every small choice will grow into something gentle and strong.',
      assetPath: 'assets/cutscene/scene1.gif',
    ),
    _OnboardingStep(
      title: 'Pick your purpose',
      description:
          'Choose a goal that fits your rhythm — water, walk, rest, learn, or another habit that helps you feel brighter.',
      assetPath: 'assets/cutscene/scene2.png',
    ),
    _OnboardingStep(
      title: 'Watch growth unfold',
      description:
          'Each check-in helps your bug evolve and the forest become more alive. Your progress is gentle, safe, and meaningful.',
      assetPath: 'assets/cutscene/scene3.png',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _goNext() {
    if (_currentPage < _steps.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEDF7EE), Color(0xFFB7E4C7)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      const Text(
                        'Forest Bug',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: _onPageChanged,
                    itemCount: _steps.length,
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 600),
                              child: Container(
                                key: ValueKey(step.assetPath),
                                height: 320,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.white.withValues(alpha: 179),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 20),
                                      blurRadius: 20,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                  step.assetPath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.image, size: 72, color: Colors.green),
                                            SizedBox(height: 16),
                                            Text(
                                              'Add your cutscene art to assets/cutscene/',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              step.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              step.description,
                              style: const TextStyle(fontSize: 18, color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 128),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: (_currentPage + 1) / _steps.length,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green[700],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _goNext,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                        child: Text(_currentPage == _steps.length - 1 ? 'Begin' : 'Continue'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingStep {
  final String title;
  final String description;
  final String assetPath;

  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.assetPath,
  });
}
