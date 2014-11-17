<%@page import="java.text.ParseException"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="edu.ncsu.csc.itrust.exception.ITrustException"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@page import="edu.ncsu.csc.itrust.beans.MessageBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPersonnelAction"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PersonnelDAO"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyMessagesAction"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPersonnelAction"%>

<%@page errorPage="/auth/exceptionHandler.jsp"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewVisitedHCPsAction"%>
<%@page import="java.util.List"%>

<%@page import="edu.ncsu.csc.itrust.beans.HCPVisitBean"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewVisitedHCPsAction"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.MessageDAO"%>

<%@page import="edu.ncsu.csc.itrust.action.ViewMyMessagesAction"%>
<%@page import="edu.ncsu.csc.itrust.beans.MessageBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PatientDAO"%>


<%@include file="/iTrust/WebRoot/auth/hcp-patient/mailbox.jsp" %>
<style>
h1{
text-align: center;
}</style>
<%
	pageTitle = "Message Inbox - Apply Filter";

%>

<%
boolean outbox = true;

if (request.getParameter("mail").equals("in"))
{
	System.out.println("its the inbox.");
	outbox = false;
}
System.out.println("lalalalal");
System.out.println(request.getParameter("mail"));
	

boolean isHCP = true;
PersonnelDAO personnelDAO = new PersonnelDAO(prodDAO);
PatientDAO patientDAO = new PatientDAO(prodDAO);

DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

ViewMyMessagesAction action = new ViewMyMessagesAction(prodDAO, loggedInMID.longValue());

List<MessageBean> messages = outbox?action.getAllMySentMessages():action.getAllMyMessages();
session.setAttribute("messages", messages);
		

%>

<%@include file="/header.jsp" %>
			<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
			<script src="/iTrust/DataTables/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
			<script src="/iTrust/DataTables/media/js/jquery.dataTables.columnFilter.js" type="text/javascript"></script>
			
			<script>
						

			</script>
			<script type="text/javascript">

				jQuery.fn.dataTableExt.oSort['lname-asc']  = function(x,y) {
					var a = x.split(" ");
					var b = y.split(" ");
					return ((a[1] < b[1]) ? -1 : ((a[1] > b[1]) ?  1 : 0));
				};
				

				
				jQuery.fn.dataTableExt.oSort['lname-desc']  = function(x,y) {
					var a = x.split(" ");
					var b = y.split(" ");
					return ((a[1] < b[1]) ? 1 : ((a[1] > b[1]) ?  -1 : 0));
				};
			</script>
			<script type="text/javascript">	
				
					
				
   				$(document).ready(function() {
   					//$("#mailbox").hide();
       				$("#mailbox").dataTable({
       					"aaColumns": [ [2,'dsc'] ],
       					"aoColumns": [ { "sType": "lname" }, null, null, {"bSortable": false} ],
       					"sPaginationType": "full_numbers"
       				})/**.columnFilter({
       					sPlaceHolder: "head:before",
       					aoColumns:[
       				         			{ sSelector: "#sender" },
       				     				{ sSelector: "#subject" },
       				     				{ sSelector: "#received", type:"number-range" }
       				     				]}
       								);**/
       				
       				
					function reset(){
	   						$("#sender").val("");
	   						$("#subject").val("");
	   						$("#includes").val("");
	   						$("#excludes").val("");
	   						$("#timestamp").val("");
						}
       				
   					$("#cancel").click(function(){
   						console.log('successfully cancelled.')
   						var table= $("#mailbox > tbody");
   						table.find('tr').each(function(i){
   							var $td = $(this).find('td')
   							$td.each(function(j){
   								$td.closest("tr").show();
   							})
   						})
   						reset();
   					})
   					
   					$("#save").click(function(){
   						var sender = $("#sender").val();
   						var subject = $("#subject").val();
   						var includes = $("#includes").val();
   						var excludes = $("#excludes").val();
   						var start_date = $("#start_date").val();
   						var end_date = $("#end_date").val();
   					})
   					
   					
   					$("#test_search").click(function(){
   						
   						var table= $("#mailbox > tbody");
   						table.find('tr').each(function(i){
   							var $td = $(this).find('td')
   							$td.each(function(j){
   								$td.closest("tr").show();
   							})
   						})
   						/**reset();**/
   						var sender = $("#sender").val().toLowerCase();
   						var subject = $("#subject").val();
   						var includes = $("#includes").val();
   						var excludes = $("#excludes").val();
   						var start_date = $("#start_date").val();
   						var end_date = $("#end_date").val();
   						console.log("hllllli");
   						
   						$("#mailbox").show();
   						
   						var table= $("#mailbox > tbody");
   						table.find('tr').each(function(i){
   							
   							var $td = $(this).find('td')
   							$td.each(function(j){
   								send_val = $td.eq(0).html().toLowerCase();
   								console.log(send_val);
   								sub_val = $td.eq(1).html().toLowerCase();
   								rec_val = $td.eq(2).html().toLowerCase();
   								
   								searcher($td.eq(0), sender);
   								searcher($td.eq(1), subject);
   								
   								
								if (send_val.indexOf(includes) < 0 && sub_val.indexOf(includes) < 0
										&& rec_val.indexOf(includes)<0 ){
									console.log("less than 0")
									$td.eq(0).closest("tr").hide();
								}
								
								/**
								if (send_val.indexOf(excludes) >= 0 || sub_val.indexOf(excludes) >= 0
										|| rec_val.indexOf(excludes)>=0 ){
									$td.eq(0).closest("tr").hide();
								}**/
								
   							})
   							
   						})
 
   						
   					});
   					
       					
  					
					function searcher(td, filter){
  							col_val = td.html().toLowerCase();
						if (filter==""){
							//td.closest("tr").show();
						}
						
						else if (filter.localeCompare(col_val)!=0)
						{
							console.log("testing.");
							td.closest("tr").hide();
						}
  					}
   				});

			</script>
			<style type="text/css" title="currentStyle">
				@import "/iTrust/DataTables/media/css/demo_table.css";		
			</style>
			
			
			
<h1>Apply a Filter</h1>
 

<!--  
		<table cellspacing="0" cellpadding="0" border="0" class="display" ID="Table1">
			<tbody>
				<tr id="filter_global">
					<td align="center">Sender</td>
					<td align="center" id="sender"></td>
				</tr>
				<tr id="filter_col1">
					<td align="center">Subject</td>
					<td align="center" id="subject"></td>
				</tr>
				<tr id="filter_col2">
					<td align="center">Received</td>
					<td align="center" id="received"></td>
				</tr>
			</tbody>
		</table>-->


<form>
  <table>
    <tr>
      <td align="right">Sender:</td>
      <td align="left"><input id="sender" type="text" name="sender" /></td>
    </tr>
    <tr>
      <td align="right">Subject:</td>
      <td align="left"><input type="text" id="subject" name="subject" /></td>
    </tr>
    <tr>
      <td align="right">Includes:</td>
      <td align="left"><input type="text" id="includes" name="includes" /></td>
    </tr>
    <tr>
      <td align="right">Excludes:</td>
      <td align="left"><input type="text" id="excludes" name="excludes" /></td>
    </tr>
    <tr>
      <td align="right">Start Date:</td>
      <td align="left"><input type="text" id="start_date" name="timestamp" /></td>
    </tr>
    <tr>
      <td align="right">End Date:</td>
      <td align="center"><input type="button" value="Select Date" onclick="displayDatePicker('endDate');" /></td>
      <td align="left"><input type="text" id="end_date" name="timestamp" /></td>
    </tr>
    
    <tr>
    	<td align="right"><input type="button" id="test_search" value="Test Search"/></td>
  		<!--  <td align="center"><input type="button" onclick="response.sendRedirect('/iTrust/auth/getPatientID.jsp?forward=hcp/sendMessage.jsp');" id="save" value="Save"/></td>-->
  		<td align="right"><input type="button" id="cancel" value="Cancel"/></td>
  </table>
 </form>



<table id="mailbox" class="display fTable">
	<thead>		
		<tr>
			<th><%= outbox?"Receiver":"Sender" %></th>
			<th>Subject</th>
			<th><%= outbox?"Sent":"Received" %></th>
			<th></th>
		</tr>
	</thead>
	<tbody>
	<% 
	int index=-1;
	for(MessageBean message : messages) {
		String style = "";
		if(message.getRead() == 0) {
			style = "style=\"font-weight: bold;\"";
		}

		if(!outbox || message.getOriginalMessageId()==0){
			index ++; 
			String primaryName = action.getName(outbox?message.getTo():message.getFrom());
			List<MessageBean> ccs = action.getCCdMessages(message.getMessageId());
			String ccNames = "";
			int ccCount = 0;
			for(MessageBean cc:ccs){
				ccCount++;
				long ccMID = cc.getTo();
				ccNames += action.getPersonnelName(ccMID) + ", ";
			}
			ccNames = ccNames.length() > 0?ccNames.substring(0, ccNames.length()-2):ccNames;
			String toString = primaryName;
			if(ccCount>0){
				String ccNameParts[] = ccNames.split(",");
				toString = toString + " (CC'd: ";
				for(int i = 0; i < ccNameParts.length-1; i++) {
					toString += ccNameParts[i] + ", ";
				}
				toString += ccNameParts[ccNameParts.length - 1] + ")";
			}			
			%>					
				<tr <%=style%>>
					<td><%= StringEscapeUtils.escapeHtml("" + ( toString)) %></td>
					<td><%= StringEscapeUtils.escapeHtml("" + ( message.getSubject() )) %></td>
					<td><%= StringEscapeUtils.escapeHtml("" + ( dateFormat.format(message.getSentDate()) )) %></td>
					<td><a href="<%= outbox?"viewMessageOutbox.jsp?msg=" + StringEscapeUtils.escapeHtml("" + ( index )):"viewMessageInbox.jsp?msg=" + StringEscapeUtils.escapeHtml("" + ( index )) %>">Read</a></td>
				</tr>			
			<%
		}
		
	}	
	%>
	
</table>
 

 
 
<%@include file="/footer.jsp" %>