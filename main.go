package main

import (
	"github.com/dailyyoga/sql-to-xorm-struct/unmarshal"
	"github.com/goroom/logger"
)

func main() {
	err := unmarshal.UnmarshalFile("./test.sql", "falcon_portal")
	if err != nil {
		logger.Error(err)
		return
	}
}
