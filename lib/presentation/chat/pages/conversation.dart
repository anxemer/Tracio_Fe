import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/core/services/signalR/implement/chat_hub_service.dart';
import 'package:Tracio/presentation/chat/bloc/bloc/conversation_bloc.dart';
import 'package:Tracio/presentation/chat/widgets/conversation_search_box.dart';
import 'package:Tracio/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/service_locator.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with RouteAware {
  final chatHub = sl<ChatHubService>();
  late final StreamSubscription _conversationSubscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });

    _conversationSubscription = chatHub.onConversationUpdate.listen((data) =>
        context
            .read<ConversationBloc>()
            .add(ReceiveUpdatedConversation(conversation: data)));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _conversationSubscription.cancel();
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<ConversationBloc>().add(GetConversations());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: _buildFloatingButton(),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            ConversationSearchBox(),
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: "Users"),
                Tab(text: "Shops"),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  UserConversationTab(),
                  ShopConversationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      height: AppSize.appBarHeight.h,
      title: Text(
        'Conversations',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: AppSize.textHeading * 0.9.sp,
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: PopupMenuButton(
          color: Colors.white,
          onCanceled: () {
            FocusScope.of(context).unfocus();
          },
          onSelected: (value) {
            FocusScope.of(context).unfocus();
            if (value == 'new') {
              // TODO: Navigate to new conversation
            } else if (value == 'share') {
              // TODO: Navigate to share route
            }
          },
          icon: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.secondBackground,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.message,
              size: AppSize.iconMedium.w,
              color: Colors.white,
            ),
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'new',
                child: Text('New Conversation'),
              ),
              PopupMenuItem(
                value: 'share',
                child: Text('Share route'),
              ),
            ];
          },
          offset: Offset(-60, -60),
        ),
      ),
    );
  }
}
