Just replace your listview with CustomLoadMore
 
 ``` Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  itemCount: value.list?.length??0,
                  itemBuilder: (context, index) {
                    final item=value.list![index];
                    return itemWidget(item);
                  },
                ),
              )
 ```

 ```
import 'package:aripra_mobile_shared_feature/pagination_widget/custom_load_more.dart';
 ```

 ```
Expanded(
                child: CustomLoadMore(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  itemCount: value.list?.length??0,
                  allowPullToRefresh: true, // if you want pull to refresh
                  onLoadMore: (page) async{
                    /// api call code that retuen bool as sucess.
                    return ciHomeProvider.searchPXTicket(context: context,showValidation: false,showLoader: page==0,page: page);
                  },
                  itemBuilder: (context, index) {
                    final item=value.list![index];
                    return itemWidget(item);
                  },
                ),
              )
```

Make sure you add all items to the local list & empty the list if page was 0 

```
        list??=[];
         if(page==0){
            list!.clear();
         }
         list!.addAll(result?.data?.vehicles??[]);
```
 
