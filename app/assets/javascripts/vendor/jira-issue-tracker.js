/*
 * Site wide feedback via JIRA Issue Collector
 * https://confluence.atlassian.com/display/JIRA/Advanced+Use+of+the+JIRA+Issue+Collector
 */

// Conditionally load the JS only when it's needed via the 'Enquire' library
$.getScript = function(url, callback, cache) {
  $.ajax({
    type: 'GET',
    url: url,
    success: callback,
    dataType: 'script',
    cache: cache
  });
};
$(function() {
  enquire.register('all and (min-width: 53.75em)', {
    deferSetup: true,
    setup: function() {
      $.getScript('https://westfieldfeedback.atlassian.net/s/d41d8cd98f00b204e9800998ecf8427e/en_UK-eecqsn-1988229788/6204/13/1.4.0-m8/_/download/batch/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs.js?collectorId=cfde49b8', function() {
        // Initialise via a custom trigger
        window.ATL_JQ_PAGE_PROPS = {
          'triggerFunction': function(showCollectorDialog) {
          $('.js-btn-site-feedback').click(function() {
            showCollectorDialog();
          });
        }};
      }, true);
    }
  });
});