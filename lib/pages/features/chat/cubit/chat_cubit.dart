import 'package:bloc/bloc.dart';

import '../model/chat_message.dart';
import '../repository/chat_repository.dart';
import 'chat_state.dart';

class _Reply {
  final List<String> keywords;
  final String response;
  const _Reply({required this.keywords, required this.response});
}

const _replies = [
  _Reply(
    keywords: ['مرحبا', 'هلا', 'سلام', 'أهلا', 'اهلا', 'صباح', 'مساء', 'هاي'],
    response:
        'وعليكم السلام ومرحباً! سعداء بتواصلك معنا. كيف يمكنني مساعدتك اليوم؟',
  ),
  _Reply(
    keywords: [
      'انترنت',
      'اتصال',
      'انقطع',
      'وقطع',
      'مش شغال',
      'لا يعمل',
      'ما يشتغل',
    ],
    response:
        'نأسف لهذه المشكلة. يرجى اتباع الخطوات:\n'
        '١. أعد تشغيل الراوتر (انتظر ٣٠ ثانية)\n'
        '٢. تأكد من أن كابل الشبكة متصل بشكل صحيح\n'
        '٣. جرب إعادة تشغيل الجهاز\n\n'
        'إذا استمرت المشكلة سنرسل فنياً في أقرب وقت ممكن.',
  ),
  _Reply(
    keywords: ['بطيء', 'بطء', 'سرعة', 'ضعيف', 'سلو', 'بطيئ'],
    response:
        'يمكنك إجراء اختبار السرعة مباشرة من التطبيق للتحقق من سرعة اتصالك الفعلية. '
        'إذا كانت السرعة أقل من اشتراكك المعتمد، سنرفع تذكرة صيانة فورية لفريقنا.',
  ),
  _Reply(
    keywords: [
      'دفع',
      'رصيد',
      'فاتورة',
      'سداد',
      'تسديد',
      'مبلغ',
      'دينار',
      'ريال',
      'درهم',
    ],
    response:
        'يمكنك إدارة مدفوعاتك وفواتيرك مباشرة من قسم المحفظة والفواتير في التطبيق. '
        'هل تحتاج مساعدة في خطوة معينة؟',
  ),
  _Reply(
    keywords: ['راوتر', 'روتر', 'موديم', 'جهاز', 'router'],
    response:
        'يمكنك إدارة الراوتر وتغيير كلمة المرور أو إعادة الضبط من قسم "أمان الراوتر" في التطبيق. '
        'هل تحتاج مساعدة في إعداد معين؟',
  ),
  _Reply(
    keywords: ['اشتراك', 'تجديد', 'باقة', 'منتهي', 'انتهى', 'مدة', 'ترقية'],
    response:
        'يمكنك تجديد اشتراكك أو الترقية إلى باقة أعلى من قسم الاشتراكات في التطبيق. '
        'هل تريد الاطلاع على الباقات المتاحة؟',
  ),
  _Reply(
    keywords: ['كلمة مرور', 'باسورد', 'password', 'مرور', 'واي فاي', 'wifi'],
    response:
        'لتغيير كلمة مرور الواي فاي، توجه إلى قسم "أمان الراوتر" في التطبيق واختر "تغيير كلمة المرور". '
        'تأكد من اختيار كلمة مرور قوية.',
  ),
  _Reply(
    keywords: ['شكر', 'شكراً', 'مشكور', 'ممنون', 'تسلم', 'يعطيك'],
    response:
        'العفو! سعداء بخدمتك دائماً 😊 لا تتردد في التواصل معنا في أي وقت.',
  ),
  _Reply(
    keywords: ['وقت', 'متى', 'ساعة', 'عمل', 'دوام'],
    response:
        'فريق الدعم الفني متاح على مدار الساعة. '
        'يمكنك إرسال رسالتك في أي وقت وسنرد عليك فور تواجد أحد أعضاء الفريق.',
  ),
  _Reply(
    keywords: ['صيانة', 'تصليح', 'عطل', 'خراب', 'مكسور'],
    response:
        'تم تسجيل طلبك. يمكنك أيضاً تقديم طلب صيانة مفصّل من قسم "الصيانة والتشخيص" في التطبيق '
        'لنتمكن من تحديد أولوية الطلب وإرسال الفني المناسب.',
  ),
];

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;

  ChatCubit(this._repository) : super(const ChatState());

  static const _welcomeId = 'welcome_msg';

  Future<void> loadMessages() async {
    final saved = await _repository.loadMessages();
    if (saved.isEmpty) {
      final welcome = _supportMessage(
        'مرحباً! أنا مساعد الدعم الفني لشبكتك. '
        'يمكنني مساعدتك في مشاكل الاتصال، السرعة، الفواتير، وإدارة الراوتر. '
        'كيف يمكنني مساعدتك؟',
        id: _welcomeId,
      );
      final messages = [welcome];
      emit(state.copyWith(messages: messages, isLoading: false));
      await _repository.saveMessages(messages);
    } else {
      emit(state.copyWith(messages: saved, isLoading: false));
    }
  }

  Future<void> sendMessage(String content) async {
    final text = content.trim();
    if (text.isEmpty) return;

    // 1. Add user message (sending)
    final userMsg = ChatMessage(
      id: _uid(),
      content: text,
      isFromUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );
    final msgs1 = [...state.messages, userMsg];
    emit(state.copyWith(messages: msgs1));
    await _repository.saveMessages(msgs1);

    // 2. Mark as sent
    await Future.delayed(const Duration(milliseconds: 400));
    if (isClosed) return;
    final msgs2 = _updateStatus(msgs1, userMsg.id, MessageStatus.sent);
    emit(state.copyWith(messages: msgs2));

    // 3. Show typing indicator
    await Future.delayed(const Duration(milliseconds: 200));
    if (isClosed) return;
    emit(state.copyWith(messages: msgs2, isTyping: true));

    // 4. Simulate typing delay
    final delay = 1000 + (text.length * 20).clamp(0, 1500);
    await Future.delayed(Duration(milliseconds: delay));
    if (isClosed) return;

    // 5. Add auto-reply
    final reply = _generateReply(text);
    final replyMsg = _supportMessage(reply);
    final msgs3 = [...msgs2, replyMsg];
    emit(state.copyWith(messages: msgs3, isTyping: false));
    await _repository.saveMessages(msgs3);
  }

  Future<void> clearChat() async {
    await _repository.clearMessages();
    emit(const ChatState(isLoading: false));
    await loadMessages();
  }

  // -------------------------------------------------------------------------

  List<ChatMessage> _updateStatus(
    List<ChatMessage> messages,
    String id,
    MessageStatus status,
  ) {
    return messages
        .map((m) => m.id == id ? m.copyWith(status: status) : m)
        .toList();
  }

  ChatMessage _supportMessage(String content, {String? id}) => ChatMessage(
    id: id ?? _uid(),
    content: content,
    isFromUser: false,
    timestamp: DateTime.now(),
    status: MessageStatus.read,
  );

  String _uid() => DateTime.now().microsecondsSinceEpoch.toString();

  String _generateReply(String message) {
    final lower = message.toLowerCase();
    for (final reply in _replies) {
      if (reply.keywords.any((kw) => lower.contains(kw))) {
        return reply.response;
      }
    }
    return 'شكراً لتواصلك معنا. تم استلام رسالتك وسيرد عليك أحد أعضاء فريق الدعم '
        'في أقرب وقت ممكن. إذا كانت المشكلة عاجلة يرجى تقديم طلب صيانة من '
        'قسم الصيانة والتشخيص في التطبيق.';
  }
}
