// The most basic web server: it answers "Hello, World!" to every request.
const http = require("http");

http
  .createServer((req, res) => {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("Hello, World! (from inside a Docker container)\n");
  })
  .listen(3000, () => console.log("Listening on port 3000"));
