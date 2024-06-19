//改为同时打开多首歌曲
function setFilesModel (selectedFiles){
    content.dialogs.fileOpen.open()

    content.dialogs.fileOpen.rejected.
    connect(()=>{ return })

    content.dialogs.fileOpen.accepted.
    connect(()=>{

    content.filesModel.clear();
     arguments[0]=content.dialogs.fileOpen.selectedFiles
    for(var i=0;i<arguments[0].length;i++){
        var filePath=selectedFiles[i]
        var data={
            "filePath":filePath,
            "title":"loading",
            "author":"loading"
        };
        content.filesModel.append(data);
        content.getTitle(filePath,i);
    }
    content.listview.model=content.filesModel
    content.listview.currentIndex=0
})
}

//将时间毫秒转化为00：00格式
function formatTime(milliseconds) {
    //Math.floor（）向下取整，返回小于等于给定值的最大值
    //1秒等于1000毫秒
    //给定值一共多少秒
    var seconds = Math.floor(milliseconds / 1000)
    //分钟
    var minutes = Math.floor(seconds / 60)
    //秒
    var remainingSeconds = seconds % 60
    //输出格式
    //padStart（）在字符串的开始处（左侧）填充指定的字符，直到字符串达到给定的长度，至少有2个字符长度，不足补‘0’
    var formattedTime = minutes.toString().padStart(
                2, '0') + ":" + remainingSeconds.toString().padStart(2, '0')
    return formattedTime
}
