String defaultNodejsAxiosImportAndOptionsTemplate = """
var axios = require("axios").default;

const options = {
  method: '{{method}}',
  url: '{{url}}'
""";

String defaultNodejsAxiosPathTemplate = """,
  params: {{params}}
""";

String defaultNodejsAxiosHeadersTemplate = """,
  headers: {{headers}}
};
""";

String defaultNodejsAxiosEmptyHeadersTemplate = """
}
""";

String defaultNodejsAxiosBodyTemplate = """,
  data: {{data}}
""";

String defaultNodejsAxiosStringResponseResult = r"""
    

axios.request(options).then(function (response) {
  console.log(response.data);
}).catch(function (error) {
  console.error(error);
});
""";
