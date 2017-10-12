# sql-to-xorm-struct

输入 sql文件，解析为struct

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