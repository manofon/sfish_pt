
#
# (C) Tenable Network Security
#
# This plugin text was extracted from Mandrake Linux Security Advisory ADVISORY
#

include("compat.inc");

if ( ! defined_func("bn_random") ) exit(0);
if(description)
{
 script_id(13879);
 script_version ("$Revision: 1.5 $");
 script_name(english: "MDKSA-2001:064: tripwire");
 script_set_attribute(attribute: "synopsis", value: 
"The remote host is missing the patch for the advisory MDKSA-2001:064 (tripwire).");
 script_set_attribute(attribute: "description", value: "Jarno Juuskonen reported that a temporary file vulnerability exists in
versions of Tripwire prior to 2.3.1-2. Because Tripwire opens/creates
temporary files in /tmp without the O_EXCL flag during filesystem
scanning and database updating, a malicious user could execute a
symlink attack against the temporary files. This new version has all
but one unsafe temporary file open fixed. It can still be used safely
when using the new TEMPDIRECTORY configuration option, which is now set
to /root/tmp.
");
 script_set_attribute(attribute: "risk_factor", value: "High");
script_set_attribute(attribute: "see_also", value: "http://wwwnew.mandriva.com/security/advisories?name=MDKSA-2001:064");
script_set_attribute(attribute: "solution", value: "Apply the newest security patches from Mandriva.");
script_end_attributes();

script_summary(english: "Check for the version of the tripwire package");
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2009 Tenable Network Security");
 script_family(english: "Mandriva Local Security Checks");
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/Mandrake/rpm-list");
 exit(0);
}

include("rpm.inc");

if ( ! get_kb_item("Host/Mandrake/rpm-list") ) exit(1, "Could not get the list of packages");

if ( rpm_check( reference:"tripwire-2.3.1.2-2.2mdk", release:"MDK8.0", yank:"mdk") )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
exit(0, "Host is not affected");
