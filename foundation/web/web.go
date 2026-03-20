// Package web provides a small web framework extension
package web

import (
	"context"
	"net/http"
)

type Encoder interface {
	Encoder() (data []byte, contentType string, er error)
}

type HandleFunc func(ctx context.Context, r *http.Request) Encoder
