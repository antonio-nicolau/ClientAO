String defaultNodejsHttpImportAndOptionsTemplate = """const http = require("https");

const options = {
  method: '{{method}}',
  hostname: '{{hostname}}',
  port: null,

""";

String defaultNodejsHttpPathTemplate = """
  path: '{{path}}'
""";

String defaultNodejsHttpHeadersTemplate = """,
  headers: {{headers}}
};
""";

String defaultNodejsHttpEmptyHeadersTemplate = """
}
""";

String defaultNodejsHttpBodyTemplate = """


req.write(JSON.stringify({{body}}));
""";

String defaultNodejsHttpStringResponseResult = r"""
    

const req = http.request(options, function (res) {
  const chunks = [];

  res.on('data', function (chunk) {
    chunks.push(chunk);
  });

  res.on('end', function () {
    const body = Buffer.concat(chunks);
    console.log(body.toString());
  });
});
""";

String defaultNodejsHttpRequestEnd = r"""


req.end();
""";
