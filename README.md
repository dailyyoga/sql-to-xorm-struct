# sql-to-xorm-struct

将sql文件解析为xorm的结构体

例：
``` sql
CREATE TABLE `action` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uic` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `url` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `callback` tinyint(4) NOT NULL DEFAULT '0',
  `before_callback_sms` tinyint(4) NOT NULL DEFAULT '0',
  `before_callback_mail` tinyint(4) NOT NULL DEFAULT '0',
  `after_callback_sms` tinyint(4) NOT NULL DEFAULT '0',
  `after_callback_mail` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
```
转为
action.go
```go
// 2017-10-12 create this file.

// CREATE TABLE `action` (
//   `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
//   `uic` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
//   `url` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
//   `callback` tinyint(4) NOT NULL DEFAULT '0',
//   `before_callback_sms` tinyint(4) NOT NULL DEFAULT '0',
//   `before_callback_mail` tinyint(4) NOT NULL DEFAULT '0',
//   `after_callback_sms` tinyint(4) NOT NULL DEFAULT '0',
//   `after_callback_mail` tinyint(4) NOT NULL DEFAULT '0',
//   PRIMARY KEY (`id`)
// ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

package falcon_portal

//Action ...
type Action struct{
    Id int `xorm:"int(10) notnull pk autoincr 'id'" json:"id"` // 
    Uic string `xorm:"varchar(255) COLLATE utf8_unicode_ci notnull default '' 'uic'" json:"uic"` // 
    Url string `xorm:"varchar(255) COLLATE utf8_unicode_ci notnull default '' 'url'" json:"url"` // 
    Callback int `xorm:"tinyint(4) notnull default 0 'callback'" json:"callback"` // 
    BeforeCallbackSms int `xorm:"tinyint(4) notnull default 0 'before_callback_sms'" json:"before_callback_sms"` // 
    BeforeCallbackMail int `xorm:"tinyint(4) notnull default 0 'before_callback_mail'" json:"before_callback_mail"` // 
    AfterCallbackSms int `xorm:"tinyint(4) notnull default 0 'after_callback_sms'" json:"after_callback_sms"` // 
    AfterCallbackMail int `xorm:"tinyint(4) notnull default 0 'after_callback_mail'" json:"after_callback_mail"` // 
}

//TableName Get table name
func (t *Action)TableName()string{
	return "action"
}
```

遗留问题：
1、SQL语法中的COMMENT在xorm中不支持，xorm开发者说是支持的，但是代码中也没见相关处理。  
2、转换后的文件未经格式化，有点乱。  
3、可能还有未支持的数据类型。  
4、struct的json tag用了表的列名，但表的列明格式不一定统一，是否要全部转换为下划线格式。  
5、暂未支持UNIQUE KEY、外键。  
