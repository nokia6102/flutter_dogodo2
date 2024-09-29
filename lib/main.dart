import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 引入 audioplayers
import 'package:flutter/services.dart'; // 用於 SystemChrome

void main() {
  // 鎖定螢幕為直屏
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 垂直屏幕
    DeviceOrientation.portraitDown, // 可選，允許上下顛倒直屏（不常用）
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '做功德'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _opacity = 0.0; // 初始時文字隱藏
  Offset _offset = const Offset(0, 0); // 控制文字初始位置
  double _boOpacity = 0.0; // 控制 "回向+1" 的透明度
  Offset _boOffset = const Offset(0, 0); // 控制 "回向+1" 的位置
  final AudioPlayer _audioPlayer = AudioPlayer(); // 創建 AudioPlayer 實例
  bool _isMuted = false; // 靜音狀態變量

  void _incrementCounter() async {
    if (!_isMuted) {
      // 播放木魚音效
      await _audioPlayer.play(AssetSource('audio/woodfish_sound.mp3'));
    }

    // 按下按鈕後，首先將位置和透明度重置為初始狀態
    setState(() {
      _offset = const Offset(0, 0); // 重置位置
      _opacity = 1.0; // 讓文字顯示出來
      _counter++; // 計數器加一
    });

    // 延遲 100 毫秒後，讓文字開始浮動並消失
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _offset = const Offset(0, -2); // 文字開始向上浮動
      });

      // 延遲 300 毫秒後讓文字漸漸消失，並重置位置而不使用動畫
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _opacity = 0.0; // 讓文字消失
        });

        // 直接將文字位置重置，不使用動畫
        Future.delayed(const Duration(milliseconds: 0), () {
          setState(() {
            _offset = const Offset(0, 0); // 無動畫地重置位置
          });
        });
      });
    });
  }

  void _playBoSound() async {
    if (!_isMuted) {
      // 播放 bo.mp3 音效
      await _audioPlayer.play(AssetSource('audio/bo.mp3'));
    }

    // 按下按鈕後顯示 "回向+1"
    setState(() {
      _boOffset = const Offset(0, 0); // 重置位置
      _boOpacity = 1.0; // 讓 "回向+1" 顯示出來
      _counter++; // 計數器也加一
    });

    // 延遲 100 毫秒後，讓 "回向+1" 開始浮動並消失
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _boOffset = const Offset(0, -2); // "回向+1" 開始向上浮動
      });

      // 延遲 300 毫秒後讓 "回向+1" 漸漸消失
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _boOpacity = 0.0; // 讓 "回向+1" 消失
        });

        // 重置位置而不使用動畫
        Future.delayed(const Duration(milliseconds: 0), () {
          setState(() {
            _boOffset = const Offset(0, 0); // 無動畫地重置位置
          });
        });
      });
    });
  }

  // 切換靜音狀態
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // 釋放資源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_isMuted ? Icons.music_off : Icons.music_note), // 根據靜音狀態切換圖標
            onPressed: _toggleMute, // 點擊按鈕切換靜音狀態
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '多少次',
              style: TextStyle(
                fontSize: 34,
                fontFamily: "Noto Sans TC",
                fontWeight: FontWeight.w500,
                letterSpacing: 0.50,
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              "(心中默唸)",
              style: TextStyle(
                color: Color(0xff80807f),
                fontSize: 16,
                fontFamily: "Noto Sans TC",
                fontWeight: FontWeight.w500,
                letterSpacing: 0.50,
              ),
            ),
             const Text(
              "all money back me home",
              style: TextStyle(
                color: Color(0xff80807f),
                fontSize: 24,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.50,
              ),
            ),
            // 顯示木魚加的文字
            Container(
              width: 375,
              height: 140,
              alignment: Alignment.center,
              child: AnimatedSlide(
                offset: _offset, // 控制 "功德+1" 的偏移量
                duration: const Duration(milliseconds: 300), // 移動動畫時間
                child: AnimatedOpacity(
                  opacity: _opacity, // 文字的透明度
                  duration: const Duration(milliseconds: 300), // 透明度變化時間
                  child: const Text(
                    "功德+1",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Noto Sans TC",
                    ),
                  ),
                ),
              ),
            ),
            // 顯示bo按鈕加的文字
            Container(
              width: 375,
              height: 140,
              alignment: Alignment.center,
              child: AnimatedSlide(
                offset: _boOffset, // 控制 "回向+1" 的偏移量
                duration: const Duration(milliseconds: 300), // 移動動畫時間
                child: AnimatedOpacity(
                  opacity: _boOpacity, // 文字的透明度
                  duration: const Duration(milliseconds: 300), // 透明度變化時間
                  child: const Text(
                    "回向+1",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Noto Sans TC",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // 增加按鈕與上方元素之間的距離
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _incrementCounter, // 木魚按鈕點擊事件
                  child: Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/woodfish.png"), // 無背景的木魚圖片按鈕
                  ),
                ),
                const SizedBox(width: 20), // 木魚與新按鈕之間的間距
                GestureDetector(
                  onTap: _playBoSound, // bo 按鈕點擊事件
                  child: Container(
                    width: 120,
                    height: 120,
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/bo.png"), // 無背景的 bo 按鈕圖片
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
