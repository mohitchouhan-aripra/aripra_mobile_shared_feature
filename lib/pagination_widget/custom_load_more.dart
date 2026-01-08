import 'package:flutter/material.dart';

class CustomLoadMore extends StatefulWidget {
  const CustomLoadMore({super.key,this.padding,this.allowPullToRefresh=false, required this.itemBuilder, this.onLoadMore, this.separatorWidget, required this.itemCount});

  final Widget? Function(BuildContext, int) itemBuilder;
  /// function that trigger when you reach the end of list , you need to call api inside and give bool result in retun to manage the page count 
  final Future<bool> Function(int page)? onLoadMore;
  final Widget? separatorWidget;
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  ///allow you to use pull to refresh, you will get callback in onLoadMore with zero value
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
        onRefresh: () async {
          page=0;
          await widget.onLoadMore?.call(page),
          }
        child: child,
      );
    }else{
      return child;
    }
  }
}
