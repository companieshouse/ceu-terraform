#STAGING#### min hour day month weekday
#STAGING###
#STAGING#### Partition orders into product groups every minute
#STAGING###
*/1 7-23 * * *     /home/ceu/chd3backend/partition.sh
#STAGING###
#STAGING#### Generate reports mon-sat 7am->midnight every minute
#STAGING####
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/reports.sh
#STAGING###
#STAGING#### Generate images mon-sat 7am->midnight
#STAGING####
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/images.sh
#STAGING###
#STAGING#### Generate packages mon-sat 7am->midnight
#STAGING####
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/packages.sh
#STAGING###
#STAGING#### Generate scud mon-sat 7am->midnight
#STAGING####
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/scud.sh
#STAGING###
#STAGING#### Generate fiche mon-sat 7am->midnight
#STAGING####
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/fiche.sh
#STAGING####
#STAGING#### Generate invoices mon-sat 7am->midnight (used for Certified Copies etc)
#STAGING####
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/invoice.sh
#STAGING###
#STAGING### Generate jobsheets mon-sat 7am->midnight (used for Certified Copies etc)
#STAGING####
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/jobsheet.sh
#STAGING#### Generate (charge) monitor orders mon-sat 7am->midnight
#STAGING####
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/monitor.sh
#STAGING###
#STAGING#### Do monitor Matching process mon-sat every 10 mins
#STAGING#### (This should only pick up matches once - but for testing purposes......)
#STAGING####
#STAGING*/10 7-23 * * *  /home/ceu/chd3backend/monitorMatch.sh
#STAGING##
#STAGING### Dispatch Faxes mon-sat 7am->midnight
#STAGING###
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/fax.sh
#STAGING##
#STAGING### Dispatch Emails mon-sat 7am->midnight
#STAGING###
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/email.sh
#STAGING*/1 7-23 * * *  /home/ceu/chd3backend/print.sh
#STAGING##
#STAGING### Scan for and record Fax delivery status to CH report dir and to Database
#STAGING##
#STAGING*/5 7-23 * * *  /home/ceu/chd3backend/faxStatus.sh
#STAGING##
#STAGING## Scan for internal-delivery products (Currently Cert Copies etc)
#STAGING###
#STAGING*/5 7-23 * * *  /home/ceu/chd3backend/internal.sh
#STAGING##
#STAGING### WEEDING
#STAGING###
#STAGING#*/5 7-23 * * *  /home/ceu/chd3backend/weedall.sh
#STAGING###
#STAGING#####You have new mail in /var/spool/mail/ceu
#STAGING###
