#
# (C) Tenable Network Security
#


include("compat.inc");

if (description) {
  script_id(20996);
  script_version("$Revision: 1.8 $");

  script_cve_id("CVE-2006-0995");
  script_bugtraq_id(16933);
  script_xref(name:"OSVDB", value:"23613");

  script_name(english:"Retrospect Client Malformed Packet DoS");
  script_summary(english:"Checks version of Retrospect client");

 script_set_attribute(attribute:"synopsis", value:
"The remote backup client is susceptible to denial of service attacks." );
 script_set_attribute(attribute:"description", value:
"According to its version number, the installed instance of Retrospect
Client for Windows reportedly will stop working if it receives a
packet starting with a specially-crafted sequence of bytes.  An
unauthenticated remote attacker may be able to leverage this flaw to
prevent the affected host from being backed up." );
 script_set_attribute(attribute:"see_also", value:"http://www.securityfocus.com/archive/1/426652/30/0/threaded" );
 script_set_attribute(attribute:"see_also", value:"http://kb.dantz.com/display/2n/articleDirect/index.asp?aid=8361&r=0.5648157" );
 script_set_attribute(attribute:"solution", value:
"Upgrade to Retrospect Client for Windows version 6.5.138 / 7.0.109 or
later." );
 script_set_attribute(attribute:"cvss_vector", value: "CVSS2#AV:N/AC:L/Au:N/C:N/I:N/A:P" );
script_end_attributes();


  script_category(ACT_GATHER_INFO);
  script_family(english:"Misc.");

  script_copyright(english:"This script is Copyright (C) 2006-2009 Tenable Network Security, Inc.");

  script_dependencies("retrospect_detect.nasl");
  script_require_ports("Services/retrospect", 497);

  exit(0);
}


port = get_kb_item("Services/retrospect");
if (!port) port = 497;
if (!get_port_state(port)) exit(0);


ver = get_kb_item(string("Retrospect/", port, "/Version"));
ostype = get_kb_item(string("Retrospect/", port, "/OSType"));
if (!ver || isnull(ostype))
  exit (0);

# Windows only
ostype = ostype >>> 16;

if (ostype > 1 && ostype < 10)
{
  iver = split(ver, sep:'.', keep:FALSE);
  if (
    (int(iver[0]) == 6 && int(iver[1]) == 5 && int(iver[2]) < 138) ||
    (int(iver[0]) == 7 && int(iver[1]) == 0 && int(iver[2]) < 109)
  ) security_warning(port);
}
