
<%@page import="java.util.List"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="edu.ncsu.csc.itrust.beans.MessageBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPersonnelAction"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PersonnelDAO"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyMessagesAction"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPersonnelAction"%>

<%
boolean outbox=(Boolean)session.getAttribute("outbox");
boolean isHCP=(Boolean)session.getAttribute("isHCP");
%>

			<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
			<script src="/iTrust/DataTables/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
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
   					
       				$("#mailbox").dataTable( {
       					"aLengthMenu":[25, 50, 75, 100],
       					"iDisplayLength": 25,
       					"aaColumns": [ [2,'dsc'] ],
       					"aoColumns": [ { "sType": "lname" }, null, null, {"bSortable": false} ],
       					"sPaginationType": "full_numbers"
       				});
       				applyFilter()
   				});
   				
				//if cell value does not match filter, hide the row
				function searcher(td, filter){
					col_val = td.html().toLowerCase();
					if (filter.localeCompare(col_val)!=0)
					{
						td.closest("tr").hide();
					}
				}
				
   				//convert date strings in date object for easy comparison				
   				function getDateObject(dateString){
   					var date = new Date();
   					if (dateString == ""){
   						console.log("NOTHING")
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
   				
   				
   				function applyFilter(){
   					/**Each variable should be the value from the database, right now are just example strings for testing. You can
   					use the outbox boolean variable initialized above to tell if its the outbox or inbox. Also the 
   					getDateObject converts a string to a javascript date object, so maybe it would just be easier to store the
   					date as a string in the database instead of timestamp, so like "1/30/2014" **/
   					//var sender = "random person";
					//var subject = "appointment";
					//var includes = "point"
					//var excludes = ""
					//var start_date = ""
					//var end_date = ""
					//start_date = getDateObject(start_date);
					//end_date = getDateObject(end_date);
					var table= $("#mailbox > tbody");
					table.find('tr').each(function(i){
						var $td = $(this).find('td')
						$td.each(function(j){
							send_val = $td.eq(0).html().toLowerCase();
							sub_val = $td.eq(1).html().toLowerCase();
							rec_val = $td.eq(2).html().toLowerCase();
							
							/**
							Once the variables are set, you can uncomment this
							
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
							}**/
							
						})
					})
   				}
       				
       				
   				
			</script>
			<style type="text/css" title="currentStyle">
				@import "/iTrust/DataTables/media/css/demo_table.css";		
			</style>

<%



String pageName="messageInbox.jsp";
if(outbox){
	pageName="messageOutbox.jsp";
}
	
PersonnelDAO personnelDAO = new PersonnelDAO(prodDAO);
PatientDAO patientDAO = new PatientDAO(prodDAO);

DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

ViewMyMessagesAction action = new ViewMyMessagesAction(prodDAO, loggedInMID.longValue());

List<MessageBean> messages = outbox?action.getAllMySentMessages():action.getAllMyMessages();
session.setAttribute("messages", messages);


if(messages.size() > 0) { %>
<a href="/iTrust/auth/hcp-patient/applyFilter.jsp?mail=<%= outbox?"out":"in" %>">Apply Filter</a>
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
	</tbody>
</table>
<%} else { %>
	<div>
		<i>You have no messages</i>
	</div>
<%	} %>