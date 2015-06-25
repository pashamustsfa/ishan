<%@page import="com.liferay.portal.service.TeamLocalServiceUtil"%>
<%@page import="com.vidyayug.scrum.service.ArtifactTeamMappingLocalServiceUtil"%>
<%@page import="com.vidyayug.scrum.common.ScrumConstants"%>
<%@page import="com.vidyayug.scrum.model.ArtifactTeamMapping"%>
<%@page import="com.vidyayug.global.service.ApplicationParamValueLocalServiceUtil"%>
<%@page import="com.vidyayug.global.service.ApplicationParamGroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.liferay.portal.model.Team"%>
<%@page import="com.vidyayug.attribute.model.Team_Hierarchy"%>
<%@page import="java.util.List"%>
<%@page import="com.vidyayug.attribute.service.Team_HierarchyLocalServiceUtil"%>
<%@page import="com.vidyayug.attribute.service.Team_HierarchyLocalServiceUtil"%>
<%@page import="javax.portlet.RenderRequest"%>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/html/init.jsp"%>

<%
	String artifactId = ParamUtil.getString(renderRequest, "artifactId");
	System.out.println("Priinting artifactId ............."+artifactId);
	String artifactTypeLabel = ParamUtil.getString(renderRequest, "artifactTypeLabel");
	System.out.println("Printing artifactTypeLabel: "+artifactTypeLabel);

	long artifactTypeId = 0;
	long isActive = 1;
	ApplicationParamGroup appParamGroup = ApplicationParamGroupLocalServiceUtil.findBygroupNameRecords(ScrumConstants.APG_ARTIFACT_TEAM);
	if (Validator.isNotNull(appParamGroup)) {
		 ApplicationParamValue appParam = ApplicationParamValueLocalServiceUtil.findByappParanNamesAppParamGrpId(artifactTypeLabel, appParamGroup.getAppParamGroupId());
		 artifactTypeId = appParam.getAppParamValueId(); 
	}
	
	List<ArtifactTeamMapping> artifactTeamMappingList = ArtifactTeamMappingLocalServiceUtil.findByArtifactTypeIdAndArtifactId(artifactTypeId, Long.valueOf(artifactId), isActive);

%>
 <liferay-ui:error key="duplicate-name" message="Team name is already exist, Unable! to upload duplicate"/>
<style>
.jqx-widget-content {
  -moz-box-sizing: content-box;
  box-sizing: content-box;
  -ms-touch-action: none;
  -moz-background-clip: padding;
  -webkit-text-size-adjust: none;
  background-clip: padding-box;
  -webkit-background-clip: padding-box;
  -webkit-tap-highlight-color: rgba(0,0,0,0);
  font-family: Verdana,Arial,sans-serif;
  font-style: normal;
  font-size: 13px;
  border-color: #c7c7c7;
  background: #fff;
  z-index: 100 ! important;
}
</style> 
 
<aui:fieldset>

	<portlet:actionURL name="AddVidyayugTeams" var="AddVidyayugTeams" />

	<aui:form action="<%=AddVidyayugTeams%>" method="post" name="insertTeamUserForm" id="insertTeamUserForm" cssClass="vy_attributes">
	<aui:input name="artifactId" id="artifactId" type="hidden" value="<%=artifactId%>"/>
	<aui:input name="artifactTypeLabel" id="artifactTypeLabel" type="hidden" value="<%=artifactTypeLabel%>"/>
		<aui:layout>		
			<aui:column columnWidth="50">
				<aui:input type="text" label="Team Name" name="teamName"
					id="teamName" placeholder="Team Name" onclick="clearMessage('teamNameErrorDiv');"/>
				<div id="<portlet:namespace/>teamNameErrorDiv" style="color:red;font-weight: bold;"></div>
			</aui:column>
		</aui:layout>
		<aui:layout>
			<aui:column columnWidth="50">
				<aui:select name="orgTeams" label="Parent Team">
					<aui:option value="">--Select--</aui:option>
					<c:if test='<%= artifactTeamMappingList!=null&&!artifactTeamMappingList.isEmpty()%>'>
						<%
							Iterator<ArtifactTeamMapping> artifactTeamMappingIt = artifactTeamMappingList.iterator();
							while (artifactTeamMappingIt.hasNext()) {
								
								ArtifactTeamMapping artifactTeamMapping = artifactTeamMappingIt.next();
								Team teamObj = TeamLocalServiceUtil.getTeam(artifactTeamMapping.getTeamId());
						%>
						<aui:option value='<%=teamObj.getTeamId() %>'><%=teamObj.getName()%></aui:option>
						<%
							}
						%>
					</c:if>
				</aui:select>
			</aui:column>
		</aui:layout>
		<aui:layout>
			<aui:column columnWidth="50">
				<aui:input type="textarea" label="Description :" name="teamDes"
					id="teamDes" onclick="clearMessage('teamDesErrorDiv');" />
				<div id="<portlet:namespace/>teamDesErrorDiv" style="color:red;font-weight: bold;"></div>
			</aui:column>
		</aui:layout>
	</aui:form>
</aui:fieldset>

<script type="text/javascript">
	function save() {
		if(validate()) {
			document.getElementById('<portlet:namespace/>insertTeamUserForm').submit();
		}
	}
	function validate() {
		var teamName = document.getElementById('<portlet:namespace/>teamName').value;
		var teamDes = document.getElementById('<portlet:namespace/>teamDes').value;
		if (teamName == "") {
			document.getElementById('<portlet:namespace/>teamNameErrorDiv').innerHTML = "Enter Team Name.";
			return false;
		}

		if (teamDes == "") {
			document.getElementById('<portlet:namespace/>teamDesErrorDiv').innerHTML = "Enter Team Descripition.";
			return false;
		}
		if (teamName.length >= 75){
			document.getElementById('<portlet:namespace/>teamNameErrorDiv').innerHTML = "Team name accepts less than 75 characters.";
			return false;
		}
		return true;
	}
	function clearMessage(id_){
		document.getElementById('<portlet:namespace/>'+id_).innerHTML = "";
	}
</script>
<style>
.aui label {
	color: #555;
	font-size: 15px;
	font-weight: bold;
}
.aui .btn {
	margin-left: 237px;
}
.aui .portlet-content {
border: 0;
margin: 0 0 10px;
padding: 13px;
text-align: left;
color: black;
}

.vy_attributes input[type="text"] {
	width: 100%;
	height: 20px;
	font-size: 15px;
}

.vy_attributes select {
	height: 30px;
	width: 103%;
	font-size: 15px;
}

.vy_attributes textarea {
	margin: 0px;
	width: 100%;
	height: 100px;
}
</style>