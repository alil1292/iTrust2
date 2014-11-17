<%@taglib uri="/WEB-INF/tags.tld" prefix="itrust" %>
<%@page errorPage="/auth/exceptionHandler.jsp" %>
<%@page import="java.util.List" %>
<%@page import="java.text.DateFormat" %>
<%@page import="edu.ncsu.csc.itrust.action.ObstetricRecordAction" %>
<%@page import="edu.ncsu.csc.itrust.action.ViewPersonnelAction" %>

<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction" %>
<%@page import="edu.ncsu.csc.itrust.beans.PatientBean" %>
<%@page import="edu.ncsu.csc.itrust.beans.PersonnelBean" %>

<%@page import="edu.ncsu.csc.itrust.BeanBuilder"%>
<%@page import="edu.ncsu.csc.itrust.beans.ObstetricRecord" %>
<%@page import="edu.ncsu.csc.itrust.beans.forms.ObstetricRecordForm"%>
<%@page import="edu.ncsu.csc.itrust.beans.forms.PregnanciesRecordForm"%>

<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>


<%@page import="edu.ncsu.csc.itrust.beans.RequiredProceduresBean" %>

<%@include file="/global.jsp" %>

<%
pageTitle = "iTrust - View Patient Obstetric Records";
%>

<%@include file="/header.jsp" %>

<itrust:patientNav thisTitle="Obstetric Records" />

<%
	/* Require a Patient ID first */
	String pidString = (String) session.getAttribute("pid");
	if (pidString == null || 1 > pidString.length()) {
		response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=/iTrust/auth/hcp-uap/viewObstetricRecords.jsp");
		return;
	}
	
	EditPatientAction patientAction = new EditPatientAction(prodDAO,loggedInMID,pidString);
	PatientBean patient = patientAction.getPatient();

	if(patient.getGender().getName().equals("Male")) {	
		%>
			<div align=center>
				<span class="iTrustError">The patient is not eligible for obstetric care.</span>
			</div>
		<%
	} else {
	
	ViewPersonnelAction personnelAction = new ViewPersonnelAction(prodDAO,loggedInMID);
	PersonnelBean person = 	personnelAction.getPersonnel(Long.toString(loggedInMID));	
	/* Get a list of all obsetric records obtained by patient */
	ObstetricRecordAction obAction = new ObstetricRecordAction(prodDAO, pidString, loggedInMID);
	long pid = Long.parseLong(pidString);
	

	String confirm = "";

	if (request.getParameter("formIsFilled") != null) {
		try { 			
			
			confirm = obAction.addObstetricRecord(pid, new BeanBuilder<ObstetricRecordForm>().build(request.getParameterMap(), new ObstetricRecordForm()));
		} catch(FormValidationException e){
	%>
			<div align=center>
				<span class="iTrustError"><%e.printHTML(pageContext.getOut());%></span>
			</div>
			<br />
	<%
		}
	}
	
	if (request.getParameter("pregnancyFormFilled") != null) {
		try { 			
			PregnanciesRecordForm pr = new PregnanciesRecordForm();
			pr.setDeliveryType(request.getParameter("DeliveryType"));
			pr.setNumberOfHoursInLabor(Long.parseLong(request.getParameter("NumberOfHoursInLabor")));
			pr.setNumberOfWeeksPregnant(Long.parseLong(request.getParameter("NumberOfWeeksPregnant")));
			pr.setYearOfConception(Long.parseLong(request.getParameter("YearOfConception")));
	    		
			confirm = obAction.addPregnancyRecord(pid,pr);
		} catch(FormValidationException e){
	%>
			<div align=center>
				<span class="iTrustError"><%e.printHTML(pageContext.getOut());%></span>
			</div>
			<br />
	<%
		}
	}
	
	List<ObstetricRecord> records = obAction.getAllPatientObstetricRecords();
	
%>



<div align="center">
<br>

<style type="text/css" media="print">
       #iTrustHeader2, #iTrustMenu, #iTrustFooter {
               display:none !important;
       }
       #container2 {
       
               background-image:none !important;
       }
       .navigation{
       		   display:none !important;
       }
       body {
			font-family: verdana, arial, sans-serif ;
			font-color: #0000;
			font-size: 12px ;
	   }
 
	   th,td {
	   		font-color: #0000;
			padding: 4px 4px 4px 4px ;
	   }
 
		th {
			font-color: #0000;
			border-bottom: 2px solid #333333 ;
		}
 
		td {
			border-bottom: 1px dotted #999999 ;
			font-color: #0000;
		}
 
		tfoot td {
			border-bottom-width: 0px ;
			font-color: #0000;
			border-top: 2px solid #333333 ;
			padding-top: 20px ;
		}

</style>
<table class="fTable" id="obstetricRecordsReport">
    <tr>
        <th colspan="9">Obstetric Records</th>
    </tr>
    <tr class = "subHeader" colspan="10">
    	<th>Date Created</th>
    </tr>
    <% if(records.size() == 0) { %>
    <tr><td colspan="9">No obstetric records.</td></tr>
    <% } else { for(ObstetricRecord rec : records) { %>
    <tr>
    
        <% DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM); %>
     	 
    	<td>
		<a href="viewSingleObstetricRecord.jsp?obID=<%= StringEscapeUtils.escapeHtml("" + (rec.getId())) %>"> <%= df.format(rec.getDateRecorded()) %> </a>
		</a>
    	</td>
    </tr>
    <% } } %>
</table>

<script type="text/javascript">
function showAddRow(){
	document.getElementById("addRow").style.display="inline";
	document.getElementById("addRowButton").style.display="none";
	document.forms[0].height.focus();
}

function showAddPregnancy(){
	document.getElementById("addPregnancy").style.display="inline";
	document.getElementById("addPregnancyButton").style.display="none";
	document.forms[0].height.focus();
}
</script>

<%
if (!"".equals(confirm)) {
%>
	<div align=center>
		<span class="iTrustMessage"><%= StringEscapeUtils.escapeHtml("" + (confirm)) %></span>
	</div>
<%
}
%>

<br>
<a href="javascript:showAddRow();" id="addRowButton" style="text-decoration:none;" >
		<input id="addRowButton" type=button value="Add Record" onClick="showAddRow();"> 
</a>

<a href="javascript:showAddPregnancy();" id="addPregnancyButton" style="text-decoration:none;" >
		<input id="addPregnancyButton" type=button value="Add Pregnancy" onClick="showAddPregnancy();"> 
</a>


<%

if (!person.getSpecialty().equals("OB/GYN")) {
%>
	<script type="text/javascript">
		document.getElementById("addRowButton").style.display="none";
		document.getElementById("addPregnancyButton").style.display="none";
	</script>
<%
}
%>


<br />

<div id="addRow" style="display: none;" align=center>
<form action="viewObstetricRecords.jsp" id="viewObstetric" name="viewObstetric" method="post">
<table class="fTable" align="center">
	<tr>
		<th colspan="2" style="background-color:silver;">Record Information</th>
	</tr>	
	<tr>
		<td class="subHeader">LMP:
			<input name="LMP" value=""/>
			<input type="button" value="Select Date" onclick="displayDatePicker('LMP');"/>
		</td>
	</tr>
</table>

<br />
<input type="submit" name="formIsFilled" value="Add Record">
</form>
</div>

<br>

<div id="addPregnancy" style="display: none;" align=center>
	<form action="viewObstetricRecords.jsp" id="pregnancyForm" name="pregnancyForm" method="post">
	<table class="fTable" align="center">
		<tr>
			<th colspan="2" style="background-color:silver;">Pregnancy Information</th>
		</tr>	
		
		<tr>
			<td>Delivery Type
				<input name="DeliveryType" value="" type="text">
			</td>	
		</tr>
		
		<tr>
	    	<td>Hours in labor
	    		<input name="NumberOfHoursInLabor" value="" type="text">
	    	</td>
	    </tr>
	    
	    <tr>
	    	<td>Weeks pregnant
	    		<input name="NumberOfWeeksPregnant" value="" type="text">
	    	</td>
	    </tr>
	    
	    <tr>
	    	<td>Year of conception
	    		<input name="YearOfConception" value="" type="text">
	    	</td>
	    </tr>
		
	</table>
	
	<br />
	<input type="submit" name="pregnancyFormFilled" value="Add Pregnancy">
	</form>
</div>


	
</div>

	
<%		
	}
%>
	
<%@include file="/footer.jsp"%>