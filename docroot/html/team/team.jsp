<%@page import="com.vidyayug.scrum.service.AgileProjectLocalServiceUtil"%>
<%@page import="com.vidyayug.scrum.model.AgileProject"%>
<%@page import="com.liferay.portal.kernel.webcache.WebCachePoolUtil"%>
<%@page import="com.liferay.portal.kernel.cache.MultiVMPoolUtil"%>
<%@page import="com.liferay.portal.model.Group"%>
<%@ include file="/html/init.jsp" %>
<link rel="stylesheet" href="/html/css/CommonStyle.css"></link>
<link rel="stylesheet" href="/html/css/team.css"></link>
<link rel="stylesheet" href="/html/css/jqx.base.css" type="text/css" />
<script type="text/javascript" src="/html/js/jqx/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxcore.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxdata.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxbuttons.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxscrollbar.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxmenu.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.filter.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.sort.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.edit.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/html/js/jqx/demos.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxcheckbox.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.pager.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxlistbox.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxdropdownlist.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.filter.js"></script>
<portlet:defineObjects />


<%
 try {
	 
%>

<%
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
					
<portlet:resourceURL var="teamURL"></portlet:resourceURL>

<liferay-portlet:renderURL var="teampopupURL" plid="<%= portletId%>" portletName="createteam_WAR_TeamManagementportlet" windowState="<%= com.liferay.portal.kernel.portlet.LiferayWindowState.POP_UP.toString() %>" >
	<liferay-portlet:param name="jspPage" value='<%="/html/createteam/createteam.jsp"%>' />
</liferay-portlet:renderURL>

<liferay-portlet:renderURL var="addUserURL" plid="<%= portletId%>" portletName="createteam_WAR_TeamManagementportlet" windowState="<%= com.liferay.portal.kernel.portlet.LiferayWindowState.POP_UP.toString() %>" >
	<liferay-portlet:param name="jspPage" value='<%="/html/createteam/add_user.jsp"%>' />
</liferay-portlet:renderURL>


<script type="text/javascript" >
	var jqTeamData = jQuery.noConflict();
	jqTeamData(document).ready(function() {
		getTeamData();
	});
</script>


<script>
function getTeamData() {
	var artifactId = jqTeamData("#<portlet:namespace />artifactId").val();
	var artifactTypeLabel = jqTeamData("#<portlet:namespace />artifactTypeLabel").val();
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
			type: "get",
			success: function(data) {
				var source =
	            {
	                datafields: [
	                    { name: 'teamId', type: 'number' },
	                    { name: 'teamName', type: 'string' },
	                    { name: 'no_of_users', typex: 'number' },
	                    { name: 'no_of_backlogs', type: 'number' },
	                    { name: 'no_of_userstory', type: 'number' }
	                ],
	                datatype: 'json',
	                localdata: data
	            };
	            var adapter = new jqTeamData.jqx.dataAdapter(source);
				// create nested grid.
	            var initrowdetails = function (index, parentElement, gridElement, record) {
	                var id = record.uid.toString();
	                var grid = jqTeamData(jqTeamData(parentElement).children()[0]);
	                var nestedSource =
	                  {
	                      datafields: [
	                          { name: 'imgPath', type: 'string' },         
	                          { name: 'screenName', map: 'screenName', type: 'string' },
	                          { name: 'noOfTasks', map: 'noOfTasks', type: 'number' },
	                          { name: 'timeLeft', map: 'timeLeft', type: 'number' }, 
	                          { name: 'teamId', map: 'teamId', type: 'number' }
	                      ],
	                      datatype: 'json',
	                      root: 'user',
	                      localdata: data[index].users
	                  };
	                var nestedAdapter = new jqTeamData.jqx.dataAdapter(nestedSource);
   		            var photorenderer = function (row, column, value) {
   	   	                var imgurl = '/html/img/user-01.png';
   	   	                var img = '<div style="background: white;"><img style="margin:2px; margin-left: 10px;" width="20" height="32" src="' + imgurl + '"></div>';
   	   	                return img;
   		   	         }
   		            
   		        	var scenarioActionButton_html = function (id) {
  		   	          var imgurl = '/html/img/Settings.png';
  			   	      var img = '<div style="background: white;"  onClick="scenarioButtonClick(event)" class="gridScenarioButton" id="' + id + '" value="Actions"><img style="margin:2px; margin-left: 10px;" width="22" height="32" src="' + imgurl + '"></div>';
  	        		  return img;
	  	        	}	            
	                if (grid != null) {
	                    grid.jqxGrid({
	                        source: nestedAdapter,selectionmode: 'checkbox',theme: theme,sortable: true,pageable: true,filterable: true,width: '100%',height: 200,
	                        scrollfeedback: function(row)
	                        {
	                            return '<table style="height: 80px;"><tr><td>' + row.imgPath + '</td></tr><tr><td>' + row.userName + '</td></tr></table>';
	                        },
	                        columns: [
	   		 					{ text: 'Photo', width: '10%',height:'500',cellsrenderer: photorenderer },
	                            { text: "screen Name", datafield: "screenName", width: '20%'},
	                            { text: "No of Tasks", datafield: "noOfTasks",width: '20%' },
	 	                        { text: "Time Left(Hrs)", datafield: "timeLeft",width: '20%' },
	 	   		                { text: '', cellsrenderer: scenarioActionButton_html, datafield: 'teamId',width:'10%', cellsalign: 'center' }
	                       ]
	                    });
	                }
	            }				
	        	var scenarioActionButton_html = function (id) {
		   	          var imgurl = '/html/img/Settings.png';
			   	      var img = '<div style="background: white;"  onClick="scenarioButtonClick(event)" class="gridScenarioButton" id="' + id + '" value="Actions"><img style="margin:2px; margin-left: 10px;" width="22" height="32" src="' + imgurl + '"></div>';
	        		  return img;
	        	}
				// create jqxgrid
				try{
	            jqTeamData("#<portlet:namespace />teamGrid").jqxGrid(
	            {
	                width: '100%',
	                height: 365,
	                source: source,
	  		        sortable: true,
		  		    showfilterrow: true,
	               	pageable: true,
	               	filterable: true,
	                theme: theme,
	                rowdetails: true,
	                rowsheight: 35,
	                initrowdetails: initrowdetails,
   		            selectionmode: 'checkbox',
	                rowdetailstemplate: { rowdetails: "<div id='grid' style='margin: 10px;'></div>", rowdetailsheight: 220, rowdetailshidden: true },
	                
	                columns: [
	                      { text: 'Name', datafield: 'teamName', filtertype: 'textbox',width: '40%'},
	                      { text: 'No of Members', datafield: 'no_of_users', filtertype: 'textbox',width: '15%',filterable: false},
	                      { text: 'No of Backlogs', datafield: 'no_of_backlogs', width: '15%',filterable: false},
	                      { text: 'No Of Userstories', datafield: 'no_of_userstory',width:'15%',filterable: false},
   		                  { text: 'Action', cellsrenderer: scenarioActionButton_html, datafield: 'teamId',width:'15%', cellsalign: 'center',filterable: false}

	                ]
	            });	
				}catch(e) {alert('grid problem:' + e);}
			}
		});
	}catch(e){
		alert('error in getResource : ' + e);
	}
}

var scenarioButtonClick= function (event) {	
    try {
    	// create context menu for Task
        var scenarioContextMenu = jqTeamData(".actions_dropdown").jqxMenu({ width: 160, height: 100, autoOpenPopup: false, mode: 'popup'});
        jqTeamData("#<portlet:namespace />teamGrid").on('contextmenu', function () {
            return false;
        });
     	// handle context menu clicks.
       	jqTeamData(".actions_dropdown").on('itemclick', function (event) {
           var args = event.args;
           var rowindex = jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('getselectedrowindex');
           if (jqTeamData.trim(jqTeamData(args).text().trim()) == "View Details") {
               editrow = rowindex;
               jqTeamData("#<portlet:namespace />rowId").val(editrow);
            	var dataRecord = jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('getrowdata', editrow);
            	<portlet:namespace />editScenarioPopup(dataRecord.teamId);
            	
           } else if (jqTeamData.trim(jqTeamData(args).text().trim()) == "Edit") {
               editrow = rowindex;
               jqTeamData("#<portlet:namespace />rowId").val(editrow);
               var dataRecord = jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('getrowdata', editrow);
               <portlet:namespace />viewTestCases(dataRecord.teamId);
           } else if (jqTeamData.trim(jqTeamData(args).text().trim()) == "Add User") {
               editrow = rowindex;
               var dataRecord = jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('getrowdata', event.args.rowindex);
               <portlet:namespace />addUser(dataRecord.teamId);
           };
       });
    	//creating context menu 
	  	var buttonID = event.target.id;	    
	  	jqTeamData("#<portlet:namespace />teamGrid").jqxGrid('selectrow', buttonID);
	    var scrollTop = jqTeamData(window).scrollTop();
	    var scrollLeft = jqTeamData(window).scrollLeft();
	 	scenarioContextMenu.jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
	    return false;
    } catch(e) {
    	alert('error in action button: ' + e);
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
function <portlet:namespace />addUser(teamId){
	try{ 
		var url='<%= addUserURL %>' + '&_createteam_WAR_TeamManagementportlet_teamId=' + teamId; 
		var dialog = Liferay.Util.Window.getWindow(
			{
				title: "Add User",
				dialog: {
						width: 950,
						height:600,
						centered: true,
						destroyOnHide: true,
						toolbars: {
							footer: [
							{	
							label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.close", "Close") %>',
							on: {
							click: function() {
							dialog.hide();
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

function <portlet:namespace />teampopup(){
	try{ 
		var artifactId=jqTeamData('#<portlet:namespace />artifactId').val();
		var artifactTypeLabel =	jqTeamData('#<portlet:namespace />artifactTypeLabel').val();
		var url='<%= teampopupURL %>' + '&_createteam_WAR_TeamManagementportlet_artifactId=' + artifactId + '&_createteam_WAR_TeamManagementportlet_artifactTypeLabel=' + artifactTypeLabel; 
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
										//getTeamData();				
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




<script type="text/javascript">
jqTeamData(document).ready(function () {
var source = [" ",];
// Create a jqxComboBox
jqTeamData("#jqxComboBox").jqxComboBox({ source: source, selectedIndex: 0, width: '200px', height: '25px', theme: 'shinyblack' });
});
 </script>



<style>
.teamsGrids{
margin-top: 26px;
}

.projectId{
width: 175px;
margin-top: 19px;
margin-left: 20px;
}

</style>

 <body>
<div class="teamDivheights" style="height:132px;">
<aui:input name="artifactId" id="artifactId" type="hidden" value="0"/>
<aui:input name="artifactTypeId" id="artifactTypeId" type="hidden" value="0"/>
<aui:input name="artifactTypeLabel" id="artifactTypeLabel" type="hidden" value="0"/>


<div id ="topHeader">
</div>

<div id="secondHeader">
<div class="buttonForAdd">
<div class="addingTeam">Add Team</div>
</div>
</div>

<div id="thirdHeader">
<div class="dropdown" style="border-left: 1px solid gray;">
<h6 style="margin-left: 9px;border-right: 1px solid gray;margin-right: 77px;height: 16px;">Add</h6>
<div class="actions_button1" ><img src="/html/img/add (2).png" style="margin-top: -56px;margin-left: 36px;width:15px;"></div>
<div class="actions_dropdown1">
	<ul class="root">
		<li >
			<a href="#Dashboard" onclick='<portlet:namespace />teampopup();'>Team</a>
		</li>
		<li ><a href="#Profile" >User</a></li>
	</ul>
</div>
</div>

</div>

<div id ="Teams">
<h5>Teams</h5>
</div>			


</div>

<div id="<portlet:namespace />teamGrid" class="teamsGrids"></div>


<div class="actions_dropdown">	
    <ul>
    		<li><img alt="View Details" src="/html/img/logMyEffort.png" style="width: 15%;">&nbsp;&nbsp;View Details</li>
			<li><img alt="Edit" src="/html/img/history.png" style="width: 15%;">&nbsp;&nbsp;Edit</li>
			<li><img alt="Add User" src="/html/img/history.png" style="width: 15%;">&nbsp;&nbsp;Add User</li>
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