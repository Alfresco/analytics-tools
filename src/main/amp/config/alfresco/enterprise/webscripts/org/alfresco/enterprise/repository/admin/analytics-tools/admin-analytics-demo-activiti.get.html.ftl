<#include "../admin-template.ftl" />
<@page title="Analytics Demo Activiti Events" readonly=true>
   <link href="${url.context}/jquery/jquery-ui.min.css" rel="stylesheet">
   <div class="column-full">
      <p class="intro-tall">${msg("tool.analytics.activiti.demo.intro-text")?html}</p>
   </div>
   <div class="column-full">
      <@section label=msg("tool.analytics.activiti.demo") />
   </div>
   <div class="column-left">
      <div class="control options">
         <span class="label">${msg("People")?html}:</span>
         <span class="value">
            <select id="people" name="people" tabindex="1" multiple size="10">
              <#list people as p>
                  <option value="${p.userName?html}" selected="true">${p.fullName?html}</option>
               </#list>
            </select>
         </span>
         <span class="description">Choose Multiple People (about 10). This list shows all the people in the "ANALYTICS_DEMO_USERS" group.
            Normally, users don't need to be in a specific group to record analytics (only for this demo data).</span>         
      </div>
   </div>
   <div class="column-right">
      <div class="control options">
         <span class="label">${msg("Process Types")?html}:</span>
         <span class="value">
            <select id="processes" name="processes" tabindex="0" multiple size="4">
              <#list processList as p>
                  <option value="${p?html}" selected="true">${msg(p+".workflow.title")}</option>
               </#list>
            </select>
         </span>
         <span class="description">The processes to use.</span>         
      </div>
      <div class="control options">
         <span class="label">${msg("Priorities")?html}:</span>
         <span class="value">
            <select id="priorities" name="priorities" tabindex="0" multiple size="4">
              <#list priorities as p>
                  <option value="${p?html}" selected="true">${msg("listconstraint.bpm_allowedPriority."+p)}</option>
               </#list>
            </select>
         </span>
         <span class="description">The workflow priorities to use.</span>         
      </div>
      <div class="control options">
         <span class="label">${msg("Task State")?html}:</span>
         <span class="value">
            <select id="state" name="state" tabindex="0" multiple size="4">
              <#list taskStateList as s>
                  <option value="${s?html}" selected="true">${s?html}</option>
               </#list>
            </select>
         </span>
         <span class="description">Should the tasks be early/overdue? (Select one)</span>         
      </div>              
   </div>
   <div id="contentSource" class="column-full">
      <div class="control field">
         <span class="label">Content source</span>
         <input id="content" tabindex="0" value="workspace://SpacesStore/880a0f47-31b1-4101-b20b-4d325e54e8b1" name="content" style='width:50em'>
         <span class="description">This should be a nodeRef of a folder with files in, to use as demo data. Processes act on content.</span>
      </div>
   </div>   
   <div class="column-left">
      <div class="control field">
         <span class="label">Date From</span>
         <input type="text" id="startDate" name="startDate">
         <span class="description">When should events start?</span>
      </div>
   </div>
   <div class="column-right">
      <div class="control field">
         <span class="label">Date To</span>
         <input type="text" id="endDate" name="endDate">
         <span class="description">When should events end?</span>
      </div>
   </div>
   <div class="column-left">
      <div class="control field">
         <span class="label">Number of Processes</span>
         <input id="numberOfValues" tabindex="0" maxlength="200" value="20" name="numberOfValues" style='width:4em'>
         <span class="description">How many processes do you want?</span>
      </div>
   </div>     
   <div class="column-right">
      <@button id="upload-events" label=msg("tool.analytics.activiti.generate") description=msg("tool.analytics.activiti.generate") />
   </div>
   <div class="column-full">
   </div>
   <div class="column-full label">
      <@section label=msg("Results") />
         <div class="ui-widget">
           <div id="result" class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;" />
         </div>       
   </div>  
   
   <script type="text/javascript" src="${url.context}/jquery/jquery-2.1.1.min.js"></script>
   <script type="text/javascript" src="${url.context}/jquery/jquery-ui.min.js"></script>   
   <script type="text/javascript">//<![CDATA[
      $.noConflict();
      
      jQuery( document ).ready(function( $ ) {
        
        $("#startDate").datepicker({
           dateFormat: "yy-mm-dd",
           showButtonPanel: true,
           numberOfMonths: 2
        });
        $("#endDate").datepicker({
           dateFormat: "yy-mm-dd",
           showButtonPanel: true,
           numberOfMonths: 2
        });
        $("#startDate").datepicker( "setDate", "-6m" );
        $("#endDate").datepicker( "setDate", "-1d" );
                              
        $( "#upload-events" ).click(function( event ) {
           $("#confirmMessage").text("Would you like to create "+$("#numberOfValues").val()+ " processes for "+$("#processes option:selected").size()+ " process types, "+$("#priorities option:selected").size()+ " priorities and "+$("#people option:selected").size()
                                      + " people. The events will be distributed uniformly from "+$("#startDate").val()+ " to "+$("#endDate").val()+". All the tasks will be "+$("#state").val()+".");
           $("#dialog-confirm").dialog({
               resizable: false,
               height:250,
               buttons: {
                 "OK": function() {
                    $( this ).dialog( "close" );
                    $( "#upload-events" ).hide();
                    $.getJSON("${url.serviceContext}/enterprise/admin/admin-analytics-bulkactiviti",
                              $("#admin-jmx-form").serializeArray(), 
                              function( data ) {
                                   $("#result").append("<br/>Successfully created "+data.totalRows +" processes from "+data.from +" to "+data.to +" <br/>");
                             })
                             .fail(function() {
                               $("#result").text("Something went wrong.<br/>");
                             })
                             .always(function() {
                               event.preventDefault();
                               $( "#upload-events" ).show();
                             });
                              
                              
                                                 
                 },
                 Cancel: function() {
                   $( this ).dialog( "close" );
                 }
               }
             });
          

        });
      });
//]]></script>
<div id="dialog-confirm" title="Create Activiti Processes?">
  <p><span style="float:left; margin:0 1px 20px 0;"></span>
  <span id="confirmMessage">&nbsp;</span></p>
</div>
</@page>