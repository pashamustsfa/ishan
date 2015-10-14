<%@page import="com.vidyayug.scrum.service.AgileProjectLocalServiceUtil"%>
<%@page import="com.vidyayug.scrum.model.AgileProject"%>
<%@page import="com.liferay.portal.kernel.webcache.WebCachePoolUtil"%>
<%@page import="com.liferay.portal.kernel.cache.MultiVMPoolUtil"%>
<%@page import="com.liferay.portal.model.Group"%>
<%@ include file="/html/init.jsp" %>
<link rel="stylesheet" href="/html/css/CommonStyle.css"></link>
<link rel="stylesheet" href="<%=renderRequest.getContextPath()%>/css/team.css"></link>
<link rel="stylesheet" href="/html/css/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="/html/css/jqx.windowsphone.css" type="text/css" />
	<link rel="stylesheet" href="/html/css/jqx.blackberry.css" type="text/css" />
	<link rel="stylesheet" href="/html/css/jqx.mobile.css" type="text/css" />
	<link rel="stylesheet" href="/html/css/jqx.android.css" type="text/css" />

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
<script type="text/javascript" src="/html/js/jqx/simulator.js"></script>
<portlet:defineObjects />


<%
 try {

	long portletId = themeDisplay.getPlid();
	Group group = themeDisplay.getScopeGroup();
	long organizationId = group.getOrganizationId();
	MultiVMPoolUtil.clear() ;   
	WebCachePoolUtil.clear();
	String instanceId = themeDisplay.getPortletDisplay().getInstanceId();	
	long isActive = 1;
	List<AgileProject> projectDetails = AgileProjectLocalServiceUtil.findByProjectsBasedOnOrganizationId(organizationId, isActive);
	pageContext.setAttribute("projectDetails", projectDetails);
%>

<%
	Log log=LogFactoryUtil.getLog(getClass());
%>
<style>
.aui button.btn{
  width:120px;
}
#teamGrid{
  margin-top: -6px;
}
</style>					
<portlet:resourceURL var="teamURL"></portlet:resourceURL>
<liferay-portlet:renderURL var="importUserURL" plid="<%= portletId%>" portletName="excelimport_WAR_ExcelImportportlet" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<liferay-portlet:param name="jspPage" value="/html/excelImport/view.jsp" />
</liferay-portlet:renderURL>
<liferay-portlet:renderURL var="teamPopupURL" windowState="<%= com.liferay.portal.kernel.portlet.LiferayWindowState.POP_UP.toString() %>" >
	<liferay-portlet:param name="jspPage" value='<%="/html/team/createteam.jsp"%>' />
</liferay-portlet:renderURL>

<liferay-portlet:renderURL var="viewUserURL" windowState="<%= com.liferay.portal.kernel.portlet.LiferayWindowState.POP_UP.toString() %>" >
	<liferay-portlet:param name="jspPage" value='<%="/html/team/user.jsp"%>' />
</liferay-portlet:renderURL>

<liferay-portlet:renderURL var="addUserURL" windowState="<%= com.liferay.portal.kernel.portlet.LiferayWindowState.POP_UP.toString() %>" >
	<liferay-portlet:param name="jspPage" value='<%="/html/team/add_user.jsp"%>' />
</liferay-portlet:renderURL>


<script type="text/javascript" >
	var jqTeamData = jQuery.noConflict();
	jqTeamData(document).ready(function() {
		getTeamData();
	});
</script>

<script>
function editTeam(){
	alert('Under construction');
}function viewTeamDetails(){
	alert('Under construction');
}
function getTeamData() {
	var artifactId = jqTeamData("#<portlet:namespace />artifactId").val();
	var artifactTypeLabel = jqTeamData("#<portlet:namespace />artifactTypeLabel").val();
	alert('artifactId------'+artifactId);
	alert('artifactTypeLabel------'+artifactTypeLabel);
	 var theme = prepareSimulator("grid");
	
	/* alert('artifactId: ' + artifactId);
	alert('artifactTypeLabel: ' + artifactTypeLabel); */
	try{
		var records = {};
		jqTeamData.ajax({
			url:'<%=teamURL%>',
			dataType: "json",
			data:{
				<portlet:namespace  />CMD:'GetTeamData',
				<portlet:namespace  />artifactId:artifactId,
				<portlet:namespace  />artifactTypeLabel:artifactTypeLabel
				},
			type: "post",
			success: function(data) {
				
				var generaterow = function (j) {
   	                var row = {};
                    row["teamId"] = data[j].teamId;
		            row["teamName"] = data[j].teamName;
					row["no_of_users"] = data[j].no_of_users;
		            row["no_of_backlogs"] = data[j].no_of_backlogs;
		            row["no_of_userstory"] = data[j].no_of_userstory;
   	                return row;
				}
				for (var j=0; j < data.length; j++) {
					var row = generaterow(j);
					records[j] = row;
				}
				var source =
					{
						localdata: records,
						datatype: "local",   		             	
						datafields:
						[
							{ name: 'teamId', type: 'number' },
							{ name: 'teamName', type: 'string' },
							{ name: 'no_of_users', typex: 'number' },
							{ name: 'no_of_backlogs', type: 'number' },
							{ name: 'no_of_userstory', type: 'number' }
						]
					};
	 	       		var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
   		                if (value == "") {
   		                    return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #00000;font-weight:bold;">' + value + '</span>';
   		                }
   		                else {
   		                    return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #00000;font-weight:normal;">' + value + '</span>';
   		                }
   		            };
					
					var workSheetButton_html = function (id) {
						return '<input type="image" src="/html/img/Settings.png" width="1" height="20" onClick="workSheetButtonClick(event)" class="workSheetButton" id="' + id + '" value="Actions" style="margin-left:26px;margin-top: 3px;"/>' 
					};
			 	        	  
			 	    var dataAdapter = new jqTeamData.jqx.dataAdapter(source);
			 	        								
					jqTeamData("#<portlet:namespace />teamGrid").jqxGrid({
						
						width:'100%',
						height:425,
						source: dataAdapter,
						showfilterrow: true,
						groupable: true,
						sortable: true,
						showaggregates: true,
						altrows: true,
						autorowheight: true,
						filterable: true,		   		                
						pageable: true,
						selectionmode: 'checkbox',
						columnsresize: true,
						theme: theme,
						
						columns: [ 
    		                      { text: 'Name', datafield: 'teamName', filtertype: 'textbox',width: '60%'},
    		                      { text: 'No. of Members', datafield: 'no_of_users', filtertype: 'textbox',width: '100',filterable: false},
    		                      { text: 'No. of Backlogs', datafield: 'no_of_backlogs', width: '100',filterable: false},
    		                      { text: 'No. of Userstories', datafield: 'no_of_userstory',width:'100',filterable: false},
    	   		                  { text: 'Action', cellsrenderer: workSheetButton_html, datafield: 'teamId',width:'80', cellsalign: 'center',filterable: false}
						]
					});	
					initSimulator("grid");
			},
				complete: function(){
				jqTeamData('#<portlet:namespace />teamGrid input[type="textarea"]'). attr("placeholder", "Search Team ...");
				},
		});
	}catch(e){
		alert('error in getResource : ' + e);
	}
}

var workSheetButtonClick= function (event) {
	var i = 0;
	try{
		
	   // create context menu for Task
       var taskContextMenu = jqTeamData("#teamMenu").jqxMenu({ width: 160, height: 202, autoOpenPopup: false, mode: 'popup'});
       jqTeamData("#<portlet:namespace />teamGrid").on('contextmenu', function () {
           return false;
       });
       
       //handle context menu clicks.
       jqTeamData("#teamMenu").on('itemclick', function (event) {
    	   
    	   if(i == 0) {
	    	   i = 1;
	           var args = event.args;
	           var rowindex = jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('getselectedrowindex');
	           if (jqTeamData.trim(jqTeamData(args).text().trim()) == "Assign User") {
	               editrow = rowindex;
	            	jqTeamData("#<portlet:namespace />rowId").val(editrow);
	            	var dataRecord = jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('getrowdata', editrow);	
	            	<portlet:namespace />addUser(dataRecord.teamId);                	
	           } else if (jqTeamData.trim(jqTeamData(args).text().trim()) == "View Users") {
	               editrow = rowindex;
	            	jqTeamData("#<portlet:namespace />rowId").val(editrow);
	            	var dataRecord = jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('getrowdata', editrow);
	            	<portlet:namespace />viewUserPopup(dataRecord.teamId)
	           } 
    	   }
       });
       
       var buttonID = event.target.id;	    
       jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('selectrow', buttonID);
	   var scrollTop = jqTeamData(window).scrollTop();
	   var scrollLeft = jqTeamData(window).scrollLeft();
	   taskContextMenu.jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
	   return false;
	   
     }catch(e) {
     	alert('error in contextmenu: ' + e);
     }
}
</script>

<script>
	Liferay.on('artifactTeamMappingEvent',function(event) {
		
		if(event.artifactId.error!=null){
			alert('error artifactId: '+event.artifactId.error);
		}else{
			var  artifactId = event.artifactId;
			
			jqTeamData("#<portlet:namespace />artifactId").val(artifactId);
		}
		
		if(event.artifactTypeLabel.error!=null){
			alert('error artifactTypeId: '+event.artifactTypeLabel.error);
		}else{
			var  artifactTypeLabel = event.artifactTypeLabel;
			
			jqTeamData("#<portlet:namespace />artifactTypeLabel").val(artifactTypeLabel);
		}
	});
</script>

<script>
function <portlet:namespace />addUser(teamId) {
	
	try{ 

		var artifactId = jqTeamData("#<portlet:namespace />artifactId").val();
		var artifactTypeLabel = jqTeamData("#<portlet:namespace />artifactTypeLabel").val();
		var url='<%= addUserURL %>' + '&<portlet:namespace />teamId=' + teamId + '&<portlet:namespace />artifactId=' + artifactId + '&<portlet:namespace />artifactTypeLabel=' + artifactTypeLabel; 
		var dialog = Liferay.Util.Window.getWindow(
			{
				title: "Assign User",
				dialog: {
					width: 950,
					height:600,
					centered: true,
					destroyOnHide: true,
					toolbars: {
						footer: [
						{
						label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.update", "Update Association") %>',
						on: {
						click: function() {						
						var iframe = document.getElementsByTagName('iframe')[0];
						if (iframe) {
						var iframeContent = (iframe.contentWindow || iframe.contentDocument);
						iframeContent.save();
						}
						}
						}
						},    
						{	
							label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.close", "Close") %>',
							on: {
								click: function() {
									dialog.hide();
									getTeamData();
								}
							}
						}]
					}
				},
				uri: url
			}
		);
	}catch (e) {
		alert(e);
	}
}

function <portlet:namespace />teamPopup(){
	try{ 
		var artifactId=jqTeamData('#<portlet:namespace />artifactId').val();
		var artifactTypeLabel =	jqTeamData('#<portlet:namespace />artifactTypeLabel').val();
		var url='<%= teamPopupURL %>' + '&<portlet:namespace />artifactId=' + artifactId + '&<portlet:namespace />artifactTypeLabel=' + artifactTypeLabel; 
		var dialog = Liferay.Util.Window.getWindow(
			{
				title: "<%=LanguageUtil.get(pageContext,"lbl.action.add.createteam", " ")%>",
				dialog: {
						width: 950,
						height:600,
						centered: true,
						destroyOnHide: true,
						toolbars: {
						footer: [
							{
								label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.save", "Save") %>',
								on: {
									click: function() {
										var iframe = document.getElementsByTagName('iframe')[0];
										if (iframe) {
										   var iframeContent = (iframe.contentWindow || iframe.contentDocument);
										   iframeContent.save();
										}
									}
								}
							},
							{
								label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.close", "Close") %>',
								on: {
									click: function() {
										dialog.hide();
										/* self.parent.location.reload(); */
										getTeamData();				
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

function <portlet:namespace />viewUserPopup(teamId){
	try{ 
		var artifactId=jqTeamData('#<portlet:namespace />artifactId').val();
		var artifactTypeLabel =	jqTeamData('#<portlet:namespace />artifactTypeLabel').val();
		var url='<%= viewUserURL %>' + '&<portlet:namespace />teamId=' + teamId  + '&<portlet:namespace />artifactId=' + artifactId + '&<portlet:namespace />artifactTypeLabel=' + artifactTypeLabel; 
		var dialog = Liferay.Util.Window.getWindow(
			{
				title: "<%=LanguageUtil.get(pageContext,"lbl.form.header.viewUser", "View User")%>",
				dialog: {
						width: 950,
						height:600,
						centered: true,
						destroyOnHide: true,
						toolbars: {
						footer: [
							<%-- {
								label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.save", "Save") %>',
								on: {
									click: function() {
										var iframe = document.getElementsByTagName('iframe')[0];
										if (iframe) {
										   var iframeContent = (iframe.contentWindow || iframe.contentDocument);
										   iframeContent.save();
										}
									}
								}
							}, --%>
							{
								label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.close", "Close") %>',
								on: {
									click: function() {
										dialog.hide();
										/* self.parent.location.reload(); */
										getTeamData();				
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
</script>


<script type="text/javascript" >
jqTeamData(document).ready(function() {
	jqTeamData('html').click(function() {
		jqTeamData(".actions_dropdown1").hide(0);
	});
	
	jqTeamData('.actions_button1').click(function(event) {	
		
		event.stopPropagation();
		if(jqTeamData(".actions_dropdown1").css('display') == '') {
			jqTeamData(".actions_dropdown1").css('display', 'block');
		} else  {
			jqTeamData(".actions_dropdown1").css('display', '');
		}
		jqTeamData(".actions_dropdown1").toggle(0);
	});		
});		
</script>

<script type="text/javascript" >
jqTeamData(document).ready(function() {
	
	jqTeamData('html').click(function() {
		jqTeamData(".actions_dropdown").hide(0);
	});
	
	jqTeamData('.actions_button').click(function(event) {		
		event.stopPropagation();
		if(jqTeamData(".actions_dropdown").css('display') == '') {
			jqTeamData(".actions_dropdown").css('display', 'block');
		} else  {
			jqTeamData(".actions_dropdown").css('display', '');
		}
		jqTeamData(".actions_dropdown").toggle(0);
	});			
});	
</script>

<aui:script>
function <portlet:namespace />importUser(){
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
										<!-- getProjectDetails(); -->
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



<script type="text/javascript">
jqTeamData(document).ready(function () {
	var source = [" ",];
	// Create a jqxComboBox
	jqTeamData("#jqxComboBox").jqxComboBox({ source: source, selectedIndex: 0, width: '200px', height: '25px', theme: 'shinyblack' });
});
 </script>



<style>
.teamsGrids {
	margin-top: 26px;
}

.projectId {
	width: 175px;
	margin-top: 19px;
	margin-left: 20px;
}

button {
	height: 30px;
	padding: 0px;
	width: 60px;
}
.root li:hover
{
background-color: rgb(232,232,232) !important;
}
.root a:hover
{
background-color: rgb(232,232,232) !important;
}

#teamMenu{
height:120px!important;
}


</style>

 <body>
	<div id="teamDivHeights" style="margin-top: -7px;width: 101.54%;">
		<aui:input name="artifactId" id="artifactId" type="hidden" value="0"/>
		<aui:input name="artifactTypeLabel" id="artifactTypeLabel" type="hidden" value="0"/>
				
		
		
		<div id="thirdHeader">
			<div  id="dropdown1" class="dropdown">
				<h6>Add</h6>
				<div class="actions_button1" ><img src="/html/img/add-01.png" style="width:10px;cursor:pointer;"></div>
				<div class="actions_dropdown1">
					<ul class="root">
						<li>
							<a href="#Dashboard" title="Click here to add team" onclick="<portlet:namespace />teamPopup();">Team</a>
						</li>
						<li ><a href="#Profile" title="Click here to assign User" onclick="<portlet:namespace />addUser(0);">User</a></li>
					    <li ><a href="#Profile" title="Click here to import Users" onclick="<portlet:namespace />importUser();">Import User</a></li>
					</ul>
				</div>
			</div>
		
		</div>
		
		<!-- <div id ="Teams">
			<h5>Teams</h5>
		</div> -->
		
		<div class='default'>
	    <div id="demoContainer" class="device-mobile-tablet">
	        <div id="myJqxGridContainer" class="device-mobile-tablet-container">
	            <div  id="<portlet:namespace />teamGrid" class="teamsGrids" ></div>
	        </div>
	    </div>
	</div>
	</div>
	
	<%-- <div id="<portlet:namespace />teamGrid" class="teamsGrids"></div> --%>
	
	
	<div id="teamMenu" class="actions_dropdown">	
	    <ul>
	   		<li onclick="viewTeamDetails();"><img alt="View Details" src="/html/img/view.png" style="width: 15%;">&nbsp;&nbsp;View Details</li>
			<li onclick="editTeam();"><img alt="Edit" src="/html/img/edit.png" style="width: 15%;">&nbsp;&nbsp;Edit</li>
	   		<li><img alt="View Users" src="/html/img/view.png" style="width: 15%;">&nbsp;&nbsp;View Users</li>
			<li><img alt="Assign User" src="/html/img/add (2).png" style="width: 15%;">&nbsp;&nbsp;Assign User</li>
	    </ul>
	</div>
</body>
<%} catch (Exception e) {
    e.printStackTrace();
%>
<h2>Service Unavailable!</h2>
<%
}
%>