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

<%@page import="java.util.List"%>

<%@page import="edu.ncsu.csc.itrust.action.ViewMyMessagesAction"%>
<%@page import="edu.ncsu.csc.itrust.beans.MessageBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PatientDAO"%>


<%@include file="/global.jsp" %>
<style>
h1{
text-align: center;
}</style>
<%
	pageTitle = "Message Inbox - Apply Filter";
%>

<%
boolean outbox = false;
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
   					console.log("test")
   					$("#error").hide();
       				$("#mailbox").dataTable({
       					"aLengthMenu":[25, 50, 75, 100],
       					"iDisplayLength": 25,
       					"aaColumns": [ [2,'dsc'] ],
       					"aoColumns": [ { "sType": "lname" }, null, null, {"bSortable": false} ],
       					"sPaginationType": "full_numbers"
       				})
       			
       				//convert date strings in date object for easy comparison				
       				function getDateObject(dateString){
       					var date = new Date();
       					if (dateString == ""){
       						return "";
       					}
       					else if (dateString.indexOf("/") >=0){
       						date_list = dateString.split("/");
       						date.setFullYear(parseInt(date_list[2]), parseInt(date_list[0])-1, parseInt(date_list[1]));
       					}
       					else{
       						dateString = dateString.slice(0, -6);
       						date_list = dateString.split("-");
       						date.setFullYear(date_list[0], parseInt(date_list[1])-1, parseInt(date_list[2]));
       					}
       					return date;
       				}
       				
       				//returns false if start date comes after end date
       				function invalidDates(start_date, end_date)
       				{
	       				if (start_date>end_date){
	       					console.log("start date is bigger");
   							$("#error").show();
   							$("#startDate").val("");
   							$("#endDate").val("");
   							return true;
	   					}
	       				else{
	       					return false;
	       				}
       				}
       				
       				//given a start and end filter, returns true if the row should be hidden and false otherwise
       				function compareDates(table, start, end){
       					if (start == "" && end == ""){
       						return false;
       					}
       					table.setHours(0,0,0,0);
       					start.setHours(0,0,0,0);
       					end.setHours(0,0,0,0);
       					if (start == ""){
       						if (table>end){
       							return true;
       						}
       						else{
       							return false;
       						}
       					}
       					else if (end == ""){
       						if (table<start){
       							return true;
       						}
       						else{
       							return false;
       						}
       					}
       					
       					else if(table<start || table>end){
       						return true;
       					}
       					else{
       						return false;
       					}
       				}
       				
					function reset(){
	   						$("#sender").val("");
	   						$("#subject").val("");
	   						$("#hasWords").val("");
	   						$("#notWords").val("");
	   						$("#startDate").val("");
	   						$("#endDate").val("");
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
   						/**Clicking save will already redirect to the inbox/outbox, you just need to
   						store these values in the database. you can use the boolean outbox variable to see if its the
   						inbox or outbox.**/
   						var sender = $("#sender").val();
   						var subject = $("#subject").val();
   						var includes = $("#hasWords").val();
   						var excludes = $("#notWords").val();
   						var start_date = $("#startDate").val();
   						var end_date = $("#endDate").val();
   						
   					
   					})
   					
   					
   					$("#test").click(function(){
   						
   						var table= $("#mailbox > tbody");
   						table.find('tr').each(function(i){
   							var $td = $(this).find('td')
   							$td.each(function(j){
   								$td.closest("tr").show();
   							})
   						})
   						/**reset();**/
   						$("#error").hide();
   						var sender = $("#sender").val().toLowerCase();
   						var subject = $("#subject").val().toLowerCase();
   						var includes = $("#hasWords").val().toLowerCase();
   						var excludes = $("#notWords").val().toLowerCase();
   						var start_date = $("#startDate").val();
   						var end_date = $("#endDate").val();
   						start_date = getDateObject(start_date);
   						end_date = getDateObject(end_date);
   						
   						if (invalidDates(start_date, end_date)){
   							return;
   						}
   						
   						$("#mailbox").show();
   						
   						var table= $("#mailbox > tbody");
   						table.find('tr').each(function(i){
   							
   							var $td = $(this).find('td')
   							$td.each(function(j){
   								send_val = $td.eq(0).html().toLowerCase();
   								sub_val = $td.eq(1).html().toLowerCase();
   								rec_val = $td.eq(2).html().toLowerCase();
   								console.log($td.eq(0).html())
   								searcher($td.eq(0), sender);
   								searcher($td.eq(1), subject);
   								if (compareDates(getDateObject(rec_val), start_date, end_date)){
   									$td.eq(0).closest("tr").hide()
   								}
   								
								if (includes!="" && send_val.indexOf(includes) < 0 && sub_val.indexOf(includes) < 0
										&& rec_val.indexOf(includes)<0 ){
									console.log("less than 0")
									$td.eq(0).closest("tr").hide();
								}
								
								
								if (excludes!="" && (send_val.indexOf(excludes) >= 0 || sub_val.indexOf(excludes) >= 0
										|| rec_val.indexOf(excludes)>=0) ){
									$td.eq(0).closest("tr").hide();
								}
								
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
<div class="filterEdit">
			<div align="center">
				<form method="post" action="messageInbox.jsp?edit=true">
					<div id="error"><span class='iTrustError'>Error: The end date cannot be before the start date.</span></div>
					<table>
						<tr style="text-align: right;">
							<td>
								<label for="sender">Sender: </label>
								<input type="text" name="sender" id="sender" value="" />
							</td>
							<td style="padding-left: 10px; padding-right: 10px;">
								<label for="hasWords">Has the words: </label>
								<input type="text" name="hasWords" id="hasWords" value="" />
							</td>
							<td>
								<label for="startDate">Start Date: </label>
								<input type="text" name="startDate" id="startDate" value="" />
								<input type="button" value="Select Date" onclick="displayDatePicker('startDate');" />
							</td>
						</tr>
						<tr style="text-align: right;">
							<td>
								<label for="subject">Subject: </label>
								<input type="text" name="subject" id="subject" value="" />
							</td>
							<td style="padding-left: 10px; padding-right: 10px;">
								<label for="notWords">Does not have the words: </label>
								<input type="text" name="notWords" id="notWords" value="val from database" />
							</td>
							<td>
								<label for="endDate">End Date: </label>
								<input type="text" name="endDate" id="endDate" value="" />
								<input type="button" value="Select Date" onclick="displayDatePicker('endDate');" />
							</td>
						</tr>
						<tr style="text-align: center;">
							<td colspan="3">
								<input type="button" name="test" id="test" value="Test Filter" />
								<input type="submit" name="save" value="Save" />
								<input type="button" name="cancel" id="cancel" value="Cancel" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>



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