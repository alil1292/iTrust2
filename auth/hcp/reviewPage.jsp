<%@page import="edu.ncsu.csc.itrust.beans.ReviewsBean"%>
<%@page import="org.jfree.ui.Align"%>
<%@page import="edu.ncsu.csc.itrust.action.ReviewsAction"%>
<%@page errorPage="/auth/exceptionHandler.jsp" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="edu.ncsu.csc.itrust.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.beans.PersonnelBean"%>
<%@page import="edu.ncsu.csc.itrust.dao.mysql.PatientDAO"%>

<%@include file="/global.jsp" %>

<% pageTitle = "iTrust - Reviews Page"; %>

<%@include file="/header.jsp" %>


<%
	String mid = request.getParameter("expertID");
	long expertID = loggedInMID;
	if(mid != null) {
		expertID = Long.parseLong(mid);
		session.setAttribute("expertID", mid);
		loggingAction.logEvent(TransactionType.VIEW_REVIEWS, loggedInMID, expertID, "");
		response.sendRedirect("/iTrust/auth/patient/reviewsPage.jsp");
		return;
	}
	if(session.getAttribute("expertID") != null){
		try {
			expertID = Long.parseLong((String)session.getAttribute("expertID"));
		} catch (NumberFormatException e){
			%> <h1>User does not exist!</h1> <%
			return;
		}
	}
	
	ReviewsAction reviewsAction = new ReviewsAction(prodDAO, loggedInMID.longValue()); 
	
	if(expertID != -1) {
		List<ReviewsBean> reviews = reviewsAction.getReviews(expertID);
		PersonnelBean physician = reviewsAction.getPhysician(expertID);
		%><h1>Reviews for <%=physician.getFullName()%></h1>
		<br>
		<%
		if(reviews.size() == 0) 
			%><p><i> <%=physician.getFullName() %> has not been reviewed yet.</i></p><%
		
		for(ReviewsBean reviewBean : reviews ) { %> 
			<div class="grey-border-container">
				<p> <b><%= reviewBean.getTitle()%> </b> <span style="margin-right:10px"></span>
				
					<%
					for(int i = 0 ; i < 5 ; i++) { 
						if(i < reviewBean.getRating())
							%> <span class="glyphicon glyphicon-star" style="color:red;"></span><% 
						else
							%> <span class="glyphicon glyphicon-star-empty"></span><% 	
					}
					%>
				    </p>
				<p><%= reviewBean.getDescriptiveReview() %> </p>
				<p><%= reviewBean.getDateOfReview()%></p>
			</div>	
		
	  <%}
	}
	   	
 %>
	


<%@include file="/footer.jsp"%>
