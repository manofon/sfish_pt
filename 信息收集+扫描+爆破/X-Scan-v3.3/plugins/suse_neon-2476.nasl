
#
# (C) Tenable Network Security
#
# The text description of this plugin is (C) Novell, Inc.
#

include("compat.inc");

if ( ! defined_func("bn_random") ) exit(0);

if(description)
{
 script_id(27361);
 script_version ("$Revision: 1.5 $");
 script_name(english: "SuSE Security Update:  neon: This update fixes a possible crash in the URI parser. (neon-2476)");
 script_set_attribute(attribute: "synopsis", value: 
"The remote SuSE system is missing the security patch neon-2476");
 script_set_attribute(attribute: "description", value: "Fix for incorrect array index handling with non-ASCII
characters in the URI parser. (CVE-2007-0157)
");
 script_set_attribute(attribute: "cvss_vector", value: "CVSS2#AV:N/AC:L/Au:N/C:N/I:N/A:C");
script_set_attribute(attribute: "solution", value: "Install the security patch neon-2476");
script_end_attributes();

script_cve_id("CVE-2007-0157");
script_summary(english: "Check for the neon-2476 package");
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2009 Tenable Network Security");
 script_family(english: "SuSE Local Security Checks");
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/SuSE/rpm-list");
 exit(0);
}

include("rpm.inc");

if ( ! get_kb_item("Host/SuSE/rpm-list") ) exit(1, "Could not gather the list of packages");
if ( rpm_check( reference:"neon-0.26.1-26.1", release:"SUSE10.2") )
{
	security_hole(port:0, extra:rpm_report_get());
	exit(0);
}
if ( rpm_check( reference:"neon-32bit-0.26.1-26.1", release:"SUSE10.2") )
{
	security_hole(port:0, extra:rpm_report_get());
	exit(0);
}
if ( rpm_check( reference:"neon-64bit-0.26.1-26.1", release:"SUSE10.2") )
{
	security_hole(port:0, extra:rpm_report_get());
	exit(0);
}
exit(0,"Host is not affected");
