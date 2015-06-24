<%@page import="com.vidyayug.scrum.service.AgileProjectLocalServiceUtil"%>
<%@page import="com.vidyayug.scrum.model.AgileProject"%>
<%@ include file="/html/init.jsp"%>
<%@page import="com.liferay.portal.model.Group"%>
<%@page import="com.liferay.portal.kernel.webcache.WebCachePoolUtil"%>
<%@page import="com.liferay.portal.kernel.cache.MultiVMPoolUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.vidyayug.scrum.service.ProductLocalServiceUtil"%>
<%@page import="com.vidyayug.scrum.model.Product"%>
<%@page import="com.vidyayug.scrum.model.Program"%>
<%@page import="com.vidyayug.scrum.service.ProgramLocalServiceUtil"%>
<%@ page import="javax.portlet.PortletPreferences"%>
<link rel="stylesheet" href="/html/css/CommonStyle.css" type="text/css" />
<link rel="stylesheet" href="/html/css/jqx.base.css" type="text/css" />
<link rel="stylesheet" href="<%=renderRequest.getContextPath()%>/css/userManagement.css" type="text/css" />
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
<%
      long portletId = themeDisplay.getPlid();

		MultiVMPoolUtil.clear() ;   
		WebCachePoolUtil.clear();	
%>




<liferay-portlet:renderURL var="importUserURL" plid="<%= portletId%>" portletName="excelimport_WAR_ExcelImportportlet" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<liferay-portlet:param name="jspPage" value="/html/excelImport/view.jsp" />
</liferay-portlet:renderURL>




 
<%
	PortletDisplay institutionMappingportletDisplay = themeDisplay.getPortletDisplay();
	Group group = themeDisplay.getScopeGroup();
	long organizationId = group.getOrganizationId();
	String instanceId = themeDisplay.getPortletDisplay().getInstanceId();
	           String url=  themeDisplay.getPortalURL();
	           System.out.println("Url........................."+url);
%>



<style>
#taskMenu{
	height:34px ! important ;
}

 #dropdown li:hover{
    background-color:#e8e8e8 ! important;
}
</style>

<!-- <div id="projectMainDivContent" style="display:none;">
	<div id="text">
		<div id="topheader">
			<ul style="list-style:none;">
				<li><span id="projecttext">Project</span><span id="rightarrow"><img src="/html/img/arrow-right.png" style="width:12px;margin-left: 9px;"></span></li>
				<li style="float:right;margin-top:-27px;margin-right:146px;">
					<div class="actions_button" style="margin-left:6px;">
						<span id="actionstext">Actions</span><img src="/html/img/Settings.png" id="settingsImageStyle">
					</div>
				</li>
			</ul>
		</div>
	</div> -->


	<div class="myproject"></div>
<div id="text1">
		<div id="topheader1">
		<ul style="list-style:none;">
		<li style="float:right;margin-right: 77px;margin-top: -48px;"><span id="projecticon"><img src="/html/img/add (2).png" style="width:21px;margin-right:3px;"></span><a href="#addproject" onclick='<portlet:namespace />importUser();'>Import User</a></li>
		<%-- <li style="float:right;margin-right: 61px;margin-top: -27px;"><span id="project"><img src="/html/img/add (2).png" style="width:21px;margin-right:3px;"></span><a href="#addproject" onclick='<portlet:namespace />importProject();'>Import Project</a></li>
		<li style="float:right;margin-right: 53px;margin-top: -6px;"><span id="release"><img src="/html/img/add (2).png" style="width:21px;margin-right:3px;"></span><a href="#addrelease" onclick='<portlet:namespace />importRelease(0);'>Import Release</a></li> --%>
		<li style="margin-top:57px;"><span id ="projectname">User</span></li>
	</ul>
	</div>
	</div>


	<div class="projectDetails" id="projectDetails"></div>
        <div  id="projectDetailsDivStyle">
            <div id="cellbegineditevent"></div>
            <div id="cellendeditevent"></div>
    </div>

 

<div id="taskMenu">
    <ul>
    	<li id="viewDetailsList">View User</li>
		<!-- <li id="teamPopUp">Team Details</li>
    	<li>Edit Project</li>
    	<li>View Document</li>
        <li>Release
        	<ul id="dropdown" class="dropdown-submenu" style="margin-left:54px !important;">
            	<li  id="adding">Add</li>
            	<li id="adding">Import</li>
            </ul>
        </li>
    </ul>    -->
</div>
</div>



<script type="text/javascript">
	var jqUser = jQuery.noConflict();
</script>


<!--*****************************************************************************************
* Created By   : Shashank Kolpuru
* Created On   : April 6, 2014 5:49:23 PM
********************************************************************************************
  Purpose      : Getting Projects Data Inside the Grid.
******************************************************************************************* -->
<script>
jqUser(document).ready(function() {
	
	/* jqUser('#iframe_id').attr("scrolling", "no");
	jqUser('#iframe_id').attr("src", jqUser('#iframe_id').attr("src"));
	 */
	 
	 getUserDetails();
});

</script>

<script>    
	function getUserDetails() {
		
				var records = {};
				jqUser.ajax({
				url:'<%=UserURL%>',
				dataType: "json",
				data:{
					<portlet:namespace  />CMD:'GetUserHistory',
				},
				type: "post",
				success: function(data) {
				if(data.length == 0){
				var obj = jqUser("div[id^='projectSecondMainDiv']");	
				jqUser("#projectSecondMainDiv").show();
				} else {
					jqUser("#projectMainDivContent").show();
					jqUser("#projectSecondMainDiv").hide();
				}	
				var generaterow = function (j) {
					var row = {};
                    row["userId"] = data[j].userId;
   	                row["userName"] = data[j].userName;		
   	             	row["emailAddress"] = data[j].emailAddress; 
   	                 
   	             	var numbers=data[j].phoneList;
   	             	//alert('numbers......'+numbers);
   	              var phoneNumbers='';
   	             	for(var i=0;i<numbers.length;i++){
   	             		if(numbers.length==1)
   	             		phoneNumbers+=numbers[i].phoneObject;
   	             		else
   	             	phoneNumbers+=numbers[i].phoneObject+' ';
   	             	}
   	             //	alert('PH.......'+phoneNumbers);
   	             	row["phoneNumbers"] = phoneNumbers;
   	            	var role=data[j].roleList; 
   	             	var roleNames='';
   	             	for(var i=0;i<role.length;i++){
   	             		 if(role.length==1)
   	             		roleNames+=role[i].roleObject;
   	             		else 
   	             	  roleNames+=role[i].roleObject+' ';
   	             	}
   	             row["roleNames"] = roleNames; 
   	             	
   	             	
   	                return row;
					}
					for (var j=0; j < data.length; j++) {
						var phoneNumbers=data[j].phoneList;
						var row = generaterow(j);
		  	            records[j] = row;
		 	        }
					var source =
   		            {
   		                localdata: records,
   		                datatype: "local",   		             	
   		                datafields:
   		                [
   		                    { name: 'userId', type: 'number' },
   		                    { name: 'userName', type: 'string' },
   		                 	{ name: 'emailAddress', type: 'string' },
   		                 	{ name: 'phoneNumbers', type: 'string'},
   		                 	{ name: 'roleNames', type: 'string'},
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
	   		       			  return '<input type="image" src="/html/img/Settings.png" width="1" height="20" onClick="workSheetButtonClick(event)" class="workSheetButton" id="' + id + '" value="Actions" style="margin-left:25px;margin-top: 3px;"/>' 
			 	        	  };
			 	        	  
			 	        	 var dataAdapter = new jqUser.jqx.dataAdapter(source);
								
			   		        	jqUser("#projectDetails").jqxGrid(
			   		            {
			   		            	width:'100%',
			   		                height:425,
			   		                source: dataAdapter,
			   		             	showfilterrow: true,
			   		                enabletooltips: true,
			   		                groupable: true,
			   		                sortable: true,
			   		                showaggregates: true,
			   		                altrows: true,
			   		                autorowheight: true,
			   		                filterable: true,		   		                
			   		                pageable: true,
			   	   		            selectionmode: 'checkbox',
			   		                columnsresize: true,		                
			      		            columns: [ 
			   		                  { text: 'Name',columntype: 'textbox', filtertype: 'textbox',datafield: 'userName', width:'38.5%'},
			   		               	  { text: 'Email Address',columntype: 'textbox', filtertype: 'textbox',datafield: 'emailAddress', width: '20%',filterable: false},
			   		            	  { text: 'PhoneNumber',columntype: 'textbox', filtertype: 'textbox', datafield: 'phoneNumbers',width: '15%',filterable: false},
			   		            	 { text: 'Roles',columntype: 'textbox', filtertype: 'textbox', datafield: 'roleNames',width: '20%',filterable: false},
			   		            	{ text: 'Action', cellsrenderer: workSheetButton_html, datafield: 'userId',width:'6%', cellsalign: 'center',filterable: false}
			   		            	  
			   		                ]
			   		         });
			   		        	jqUser("#columntableprojectDetails").find(".jqx-checkbox-default").css('display', 'none');
				},
				
				
			});
			   		        	
			   		        	
           
	}
	
	
	
	
var workSheetButtonClick= function (event) {
		
		try{
			
		   // create context menu for Task
           var taskContextMenu = jqUser("#taskMenu").jqxMenu({ width: 160, height: 162, autoOpenPopup: false, mode: 'popup'});
           jqUser("#projectDetails").on('contextmenu', function () {
               return false;
           });
           
           var buttonID = event.target.id;	    
           jqUser("#projectDetails").jqxGrid('selectrow', buttonID);
   	       var scrollTop = jqUser(window).scrollTop();
   	       var scrollLeft = jqUser(window).scrollLeft();
   	       taskContextMenu.jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
   	       return false;
         }catch(e) {
         	alert('error in contextmenu: ' + e);
         }
      }
			
	
	// handle context menu clicks.
   
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

 
<!--*****************************************************************************************
* Created By   : Shashank Kolpuru
* Created On   : April 6, 2014 5:49:23 PM
********************************************************************************************
  Purpose      : Getting View details Popup In Project.
******************************************************************************************* -->



<script type="text/javascript">
jqUser(document).ready(function() {
	jqUser('html').click(function() {
		jqUser(".actions_dropdown").hide(0);
});
	jqUser('#secondBoxDiv').click(function(event) {		
event.stopPropagation();
if(jqUser(".actions_dropdown").css('display') == '') {
	jqUser(".actions_dropdown").css('display', 'block');
} else  {
	jqUser(".actions_dropdown").css('display', '');
}
jqUser(".actions_dropdown").toggle(0);
});			
});		
</script>


<style>
#boxDiv{
  width: 17%;
  height:32px;
  border: 1px solid gray;
  background-color: #FFFFFF;
  margin-left: 370px;
  margin-top: 14px;
}

#secondBoxDiv{
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
margin-left:15px;
}

#downArrowImage{
padding-top: 10px;
width: 13px;
padding-left: 10px;
}


#createProjectTextStyle{
	color: rgb(51, 51, 51);
	padding-top: 5px;
	padding-left: 31px;
}

#enter{
padding-left: 309px;
}

</style>
<div id="projectSecondMainDiv" style="display:none;">
<span id="enter">You don't have any user please add user</span>
<div id="main body">
<div id="boxDiv">
<div id="createProjectTextStyle">Add User</div>
<div id="secondBoxDiv">
<img src="/html/img/Down_arrow.png" id="downArrowImage"> 
</div>
<div class="actions_dropdown">	
    <ul>
		<li onClick="alert('Under Construction')">Quick</li>
        <li onclick="alert('Under Construction')">Full</li>

        <li onclick=' <portlet:namespace />importUser();'>Import</li>

    </ul>
</div>
</div>
</div>
</div>



