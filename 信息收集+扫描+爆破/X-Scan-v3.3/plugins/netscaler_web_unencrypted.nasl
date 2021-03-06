# netscaler_web_unencrypted.nasl
# GPLv2

# Changes by Tenable:
# - Revised plugin title (9/23/09)


include("compat.inc");

if (description)
    {
    script_id(29224);
    script_version("$Revision: 1.4 $");

    script_name(english:"NetScaler Unencrypted Web Management Interface");

 script_set_attribute(attribute:"synopsis", value:
"The remote web management interface does not encrypt connections." );
 script_set_attribute(attribute:"description", value:
"The remote Citrix NetScaler web management interface does use TLS or
SSL to encrypt connections." );
 script_set_attribute(attribute:"solution", value:
"Consider disabling this port completely and using only HTTPS." );
 script_set_attribute(attribute:"cvss_vector", value: "CVSS2#AV:N/AC:L/Au:N/C:P/I:N/A:N" );

    script_summary(english:"Detects an unencrypted NetScaler web management interface");
    script_family(english:"Web Servers");
script_end_attributes();

    script_category(ACT_GATHER_INFO);
    script_copyright(english:"This script is Copyright (c) 2007-2009 nnposter");
    script_dependencies("netscaler_web_detect.nasl");
    script_require_keys("www/netscaler");
    script_require_ports("Services/www",80);
    exit(0);
    }


if (!get_kb_item("www/netscaler")) exit(0);


include("http_func.inc");


function is_ssl(port)
{
local_var encaps;
encaps= get_kb_item("Transports/TCP/"+port);
if ( encaps && encaps>=ENCAPS_SSLv2 && encaps<=ENCAPS_TLSv1 )
	return TRUE;
 else
	return FALSE;
}


port=get_http_port(default:80);
if (!get_tcp_port_state(port) || !get_kb_item("www/netscaler/"+port))
    exit(0);

if (!is_ssl(port:port)) security_warning(port);
