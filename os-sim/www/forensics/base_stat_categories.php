<?php
/*******************************************************************************
** OSSIM Forensics Console
** Copyright (C) 2009 OSSIM/AlienVault
** Copyright (C) 2004 BASE Project Team
** Copyright (C) 2000 Carnegie Mellon University
**
** (see the file 'base_main.php' for license details)
**
** Built upon work by Roman Danyliw <rdd@cert.org>, <roman@danyliw.com>
** Built upon work by the BASE Project Team <kjohnson@secureideas.net>
*/


require ("base_conf.php");
require ("vars_session.php");
require ("$BASE_path/includes/base_constants.inc.php");
require ("$BASE_path/includes/base_include.inc.php");
include_once ("$BASE_path/base_db_common.php");
include_once ("$BASE_path/base_qry_common.php");
include_once ("$BASE_path/base_stat_common.php");

$_SESSION["siem_default_group"] = "base_stat_categories.php?sort_order=occur_d";


($debug_time_mode >= 1) ? $et = new EventTiming($debug_time_mode) : '';
$cs = new CriteriaState("base_stat_categories.php");
$submit = ImportHTTPVar("submit", VAR_ALPHA | VAR_SPACE, array(
    gettext("Delete Selected"),
    gettext("Delete ALL on Screen"),
    _ENTIREQUERY
));
$cs->ReadState();
// Check role out and redirect if needed -- Kevin
$roleneeded = 10000;
#$BUser = new BaseUser();
#if (($BUser->hasRole($roleneeded) == 0) && ($Use_Auth_System == 1)) base_header("Location: " . $BASE_urlpath . "/index.php");
$qs = new QueryState();
$qs->AddCannedQuery("most_frequent", $freq_num_alerts, gettext("Most Frequent Events"), "occur_d");
$qs->AddCannedQuery("last_alerts", $last_num_ualerts, gettext("Last Events"), "last_d");
$qs->MoveView($submit); /* increment the view if necessary */

$page_title = gettext("Event Listing");

/* Connect to the Alert database */
$db = NewBASEDBConnection($DBlib_path, $DBtype);
$db->baseDBConnect($db_connect_method, $alert_dbname, $alert_host, $alert_port, $alert_user, $alert_password);

if ($event_cache_auto_update == 1) UpdateAlertCache($db);
$criteria_clauses = ProcessCriteria();

// Include base_header.php
if ($qs->isCannedQuery()) PrintBASESubHeader($page_title . ": " . $qs->GetCurrentCannedQueryDesc() , $page_title . ": " . $qs->GetCurrentCannedQueryDesc() , $cs->GetBackLink() , 1);
else PrintBASESubHeader($page_title, $page_title, $cs->GetBackLink() , 1);

// Use accumulate tables only when timestamp criteria is not hour sensitive
$use_ac = $criteria_clauses[3];
$where = " WHERE " . $criteria_clauses[1];

if ($use_ac)
{ // use ac/po_acid_event
    $acc     = (preg_match("/ip_src|ip_dst/",$where)) ? "po_acid_event" : "ac_acid_event";
    $from    = " FROM $acc as acid_event, sensor " . $criteria_clauses[0];
    $fromcnt = " FROM $acc as acid_event " . $criteria_clauses[0];
    $counter = "sum(acid_event.cnt) as events";
}
else
{
    $from    = " FROM acid_event, sensor " . $criteria_clauses[0];
    $fromcnt = " FROM acid_event " . $criteria_clauses[0];
    $counter = "count(acid_event.ctx) as events";
}

if (preg_match("/^(.*)AND\s+\(\s+timestamp\s+[^']+'([^']+)'\s+\)\s+AND\s+\(\s+timestamp\s+[^']+'([^']+)'\s+\)(.*)$/", $where, $matches)) {
    if ($matches[2] != $matches[3]) {
        $where = $matches[1] . " AND timestamp BETWEEN('" . $matches[2] . "') AND ('" . $matches[3] . "') " . $matches[4];
    } else {
        $where = $matches[1] . " AND timestamp >= '" . $matches[2] . "' " . $matches[4];
    }
}
// Timezone
$tz = Util::get_timezone();

//$qs->AddValidAction("ag_by_id");
//$qs->AddValidAction("ag_by_name");
//$qs->AddValidAction("add_new_ag");
//$qs->AddValidAction("del_alert");
//$qs->AddValidAction("email_alert");
//$qs->AddValidAction("email_alert2");
//$qs->AddValidAction("csv_alert");
//$qs->AddValidAction("archive_alert");
//$qs->AddValidAction("archive_alert2");
//$qs->AddValidActionOp(gettext("Delete Selected"));
//$qs->AddValidActionOp(gettext("Delete ALL on Screen"));
$qs->SetActionSQL($from . $where);
($debug_time_mode >= 1) ? $et->Mark("Initialization") : '';
$qs->RunAction($submit, PAGE_STAT_ALERTS, $db);
($debug_time_mode >= 1) ? $et->Mark("Alert Action") : '';
/* Get total number of events */
/* mstone 20050309 this is expensive -- don't do it if we're avoiding count() */
/*if ($avoid_counts != 1 && !$use_ac) {
$event_cnt = EventCnt($db);
if($event_cnt == 0){
$event_cnt = 1;
}
}*/
$subcat = (intval($_SESSION["category"][0])>0) ? true : false;

/* create SQL to get Unique Alerts */
$cnt_sql = "SELECT count(DISTINCT acid_event.plugin_id) " . $fromcnt . $where;
/* Run the query to determine the number of rows (No LIMIT)*/
$qs->GetNumResultRows($cnt_sql, $db);
($debug_time_mode >= 1) ? $et->Mark("Counting Result size") : '';
/* Setup the Query Results Table */
$qro = new QueryResultsOutput("base_stat_categories.php?caller=" . $caller);
//$qro->AddTitle(" ");
$qro->AddTitle(gettext("Category"));
$events_title = _("Events"). "&nbsp;# <span class='idminfo' txt='".Util::timezone($tz)."'>(*)</span>";
$qro->AddTitle($events_title , "occur_a", " ", " ORDER BY events ASC", "occur_d", ", ", " ORDER BY events DESC");
$qro->AddTitle((Session::show_entities()) ? gettext("Context") : gettext("Sensor"));
$qro->AddTitle(gettext("Last Event"));
$qro->AddTitle(gettext("Date")." ".Util::timezone($tz));
$sort_sql = $qro->GetSortSQL($qs->GetCurrentSort() , $qs->GetCurrentCannedQuerySort());
/* mstone 20050309 add sig_name to GROUP BY & query so it can be used in postgres ORDER BY */
/* mstone 20050405 add sid & ip counts */
$fromcnt = (preg_match("/plugin_sid/",$fromcnt)) ? $fromcnt : $fromcnt.",alienvault.plugin_sid ";
$where = (preg_match("/plugin_sid.plugin_id/",$fromcnt)) ? $where : $where." AND plugin_sid.plugin_id=acid_event.plugin_id AND plugin_sid.sid=acid_event.plugin_sid ";
$where2 = (preg_match("/plugin_sid.plugin_id/",$fromcnt)) ? $where2 : $where2." AND plugin_sid.plugin_id=acid_event.plugin_id AND plugin_sid.sid=acid_event.plugin_sid ";

if (Session::show_entities())
{
    if ($subcat)
    {
        $sql = "SELECT plugin_sid.subcategory_id,hex(ctx) as ctx, $counter " . $fromcnt  . $where . " AND plugin_sid.category_id=".$_SESSION["category"][0]." GROUP BY plugin_sid.category_id,plugin_sid.subcategory_id,ctx HAVING plugin_sid.subcategory_id>0 AND events>0 " . $sort_sql[1];

        $_SESSION['_siem_plugins_query'] = "SELECT plugin_sid.name as sig_name,acid_event.timestamp
                                            $fromcnt, alienvault.plugin
                                            $where AND plugin_sid.plugin_id=acid_event.plugin_id AND plugin_sid.sid=acid_event.plugin_sid AND acid_event.plugin_id=plugin.id AND acid_event.plugin_id=plugin.id AND plugin_sid.category_id=PLUGIN_ID AND plugin_sid.subcategory_id=SUBCAT AND acid_event.ctx=UNHEX('DID')
                                            ORDER BY timestamp DESC LIMIT 1";
    }
    else
    {
        $sql = "SELECT plugin_sid.category_id,hex(ctx) as ctx, $counter " . $fromcnt  . $where . " GROUP BY plugin_sid.category_id,ctx HAVING plugin_sid.category_id>0 AND events>0 " . $sort_sql[1];

        $_SESSION['_siem_plugins_query'] = "SELECT plugin_sid.name as sig_name,acid_event.timestamp
                                            $fromcnt, alienvault.plugin
                                            $where AND plugin_sid.plugin_id=acid_event.plugin_id AND plugin_sid.sid=acid_event.plugin_sid AND acid_event.plugin_id=plugin.id AND acid_event.plugin_id=plugin.id AND plugin_sid.category_id=PLUGIN_ID AND acid_event.ctx=UNHEX('DID')
                                            ORDER BY timestamp DESC LIMIT 1";
    }
}
else
{
    if ($subcat)
    {
        $sql = "SELECT plugin_sid.subcategory_id, device_id as ctx, $counter " . $fromcnt . ",device" . $where . " AND device.id=acid_event.device_id AND plugin_sid.category_id=".$_SESSION["category"][0]." GROUP BY plugin_sid.category_id,plugin_sid.subcategory_id,device_id HAVING plugin_sid.subcategory_id>0 AND events>0 " . $sort_sql[1];

        $_SESSION['_siem_plugins_query'] = "SELECT plugin_sid.name as sig_name,acid_event.timestamp
                                            $fromcnt, alienvault.plugin
                                            $where AND plugin_sid.plugin_id=acid_event.plugin_id AND plugin_sid.sid=acid_event.plugin_sid AND acid_event.plugin_id=plugin.id AND acid_event.plugin_id=plugin.id AND plugin_sid.category_id=PLUGIN_ID AND plugin_sid.subcategory_id=SUBCAT AND acid_event.device_id=DID
                                            ORDER BY timestamp DESC LIMIT 1";
    }
    else
    {
        $sql = "SELECT plugin_sid.category_id, device_id as ctx, $counter  " . $fromcnt . ",device" . $where . " AND device.id=acid_event.device_id GROUP BY plugin_sid.category_id,device_id HAVING plugin_sid.category_id>0 AND events>0 " . $sort_sql[1];

        $_SESSION['_siem_plugins_query'] = "SELECT plugin_sid.name as sig_name,acid_event.timestamp
                                            $fromcnt, alienvault.plugin
                                            $where AND plugin_sid.plugin_id=acid_event.plugin_id AND plugin_sid.sid=acid_event.plugin_sid AND acid_event.plugin_id=plugin.id AND plugin_sid.category_id=PLUGIN_ID AND acid_event.device_id=DID
                                            ORDER BY timestamp DESC LIMIT 1";
    }
}

if (file_exists('/tmp/debug_siem'))
{
    file_put_contents("/tmp/siem", "STATS CATEGORIES:$sql\n".$_SESSION['_siem_plugins_query']."\n", FILE_APPEND);
}
//$event_cnt = EventCnt($db, "", "", $sql);
/* Run the Query again for the actual data (with the LIMIT) */
session_write_close();
$result = $qs->ExecuteOutputQuery($sql, $db);
if ($result->baseRecordCount()==0 && $use_ac) $result = $qs->ExecuteOutputQuery($sql, $db);
$qs->num_result_rows = $result->baseRecordCount();

($debug_time_mode >= 1) ? $et->Mark("Retrieve Query Data") : '';
// if ($debug_mode == 1) {
    // $qs->PrintCannedQueryList();
    // $qs->DumpState();
    // echo "$sql<BR>";
// }
/* Print the current view number and # of rows */
$displaying = gettext("Displaying unique ".($subcat ? "sub" : "")."categories %d-%d of <b>%s</b> matching your selection.");
$qs->PrintResultCnt("",array(),$displaying);
echo '<FORM METHOD="post" name="PacketForm" id="PacketForm" ACTION="base_stat_categories.php">';
if ($qs->num_result_rows > 0)
{
    $qro->PrintHeader();
}
$i = 0;
// The below is due to changes in the queries...
// We need to verify that it works all the time -- Kevin
$and = (strpos($where, "WHERE") != 0) ? " AND " : " WHERE ";
$i = 0;
$report_data = array(); // data to fill report_data
if (is_array($_SESSION["server"]) && $_SESSION["server"][0]!="")
    $_conn = $dbo->custom_connect($_SESSION["server"][0],$_SESSION["server"][2],$_SESSION["server"][3]);
else
    $_conn = $dbo->connect();
while (($myrow = $result->baseFetchRow()) && ($i < $qs->GetDisplayRowCnt())) {
    $max_cid = bin2hex($myrow[0]);
    $ctx = $myrow["ctx"];
    $category_id = ($subcat) ? $myrow["subcategory_id"] : $myrow["category_id"];
    $total_occurances = $myrow["events"];

    $temp = ($subcat) ? "SELECT CONCAT(c.name,' / ',s.name) as name FROM alienvault.category c,alienvault.subcategory s WHERE c.id=s.cat_id AND s.id = $category_id AND c.id = ".$_SESSION["category"][0] : "SELECT name FROM alienvault.category WHERE id = $category_id";
    $result1 = $db->baseExecute($temp);
    $cname = $result1->baseFetchRow();
    $result1->baseFreeRows();
    if ($cname["name"]=="") $cname["name"] = _("Unknown"); # Don't show unknown categories? put continue;

    if ( $subcat )
        $urlp = "base_qry_main.php?search=1&sensor=&bsf=Query+DB&search_str=&sip=&ossim_risk_a=+";
    else
        $urlp = "base_stat_categories.php?sort_order=occur_d";
    $urlp .= ($subcat) ? "&category%5B1%5D=".$category_id."&category%5B0%5D=".$_SESSION["category"][0] : "&category%5B1%5D=&category%5B0%5D=".$category_id;
    $tmpid = ($subcat) ? $_SESSION["category"][0]."_".$category_id : $category_id;
    qroPrintEntryHeader($i);
    qroPrintEntry('&nbsp;<a href="'.$urlp.'">' . str_replace("_","",$cname["name"]) . '</a>','left',"","nowrap",$bgcolor);
    qroPrintEntry('&nbsp;<a href="'.$urlp.'">' . Util::number_format_locale($total_occurances,0) . '</a>',"center","","",$bgcolor);
    qroPrintEntry((Session::show_entities() && !empty($entities[$ctx])) ? $entities[$ctx] : ((Session::show_entities()) ? _("Unknown") : GetSensorName($ctx, $db)),"center","","",$bgcolor);
    qroPrintEntry("<A class='usig' id='sg$tmpid-$ctx' HREF='$urlp'>".$last_signature."</a>","left","","",$bgcolor);

    qroPrintEntry("<div id='ts$tmpid-$ctx'>-</div>","center","","nowrap",$bgcolor);
    qroPrintEntryFooter();
    $i++;
    $prev_time = null;

}
$result->baseFreeRows();
$dbo->close($_conn);
$qro->PrintFooter();
$qs->PrintBrowseButtons();
$qs->PrintAlertActionButtons();
$qs->SaveState();
echo "\n</FORM>\n";
PrintBASESubFooter();
if ($debug_time_mode >= 1) {
    $et->Mark("Get Query Elements");
    $et->PrintTiming();
}
$db->baseClose();
?>
<script>
    var tmpimg = '<img alt="" src="data:image/gif;base64,R0lGODlhEAALAPQAAOPj4wAAAMLCwrm5udHR0QUFBQAAACkpKXR0dFVVVaamph4eHkJCQnt7e1lZWampqSEhIQMDA0VFRc3NzcHBwdra2jIyMsTExNjY2KKioo6OjrS0tNTU1AAAAAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh/hpDcmVhdGVkIHdpdGggYWpheGxvYWQuaW5mbwAh+QQJCwAAACwAAAAAEAALAAAFLSAgjmRpnqSgCuLKAq5AEIM4zDVw03ve27ifDgfkEYe04kDIDC5zrtYKRa2WQgAh+QQJCwAAACwAAAAAEAALAAAFJGBhGAVgnqhpHIeRvsDawqns0qeN5+y967tYLyicBYE7EYkYAgAh+QQJCwAAACwAAAAAEAALAAAFNiAgjothLOOIJAkiGgxjpGKiKMkbz7SN6zIawJcDwIK9W/HISxGBzdHTuBNOmcJVCyoUlk7CEAAh+QQJCwAAACwAAAAAEAALAAAFNSAgjqQIRRFUAo3jNGIkSdHqPI8Tz3V55zuaDacDyIQ+YrBH+hWPzJFzOQQaeavWi7oqnVIhACH5BAkLAAAALAAAAAAQAAsAAAUyICCOZGme1rJY5kRRk7hI0mJSVUXJtF3iOl7tltsBZsNfUegjAY3I5sgFY55KqdX1GgIAIfkECQsAAAAsAAAAABAACwAABTcgII5kaZ4kcV2EqLJipmnZhWGXaOOitm2aXQ4g7P2Ct2ER4AMul00kj5g0Al8tADY2y6C+4FIIACH5BAkLAAAALAAAAAAQAAsAAAUvICCOZGme5ERRk6iy7qpyHCVStA3gNa/7txxwlwv2isSacYUc+l4tADQGQ1mvpBAAIfkECQsAAAAsAAAAABAACwAABS8gII5kaZ7kRFGTqLLuqnIcJVK0DeA1r/u3HHCXC/aKxJpxhRz6Xi0ANAZDWa+kEAA7AAAAAAAAAAAA" />';
    var plots=new Array();
    var pi = 0;
    function load_content() {
        if (pi>=plots.length) return;
        var item = plots[pi]; pi++;
        var params = item.replace(/sg/,'?plugin=').replace(/-/,'&id=');
        var pid = item.replace(/sg/,'');
        $.ajax({
            beforeSend: function() {
                $('#sg'+pid).html(tmpimg);
                $('#ts'+pid).html(tmpimg);
            },
            type: "GET",
            url: "base_stat_plugin_data.php"+params,
            success: function(msg) {
                var res = msg.split(/##/);
                $('#sg'+pid).html(res[0]);
                $('#ts'+pid).html(res[1]);
                setTimeout('load_content()',10);
            }
        });
    }
    $(document).ready(function() {
        $('.usig').each(function(index, item) {
            plots.push(item.id);
        });
        setTimeout('load_content()',10);
    });
</script>
<?php
echo "</body>\r\n</html>";
?>
