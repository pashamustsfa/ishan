<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ include file="/html/init.jsp"%>
     <link rel="stylesheet" href="<%=renderRequest.getContextPath()%>/css/user.css" type="text/css" />
   <%--  <link rel="stylesheet" href="<%=renderRequest.getContextPath()%>/css/projectManagement.css" type="text/css" />
    <link rel="stylesheet" href="/html/css/CommonStyle.css" type="text/css" /> --%>
<!-- <link rel="stylesheet" href="/html/css/jqx.base.css" type="text/css" /> -->
    <script type="text/javascript" src="/html/js/jqx/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/html/js/jqx/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/html/js/jquery-ui.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxcore.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxdata.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxbuttons.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxscrollbar.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxmenu.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.edit.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.sort.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.filter.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.grouping.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.columnsresize.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.aggregates.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxpanel.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxlistbox.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxdropdownlist.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.pager.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxtree.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxcheckbox.js"></script>
<portlet:defineObjects />
<portlet:resourceURL var="UserURL"></portlet:resourceURL>
<h1>Manage User</h1>
<%
long portletId = themeDisplay.getPlid();
%>
<liferay-portlet:renderURL var="importUserURL" plid="<%= portletId%>" portletName="excelimport_WAR_ExcelImportportlet" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<liferay-portlet:param name="jspPage" value="/html/excelImport/view.jsp" />
</liferay-portlet:renderURL>
<style>
#userboxDiv{
  width: 17%;
  height:32px;
  border: 1px solid gray;
  background-color: #FFFFFF;
  margin-left: 370px;
  margin-top: 14px;
}

#secondUserBoxDiv{
  width: 17%;
  height:34px;
  background-color: #bfbfbf;
  float: right;
  margin-top:-26px;
}

 .actions_dropdown{
margin-top: 7px;
width: 10%;
height: 79px;
}

#downArrowImage{
padding-top: 10px;
width: 13px;
padding-left: 10px;
}

#createUserTextStyle{
	color: rgb(51, 51, 51);
	padding-top: 5px;
	padding-left: 31px;
}

#enter{
padding-left: 309px;
}

</style>
<div id="userSecondMainDiv" style="display:none;">
 <span id="enter">Don't have any users please create user</span>
<div id="main body">
<div id="userboxDiv">
<div id="createUserTextStyle">Create User</div>
<div id="secondUserBoxDiv">
<img src="/html/img/Down_arrow.png" id="downArrowImage"> 
</div>
<div class="actions_dropdown">	
    <ul>
		<li onClick="alert('Under Construction')">Quick</li>
        <li onclick='<portlet:namespace />addUser();'>AddUser</li>
		<li onclick='<portlet:namespace />importUsers();'>ImportUsers</li>

    </ul>
</div>
</div>
</div> 
</div>


<div id="userMainDivContent" style="display:none;">users are there
	 <div id="text">
		<div id="topheader">
			<ul style="list-style:none;">
				
				<li style="float:right;margin-top:-27px;margin-right:146px;">
					<div id="importUser" style="margin-left:6px;">
						<span id="actionstext">Import through ExcelSheet</span><img src="/html/img/add (2).png" id="settingsImageStyle">
					</div>
				</li>
			</ul>
		</div>
	</div> 


	<div class="myUser"></div>
		


	<div class="userDetails" id="userDetails"></div>
        <div  id="userDetailsDivStyle">
            <div id="cellbegineditevent"></div>
            <div id="cellendeditevent"></div>
    </div>

 


</div>







<script>
function addUser(){
alert('add user');	
}
<aui:script>
function <portlet:namespace />importUsers(){
	try{
		var url='<%= importUserURL %>'+ '&_excelimport_WAR_ExcelImportportlet_templateName=UserCreation'+ '&_excelimport_WAR_ExcelImportportlet_noOfColumns=7'+'&_excelimport_WAR_ExcelImportportlet_columns=First Name,Middle Name,Last Name,Email Address,Mobile Number,Gender,Role';
		
		var dialog = Liferay.Util.Window.getWindow(
			{
				title: "<%=LanguageUtil.get(pageContext,"lbl.action.import.user", "Import User")%>",
				dialog: {
						width: 1077,
						height:650,
						centered: true,
						destroyOnHide: true,
						toolbars: {
						footer: [
							{
								label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.close", "Close") %>',
								on: {
									click: function() {
										dialog.hide();
										location.reload();
										
									}
								}
							}
						]
					}
				},
				uri: url
			}
		);
	}catch (e) {
		alert(e);
	}
}
</aui:script>
</script>

<aui:script use="liferay-portlet-url">
Liferay.on('moveToManageUsers',function(event) {
	alert('in moveToManageUsers');
		 renderURL.setPortletMode("view");
		 renderURL.setWindowState("normal");
		 renderURL.setPortletId("ManageUsers_WAR_TeamManagementportlet");
		 renderURL.setParameter("jspPage","/html/manageUsers/manageUsers.jsp");
		 window.location.href = renderURL.toString();
	
}); 
</aui:script>
<script type="text/javascript">
	var jqUser = jQuery.noConflict();
</script>
<script>
jqUser(document).ready(function() {
	
	/* jqUser('#iframe_id').attr("scrolling", "no");
	jqUser('#iframe_id').attr("src", jqUser('#iframe_id').attr("src"));
	 */
	 alert('ready');
	 getUserDetails();
});

</script>
<script>    
	function getUserDetails() {
		alert("getuserdetails");
				var records = {};
				jqUser.ajax({
				url:'<%=UserURL%>',
				dataType: "json",
				data:{
					<portlet:namespace  />CMD:'GetUserHistory',
				},
				type: "post",
				success: function(data) {
				if(0 == 0){
				var obj = jqUser("div[id^='userSecondMainDiv']");	
					jqUser("#userSecondMainDiv").show();
				} else {
					jqUser("#userMainDivContent").show();
					jqUser("#userSecondMainDiv").hide();
				}	
			},
				});
				}
		
	</script>