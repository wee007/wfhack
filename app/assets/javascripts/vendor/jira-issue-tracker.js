/*
 * Site wide feedback via JIRA Issue Collector
 * https://confluence.atlassian.com/display/JIRA/Advanced+Use+of+the+JIRA+Issue+Collector
 */

 // AJAX in the feedback form dialog
 jQuery.ajax({
  url:      'https://westfieldfeedback.atlassian.net/s/d41d8cd98f00b204e9800998ecf8427e/en_UK-eecqsn-1988229788/6204/13/1.4.0-m8/_/download/batch/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs.js?collectorId=cfde49b8',
  type:     'get',
  cache:    true,
  dataType: 'script'
});

// Initialise via a custom trigger
window.ATL_JQ_PAGE_PROPS = {
  "triggerFunction": function(showCollectorDialog) {
  jQuery('.js-btn-site-feedback').click(function() {
    showCollectorDialog();
  });
}};