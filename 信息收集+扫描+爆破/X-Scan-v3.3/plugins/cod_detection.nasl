#
# (C) Tenable Network Security, Inc.
#


include("compat.inc");

if(description)
{
  script_id(33275);
  script_version ("$Revision: 1.3 $");

  name["english"] = "Call Of Duty Server Detection";
  script_name(english:name["english"]);

 script_set_attribute(attribute:"synopsis", value:
"A game server has been detected on the remote host." );
 script_set_attribute(attribute:"description", value:
"The remote host is running Call of Duty game server.

Make sure that the use of this program is done in accordance with your
corporate security policy." );
 script_set_attribute(attribute:"see_also", value:"http://www.callofduty.com/hub" );
 script_set_attribute(attribute:"solution", value:
"If this service is not needed, disable it or filter incoming traffic
to this port." );
 script_set_attribute(attribute:"risk_factor", value:"None" );
 script_end_attributes();

  summary["english"] = "Detects Call Of Duty Server";
  script_summary(english:summary["english"]);
  script_category(ACT_GATHER_INFO);

  script_copyright(english:"This script is Copyright (C) 2008-2009 Tenable Network Security, Inc.");

  script_family(english:"Service detection");
  exit(0);
}


include("global_settings.inc");
include('misc_func.inc');
include('byte_func.inc');

foreach port (make_list(28960, 28961))
{
 if (!known_service(port:port, ipproto:"udp"))
  {
   sock = open_sock_udp(port);
   if ( ! sock ) exit(0);

   # Send getstatus request
   # 0xFF,0xFF,0xFF,0xFF, getstatus

   req = mkdword(0xffffffff) + "getstatus";

   send(socket:sock, data:req);
   res = recv(socket:sock, length:1024);

   if ( "statusResponse" >< res && 
     "Call of Duty" >< res
     )
    {
     report = NULL;

     res2 = split(res, sep:"\",keep:FALSE);
     for ( i = 1 ; i < max_index(res2) && i+1 < max_index(res2) ; i+=2 )
     {
       report += string( res2[i], " : ", res2[i+1] ,'\n');
     }

     if (report_verbosity && report )
      {
          report = string('\n',"The following is known about the remote COD server : ",'\n\n',
		     report) ;	
          register_service(port:port, ipproto:"udp", proto:"call-of-duty");
          security_note(port:port, proto:"udp", extra:report); 
      }
     else
     {
      register_service(port: port, ipproto:"udp", proto: "call-of-duty");
      security_note(port:port, proto:"udp"); 
     }
    if (!thorough_tests) exit(0);
   }
  }
}

