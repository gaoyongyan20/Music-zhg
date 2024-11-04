//改为同时打开多首歌曲
function setFilesModel(selectedFiles) {
    content.dialogs.fileOpen.open()

    content.dialogs.fileOpen.rejected.connect(() => {
                                                  return
                                              })

    content.dialogs.fileOpen.accepted.connect(() => {
                                                  console.log("accept")
                                                  content.filesModel.clear()

                                                  arguments[0]
                                                  = content.dialogs.fileOpen.selectedFiles
                                                  for (var i = 0; i < arguments[0].length; i++) {
                                                      var filePath = selectedFiles[i]
                                                      var data = {
                                                          "filePath": filePath,
                                                          "title": "loading",
                                                          "author": "loading"
                                                      }
                                                      content.filesModel.append(
                                                          data)
                                                      content.getTitle(
                                                          filePath, i)
                                                      console.log(filePath)
                                                  }

                                                  content.listview.model = content.filesModel
                                                  content.listview.currentIndex = 0
                                                  content.playmusic.source = content.filesModel.get(
                                                      0).filePath
                                                  // content.textalubm=content.filesModel.get(0).title
                                                  // content.textauthor=content.filesModel.get(0).author
                                                  console.log(
                                                      content.listview.currentIndex)
                                                  content.changeinformation()
                                                  content.playmusic.play()
                                                  content.rotate()
                                                  content.exchangepath()
                                              })
}

//设置上一首歌
function setBackwardMusic() {
    console.log("Now play in ", "loop: ", arguments[0], "random: ",
                arguments[1])

    // 判断是否循环播放
    if (arguments[0]) {
        content.playmusic.source = content.filesModel.get(
                    content.listview.currentIndex).filePath
        content.changeinformation()
        content.exchangepath()
        content.playmusic.play()
        return
    }

    // 判断是否为随机播放
    if (arguments[1]) {
        var index = getRandomIndex(0, content.listview.count - 1)

        // 当随机到当前歌曲的时候也可以重新刷新播放位置
        if (content.listview.currentIndex === index) {
            content.playmusic.position = 0
        } else {
            content.listview.currentIndex = index
        }
        content.playmusic.source = content.filesModel.get(index).filePath
        content.changeinformation()
        content.exchangepath()
        content.playmusic.play()
        return
    }

    // 顺序播放
    // if (currentMusicIndex === 0) {
    //     content.playmusic.source = arguments[0][arguments[0].length - 1]
    //     content.listview.currentIndex = arguments[0].length - 1
    //     content.filesModel.move(content.listview.currentIndex, 0, 1)
    // } else {
    //     content.playmusic.source = arguments[0][currentMusicIndex - 1]
    //     content.listview.currentIndex = currentMusicIndex - 1
    //     content.filesModel.move(content.listview.currentIndex, 0, 1)
    // }
    if (content.listview.currentIndex > 0) {
        content.listview.currentIndex -= 1
    } else {
        content.listview.currentIndex = content.filesModel.count - 1
    }
    var nextFilePath = content.filesModel.get(
                content.listview.currentIndex).filePath
    content.playmusic.source = nextFilePath

    content.changeinformation()
    content.exchangepath()
    content.playmusic.play()
}

//设置下一首歌
function setForwardMusic() {

    console.log("Now play in ", "loop: ", arguments[0], "random: ",
                arguments[1])

    // 判断是否为循环播放
    if (arguments[0]) {
        content.playmusic.source = content.filesModel.get(
                    content.listview.currentIndex).filePath
        content.changeinformation()
        content.exchangepath()
        content.playmusic.play()
        return
    }

    // 判断是否为随机播放
    if (arguments[1]) {
        var index = getRandomIndex(0, content.listview.count - 1)

        // 当随机到当前歌曲的时候也可以重新刷新播放位置
        if (content.listview.currentIndex === index) {
            content.playmusic.position = 0
        } else {
            content.listview.currentIndex = index
        }
        content.playmusic.source = content.filesModel.get(index).filePath
        content.changeinformation()
        content.exchangepath()
        content.playmusic.play()
        return
    }

    //判断当前是否为顺序播放
    if (content.listview.currentIndex < content.filesModel.count - 1) {
        content.listview.currentIndex += 1
    } else {
        content.listview.currentIndex = 0
    }
    var nextFilePath = content.filesModel.get(
                content.listview.currentIndex).filePath
    content.playmusic.source = nextFilePath
    content.changeinformation()
    content.exchangepath()
    content.playmusic.play()
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

function getRandomIndex(min, max) {
    // floor函数是向下取整
    // Math.random()函数生成一个0到1之间的随机数（不包括1）
    return Math.floor(Math.random() * (max - min + 1)) + min
}

//获取歌词文件路径
function getlrcpath() {
    var songpath = content.filesModel.get(
                content.listview.currentIndex).filePath
    var extension = songpath.toString().substring(7)
    var lastDotIndex = extension.toString().lastIndexOf(".")
    //找到了后缀点号
    if (lastDotIndex !== -1) {
        // var extension=songpath.toString().substring(lastDotIndex+1)
        var extensions = extension.toString().substring(lastDotIndex + 1)
        var newsongpath = extension.toString().replace(extensions, "lrc")
        console.log(newsongpath)
        return newsongpath
    }
}

function setlrcmodel() {

    content.playlistshow.lrcmodel.clear()

    var allLyrics = content.lyrics.getAllLyrics()

    for (var i = 0; i < allLyrics.length; ++i) {

        var ci = allLyrics[i]
        console.log("if i enter")
        console.log(ci)
        var da = {
            "ci": ci
        }
        content.playlistshow.lrcmodel.append(da)
    }
    content.playlistshow.list.model = content.playlistshow.lrcmodel
    content.playlistshow.list.currentIndex = 0
}

function setNoLyricsFileModel() {
    content.playlistshow.lrcmodel.clear()
    console.log("enter!!")

    var ci = "no lyric file, please enjoy music.."
    var data = {
        "ci": ci
    }
    content.playlistshow.lrcmodel.append(data)

    content.playlistshow.list.model = content.playlistshow.lrcmodel
    content.playlistshow.list.currentIndex = 0
}

function setplaylistModel() {
    console.log("accept")
    content.mySongDataModel.clear()

    var allsongs = content.songlist.getAllMap()

    var size = content.songlist.getMapCount()
    console.log(size)
    var playlistPath
    for (var i = 0; i < size; i++) {
        console.log("...")
        if ((playlistPath = content.songlist.getUrlByIndex(i)) !== "") {
            console.log(playlistPath)
            var data = {
                "playlistPath": playlistPath,
                "title": "loading",
                "author": "loading",
                "duration": "00.00",
                "genre": "loading",
                "canDelete": "true"
            }
        }
        content.mySongDataModel.append(data)
        content.getAllData(playlistPath, i)
    }
    console.log(content.mySongDataModel.count)
    content.mySongData.model = content.mySongDataModel
    content.mySongData.currentIndex = 0
}

function appendsong(cindex) {

    var data = {
        "filePath": content.mySongDataModel.get(cindex).playlistPath,
        "title": content.mySongDataModel.get(cindex).title,
        "author": content.mySongDataModel.get(cindex).author
    }
    content.filesModel.append(data)
}

function deletesong(songIndex) {
    console.log("enter..")
}

function disableDeleteButton() {
    for (var i = 0; i !== content.mySongDataModel.count; i++) {
        content.mySongDataModel.setProperty(
                    i, "canDelete", false) // setProperty的作用是将某一位置模型数据项目的对应属性值修改
        // 这样做的目的是：因为在delegate中button的enabled属性值是绑定在“canDelete”属性的，模型数据中的值发生了改变，
        // 委托中的数据也发生了改变
        // 委托中数据的显示关联到模型数据中通过required property的机制实现的，同样的还有filepath,title之类的，只不过他们没有涉及到
        // 模型中数据的改变
    }
}

function appendToList() {
    // 在歌单列表中我们可以从它的模型数据中获取到播放歌曲的路径，但是别的信息需要调用元数据解析方法获得
    var filePath = content.filesModel.get(arguments[0]).filePath
    var data = {
        "filePath": filePath,
        "title": "loading",
        "author": "loading",
        "duration": "00.00",
        "genre": "loading",
        "canDelete": "true"
    }
    content.mySongDataModel.append(data)
    content.getAllData(filePath, arguments[0])
}
