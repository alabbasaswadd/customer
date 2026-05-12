import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';
import 'package:mikrotic_customer/pages/features/chat/cubit/chat_cubit.dart';
import 'package:mikrotic_customer/pages/features/chat/cubit/chat_state.dart';
import 'package:mikrotic_customer/pages/features/chat/model/chat_message.dart';

// ────────────────────────────────────────────────────────────────────────────
// Helpers
// ────────────────────────────────────────────────────────────────────────────

String _formatTime(DateTime dt) {
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m ${dt.hour < 12 ? 'ص' : 'م'}';
}

String _formatDateLabel(DateTime dt) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(dt.year, dt.month, dt.day);
  if (d == today) return 'اليوم';
  if (d == today.subtract(const Duration(days: 1))) return 'أمس';
  return '${dt.day}/${dt.month}/${dt.year}';
}

// Used as a sentinel in the flat item list to render date chips
class _DateLabel {
  final DateTime date;
  const _DateLabel(this.date);
}

// ────────────────────────────────────────────────────────────────────────────
// Main Screen
// ────────────────────────────────────────────────────────────────────────────

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _hasText = false;
  bool _showScrollDown = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final has = _textController.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
    _scrollController.addListener(() {
      final show = _scrollController.offset > 200;
      if (show != _showScrollDown) setState(() => _showScrollDown = show);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatCubit>().sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showClearDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'مسح المحادثة',
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'سيتم حذف جميع الرسائل نهائياً. هل أنت متأكد؟',
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontWeight: FontWeight.w400,
            color: AppColors.kGreyColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Cairo-Bold',
                color: AppColors.kGreyColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChatCubit>().clearChat();
            },
            child: Text(
              'مسح',
              style: TextStyle(
                fontFamily: 'Cairo-Bold',
                color: AppColors.kRedColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (prev, curr) =>
          prev.messages.length != curr.messages.length ||
          prev.isTyping != curr.isTyping,
      listener: (_, __) => _scrollToBottom(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(theme),
        body: Column(
          children: [
            _OfflineBanner(theme: theme),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    );
                  }
                  return _buildMessageList(state, theme);
                },
              ),
            ),
            _InputBar(
              controller: _textController,
              hasText: _hasText,
              onSend: _send,
              theme: theme,
            ),
          ],
        ),
        floatingActionButton: _showScrollDown
            ? Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: FloatingActionButton.small(
                  onPressed: _scrollToBottom,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.kWhiteColor,
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.82),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.kWhiteColor,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: AppColors.kWhiteColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'فريق الدعم الفني',
                        style: TextStyle(
                          fontFamily: 'Cairo-Bold',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kWhiteColor,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            margin: const EdgeInsets.only(left: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            'متاح دائماً',
                            style: TextStyle(
                              fontFamily: 'Cairo-Bold',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.kWhiteColor.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.kWhiteColor,
                    size: 22,
                  ),
                  onPressed: _showClearDialog,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList(ChatState state, ThemeData theme) {
    final items = _buildFlatItems(state.messages, state.isTyping);

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is String && item == 'typing') {
          return _TypingBubble(theme: theme);
        }
        if (item is _DateLabel) {
          return _DateChip(label: _formatDateLabel(item.date));
        }
        final msg = item as ChatMessage;
        final isFirst = index == items.length - 1;
        final prev = index < items.length - 1 ? items[index + 1] : null;
        final showAvatar =
            !msg.isFromUser ? false : false; // user has no avatar
        final hideSupportAvatar = prev is ChatMessage &&
            !prev.isFromUser &&
            !msg.isFromUser;
        return _MessageBubble(
          message: msg,
          theme: theme,
          showSupportAvatar: !msg.isFromUser && !hideSupportAvatar,
          formatTime: _formatTime,
        );
      },
    );
  }

  List<dynamic> _buildFlatItems(
    List<ChatMessage> messages,
    bool isTyping,
  ) {
    final items = <dynamic>[];

    if (isTyping) items.add('typing');

    final reversed = messages.reversed.toList();
    for (int i = 0; i < reversed.length; i++) {
      final msg = reversed[i];
      items.add(msg);

      final currDay = DateTime(
        msg.timestamp.year,
        msg.timestamp.month,
        msg.timestamp.day,
      );

      if (i == reversed.length - 1) {
        items.add(_DateLabel(msg.timestamp));
      } else {
        final nextMsg = reversed[i + 1];
        final nextDay = DateTime(
          nextMsg.timestamp.year,
          nextMsg.timestamp.month,
          nextMsg.timestamp.day,
        );
        if (currDay != nextDay) {
          items.add(_DateLabel(msg.timestamp));
        }
      }
    }

    return items;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Offline Banner
// ────────────────────────────────────────────────────────────────────────────

class _OfflineBanner extends StatelessWidget {
  final ThemeData theme;
  const _OfflineBanner({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.orange.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 13, color: Colors.orange),
          const SizedBox(width: 6),
          Text(
            'الرسائل محفوظة على جهازك • يعمل دون اتصال',
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Date Chip
// ────────────────────────────────────────────────────────────────────────────

class _DateChip extends StatelessWidget {
  final String label;
  const _DateChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.15),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.kGreyColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Message Bubble
// ────────────────────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ThemeData theme;
  final bool showSupportAvatar;
  final String Function(DateTime) formatTime;

  const _MessageBubble({
    required this.message,
    required this.theme,
    required this.showSupportAvatar,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: message.isFromUser ? _userBubble() : _supportBubble(),
    );
  }

  Widget _userBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.88),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.content,
                style: const TextStyle(
                  fontFamily: 'Cairo-Bold',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.kWhiteColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatTime(message.timestamp),
                    style: TextStyle(
                      fontFamily: 'Cairo-Bold',
                      fontSize: 10,
                      color: AppColors.kWhiteColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _statusIcon(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _supportBubble() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Support avatar
        if (showSupportAvatar)
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(left: 8, bottom: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.kWhiteColor,
              size: 16,
            ),
          )
        else
          const SizedBox(width: 38),
        // Bubble
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      fontFamily: 'Cairo-Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTime(message.timestamp),
                    style: const TextStyle(
                      fontFamily: 'Cairo-Bold',
                      fontSize: 10,
                      color: AppColors.kGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return Icon(
          Icons.schedule_rounded,
          size: 13,
          color: AppColors.kWhiteColor.withOpacity(0.7),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.done_rounded,
          size: 13,
          color: AppColors.kWhiteColor.withOpacity(0.7),
        );
      case MessageStatus.read:
        return const Icon(
          Icons.done_all_rounded,
          size: 13,
          color: AppColors.kWhiteColor,
        );
    }
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Typing Indicator
// ────────────────────────────────────────────────────────────────────────────

class _TypingBubble extends StatefulWidget {
  final ThemeData theme;
  const _TypingBubble({required this.theme});

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(left: 8, bottom: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.theme.colorScheme.primary,
                  widget.theme.colorScheme.secondary,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.kWhiteColor,
              size: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.theme.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
              border: Border.all(
                color: widget.theme.colorScheme.outline.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.theme.shadowColor.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(controller: _controller, delay: 0.0, theme: widget.theme),
                const SizedBox(width: 5),
                _Dot(
                    controller: _controller,
                    delay: 0.3,
                    theme: widget.theme),
                const SizedBox(width: 5),
                _Dot(
                    controller: _controller,
                    delay: 0.6,
                    theme: widget.theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final ThemeData theme;

  const _Dot({
    required this.controller,
    required this.delay,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = ((controller.value + delay) % 1.0);
        final y = t < 0.5 ? t * 2 : (1.0 - t) * 2;
        return Transform.translate(
          offset: Offset(0, -5 * y),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.55),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Input Bar
// ────────────────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;
  final ThemeData theme;

  const _InputBar({
    required this.controller,
    required this.hasText,
    required this.onSend,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.15),
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    style: TextStyle(
                      fontFamily: 'Cairo-Bold',
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      hintStyle: TextStyle(
                        fontFamily: 'Cairo-Bold',
                        fontSize: 14,
                        color: AppColors.kGreyColor.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 11,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Send button
              AnimatedScale(
                scale: hasText ? 1.0 : 0.85,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: GestureDetector(
                  onTap: hasText ? onSend : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: hasText
                            ? [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.82),
                              ]
                            : [
                                AppColors.kGreyColor.withOpacity(0.25),
                                AppColors.kGreyColor.withOpacity(0.15),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: hasText
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: hasText
                          ? AppColors.kWhiteColor
                          : AppColors.kGreyColor.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
