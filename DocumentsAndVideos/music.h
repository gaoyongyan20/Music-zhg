/*
 * libid3tag - ID3 tag manipulation library
 * Copyright (C) 2000-2004 Underbit Technologies, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * If you would like to negotiate alternate licensing terms, you may do
 * so by contacting: Underbit Technologies, Inc. <info@underbit.com>
 *
 * $Id: id3tag.h,v 1.17 2004/01/23 23:22:46 rob Exp $
 */

# ifndef LIBID3TAG_ID3TAG_H
# define LIBID3TAG_ID3TAG_H

#include <stdint.h>

# ifdef __cplusplus
extern "C" {
    # endif

    /*这些宏定义使得在处理ID3标签时能够更方便地获取和检查版本信息。
     *例如，如果你有一个ID3标签版本号存储在一个整数变量中，你可以使用 *ID3_TAG_VERSION_MAJOR 和 ID3_TAG_VERSION_MINOR 宏来分别
     * 获取主版本和次版本号，而不是进行繁琐的位操作。*/
    # define ID3_TAG_VERSION		0x0400//表示ID3标签的版本号。在这种情况下，0x0400 表示ID3v2.4.0版本。
    # define ID3_TAG_VERSION_MAJOR(x)	(((x) >> 8) & 0xff)//接受一个参数 x 并返回 x 的高位8位。这个宏通常用于提取ID3标签版本号的主版本部分
    # define ID3_TAG_VERSION_MINOR(x)	(((x) >> 0) & 0xff)//接受一个参数 x 并返回 x 的低位8位。这个宏通常用于提取ID3标签版本号的次版本部分。

    typedef unsigned char id3_byte_t;//单个字节
    typedef unsigned long id3_length_t;//数据大小

    typedef uint32_t id3_ucs4_t;//存储UCS-4编码的Unicode字符

    typedef unsigned char id3_latin1_t;//存储Latin-1编码的字符
    typedef uint16_t id3_utf16_t;//存储UTF-16编码的Unicode字符。
    typedef signed char id3_utf8_t;//存储UTF-8编码的字符


    //表示ID3标签的数据结构
    /*ID3标签是MP3和其他音频文件中常见的元数据格式，用于存储歌曲的信息，如标题、艺术家、专辑、年份等。*/
    struct id3_tag {
        //记录指向这个ID3标签的引用计数，在内存管理中，引用计数是一种跟踪和控制对象生命周期的机制。
        unsigned int refcount;
        //ID3标签的版本号
        unsigned int version;
        // 存储ID3标签的标志信息，这些标志可能指示标签的某些特殊属性或状态。
        int flags;
        //存储额外的扩展标志信息，这些标志可能包含一些非标准的或者特定应用程序的属性。
        int extendedflags;
        //指定对ID3标签的编辑限制，比如哪些类型的操作是被禁止的。
        int restrictions;
        //存储ID3标签的其他选项或配置信息
        int options;
        //在这个ID3标签中有多少个帧（ID3帧是ID3标签中的子结构，每个帧存储一类特定的元数据信息，如标题、艺术家等）。
        unsigned int nframes;
        //指向id3_frame结构体的指针的指针（即二级指针），它指向一个数组，该数组包含了所有ID3帧的指针
        struct id3_frame **frames;
        //ID3标签经过填充后的总大小。在某些情况下，ID3标签可能会被填充以满足特定的边界要求，例如为了使其大小成为某个字节数的倍数。
        id3_length_t paddedsize;
    };

    /*这些宏代表了ID3标签中不同字段和帧的标识符
     * 这些宏通常在处理ID3标签的代码中用于识别和操作不同的帧。
     * 例如，当从音频文件中读取ID3标签时，可以使用这些宏来查找和提取特定的元数据信息。
   */
    //这个宏定义了一个常量 10，它可能是用于查询ID3标签大小时的默认大小或其他相关用途
    # define ID3_TAG_QUERYSIZE	10

    /* ID3v1 field frames */

    //定义了标题帧的标识符，通常用于存储歌曲的标题。
    # define ID3_FRAME_TITLE	"TIT2"//替代词
    //定义了艺术家帧的标识符，用于存储歌曲的表演者或艺术家。
    # define ID3_FRAME_ARTIST	"TPE1"
    //定义了专辑帧的标识符，用于存储歌曲所属的专辑名称。
    # define ID3_FRAME_ALBUM	"TALB"
    //定义了音轨帧的标识符，用于存储歌曲在专辑中的音轨号码。
    # define ID3_FRAME_TRACK	"TRCK"
    //这个宏定义了年份帧的标识符，用于存储歌曲的发行年份。注意，这里的标识符是 "TDRC"，而不是通常的 "TYER"，这可能是因为代码作者选择了不同的命名约定或特定的实现。
    # define ID3_FRAME_YEAR		"TDRC"
    //这个宏定义了流派帧的标识符，用于存储歌曲的音乐流派。
    # define ID3_FRAME_GENRE	"TCON"
    //定义了评论帧的标识符，用于存储与歌曲相关的评论或注释。
    # define ID3_FRAME_COMMENT	"COMM"

    /* special frames */

    //定义了一个特殊的帧标识符，标记为已废弃的帧。注释中的“with apologies to the French”可能是对法国人的一种幽默或讽刺，但这与宏本身的功能没有直接关系。
    # define ID3_FRAME_OBSOLETE	"ZOBS"	/* with apologies to the French */


    /*定义了一系列枚举类型（enum），用于表示ID3标签的不同属性和限制。ID3标签是嵌入在MP3和其他音频文件中的元数据，用于存储关于音乐的信息，如标题、艺术家、专辑等
     如果这个标志位被设置（即其值为0x80）

     这些枚举值用于在处理ID3标签时设置和检查各种属性和限制。通过使用这些枚举，代码可以更加清晰和易于理解，同时也便于维护和更新。*/

    /* tag flags  标签标志*/

    enum {
        //表示标签是否包含未同步化的数据
        ID3_TAG_FLAG_UNSYNCHRONISATION     = 0x80,
        //表示是否存在扩展头部
        ID3_TAG_FLAG_EXTENDEDHEADER        = 0x40,
        //表示是否存在实验性指示符
        ID3_TAG_FLAG_EXPERIMENTALINDICATOR = 0x20,
        //表示是否存在尾部
        ID3_TAG_FLAG_FOOTERPRESENT         = 0x10,
        //表示已知的标签标志掩码。
        ID3_TAG_FLAG_KNOWNFLAGS            = 0xf0
    };

    /* tag extended flags 标签扩展标志*/

    enum {
        // 表示标签是否为更新
        ID3_TAG_EXTENDEDFLAG_TAGISANUPDATE   = 0x40,
        //表示是否存在CRC数据
        ID3_TAG_EXTENDEDFLAG_CRCDATAPRESENT  = 0x20,
        //表示是否存在标签限制
        ID3_TAG_EXTENDEDFLAG_TAGRESTRICTIONS = 0x10,
        //表示已知的扩展标志掩码
        ID3_TAG_EXTENDEDFLAG_KNOWNFLAGS      = 0x70
    };

    /* tag restrictions 标签限制*/

    enum {
        //表示标签大小的限制掩码。
        ID3_TAG_RESTRICTION_TAGSIZE_MASK             = 0xc0,
        //表示标签大小限制为128帧（1MB）。
        ID3_TAG_RESTRICTION_TAGSIZE_128_FRAMES_1_MB  = 0x00,
        //表示标签大小限制为64帧（128KB）。
        ID3_TAG_RESTRICTION_TAGSIZE_64_FRAMES_128_KB = 0x40,
        // 表示标签大小限制为32帧（40KB）。
        ID3_TAG_RESTRICTION_TAGSIZE_32_FRAMES_40_KB  = 0x80,
        //：表示标签大小限制为32帧（4KB）。
        ID3_TAG_RESTRICTION_TAGSIZE_32_FRAMES_4_KB   = 0xc0
    };

    enum {
        //表示文本编码的限制掩码。
        ID3_TAG_RESTRICTION_TEXTENCODING_MASK        = 0x20,
        //表示无文本编码限制。
        ID3_TAG_RESTRICTION_TEXTENCODING_NONE        = 0x00,
        //表示限制为Latin1或UTF-8编码。
        ID3_TAG_RESTRICTION_TEXTENCODING_LATIN1_UTF8 = 0x20
    };

    enum {
        //表示文本大小的限制掩码。
        ID3_TAG_RESTRICTION_TEXTSIZE_MASK            = 0x18,
        //表示无文本大小限制
        ID3_TAG_RESTRICTION_TEXTSIZE_NONE            = 0x00,
        //表示限制文本大小为1024个字符。
        ID3_TAG_RESTRICTION_TEXTSIZE_1024_CHARS      = 0x08,
        //表示限制文本大小为128个字符。
        ID3_TAG_RESTRICTION_TEXTSIZE_128_CHARS       = 0x10,
        //表示限制文本大小为30个字符。
        ID3_TAG_RESTRICTION_TEXTSIZE_30_CHARS        = 0x18
    };

    enum {
        //表示图像编码的限制掩码
        ID3_TAG_RESTRICTION_IMAGEENCODING_MASK       = 0x04,
        //表示无图像编码限制
        ID3_TAG_RESTRICTION_IMAGEENCODING_NONE       = 0x00,
        //表示限制为PNG或JPEG编码。
        ID3_TAG_RESTRICTION_IMAGEENCODING_PNG_JPEG   = 0x04
    };

    enum {
        //表示图像大小的限制掩码
        ID3_TAG_RESTRICTION_IMAGESIZE_MASK           = 0x03,
        //表示无图像大小限制。
        ID3_TAG_RESTRICTION_IMAGESIZE_NONE           = 0x00,
        //表示限制图像大小为256x256像素。
        ID3_TAG_RESTRICTION_IMAGESIZE_256_256        = 0x01,
        //表示限制图像大小为64x64像素。
        ID3_TAG_RESTRICTION_IMAGESIZE_64_64          = 0x02,
        //表示精确限制图像大小为64x64像素。
        ID3_TAG_RESTRICTION_IMAGESIZE_64_64_EXACT    = 0x03
    };

    /* library options库选项 */

    enum {
        //表示使用未同步化
        ID3_TAG_OPTION_UNSYNCHRONISATION = 0x0001,	/* use unsynchronisation */
        //表示使用压缩
        ID3_TAG_OPTION_COMPRESSION       = 0x0002,	/* use compression */
        //表示使用CRC校验
        ID3_TAG_OPTION_CRC               = 0x0004,	/* use CRC */
        //表示标签将被附加
        ID3_TAG_OPTION_APPENDEDTAG       = 0x0010,	/* tag will be appended */
        //表示音频数据已被更改。
        ID3_TAG_OPTION_FILEALTERED       = 0x0020,	/* audio data was altered */
        //表示渲染ID3v1或ID3v1.1标签
        ID3_TAG_OPTION_ID3V1             = 0x0100	/* render ID3v1/ID3v1.1 tag */
    };

    /*这个结构体用于在处理ID3标签时存储和管理单个帧的信息。通过使用这样的结构体，程序可以方便地访问和修改ID3帧的内容，同时保持代码的模块化和可维护性*/
    //表示ID3标签帧的数据结构，每个ID3标签由一个或多个帧组成，每个帧包含特定类型的信息。
    struct id3_frame {
        /*这是一个长度为5的字符数组，用于存储帧的标识符（ID）。ID3帧的ID通常是四个字符长，例如"TIT2"表示标题帧，但这里额外分配了一个字符的空间，可能是用于存储空终止符（null-terminator）*/
        char id[5];
        /*这是一个指向常量字符串的指针，用于描述该帧所代表的信息类型，例如"Title"、"Artist"等*/
        char const *description;
        /*这个变量用于记录有多少个地方引用了这个帧结构。在内存管理中，引用计数用于跟踪对象的引用数量，以决定何时可以释放内存*/
        unsigned int refcount;
        /*这是一个整数，用于存储帧的各种标志，如是否使用了未同步化（unsynchronization）、是否包含扩展数据等*/
        int flags;
        /*这个整数可能用于标识帧所属的组或类别，这在某些ID3标签的扩展或变体中可能有特殊意义*/
        int group_id;
        /*这个整数可能用于指示帧中数据使用的加密方法，尽管ID3规范本身不包含加密机制。*/
        int encryption_method;
        /*这是一个指向id3_byte_t类型的指针，用于存储帧的编码后数据。id3_byte_t可能是一个简单的字节类型或具有特定含义的类型。*/
        // typedef unsigned char id3_byte_t;//单个字节
        id3_byte_t *encoded;
        /*这是一个用于存储编码后数据长度的变量。id3_length_t可能是一个特定于ID3标签处理库的无符号整数类型。
         */
        id3_length_t encoded_length;
        /*这是一个用于存储解码后数据长度的变量。这个长度是在数据被解码成人类可读格式后的长度*/
        id3_length_t decoded_length;
        /*这个变量用于记录该帧中包含的字段（fields）的数量。
         *
         */
        unsigned int nfields;
        /*这是一个指向联合类型id3_field的指针，用于存储帧中的各个字段。联合（union）是一种节省内存的数据结构，其中所有成员共享相同的内存空间。在这个联合中，可能包含了不同类型的字段，如字符串、整数等。*/
        union id3_field *fields;
    };

    /*定义了几个枚举类型（enum）和一个联合类型（union），它们用于处理和表示ID3标签的不同方面*/

    /*这些枚举和联合类型通常用于ID3标签处理库中，以便于处理和操作ID3标签的各个部分。通过使用这些定义，程序可以轻松地读取、写入和修改ID3标签中的数据，同时保持代码的一致性和可维护性。例如，联合id3_field可以用来表示ID3帧中的不同类型的字段，而enum id3_file_mode可以用来指定如何打开一个包含ID3标签的音频文件。*/

    enum {
        /* frame status flags 帧状态和格式标志 */
        /*ID3_FRAME_FLAG_*：这些枚举值定义了ID3帧的各种标志，包括状态标志和格式标志。
         状态标志如ID3_FRAME_FLAG_TAGALTERPRESERVATION和ID3_FRAME_FLAG_FILEALTERPRESERVATION,
         用于指示帧是否应该在标签或文件更改时保持不变。格式标志如ID3_FRAME_FLAG_COMPRESSION和ID3_FRAME_FLAG_ENCRYPTION，
         用于指示帧数据的处理方式，比如是否压缩或加密*/
        ID3_FRAME_FLAG_TAGALTERPRESERVATION	= 0x4000,
        ID3_FRAME_FLAG_FILEALTERPRESERVATION	= 0x2000,
        ID3_FRAME_FLAG_READONLY		= 0x1000,

        ID3_FRAME_FLAG_STATUSFLAGS            = 0xff00,

        /* frame format flags */
        ID3_FRAME_FLAG_GROUPINGIDENTITY	= 0x0040,
        ID3_FRAME_FLAG_COMPRESSION		= 0x0008,
        ID3_FRAME_FLAG_ENCRYPTION		= 0x0004,
        ID3_FRAME_FLAG_UNSYNCHRONISATION	= 0x0002,
        ID3_FRAME_FLAG_DATALENGTHINDICATOR	= 0x0001,

        ID3_FRAME_FLAG_FORMATFLAGS            = 0x00ff,

        ID3_FRAME_FLAG_KNOWNFLAGS             = 0x704f
    };

    //字段类型
    /*这个枚举定义了ID3帧中可能出现的不同类型的字段，包括文本编码、字符串、整数、二进制数据等*/
    enum id3_field_type {
        ID3_FIELD_TYPE_TEXTENCODING,
        ID3_FIELD_TYPE_LATIN1,
        ID3_FIELD_TYPE_LATIN1FULL,
        ID3_FIELD_TYPE_LATIN1LIST,
        ID3_FIELD_TYPE_STRING,
        ID3_FIELD_TYPE_STRINGFULL,
        ID3_FIELD_TYPE_STRINGLIST,
        ID3_FIELD_TYPE_LANGUAGE,
        ID3_FIELD_TYPE_FRAMEID,
        ID3_FIELD_TYPE_DATE,
        ID3_FIELD_TYPE_INT8,
        ID3_FIELD_TYPE_INT16,
        ID3_FIELD_TYPE_INT24,
        ID3_FIELD_TYPE_INT32,
        ID3_FIELD_TYPE_INT32PLUS,
        ID3_FIELD_TYPE_BINARYDATA
    };

    //字段文本编码
    /*这个枚举定义了文本字段可能使用的编码方式，如ISO-8859-1、UTF-16、UTF-16BE、UTF-8等。*/
    enum id3_field_textencoding {
        ID3_FIELD_TEXTENCODING_ISO_8859_1 = 0x00,
        ID3_FIELD_TEXTENCODING_UTF_16     = 0x01,
        ID3_FIELD_TEXTENCODING_UTF_16BE   = 0x02,
        ID3_FIELD_TEXTENCODING_UTF_8      = 0x03
    };

    //联合字段
    /*这个联合类型定义了一个通用的字段结构，可以容纳不同类型的数据。联合中的每个结构体对应于不同的字段类型，
     *如整数、字符串、二进制数据等。这种设计允许一个联合实例根据其type成员存储不同类型的数据，从而节省内存并提高灵活性*/
    union id3_field {
        enum id3_field_type type;
        struct {
            enum id3_field_type type;
            signed long value;
        } number;
        struct {
            enum id3_field_type type;
            id3_latin1_t *ptr;
        } latin1;
        struct {
            enum id3_field_type type;
            unsigned int nstrings;
            id3_latin1_t **strings;
        } latin1list;
        struct {
            enum id3_field_type type;
            id3_ucs4_t *ptr;
        } string;
        struct {
            enum id3_field_type type;
            unsigned int nstrings;
            id3_ucs4_t **strings;
        } stringlist;
        struct {
            enum id3_field_type type;
            char value[9];
        } immediate;
        struct {
            enum id3_field_type type;
            id3_byte_t *data;
            id3_length_t length;
        } binary;
    };

    /* file interface 文件模式*/
    /*这个枚举定义了打开ID3文件时的两种模式，只读（ID3_FILE_MODE_READONLY）和读写（ID3_FILE_MODE_READWRITE）*/
    enum id3_file_mode {
        ID3_FILE_MODE_READONLY = 0,
        ID3_FILE_MODE_READWRITE
    };

    //打开ID3标签
    struct id3_file *id3_file_open(char const *, enum id3_file_mode);
    /*
     *    功能：这个函数用于打开一个包含ID3标签的音频文件。它接受两个参数：一个指向文件路径的字符串常量和一个enum id3_file_mode枚举值，指定文件的打开模式（只读或读写）。函数返回一个指向struct id3_file的指针，该结构体包含了与文件相关的所有信息，包括ID3标签数据。
     *    参数：
     *        char const *：文件路径。
     *        enum id3_file_mode：文件打开模式。
     *    返回值：成功时返回一个指向struct id3_file的指针，失败时可能返回NULL。
     */

    struct id3_file *id3_file_fdopen(int, enum id3_file_mode);
    /*
     *    功能：这个函数类似于id3_file_open，但它不是通过文件路径打开文件，而是通过文件描述符（file descriptor）打开文件。这在文件已经被另一个函数打开并获得了文件描述符时非常有用。
     *    参数：
     *        int：文件描述符。
     *        enum id3_file_mode：文件打开模式。
     *    返回值：成功时返回一个指向struct id3_file的指针，失败时可能返回NULL。
     */



    //关闭ID3标签
    int id3_file_close(struct id3_file *);
    /*
     *    功能：这个函数用于关闭之前通过id3_file_open或id3_file_fdopen打开的文件。它接受一个指向struct id3_file的指针作为参数，该指针是在打开文件时获得的。
     *    参数：
     *        struct id3_file *：之前打开的文件结构体的指针。
     *    返回值：成功时返回0，失败时返回非零值。
     */




    struct id3_tag *id3_file_tag(struct id3_file const *);
    /*
     *    功能：这个函数用于从打开的文件中获取ID3标签信息。它接受一个指向struct id3_file的常量指针作为参数，该指针是在打开文件时获得的。函数返回一个指向struct id3_tag的指针，该结构体包含了文件中的ID3标签信息。
     *    参数：
     *        struct id3_file const *：之前打开的文件结构体的常量指针。
     *    返回值：成功时返回一个指向struct id3_tag的指针，失败时可能返回NULL。
     */



    int id3_file_update(struct id3_file *);
    /*
     *    功能：这个函数用于更新文件中的ID3标签信息。它接受一个指向struct id3_file的指针作为参数，该指针是在打开文件时获得的。函数会将所有对ID3标签的更改保存回文件中。
     *    参数：
     *        struct id3_file *：之前打开的文件结构体的指针。
     *    返回值：成功时返回0，失败时返回非零值。
     */



    /*以上提供了对ID3标签的基本读写操作，使得应用程序可以方便地管理和修改音频文件中的元数据*/






    /* tag interface */

    struct id3_tag *id3_tag_new(void);
    /*函数的作用是创建一个新的空ID3标签结构体。这个结构体通常用于存储音乐文件中的元数据，例如歌曲标题、艺术家、专辑名称等信息。
     *当你需要处理或修改音乐文件的ID3标签时，你首先需要一个空的ID3标签结构体来开始。这个函数返回一个指向新创建的struct id3_tag的指针，
     * 你可以使用这个指针来访问和修改标签中的数据。*/


    void id3_tag_delete(struct id3_tag *);
    /*这个函数的作用是删除一个ID3标签结构体，释放其占用的资源。当您不再需要一个ID3标签结构体时，应该调用这个函数来清理它所占用的内存。*/


    unsigned int id3_tag_version(struct id3_tag const *);
    /*这个函数的作用是获取一个ID3标签的版本号。ID3标签有不同的版本，如ID3v1、ID3v2等，这个函数允许您检查一个特定的ID3标签结构体是哪个版本的。
     *它接受一个指向struct id3_tag的常量指针作为参数，并返回一个表示版本号的无符号整数。*/


    int id3_tag_options(struct id3_tag *, int, int);
    /*这个函数的作用是设置或获取ID3标签的选项。id3_tag_options函数接受一个指向struct id3_tag的指针作为第一个参数，
     *第二个参数是一个掩码，用来指定哪些选项可以被设置或查询，第三个参数是一个整数值，用来设置或获取选项的具体值。
     * 这个函数可以用来启用或禁用某些特定的标签处理特性，例如压缩、加密等。*/

    void id3_tag_setlength(struct id3_tag *, id3_length_t);
    /*这个函数的作用是设置ID3标签的最小渲染长度。id3_tag_setlength函数接受一个指向struct id3_tag的指针作为第一个参数，
     *第二个参数是一个id3_length_t类型的值，用来指定标签的最小渲染长度。
     * 这个长度指的是标签在渲染时至少需要保留的空间大小，以保证标签的完整性和可读性。*/

    void id3_tag_clearframes(struct id3_tag *);
    /*这个函数的作用是清除与ID3标签关联的所有帧。id3_tag_clearframes函数接受一个指向struct id3_tag的指针作为参数，
     *它会移除所有附加到该标签的帧，并释放这些帧占用的资源。这个函数通常在需要重新构建或更新标签时使用，以便从标签中移除不再需要的信息。*/


    int id3_tag_attachframe(struct id3_tag *, struct id3_frame *);
    /*这个函数的作用是将一个ID3帧附加到ID3标签上。id3_tag_attachframe接受两个参数：一个指向struct id3_tag的指针，
     *表示要添加帧的标签；一个指向struct id3_frame的指针，表示要添加的帧。如果帧成功附加到标签上，函数返回0，否则返回一个非零值*/


    int id3_tag_detachframe(struct id3_tag *, struct id3_frame *);
    /*这个函数的作用是从ID3标签上移除一个指定的ID3帧。id3_tag_detachframe同样接受两个参数：一个指向struct id3_tag的指针，
     *表示包含帧的标签；一个指向struct id3_frame的指针，表示要移除的帧。如果帧成功从标签上移除，函数返回0，否则返回一个非零值。*/

    struct id3_frame *id3_tag_findframe(struct id3_tag const *,
                                        char const *, unsigned int);
    /*这个函数的作用是在ID3标签中查找一个具有特定标识符的ID3帧。id3_tag_findframe接受三个参数：一
     *个指向struct id3_tag的常量指针，表示要搜索的标签；一个指向标识符字符串的常量指针；一个无符号整数，表示标识符字符串的长度。
     * 函数返回找到的帧的指针，如果没有找到匹配的帧，则返回NULL。*/

    signed long id3_tag_query(id3_byte_t const *, id3_length_t);
    /*这个函数的作用是查询ID3标签中的数据。id3_tag_query接受两个参数：
     *一个指向字节数据的常量指针；一个表示数据长度的id3_length_t类型值
     * 。函数返回查询结果的带符号长整型数值。*/

    struct id3_tag *id3_tag_parse(id3_byte_t const *, id3_length_t);
    /*这个函数的作用是解析ID3标签数据。id3_tag_parse接受两个参数：一个指向字节数据的常量指针；
     *一个表示数据长度的id3_length_t类型值。函数返回解析后的ID3标签结构体的指针。*/


    id3_length_t id3_tag_render(struct id3_tag const *, id3_byte_t *);
    /*这个函数的作用是将ID3标签渲染成字节序列。id3_tag_render接受两个参数：一个指向ID3标签的常量指针；一个指向目标缓冲区的指针。函数返回渲染后的字节序列的长度。*/

    /* frame interface */

    struct id3_frame *id3_frame_new(char const *);
    /*这个函数的作用是创建一个新的ID3帧结构体。id3_frame_new接受一个指向标识符字符串的常量指针作为参数，并返回一个指向新创建的struct id3_frame的指针*/


    void id3_frame_delete(struct id3_frame *);
    /*这个函数的作用是删除一个ID3帧结构体，释放其占用的资源。id3_frame_delete接受一个指向struct id3_frame的指针作为参数。*/

    union id3_field *id3_frame_field(struct id3_frame const *, unsigned int);
    /*这个函数的作用是从ID3帧中获取一个字段。id3_frame_field接受两个参数：一个指向struct id3_frame的常量指针，表示包含字段的帧；
     *一个无符号整数，表示字段的索引。函数返回指向该字段的联合体union id3_field的指针。*/


    /* field interface */


    /*这些函数允许应用程序向 ID3 标签中的字段设置各种类型的数据，包括文本、语言代码、整数和二进制数据。通过这些函数，
     *你可以自定义和更新 ID3 标签的内容，以反映音频文件的元数据信息。*/
    enum id3_field_type id3_field_type(union id3_field const *);
    /*这个函数的作用是获取一个ID3字段的类型。id3_field_type接受一个指向union id3_field的常量指针作为参数，
     *并返回一个enum id3_field_type类型的值，表示字段的类型。这个类型可以是文本、二进制数据、数字等。*/
    int id3_field_setint(union id3_field *, signed long);
    //此函数用于将一个有符号的 32 位整数值设置到字段中。
    int id3_field_settextencoding(union id3_field *, enum id3_field_textencoding);
    //此函数用于设置字段的文本编码格式，例如 UTF-16、UTF-8 等。
    int id3_field_setstrings(union id3_field *, unsigned int, id3_ucs4_t **);
    //此函数用于将一个或多个字符串设置到字段中。它接受一个字符串数组和一个字符串数量。
    int id3_field_addstring(union id3_field *, id3_ucs4_t const *);
    //此函数用于向已经包含字符串的字段中添加一个新字符串。
    int id3_field_setlanguage(union id3_field *, char const *);
    //此函数用于设置字段的语言代码。
    int id3_field_setlatin1(union id3_field *, id3_latin1_t const *);
    //此函数用于将一个以 Latin-1 编码的字符串设置到字段中
    int id3_field_setfulllatin1(union id3_field *, id3_latin1_t const *);
    //此函数与 id3_field_setlatin1 类似，用于设置以 Latin-1 编码的字符串，但它接受一个完整的字符串数组。
    int id3_field_setstring(union id3_field *, id3_ucs4_t const *);
    //此函数用于将一个以 UTF-16 编码的字符串设置到字段中。
    int id3_field_setfullstring(union id3_field *, id3_ucs4_t const *);
    //此函数与 id3_field_setstring 类似，用于设置以 UTF-16 编码的字符串，但它接受一个完整的字符串数组。
    int id3_field_setframeid(union id3_field *, char const *);
    //此函数用于设置字段的帧 ID。
    int id3_field_setbinarydata(union id3_field *,
                                id3_byte_t const *, id3_length_t);
    //此函数用于将一个二进制数据块设置到字段中




    /*这些函数允许应用程序从 ID3 标签中的字段读取各种类型的数据，包括文本、语言代码、整数和二进制数据。通过这些函数，你可以访问和解析 ID3 标签中的元数据信息。*/
    signed long id3_field_getint(union id3_field const *);
    //此函数用于从字段中获取一个有符号的 32 位整数值。
    enum id3_field_textencoding id3_field_gettextencoding(union id3_field const *);
    //此函数用于获取字段的文本编码格式，例如 UTF-16、UTF-8 等。
    id3_latin1_t const *id3_field_getlatin1(union id3_field const *);
    //此函数用于获取以 Latin-1 编码的字符串，如果字段中存储了这样的字符串
    id3_latin1_t const *id3_field_getfulllatin1(union id3_field const *);
    //此函数与 id3_field_getlatin1 类似，但它返回一个完整的字符串数组，而不是单个字符串。
    id3_ucs4_t const *id3_field_getstring(union id3_field const *);
    //此函数用于获取以 UTF-16 编码的字符串，如果字段中存储了这样的字符串。
    id3_ucs4_t const *id3_field_getfullstring(union id3_field const *);
    //此函数与 id3_field_getstring 类似，但它返回一个完整的字符串数组，而不是单个字符串。
    unsigned int id3_field_getnstrings(union id3_field const *);
    //此函数用于获取字段中字符串的数量，如果字段包含多个字符串。
    id3_ucs4_t const *id3_field_getstrings(union id3_field const *,
                                           unsigned int);
    //此函数用于获取字段中指定索引的字符串，如果字段包含多个字符串
    char const *id3_field_getframeid(union id3_field const *);
    //此函数用于获取字段的帧 ID。
    id3_byte_t const *id3_field_getbinarydata(union id3_field const *,
                                              id3_length_t *);
   //此函数用于获取字段中的二进制数据块，并返回数据块的指针和长度。




    /*这些函数允许应用程序在处理 Unicode 字符串和数字时进行编码转换和格式化操作。通过这些函数，你可以方便地在不同编码之间转换字符串，以及将数字转换为字符串表示形式。*/
    /* genre interface */

    id3_ucs4_t const *id3_genre_index(unsigned int);
    /**此函数用于通过 genre 编号查找对应的 genre 名称。它返回一个指向 Unicode 字符串的指针，该字符串包含了对应编号的 genre 名称。*/
    id3_ucs4_t const *id3_genre_name(id3_ucs4_t const *);
    /*此函数用于通过 genre 名称查找对应的 genre 编号。它返回一个指向 Unicode 字符串的指针，该字符串包含了对应名称的 genre 编号*/
    int id3_genre_number(id3_ucs4_t const *);
    /*此函数用于获取 genre 名称对应的 genre 编号。它返回一个整数值，表示给定 genre 名称的编号。*/

    /* ucs4 interface */

    id3_latin1_t *id3_ucs4_latin1duplicate(id3_ucs4_t const *);
    /*此函数用于将 Unicode 字符串转换为 Latin-1 字符串。它返回一个指向 Latin-1 字符串的指针，该字符串是输入 Unicode 字符串的 Latin-1 编码版本*/
    id3_utf16_t *id3_ucs4_utf16duplicate(id3_ucs4_t const *);
    /*此函数用于将 Unicode 字符串转换为 UTF-16 字符串。它返回一个指向 UTF-16 字符串的指针，该字符串是输入 Unicode 字符串的 UTF-16 编码版本。*/
    id3_utf8_t *id3_ucs4_utf8duplicate(id3_ucs4_t const *);
    /*此函数用于将 Unicode 字符串转换为 UTF-8 字符串。它返回一个指向 UTF-8 字符串的指针，该字符串是输入 Unicode 字符串的 UTF-8 编码版本*/

    void id3_ucs4_putnumber(id3_ucs4_t *, unsigned long);
    /*此函数用于将一个无符号长整数值转换为 Unicode 字符串。它接受一个指向 Unicode 字符串的指针和一个无符号长整数值，并将其转换为字符串形式*/
    unsigned long id3_ucs4_getnumber(id3_ucs4_t const *);
    /*此函数用于从 Unicode 字符串中获取一个无符号长整数值。它接受一个指向 Unicode 字符串的指针，并将其转换为一个无符号长整数值*/


    /* latin1/utf16/utf8 interfaces */

    id3_ucs4_t *id3_latin1_ucs4duplicate(id3_latin1_t const *);
    /*此函数用于将 Latin-1 字符串转换为 Unicode 字符串。它返回一个指向 Unicode 字符串的指针，该字符串是输入 Latin-1 字符串的 Unicode 编码版本。*/
    id3_ucs4_t *id3_utf16_ucs4duplicate(id3_utf16_t const *);
    /*此函数用于将 UTF-16 字符串转换为 Unicode 字符串。它返回一个指向 Unicode 字符串的指针，该字符串是输入 UTF-16 字符串的 Unicode 编码版本。*/
    id3_ucs4_t *id3_utf8_ucs4duplicate(id3_utf8_t const *);
    /*此函数用于将 UTF-8 字符串转换为 Unicode 字符串。它返回一个指向 Unicode 字符串的指针，该字符串是输入 UTF-8 字符串的 Unicode 编码版本*/

    /* version interface */

    # define ID3_VERSION_MAJOR	0
    # define ID3_VERSION_MINOR	16
    # define ID3_VERSION_PATCH	3
    # define ID3_VERSION_EXTRA	""

    # define ID3_VERSION_STRINGIZE(str)	#str
    # define ID3_VERSION_STRING(num)	ID3_VERSION_STRINGIZE(num)

    # define ID3_VERSION	ID3_VERSION_STRING(ID3_VERSION_MAJOR) "."  \
    ID3_VERSION_STRING(ID3_VERSION_MINOR) "."  \
    ID3_VERSION_STRING(ID3_VERSION_PATCH)  \
    ID3_VERSION_EXTRA

    # define ID3_PUBLISHYEAR	"2000-2004"
    # define ID3_AUTHOR		"Underbit Technologies, Inc."
    # define ID3_EMAIL		"info@underbit.com"

    extern char const id3_version[];
    extern char const id3_copyright[];//版权
    extern char const id3_author[];
    extern char const id3_build[];

    # ifdef __cplusplus
}
# endif

# endif

