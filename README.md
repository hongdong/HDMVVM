# 一个MVVM+ReactiveCocoa实践
一个MVVM的DEMO，我自己也在慢慢学习中，这个DEMO会慢慢完善
并且会把学习中需要注意的东西记录下来。感谢关注阅读

## 首先先谈谈MVVM是个什么东西
    M是Model，V是View，VM是viewmodel，在cocoa体系的IOS开发中，View是指纯View，包括View和管理view的control。
    VM就是View的逻辑数据，在平常开发的过程中，view初始化的时候一般要传入一个vm，所以在view中拥有一个vm，但是vm
    是不能拥有view的，所以这里的关系是单向的。
    view中需要向用户动态展现从vm中读取的数据，同样用户所有对于view的操作都写入vm，也就是说view在这其中的职能就是：
    － 动态展现vm中的数据给用户看，
    － 以及接收用户对view的操作并并写入vm，
    是的，那处理数据的逻辑都到了VM中去了。
    
    # 上面说到的一个view的职能:动态展现VM中的数据给用户看，这句话理解为，view自己能及时地更新显示的数据以及UI。
    但是但是、数据的处理逻辑在vm中，而vm中是没有拥有view的，那在vm中逻辑处理完了以后，view自己是怎么更新自己的呢？
    这就要用到ReactiveCocoa（以下简称RAC）了，RAC能够绑定UI与数据源（VM），通过绑定View与VM，只要VM中的数据有变动，
    那么View就会自己更新自己。
    
