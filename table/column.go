package table

import (
	"fmt"
	"strings"
)

type Column struct {
	StructField string   //结构体字段名
	StructType  string   //结构体字段类型
	ColumnType  string   //列类型
	OtherTag    []string //其他tag
	ColumnName  string   //表列名
	JsonName    string
	Comment     string
}

func (c *Column) String() string {
	return fmt.Sprintf("    %s %s `xorm:\"%s %s '%s'\" json:\"%s\"` // %s\n",
		c.StructField,
		c.StructType,
		c.ColumnType,
		strings.Join(c.OtherTag, " "),
		c.ColumnName,
		c.JsonName,
		c.Comment)
}
