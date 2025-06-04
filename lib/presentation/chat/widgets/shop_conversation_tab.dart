import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/chat/bloc/bloc/conversation_bloc.dart';
import 'package:Tracio/presentation/chat/widgets/conversation_list_item.dart';

class ShopConversationTab extends StatefulWidget {
  const ShopConversationTab({super.key});

  @override
  State<ShopConversationTab> createState() => _ShopConversationTabState();
}

class _ShopConversationTabState extends State<ShopConversationTab>
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
                final groupConversations = state.shopConversations;

                if (groupConversations.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                            child: Text("No shop conversations found.")),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: groupConversations.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.only(top: AppSize.apVerticalPadding),
                  itemBuilder: (context, index) {
                    return ConversationListItem(
                      conversation: groupConversations[index],
                    );
                  },
                );
              }

              return ListView();
            },
          ),
        );
      },
    );
  }
}
