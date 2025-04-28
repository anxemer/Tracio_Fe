import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/chat/bloc/bloc/conversation_bloc.dart';
import 'package:tracio_fe/presentation/chat/widgets/conversation_list_item.dart';

class UserConversationTab extends StatefulWidget {
  const UserConversationTab({super.key});

  @override
  State<UserConversationTab> createState() => _UserConversationTabState();
}

class _UserConversationTabState extends State<UserConversationTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    context.read<ConversationBloc>().add(GetConversations());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ConversationBloc, ConversationState>(
      buildWhen: (previous, current) {
        if (previous is ConversationLoaded && current is ConversationLoaded) {
          return previous.refreshKey != current.refreshKey;
        }
        return true;
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: Builder(
            builder: (_) {
              if (state is ConversationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ConversationFailure) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      child:
                          Center(child: Text("Error: ${state.errorMessage}")),
                    ),
                  ],
                );
              } else if (state is ConversationLoaded) {
                final userConversations =
                    state.conversations.where((c) => !c.isGroup).toList();

                if (userConversations.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child:
                            Center(child: Text("No user conversations found.")),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: userConversations.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.only(top: AppSize.apVerticalPadding),
                  itemBuilder: (context, index) {
                    return ConversationListItem(
                      conversation: userConversations[index],
                    );
                  },
                );
              }

              return ListView(); // fallback empty
            },
          ),
        );
      },
    );
  }
}
