# 一个MVVM+ReactiveCocoa实践
一个MVVM的DEMO，我自己也在慢慢学习中，这个DEMO会慢慢完善
并且会把学习中需要注意的东西记录下来。感谢关注阅读

## 首先先谈谈MVVM是个什么东西
    M是Model，V是View，VM是viewmodel，在cocoa体系的IOS开发中，View是指纯View，包括View和管理view的control。VM就是View的逻辑数据，在平常开发的过程中，view初始化的时候一般要传入一个vm，所以在view中拥有一个vm，view中需要向用户展现的数据从vm中读取，同样用户所有对于view的操作都写入vm，也就是说view在这其中所拥有的功能就是展现vm中的数据给用户看，以及接受用户对view的操作并写入vm
    
