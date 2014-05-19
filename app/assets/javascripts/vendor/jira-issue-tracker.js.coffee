###
  Site wide feedback via JIRA Issue Collector
  https://confluence.atlassian.com/display/JIRA/Advanced+Use+of+the+JIRA+Issue+Collector
###

class IssueTracker
  buttonSelector: '.js-btn-site-feedback'
  pluginUrl: 'https://westfieldfeedback.atlassian.net/s/d41d8cd98f00b204e9800998ecf8427e/en_UK-eecqsn-1988229788/6204/13/1.4.0-m8/_/download/batch/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs.js?collectorId=cfde49b8'
  constructor: ->
    @doc = $(document)
    @setupJiraConfig()
    @setupFirstClickEvent()

  setupJiraConfig: =>
    window.ATL_JQ_PAGE_PROPS =
      triggerFunction: (showCollectorDialog) =>
        # Popup trigger needs to wait for plugin initialisation, so run inside a setTimeout
        setTimeout showCollectorDialog, 0

        # After the JS is loaded and on subsequest "Give Feedback" clicks, just trigger the popup
        @doc.on 'click', @buttonSelector, showCollectorDialog

  setupFirstClickEvent: =>
    # Only on the first click, load the JS for the issue collector
    @doc.one 'click', @buttonSelector, =>
      Modernizr.load @pluginUrl

new IssueTracker()