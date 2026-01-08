import 'package:flutter/material.dart';

class CustomLoadMore extends StatefulWidget {
  const CustomLoadMore({super.key,this.padding,this.allowPullToRefresh=false, required this.itemBuilder, this.onLoadMore, this.separatorWidget, required this.itemCount});

  final Widget? Function(BuildContext, int) itemBuilder;
  final Future<bool> Function(int page)? onLoadMore;
  final Widget? separatorWidget;
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final bool allowPullToRefresh;
  @override
  State<CustomLoadMore> createState() => _CustomLoadMoreState();
}

class _CustomLoadMoreState extends State<CustomLoadMore> {
  final scrollCtr=ScrollController();
  bool isLoadingMore=false;
  int page=0;
  @override
  void initState() {
    scrollCtr.addListener(() {
      if(!isLoadingMore){
        if(scrollCtr.position.pixels>=scrollCtr.position.maxScrollExtent*.9){
          loadMore();
        }
      }
    },);
    super.initState();
  }
  void loadMore()async{
    page++;
    setState(() {
      isLoadingMore = true;
    });
    final result=await widget.onLoadMore?.call(page);
    if(result!=true){
      page--;
    }
    setState(() {
      isLoadingMore = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final child=ListView.separated(
      controller: scrollCtr,
      padding: widget.padding,
      itemCount: widget.itemCount+(isLoadingMore?1:0),
      itemBuilder: (context, index) {
        if (index == (widget.itemCount)) {
          return SafeArea(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ));
        }
        return widget.itemBuilder(context,index);
      },
      separatorBuilder: (context, index) => widget.separatorWidget ?? SizedBox(),

    );
    if(widget.allowPullToRefresh){
      return RefreshIndicator(
        onRefresh: () async =>await widget.onLoadMore?.call(0),
        child: child,
      );
    }else{
      return child;
    }
  }
}
