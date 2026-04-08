import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineGeneratorView extends StatefulWidget {
  final String routineSource;
  final String? initialRoutineSource;
  final bool hasModifiedInitialRoutine;
  final VoidCallback onClose;
  final Function(String) onRoutineStateChanged;

  const RoutineGeneratorView({
    Key? key,
    required this.routineSource,
    required this.initialRoutineSource,
    required this.hasModifiedInitialRoutine,
    required this.onClose,
    required this.onRoutineStateChanged,
  }) : super(key: key);

  @override
  _RoutineGeneratorViewState createState() => _RoutineGeneratorViewState();
}

class _RoutineGeneratorViewState extends State<RoutineGeneratorView> {
  WebViewController? generatorController;
  bool _canRevertRoutineState = false;

  @override
  void initState() {
    super.initState();
    _initializeView();
  }

  Future<void> _initializeView() async {
    generatorController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(_setupRoutineHandlers())
      ..loadRequest(Uri.parse(widget.routineSource));
  }

  NavigationDelegate _setupRoutineHandlers() {
    return NavigationDelegate(
      onPageStarted: _handleRoutineStepStart,
      onPageFinished: _handleRoutineStepFinish,
      onWebResourceError: _handleRoutineError,
      onNavigationRequest: _handleRoutineTransitionRequest,
    );
  }

  Future<void> _handleRoutineStepStart(String path) async {
    widget.onRoutineStateChanged(path);
    await _verifyRoutineTransition(path);
  }

  Future<void> _verifyRoutineTransition(String currentPath) async {
    if (_shouldBlockRoutineTransition(currentPath)) {
      return;
    }
  }

  bool _shouldBlockRoutineTransition(String currentPath) {
    return widget.hasModifiedInitialRoutine &&
           (currentPath + "/" == widget.initialRoutineSource || currentPath == widget.initialRoutineSource);
  }

  NavigationDecision _handleRoutineTransitionRequest(NavigationRequest request) {
    if (_shouldBlockRoutineTransition(request.url)) {
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<void> _handleRoutineStepFinish(String currentPath) async {
    await _processRoutineStepComplete(currentPath);
    _updateRoutineState();
  }

  Future<void> _processRoutineStepComplete(String currentPath) async {
    if (_shouldSaveRoutineState(currentPath)) {
      await _cacheRoutineState(currentPath);
    }
  }

  bool _shouldSaveRoutineState(String currentPath) {
    return currentPath.isNotEmpty &&
           (currentPath + "/" != widget.initialRoutineSource && currentPath != widget.initialRoutineSource);
  }

  Future<void> _cacheRoutineState(String currentPath) async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    if (!storage.containsKey("SavedRoutine")) {
      await storage.setString("SavedRoutine", currentPath);
    }
  }

  void _handleRoutineError(WebResourceError error) {
    if (_isNotFoundError(error)) {
      widget.onClose();
      return;
    }

    _reloadGenerator();
  }

  bool _isNotFoundError(WebResourceError error) {
    return error.description.contains("404");
  }

  void _reloadGenerator() {
    generatorController?.reload();
  }

  Future<void> _revertRoutineState() async {
    if (await _canRevertRoutineStateCheck()) {
      await generatorController!.goBack();
    }
  }

  Future<bool> _canRevertRoutineStateCheck() async {
    return generatorController != null &&
           await generatorController!.canGoBack();
  }

  Future<void> _updateRoutineState() async {
    final canRevert = await _canRevertRoutineStateCheck();
    if (canRevert != _canRevertRoutineState) {
      setState(() {
        _canRevertRoutineState = canRevert;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && await _canRevertRoutineStateCheck()) {
          await _revertRoutineState();
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildGeneratorBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _revertRoutineState,
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => generatorController?.reload(),
        ),
      ],
    );
  }

  Widget _buildGeneratorBody() {
    return generatorController != null
        ? WebViewWidget(controller: generatorController!)
        : const Center(child: CircularProgressIndicator());
  }
}
