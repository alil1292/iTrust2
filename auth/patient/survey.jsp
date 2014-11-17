<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@page import="edu.ncsu.csc.itrust.beans.SurveyBean"%>
<%@page import="edu.ncsu.csc.itrust.action.SurveyAction"%>
<%@page import="edu.ncsu.csc.itrust.BeanBuilder"%>
<%@page import="edu.ncsu.csc.itrust.exception.ITrustException"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="java.util.Date"%>
<%@page import="edu.ncsu.csc.itrust.beans.ReviewsBean"%>
<%@page import="org.jfree.ui.Align"%>
<%@page import="edu.ncsu.csc.itrust.action.ReviewsAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ZipCodeAction"%>
<%@page errorPage="/auth/exceptionHandler.jsp" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="edu.ncsu.csc.itrust.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.action.FindExpertAction"%>
<%@page import="edu.ncsu.csc.itrust.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.beans.HospitalBean"%>
<%@page import="edu.ncsu.csc.itrust.beans.PersonnelBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PatientDAO"%>
<%@page import="java.util.HashMap"%>


<%@taglib uri="/WEB-INF/tags.tld" prefix="itrust"%>

<%@include file="/global.jsp"%>

<%
	pageTitle = "iTrust - Patient Survey";
%>

<%@include file="/header.jsp"%>

<%

//PROCESS HCP RATING AND COMMENTS

String mid = request.getParameter("expertID");
String rating = null;
long expertID = -1;
if(mid != null){
	expertID = Long.parseLong(mid);
	session.setAttribute("expertID", mid);
	loggingAction.logEvent(TransactionType.VIEW_REVIEWS, loggedInMID, expertID, "");
}
if(session.getAttribute("expertID") != null){
	try {
		expertID = Long.parseLong((String)session.getAttribute("expertID"));
	} catch (NumberFormatException e){
		%> <h1>User does not exist! Try logging in again.</h1> <%
		return;
	}
}

	ReviewsAction reviewsAction = new ReviewsAction(prodDAO, loggedInMID.longValue()); 
	String reviewTitle = request.getParameter("title");
	String reviewRating = request.getParameter("rating");
	String description = request.getParameter("description");
	
	// Prevent profanity from entering the comment submissions.
	if (description!= null && description!="") {
		String[] profanity = new String[]{"fuck", "shit", "damn", "ass", "bitch", "bastard", "faggot", "nigger", "spick", "piss"};
		for (String word: profanity){
			if (description.toLowerCase().contains(word)) {
				%><h3>Please do not use profanity in your comment submission.
				<br /><br />
				Press the back button to clean up your language.</h3><%
				return;
			}
		}
	}
	if(reviewTitle != null && reviewRating != null && description != null)
	{
		loggingAction.logEvent(TransactionType.SUBMIT_REVIEW, loggedInMID, expertID, "");
		ReviewsBean review = new ReviewsBean();
		review.setDescriptiveReview(description);
		review.setRating(Integer.parseInt(reviewRating));
		review.setTitle(reviewTitle);
		review.setMID(loggedInMID.longValue());
		review.setPID(expertID);
		review.setDateOfReview(new Date());
		
		reviewsAction.addReview(review);
		
	}


//END PROCESSING OF HCP RATING AND COMMENTS



SurveyAction action = new SurveyAction(prodDAO);
SurveyBean surveyBean = null;
long visitID = 0;
//get office visit ID from previous JSP
String visitIDStr = request.getParameter("ovID");
String visitDateStr = request.getParameter("ovDate");


if(visitIDStr != null && !visitIDStr.equals("")) {
	try {
		visitID = Long.parseLong(visitIDStr);

	} catch(Exception e) {
		
	}
}

boolean formIsFilled = request.getParameter("formIsFilled") != null
&& request.getParameter("formIsFilled").equals("true");

if(formIsFilled) {
	surveyBean = new BeanBuilder<SurveyBean>().build(request.getParameterMap(), new SurveyBean());
	surveyBean.setVisitID(visitID);
	
	String waitingMinutes = request.getParameter("waitingMinutesString");
	if (waitingMinutes != null && !waitingMinutes.equals(""))
		surveyBean.setWaitingRoomMinutes(Integer.parseInt(waitingMinutes));
	
	String examMinutes = request.getParameter("examMinutesString");
	if (examMinutes != null && !examMinutes.equals(""))
		surveyBean.setExamRoomMinutes(Integer.parseInt(examMinutes));
	
	//update satisfaction number in bean
	if (request.getParameter("Satradios") != null) {
		if (request.getParameter("Satradios").equals("satRadio5")) {
	surveyBean.setVisitSatisfaction(5);
		} if (request.getParameter("Satradios").equals("satRadio4")) {
	surveyBean.setVisitSatisfaction(4);
		} if (request.getParameter("Satradios").equals("satRadio3")) {
	surveyBean.setVisitSatisfaction(3);
		} if (request.getParameter("Satradios").equals("satRadio2")) {
	surveyBean.setVisitSatisfaction(2);
		} if (request.getParameter("Satradios").equals("satRadio1")) {
	surveyBean.setVisitSatisfaction(1);
		}
	}

    //update treatment number in bean
	if (request.getParameter("Treradios") != null) {
		if (request.getParameter("Treradios").equals("treRadio5")) {
	surveyBean.setTreatmentSatisfaction(5);
		} if (request.getParameter("Treradios").equals("treRadio4")) {
	surveyBean.setTreatmentSatisfaction(4);
		} if (request.getParameter("Treradios").equals("treRadio3")) {
	surveyBean.setTreatmentSatisfaction(3);
		} if (request.getParameter("Treradios").equals("treRadio2")) {
	surveyBean.setTreatmentSatisfaction(2);
		} if (request.getParameter("Treradios").equals("treRadio1")) {
	surveyBean.setTreatmentSatisfaction(1);
		}
	}
    
    try {
    	//add survey data
    	action.addSurvey(surveyBean, visitID);
		loggingAction.logEvent(TransactionType.SATISFACTION_SURVEY_TAKE, loggedInMID.longValue(), action.getPatientMID(visitID), "Office visit ID for completed survey is: "+visitIDStr);
		response.sendRedirect("viewMyRecords.jsp?message=Survey%20Successfully%20Submitted");
	} catch(Exception e) {
     	%><span ><%=StringEscapeUtils.escapeHtml(e.getMessage())%></span><%
	  }
} 
else {
	if(visitDateStr.contains("<")) 
		throw new ITrustException("Illegal parameter for ovDate.");
}




%>



<div id=Header>
<h1>iTrust Patient Survey for Office Visit on <%= StringEscapeUtils.escapeHtml("" + (visitDateStr )) %></h1></div>
<div id=Content>

<form action="survey.jsp" method="post" name="mainForm">
<input type="hidden" name="formIsFilled" value="true"> 
<input type="hidden" name="ovID" value="<%= StringEscapeUtils.escapeHtml("" + (visitIDStr)) %>">
<h3>How long did you have to wait during your visit?</h3>
<table>
	<tr>
		<td>In the waiting room?</td>
		<td><input type="text" name="waitingMinutesString" maxlength =3 size=3 /> </td>
		<td>1-999 minutes</td>
	</tr>
	
	<tr>
		<td>In the examination room <br />before seeing your physician?</td>
		<td><input type="text" name="examMinutesString" maxlength =3 size=3 /> </td>
		<td>1-999 minutes</td>
	</tr>
</table>

<h3>How satisfied were you with your office visit?</h3>
<table><tr><td>
<tr><td><input align="left" type="radio" name="Satradios" value="satRadio5">
Very Satisfied (5) <br /></td></tr>
<tr><td><input align="left" type="radio" name="Satradios" value="satRadio4">
Satisfied (4) <br /></td></tr>
<tr><td><input align="left" type="radio" name="Satradios" value="satRadio3">
Moderately Satisfied (3) <br /></td></tr>
<tr><td><input align="left" type="radio" name="Satradios" value="satRadio2">
Somewhat Unhappy (2) <br /></td></tr>
<tr><td><input align="left" type="radio" name="Satradios" value="satRadio1">
Very Unhappy (1) <br /></td></tr>
</table>

<h3>How satisfied were you with the treatment or information you received?</h3>
<table><tr><td>
<tr><td><input align="left" type="radio" name="Treradios" value="treRadio5">
Very Satisfied (5) <br /></td></tr>
<tr><td><input align="left" type="radio" name="Treradios" value="treRadio4">
Satisfied (4) <br /></td></tr>
<tr><td><input align="left" type="radio" name="Treradios" value="treRadio3">
Moderately Satisfied (3) <br /></td></tr>
<tr><td><input align="left" type="radio" name="Treradios" value="treRadio2">
Somewhat Unhappy (2) <br /></td></tr>
<tr><td><input align="left" type="radio" name="Treradios" value="treRadio1">
Very Unhappy (1) <br /></td></tr>
</table>
<br />
<br />


<% //START OF THE EXTENDED SURVEY WITH HCP REVIEW FIELDS %>

<table border="1" bordercolor="989898"><tr><td>
<h3 id="addReview">Add a Review of the HCP</h3>
</td></tr><tr><td>
<b>Title: </b>
<input class="form-control" type="text" width="1" name="title">
</td></tr><tr><td>

<b>HCP Rating (out of 5): </b>	
<select class="form-control" name="rating">
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>			
<option value="4">4</option>
<option value="5">5</option>
</select>
</td></tr><tr><td>	

<b>Comment on your experience with the HCP: </b>
<textarea style="margin-top: 5px; width: 100%;" rows="4" cols="80" name="description" class="form-control"></textarea>
</td></tr></table>
<br />
<br />

<% // END OF THE EXTENDED SURVEY %>			

<p> To avoid errors, click "Submit Survey" only once. </p>
<input type="submit" style="font-size: 16pt; font-weight: bold;" value="Submit Survey">
</form>
				

<%@include file="/footer.jsp"%>