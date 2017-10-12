package table

import (
	"fmt"
	"strconv"
	"strings"
)

type Table struct {
	Comment       string
	Sql           string
	Package       string
	Import        []string
	StructComment string
	StructName    string
	Columns       []*Column
	TableName     string
}

func (t *Table) String() string {
	return fmt.Sprintf(`%s

%s
package %s
%s
//%s %s
type %s struct{
%s}

//TableName Get table name
func (t *%s)TableName()string{
	return "%s"
}
`, t.Comment, t.Sql, t.Package, t.ImportString(), t.StructName, t.StructComment,
		t.StructName, t.ColumnsString(), t.StructName, t.TableName)
}

func (t *Table) ImportString() string {
	if len(t.Import) <= 0 {
		return ""
	}
	return fmt.Sprintf("\nimport(\n    \"%s\"\n)\n", strings.Join(t.Import, "\n    "))
}

func (t *Table) ColumnsString() string {
	if len(t.Columns) <= 0 {
		return ""
	}
	str := ""
	for i := 0; i < len(t.Columns); i++ {
		str += t.Columns[i].String()
	}
	return str
}

func (t *Table) HasField(field string) bool {
	for i := 0; i < len(t.Columns); i++ {
		if t.Columns[i].StructField == field {
			return true
		}
	}
	return false
}

func (t *Table) HasImport(_import string) bool {
	for i := 0; i < len(t.Import); i++ {
		if t.Import[i] == _import {
			return true
		}
	}
	return false
}

func (t *Table) AddImport(i string) {
	if !t.HasImport(i) {
		t.Import = append(t.Import, i)
	}
}

func (t *Table) AddColumn(c *Column) {
	//logger.Debug(c.StructField)
	if t.HasField(c.StructField) {
		for i := 2; ; i++ {
			_structName := c.StructField + strconv.Itoa(i)
			if !t.HasField(_structName) {
				//logger.Warn("重复的字段名", t.Package, t.TableName, c.StructField, "=>", _structName)
				c.StructField = _structName
				break
			}
		}
	}

	t.Columns = append(t.Columns, c)
}

func (t *Table) UnderlineToHump(s string) string {
	s = strings.Replace(s, "_", " ", -1)
	s = strings.Title(s)
	s = strings.Replace(s, " ", "", -1)
	return s
}

func (t *Table) UnmarshalColumn(line string) (err error) {
	line = strings.TrimSpace(line)
	if line[0] != '`' {
		err = fmt.Errorf("错误的行开头")
		return
	}
	if line[len(line)-1] == ',' {
		line = line[:len(line)-1]
	}

	column := &Column{}

	//注释
	if strings.Index(line, "COMMENT") > 0 {
		_comment := line[strings.Index(line, "COMMENT")+9:]
		column.Comment = _comment[:strings.Index(_comment, "'")]

		line = line[:strings.Index(line, "COMMENT")-1]
	}

	//列名
	column.ColumnName = line[1 : strings.Index(line, " ")-1]
	line = line[len(column.ColumnName)+3:]
	//结构体字段名
	column.StructField = t.UnderlineToHump(column.ColumnName)
	//json名？
	column.JsonName = column.ColumnName

	//列类型
	switch {
	case strings.HasPrefix(line, "datetime"),
		strings.HasPrefix(line, "date"),
		strings.HasPrefix(line, "timestamp"):
		column.StructType = "time.Time"
		t.AddImport("time")
	case strings.HasPrefix(line, "bigint"):
		column.StructType = "int64"
	case strings.HasPrefix(line, "int"),
		strings.HasPrefix(line, "tinyint"),
		strings.HasPrefix(line, "smallint"):
		column.StructType = "int"
	case strings.HasPrefix(line, "varchar"),
		strings.HasPrefix(line, "longtext"),
		strings.HasPrefix(line, "text"),
		strings.HasPrefix(line, "char"),
		strings.HasPrefix(line, "enum"),
		strings.HasPrefix(line, "mediumtext"):
		column.StructType = "string"
	case strings.HasPrefix(line, "decimal"),
		strings.HasPrefix(line, "float"),
		strings.HasPrefix(line, "double"):
		column.StructType = "float32"
	default:
		return fmt.Errorf("未知类型")
	}

	if strings.Index(line, " ") > 0 {
		column.ColumnType = line[:strings.Index(line, " ")]
	} else {
		column.ColumnType = line
	}
	if column.ColumnType == "" {
		return fmt.Errorf("未找到类型")
	}
	if len(line) > len(column.ColumnType) {
		line = line[len(column.ColumnType)+1:]
	} else {
		line = ""
	}

	if len(line) > 0 {
		columnSp := strings.Split(line, " ")
		for i := 0; i < len(columnSp); i++ {
			switch columnSp[i] {
			case "NOT":
				column.OtherTag = append(column.OtherTag, "notnull")
				i++
			case "DEFAULT":
				value := columnSp[i+1]
				if value[0] == '\'' && (column.StructType == "int" || column.StructType == "int64" || column.StructType == "float32") {
					value = value[1 : len(value)-1]
				}
				column.OtherTag = append(column.OtherTag, "default "+value)
				i++
			case "AUTO_INCREMENT":
				column.OtherTag = append(column.OtherTag, "pk autoincr")
			case "COLLATE":
				column.OtherTag = append(column.OtherTag, "COLLATE "+columnSp[i+1])
				i++
			case "unsigned":
			case "CHARACTER":
				column.OtherTag = append(column.OtherTag, "CHARACTER SET "+columnSp[i+2])
				i += 2
			case "ON":
				column.OtherTag = append(column.OtherTag, "ON "+columnSp[i+1]+" "+columnSp[i+2])
				i += 2
			default:
				err = fmt.Errorf("未知[%s]", columnSp[i])
				return
			}
		}
	}

	t.AddColumn(column)
	return
}
