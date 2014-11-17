<%@taglib uri="/WEB-INF/tags.tld" prefix="itrust" %>
<%@page errorPage="/auth/exceptionHandler.jsp" %>
<%@page import="java.util.List" %>
<%@page import="java.text.DateFormat" %>
<%@page import="edu.ncsu.csc.itrust.action.ObstetricRecordAction" %>
<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction" %>
<%@page import="edu.ncsu.csc.itrust.beans.PatientBean" %>
<%@page import="edu.ncsu.csc.itrust.BeanBuilder"%>
<%@page import="edu.ncsu.csc.itrust.beans.ObstetricRecord" %>
<%@page import="edu.ncsu.csc.itrust.beans.Pregnancy" %>

<%@page import="edu.ncsu.csc.itrust.beans.forms.ObstetricRecordForm"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>


<%@page import="edu.ncsu.csc.itrust.beans.RequiredProceduresBean" %>

<%@include file="/global.jsp" %>

<%
pageTitle = "iTrust - View Obstetric Record";
%>

<%@include file="/header.jsp" %>

<itrust:patientNav thisTitle="Obstetric Record" />

<%
		
	// If ob was clicked show it
	String obIDString = request.getParameter("obID");	
	long obID = Long.parseLong(obIDString);
	String pidString = (String)session.getAttribute("pid");
	
	if (pidString == null || pidString.length() == 0) {
	    response.sendRedirect("/iTrust/auth/ViewObstetricRecords.jsp?");
	    return;
	}
	
	
	/* Get a list of all obsetric records obtained by patient */
	ObstetricRecordAction obAction = new ObstetricRecordAction(prodDAO, pidString, loggedInMID);
	ObstetricRecord record = obAction.getObstetricRecordForID(obID);

	/*
	hr.setDeliveryType("Miscarriage");
	hr.setNumberOfHoursInLabor(1);
	hr.setNumberOfWeeksPregnant(231);
	hr.setYearOfConception(2000);
	
	String confirm = action.addPregnancyRecord(2L, hr);
	
	*/
	
	
	List<Pregnancy> pregnancies = obAction.getAllPatientPregnancies();
	
	
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
<table class="fTable" id="obstetricRecordReport">
    <tr>
        <th colspan="9">Obstetric Record <%=record.getId()%></th>
    </tr>
    <tr class = "subHeader" colspan="10">
    	<th>Date Created</th>
    	<th>LMP</th>
    	<th>EDD</th>
    	<th>Weeks Pregnant</th>
    	
    </tr>
    <% if(record == null) { %>
    <tr><td colspan="9">No such obstetric record.</td></tr>
    <% } else {%>
    <tr>
    
        <% DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM); %>
    	<td>
		 	 <%= df.format(record.getDateRecorded()) %>
    	</td>
    	
    	<td>
			 <%= record.getLMPDateStr() %>
    	</td>
    	
    	<td> 
			 <%= record.getEDD() %>
    	</td>
    	
    	<td> 
			 <%= record.getWeeksOfPregnancy()/10 + " weeks " + record.getWeeksOfPregnancy()%10 + " days" %>
    	</td>
    	
    </tr>
    
    <tr> </tr>
    <% } %>
</table>

<br>

<table class="fTable" id="pregnanciesReport">
    <tr>
        <th colspan="9">Pregnancies</th>
    </tr>
    <tr class = "subHeader" colspan="10">
    	<th>Delivery Type</th>
    	<th>Hours in labor</th>
    	<th>Weeks pregnant</th>
    	<th>Year of conception</th>
    </tr>
    <% if(pregnancies.size() == 0) { %>
    <tr><td colspan="9">No pregnancies.</td></tr>
    <% } else { for(Pregnancy p : pregnancies) { %>
    <tr>
    
        <td>
		 	 <%= p.getDeliveryType() %>
    	</td>
    	
    	<td>
			 <%= p.getNumberOfHoursInLabor() %>
    	</td>
    	
    	<td> 
			 <%= p.getNumberOfWeeksPregnant()/10 + " weeks " + p.getNumberOfWeeksPregnant()%10 + " days" %>
    	</td>
    	
    	<td> 
			 <%= p.getYearOfConception() %>
    	</td>
    	
    </tr>
    <% } } %>
</table>

<br>

<a href="viewObstetricRecords.jsp"> Back </a>
	
</div>
<%@include file="/footer.jsp"%>