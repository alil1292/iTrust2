<%@page import="edu.ncsu.csc.itrust.enums.TransactionType"%>
<%@page import="edu.ncsu.csc.itrust.beans.OperationalProfile"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.TransactionDAO"%>
<%@page import="edu.ncsu.csc.itrust.beans.TransactionBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.DAOFactory"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PersonnelDAO"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.beans.PersonnelBean"%>

<%@include file="/global.jsp" %>


<%
pageTitle = "iTrust - View Transaction Logs";
%>

<%@include file="/header.jsp" %>

<div class="page-header"><h1>View Transaction Logs</h1></div>

<form action="viewTransactionLogs.jsp" method="post">
<input type="hidden" name="formIsFilled" value="true"><br />
<table class="fTable">
	<tr>
		<th colspan=2>Filter Transactions</th>
	</tr>
	<tr>
		<td class="subHeaderVertical">Logged-in User</td>
		<td><select name="loggedInRole">
		<option value="all">All</option>
		<option value="patient">Patient</option>
		<option value="er">ER</option>
		<option value="hcp">HCP</option>
		<option value="uap">UAP</option>
		<option value="lt">LT</option>
		<option value="admin">Admin</option>
		<option value="pha">PHA</option>
		<option value="tester">Tester</option>
	</tr>
	<tr>
		<td class="subHeaderVertical">Secondary User</td>
		<td><select name="secondaryRole">
		<option value="all">All</option>
		<option value="patient">Patient</option>
		<option value="er">ER</option>
		<option value="hcp">HCP</option>
		<option value="uap">UAP</option>
		<option value="lt">LT</option>
		<option value="admin">Admin</option>
		<option value="pha">PHA</option>
		<option value="tester">Tester</option>
	</tr>
	<tr>
		<td class="subHeaderVertical">Starting Date:</td>
		<td><input type="text" name="startingDate" value="">
            <input type="button" value="Select Date" onclick="displayDatePicker('startingDate');" /><br /><br /></td> 
	</tr>
	<tr>
		<td class="subHeaderVertical">Ending Date:</td>
		<td><input type="text" name="endingDate" value="">
            <input type="button" value="Select Date" onclick="displayDatePicker('endingDate');" /><br /><br /></td></td> 	 
	</tr>
	<tr>
		<td class="subHeaderVertical">Transaction Type</td>
		<td><select name="transactionType">
		<option value="0">All</option>
		<option value="1">LOGIN_FAILURE</option>
		<option value="10">HOME_VIEW</option>
		<option value="20">UNCAUGHT_EXCEPTION</option>
		<option value="30">GLOBAL_PREFERENCES_VIEW</option>
		<option value="31">GLOBAL_PREFERENCES_EDIT</option>
		<option value="32">USER_PREFERENCES_VIEW</option>
		<option value="33">USER_PREFERENCES_EDIT</option>
		<option value="100">PATIENT_CREATE</option>
		<option value="101">PATIENT_DISABLE</option>
		<option value="102">PATIENT_DEACTIVATE</option>
		<option value="103">PATIENT_ACTIVATE</option>
		<option value="200">LHCP_CREATE</option>
		<option value="201">LHCP_EDIT</option>
		<option value="202">LHCP_DISABLE</option>
		<option value="210">ER_CREATE</option>
		<option value="211">ER_EDIT</option>
		<option value="212">ER_DISABLE</option>
		<option value="220">PHA_CREATE</option>
		<option value="221">PHA_EDIT</option>
		<option value="222">PHA_DISABLE</option>
		<option value="230">LHCP_ASSIGN_HOSPITAL</option>
		<option value="231">LHCP_REMOVE_HOSPITAL</option>
		<option value="232">LT_ASSIGN_HOSPITAL</option>
		<option value="233">LT_REMOVE_HOSPITAL</option>
		<option value="240">UAP_CREATE</option>
		<option value="241">UAP_EDIT</option>
		<option value="242">UAP_DISABLE</option>
		<option value="250">PERSONNEL_VIEW</option>
		<option value="260">LT_CREATE</option>
		<option value="261">LT_EDIT</option>
		<option value="262">LT_DISABLE</option>
		<option value="300">LOGIN_SUCCESS</option>
		<option value="301">LOGOUT</option>
		<option value="302">LOGOUT_INACTIVE</option>
		<option value="310">PASSWORD_RESET</option>
		<option value="400">DEMOGRAPHICS_VIEW</option>
		<option value="410">DEMOGRAPHICS_EDIT</option>
		<option value="411">PATIENT_PHOTO_UPLOAD</option>
		<option value="412">PATIENT_PHOTO_REMOVE</option>
		<option value="421">DEPEND_DEMOGRAPHICS_EDIT</option>
		<option value="600">LHCP_VIEW</option>
		<option value="601">LHCP_DECLARE_DLHCP</option>
		<option value="602">LHCP_UNDECLARE_DLHCP</option>
		<option value="800">ACCESS_LOG_VIEW</option>
		<option value="900">MEDICAL_RECORD_VIEW</option>
		<option value="1000">PATIENT_HEALTH_INFORMATION_VIEW</option>
		<option value="1001">PATIENT_HEALTH_INFORMATION_EDIT</option>
		<option value="1002">BASIC_HEALTH_CHARTS_VIEW</option>
		<option value="1100">OFFICE_VISIT_CREATE</option>
		<option value="1101">OFFICE_VISIT_VIEW</option>
		<option value="1102">OFFICE_VISIT_EDIT</option>
		<option value="1110">PRESCRIPTION_ADD</option>
		<option value="1111">PRESCRIPTION_EDIT</option>
		<option value="1112">PRESCRIPTION_REMOVE</option>
		<option value="1120">LAB_PROCEDURE_ADD</option>
		<option value="1121">LAB_PROCEDURE_EDIT</option>
		<option value="1122">LAB_PROCEDURE_REMOVE</option>
		<option value="1130">DIAGNOSIS_ADD</option>
		<option value="1132">DIAGNOSIS_REMOVE</option>
		<option value="1133">DIAGNOSIS_URL_EDIT</option>
		<option value="1140">PROCEDURE_ADD</option>
		<option value="1141">PROCEDURE_EDIT</option>
		<option value="1142">PROCEDURE_REMOVE</option>
		<option value="1150">IMMUNIZATION_ADD</option>
		<option value="1152">IMMUNIZATION_REMOVE</option>
		<option value="1160">OFFICE_VISIT_BILLED</option>
		<option value="1200">OPERATIONAL_PROFILE_VIEW</option>
		<option value="1300">HEALTH_REPRESENTATIVE_DECLARE</option>
		<option value="1301">HEALTH_REPRESENTATIVE_UNDECLARE</option>
		<option value="1500">MEDICAL_PROCEDURE_CODE_ADD</option>
		<option value="1501">MEDICAL_PROCEDURE_CODE_VIEW</option>
		<option value="1502">MEDICAL_PROCEDURE_CODE_EDIT</option>
		<option value="1510">IMMUNIZATION_CODE_ADD</option>
		<option value="1511">IMMUNIZATION_CODE_VIEW</option>
		<option value="1512">IMMUNIZATION_CODE_EDIT</option>
		<option value="1520">DIAGNOSIS_CODE_ADD</option>
		<option value="1521">DIAGNOSIS_CODE_VIEW</option>
		<option value="1522">DIAGNOSIS_CODE_EDIT</option>
		<option value="1530">DRUG_CODE_ADD</option>
		<option value="1531">DRUG_CODE_VIEW</option>
		<option value="1532">DRUG_CODE_EDIT</option>
		<option value="1533">DRUG_CODE_REMOVE</option>
		<option value="1540">LOINC_CODE_ADD</option>
		<option value="1541">LOINC_CODE_VIEW</option>
		<option value="1542">LOINC_CODE_EDIT</option>
		<option value="1549">LOINC_CODE_FILE_ADD</option>
		<option value="1600">RISK_FACTOR_VIEW</option>
		<option value="1700">PATIENT_REMINDERS_VIEW</option>
		<option value="1800">HOSPITAL_LISTING_ADD</option>
		<option value="1801">HOSPITAL_LISTING_VIEW</option>
		<option value="1802">HOSPITAL_LISTING_EDIT</option>
		<option value="1900">PRESCRIPTION_REPORT_VIEW</option>
		<option value="2000">DEATH_TRENDS_VIEW</option>
		<option value="2100">EMERGENCY_REPORT_CREATE</option>
		<option value="2101">EMERGENCY_REPORT_VIEW</option>
		<option value="2200">APPOINTMENT_TYPE_ADD</option>
		<option value="2201">APPOINTMENT_TYPE_VIEW</option>
		<option value="2202">APPOINTMENT_TYPE_EDIT</option>
		<option value="2210">APPOINTMENT_ADD</option>
		<option value="2211">APPOINTMENT_VIEW</option>
		<option value="2212">APPOINTMENT_EDIT</option>
		<option value="2213">APPOINTMENT_REMOVE</option>
		<option value="2220">APPOINTMENT_ALL_VIEW</option>
		<option value="2230">APPOINTMENT_CONFLICT_OVERRIDE</option>
		<option value="2240">APPOINTMENT_REQUEST_SUBMITTED</option>
		<option value="2250">APPOINTMENT_REQUEST_APPROVED</option>
		<option value="2251">APPOINTMENT_REQUEST_REJECTED</option>
		<option value="2260">APPOINTMENT_REQUEST_VIEW</option>
		<option value="2300">COMPREHENSIVE_REPORT_VIEW</option>
		<option value="2301">COMPREHENSIVE_REPORT_ADD</option>
		<option value="2400">SATISFACTION_SURVEY_TAKE</option>
		<option value="2500">SATISFACTION_SURVEY_VIEW</option>
		<option value="2600">LAB_RESULTS_UNASSIGNED</option>
		<option value="2601">LAB_RESULTS_CREATE</option>
		<option value="2602">LAB_RESULTS_VIEW</option>
		<option value="2603">LAB_RESULTS_REASSIGN</option>
		<option value="2604">LAB_RESULTS_REMOVE</option>
		<option value="2605">LAB_RESULTS_ADD_COMMENTARY</option>
		<option value="2606">LAB_RESULTS_VIEW_QUEUE</option>
		<option value="2607">LAB_RESULTS_RECORD</option>
		<option value="2608">LAB_RESULTS_RECEIVED</option>
		<option value="2700">EMAIL_SEND</option>
		<option value="2710">EMAIL_HISTORY_VIEW</option>
		<option value="2800">PATIENT_LIST_VIEW</option>
		<option value="2900">EXPERIENCED_LHCP_FIND</option>
		<option value="3000">MESSAGE_SEND</option>
		<option value="3001">MESSAGE_VIEW</option>
		<option value="3010">INBOX_VIEW</option>
		<option value="3011">OUTBOX_VIEW</option>
		<option value="3100">PATIENT_FIND_LHCP_FOR_RENEWAL</option>
		<option value="3110">EXPIRED_PRESCRIPTION_VIEW</option>
		<option value="3200">PRECONFIRM_PRESCRIPTION_RENEWAL</option>
		<option value="3210">DIAGNOSES_LIST_VIEW</option>
		<option value="3300">CONSULTATION_REFERRAL_CREATE</option>
		<option value="3310">CONSULTATION_REFERRAL_VIEW</option>
		<option value="3311">CONSULTATION_REFERRAL_EDIT</option>
		<option value="3312">CONSULTATION_REFERRAL_CANCEL</option>
		<option value="3400">PATIENT_LIST_ADD</option>
		<option value="3401">PATIENT_LIST_EDIT</option>
		<option value="3402">PATIENT_LIST_REMOVE</option>
		<option value="3410">TELEMEDICINE_DATA_REPORT</option>
		<option value="3420">TELEMEDICINE_DATA_VIEW</option>
		<option value="3500">ADVERSE_EVENT_REPORT</option>
		<option value="3600">ADVERSE_EVENT_VIEW</option>
		<option value="3601">ADVERSE_EVENT_REMOVE</option>
		<option value="3602">ADVERSE_EVENT_REQUEST_MORE</option>
		<option value="3603">ADVERSE_EVENT_CHART_VIEW</option>
		<option value="3700">OVERRIDE_INTERACTION_WARNING</option>
		<option value="3710">OVERRIDE_CODE_ADD</option>
		<option value="3711">OVERRIDE_CODE_EDIT</option>
		<option value="3800">DRUG_INTERACTION_ADD</option>
		<option value="3801">DRUG_INTERACTION_EDIT</option>
		<option value="3802">DRUG_INTERACTION_DELETE</option>
		<option value="4000">CALENDAR_VIEW</option>
		<option value="4010">UPCOMING_APPOINTMENTS_VIEW</option>
		<option value="4200">NOTIFICATIONS_VIEW</option>
		<option value="4300">ACTIVITY_FEED_VIEW</option>
		<option value="4400">PATIENT_INSTRUCTIONS_ADD</option>
		<option value="4401">PATIENT_INSTRUCTIONS_EDIT</option>
		<option value="4402">PATIENT_INSTRUCTIONS_DELETE</option>
		<option value="4403">PATIENT_INSTRUCTIONS_VIEW</option>
		<option value="4500">DIAGNOSIS_TRENDS_VIEW</option>
		<option value="4600">DIAGNOSIS_EPIDEMICS_VIEW</option>
		<option value="4601">GROUP_REPORT_VIEW</option>
		<option value="4700">FIND_EXPERT</option>
		<option value="4701">FIND_EXPERT_ZIP_ERROR</option>
		<option value="4800">PATIENT_ASSIGNED_TO_ROOM</option>
		<option value="4801">PATIENT_REMOVED_FROM_ROOM</option>
		<option value="4802">ROOMS_FULL</option>
		<option value="5100">CREATE_BASIC_HEALTH_METRICS</option>
		<option value="5101">VIEW_BASIC_HEALTH_METRICS</option>
		<option value="5102">EDIT_BASIC_HEALTH_METRICS</option>
		<option value="5103">REMOVE_BASIC_HEALTH_METRICS</option>
		<option value="5200">PATIENT_VIEW_BASIC_HEALTH_METRICS</option>
		<option value="5201">HCP_VIEW_BASIC_HEALTH_METRICS</option>
		<option value="5301">HCP_VIEW_PERCENTILES_CHART</option>
		<option value="5300">PATIENT_VIEW_PERCENTILES_CHART</option>
		<option value="5302">ADMIN_UPLOAD_CDCMETRICS</option>
		<option value="5700">PASSWORD_CHANGE</option>
		<option value="5701">PASSWORD_CHANGE_FAILED</option>
		<option value="5500">IMMUNIZATION_REPORT_PATIENT_VIEW</option>
		<option value="5501">IMMUNIZATION_REPORT_HCP_VIEW</option>
		<option value="5600">PATIENT_RELEASE_HEALTH_RECORDS</option>
		<option value="5601">PATIENT_VIEW_RELEASE_REQUEST</option>
		<option value="5602">HCP_RELEASE_APPROVAL</option>
		<option value="5603">HCP_RELEASE_DENIAL</option>
		<option value="5604">UAP_RELEASE_APPROVAL</option>
		<option value="5605">UAP_RELEASE_DENIAL</option>
		<option value="5800">HCP_CREATED_DEPENDENT_PATIENT</option>
		<option value="5801">HCP_CHANGE_PATIENT_DEPENDENCY</option>
		<option value="5900">PATIENT_VIEW_DEPENDENT_REQUESTS</option>
		<option value="5901">PATIENT_REQUEST_DEPEDENT_RECORDS</option>
		<option value="6000">PATIENT_BILLS_VIEW_ALL</option>
		<option value="6001">PATIENT_VIEWS_BILL</option>
		<option value="6002">PATIENT_PAYS_BILL</option>
		<option value="6003">PATIENT_SUBMITS_INSURANCE</option>
		<option value="6004">UAP_INITIAL_APPROVAL</option>
		<option value="6005">UAP_INITIAL_DENIAL</option>
		<option value="6006">UAP_SECOND_APPROVAL</option>
		<option value="6007">UAP_SECOND_DENIAL</option>
		<option value="6008">PATIENT_RESUBMITS_INSURANCE</option>
		<option value="6100">VIEW_EXPERT_SEARCH_NAME</option>
		<option value="6101">VIEW_REVIEWS</option>
		<option value="6102">SUBMIT_REVIEW</option>     
	</tr>
</table>
<br />
<input type="submit" style="font-size: 16pt; font-weight: bold;" value="View">
<input type="submit" style="font-size: 16pt; font-weight: bold;" value="Summarize">
<br />
</form>
<br />

<%
	boolean formIsFilled = request.getParameter("formIsFilled") != null
	&& request.getParameter("formIsFilled").equals("true");

	if (formIsFilled) {			
		String loggedInRole = request.getParameter("loggedInRole");
		String secondaryRole = request.getParameter("secondaryRole");
		String startingDate = request.getParameter("startingDate");
		String endingDate = request.getParameter("endingDate");
		String transactionCode = request.getParameter("transactionType");
		int tCode = tCode = Integer.parseInt(transactionCode);
		
	    String year = "";
	    String month = "";
	    String day = "";
	  
	    if(startingDate != null  && !startingDate.equals(""))
	    {
	    	month = startingDate.substring(0,2);
	    	day = startingDate.substring(3,5);
	    	year = startingDate.substring(6,startingDate.length());
	       
	    }
	    else
	    {
	    	month = "01";
	    	day = "01";
	    	year = "2000";
	    }
	    startingDate = year + "-" + month + "-" + day + " 00:00:00";
	    Timestamp sDate = Timestamp.valueOf(startingDate);
	    
	    if(endingDate != null  && !endingDate.equals(""))
	    {
	    	month = endingDate.substring(0,2);
	    	day = endingDate.substring(3,5);
	    	year = endingDate.substring(6,endingDate.length());
	    }
	    else
	    {
	    	month = "01";
	    	day = "01";
	    	year = "2020";
	    }
	    endingDate = year + "-" + month + "-" + day + " 23:59:59";
	    Timestamp eDate = Timestamp.valueOf(endingDate); 
		
%>
    <table border=1>
	<tr>
		<th>ID></th>
		<th>Time Logged</th>
		<th>Type</th>
		<th>Code</th>
		<th>Description</th>
		<th>Logged in User MID</th>
		<th>Secondary MID</th>
		<th>Extra Info</th>
	</tr>
<% 
 	TransactionDAO pDAO = DAOFactory.getProductionInstance().getTransactionDAO();
	
	List<TransactionBean> list = pDAO.getTransactionsWithCriterias(loggedInRole, secondaryRole, tCode, sDate, eDate);
	for (TransactionBean t : list) {  
 %>
 
	<tr>
	<td><%= StringEscapeUtils.escapeHtml("" + (t.getTransactionID())) %></td>
	<td><%= StringEscapeUtils.escapeHtml("" + (t.getTimeLogged())) %></td>
	<td><%= StringEscapeUtils.escapeHtml("" + (t.getTransactionType().name())) %></td>
	<td><%= StringEscapeUtils.escapeHtml("" + (t.getTransactionType().getCode())) %></td>
	<td><%= StringEscapeUtils.escapeHtml("" + (t.getTransactionType().getDescription())) %></td>
	<td><%= StringEscapeUtils.escapeHtml("" + (t.getLoggedInMID())) %></td>
	<td><%= StringEscapeUtils.escapeHtml("" + (t.getSecondaryMID())) %></td>
	<td><%= StringEscapeUtils.escapeHtml("" + (t.getAddedInfo())) %></td>
</tr> 
<%
	}
%>
</table>
<%
	}
%>
<%@include file="/footer.jsp" %>
