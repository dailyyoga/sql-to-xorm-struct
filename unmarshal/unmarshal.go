package unmarshal

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"
	"time"

	"github.com/dailyyoga/sql-to-xorm-struct/table"
	"github.com/goroom/logger"
)

func UnmarshalFile(sqlFilePath string, packageName string) error {
	f, err := os.Open(sqlFilePath)
	if err != nil {
		return err
	}
	defer f.Close()

	buff := bufio.NewReader(f)

	baseTable := table.Table{
		Package:       packageName,
		Comment:       "// " + time.Now().Format("2006-01-02") + " create this file.",
		StructComment: "...",
	}

	t := baseTable
	for {
		line, err := buff.ReadString('\n')
		if err != nil {
			if err != io.EOF {
				return err
			}
			break
		}
		if len(line) <= 0 {
			continue
		}
		if line[0] == '#' || line[0] == '/' || line[0] == '\n' {
			continue
		}
		t.Sql += "// " + line

		if strings.HasPrefix(line, "CREATE TABLE") {
			line = line[len("CREATE TABLE `"):]
			t.TableName = line[:(len(line) - len("`(\n") - 1)]
			t.StructName = t.UnderlineToHump(t.TableName)
			continue
		}

		if strings.HasPrefix(line, "  `") {
			err := t.UnmarshalColumn(line)
			if err != nil {
				return fmt.Errorf("行解析失败,[%s],[%s],[%s]", err.Error(), t, line)
			}
			continue
		}

		if strings.HasPrefix(line, ")") {
			if strings.Index(line, "COMMENT") > 0 {
				_comment := line[strings.Index(line, "COMMENT")+9:]
				t.StructComment = _comment[:strings.Index(_comment, "'")]
			}

			//保存
			filePath := "./databases/" + packageName
			err = os.MkdirAll(filePath, os.ModePerm)
			if err != nil {
				return err
			}
			f2, err := os.OpenFile(filePath+"/"+t.TableName+".go", os.O_CREATE|os.O_RDWR|os.O_TRUNC, 0666)
			if err != nil {
				return err
			}
			f2.Write([]byte(t.String()))
			f2.Close()
			logger.Debug("保存结构体", t.TableName)

			t = baseTable
			continue
		}
	}

	return nil
}
