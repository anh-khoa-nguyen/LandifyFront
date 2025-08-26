import 'package:flutter/material.dart';

const Color kPrimaryBlue = Color(0xFF165DFF);

class ChatInputArea extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;

  const ChatInputArea({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  bool _expanded = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocus);
    widget.controller.addListener(_handleTextChange);
    _hasText = widget.controller.text.trim().isNotEmpty;
  }

  void _handleFocus() {
    setState(() {
      _expanded = _focusNode.hasFocus;
    });
  }

  void _handleTextChange() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) {
      setState(() => _hasText = has);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _sendOrLike() {
    if (_hasText) {
      final text = widget.controller.text.trim();
      if (text.isEmpty) return;
      widget.onSend(text);
      widget.controller.clear();
      _focusNode.unfocus();
    } else {
      widget.onSend('👍');
    }
  }

  void _collapse() {
    _focusNode.unfocus();
    setState(() => _expanded = false);
  }

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 200);
    const circleSize = 44.0;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // LEFT: action icons OR collapse arrow when expanded
          AnimatedCrossFade(
            duration: animationDuration,
            firstChild: Row(
              children: [
                // <-- NOW: plain filled icons WITHOUT circular bg
                _PlainIcon(icon: Icons.add, onTap: () {}),
                const SizedBox(width: 12),
                _PlainIcon(icon: Icons.camera_alt, onTap: () {}),
                const SizedBox(width: 12),
                _PlainIcon(icon: Icons.photo, onTap: () {}),
              ],
            ),
            secondChild: GestureDetector(
              onTap: _collapse,
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                child: const Icon(Icons.arrow_back_ios_new, color: kPrimaryBlue, size: 18),
              ),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),

          AnimatedContainer(duration: animationDuration, width: _expanded ? 8 : 6),

          // INPUT
          Expanded(
            child: AnimatedContainer(
              duration: animationDuration,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: 'Aa',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: 6),
                      ),
                      onSubmitted: (v) => _sendOrLike(),
                    ),
                  ),

                  // INSIDE ICON: now filled, no circular bg
                  GestureDetector(
                    onTap: () {
                      // emoji picker
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Icon(Icons.emoji_emotions, color: kPrimaryBlue, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // TRAILING: keep circular send/like for emphasis (optional)
          AnimatedContainer(
            duration: animationDuration,
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hasText ? kPrimaryBlue : Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
            ),
            child: IconButton(
              onPressed: _sendOrLike,
              icon: Icon(
                _hasText ? Icons.send : Icons.thumb_up,
                color: _hasText ? Colors.white : kPrimaryBlue,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Plain filled icon widgets (no circular background).
class _PlainIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  const _PlainIcon({required this.icon, required this.onTap, this.size = 26});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: kPrimaryBlue, size: size),
      ),
    );
  }
}
