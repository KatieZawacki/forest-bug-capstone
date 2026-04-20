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
      title: 'Time for a Change ...',
      description:
          'The train pulls up. It\'s time to go to your new home.',
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
              color: Colors.black,
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
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: Colors.white),
                        ),
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
                      return Stack(
                        children: [
                          // Full-screen image background
                          Positioned.fill(
                            child: Image.asset(
                              step.assetPath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.green[50],
                                  child: Center(
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
                                  ),
                                );
                              },
                            ),
                          ),
                          // Overlay content
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 102),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      step.title,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 18),
                                    Text(
                                      step.description,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 40),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: _goNext,
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                        ),
                                        child: Text(_currentPage == _steps.length - 1 ? 'Begin' : 'Continue'),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
