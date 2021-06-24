package main

import (
   "net/http"
   "fmt"
   "time"
   "html"
   "log"
)

var body = `
<html>
<head><title>Hello, world!</title></head>

<body style="background-color:%s;">
<h1>Hello, World</h1>

<p>
   The time is <b>%s</b>.
</p>
</body>
</html>`




//Go application entrypoint
func main() {

   http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
      fmt.Fprintf(w, body, "powderblue", html.EscapeString( time.Now().Format(time.Stamp) ))
   })

   fmt.Println("Listening on :8080");
   log.Fatal( fmt.Println(http.ListenAndServe(":8080", nil)) );
}