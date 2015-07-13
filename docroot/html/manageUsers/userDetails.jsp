

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ include file="/html/init.jsp"%>
<link rel="stylesheet" href="/html/css/CommonStyle.css"></link>
<link rel="stylesheet" href="/html/css/jqx.base.css" type="text/css" />
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
<%-- <script type='text/javascript' src='<%=renderRequest.getContextPath()%>/js/jquery-1.11.1.min.js'></script> --%>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.pager.js"></script>

<script type="text/javascript" src="/html/js/jqx/jqxtree.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxcheckbox.js"></script>

<script  src='<%=renderRequest.getContextPath()%>/js/highcharts.js'></script>
<script src='<%=renderRequest.getContextPath()%>/js/exporting.js'></script>


<!-- <script type="text/javascript" src="/html/js/jqx/highcharts.js"></script>
<script type="text/javascript" src="/html/js/jqx/exporting.js"></script> -->

    <link rel="stylesheet" href="<%=renderRequest.getContextPath()%>/css/viewDetails.css" type="text/css" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- portlet related code -->
<portlet:resourceURL var="userURL"></portlet:resourceURL>
<!-- portlet related code -->
<!-- html code -->
<%
long selecteduserId=0;

try{
 selecteduserId = (Long)ParamUtil.getLong(renderRequest, "selecteduserId");
 }catch(Exception e){
	 System.out.println("exception in selecteduserid====="+e);
 }
%>

<body>
<div id="totalDiv" >
<div id="navigateDiv" style="margin-top:50px;">
<div id="userText"><a href="<portlet:renderURL/>" style="text-decoration: none;">User list</a></div>
<img src="/html/img/arrow-right.png" id="userTextImage"/>
</div>

<div id="userProfile" >
	<div id="userDetails" >
	
	<table id="userDetailsTable" class="tableData table">
  <tr id="userNameRow">
    <th>Name</th>
    <td></td>		
    
  </tr>
  <tr id="userRoleRow">
    <th>Role</th>
    <td class="moretextTd"></td>		
    
  </tr>
  <tr id="userEmailRow">
    <th>Email</th>
    <td ></td>		
    
  </tr>
  <tr id="userPhoneRow">
    <th>Phone</th>
    <td class="moretextTd"></td>		
    
  </tr>
  <tr id="userOrgNameRow">
    <th>Organization</th>
    <td></td>		
    
  </tr>
  <tr id="userDOJRow">
    <th>DOJ</th>
    <td></td>		
    
  </tr>
  <tr id="userTeamNamesRow">
    <th>Team Name</th>
    <td class="moretextTd"></td>		
    
  </tr>
</table>
	</div>
	<div id="taskDetails">
	
	<table id="taskDetailsTable" class="tableData table">
  
  <tr id="currentReleaseRow">
    <th>currentRelease</th>
    <td class="moretextTd"></td>		
    
  </tr>
  <tr id="currentBacklogRow">
    <th>currentBacklog</th>
    <td></td>		
    
  </tr>
  <tr id="currentSprintRow">
    <th>currentSprint</th>
    <td class="moretextTd"></td>		
    
  </tr>
  <tr id="currentUserStoryRow">
    <th>currentUserStory</th>
    <td class="moretextTd"></td>		
    
  </tr>
</table>
</div>
	<div id="taskGraph">
	
	<div id="pie_container"></div>
	</div>
	<div id="userPhoto">
	
	</div>
</div>
<div id="<portlet:namespace />taskGrid" class="taskGrids">

</div>

</div>


<div id="<portlet:namespace />taskMenu" class="actions_dropdown" style="margin-left:405px !important;height:110px !important;width:140px !important;">	
	    <ul>
	   		<!-- <li onclick="viewTaskDetails();"><img alt="View Details" src="/html/img/view.png" style="width: 15%;">&nbsp;&nbsp;View Details</li>
			<li onclick="editTeam();"><img alt="Edit" src="/html/img/edit.png" style="width: 15%;">&nbsp;&nbsp;Edit</li> -->
	   		<li><img alt="View Details" src="/html/img/view.png" style="width: 15%;">&nbsp;&nbsp;View Details</li>
			<!-- <li><img alt="Assign User" src="/html/img/add (2).png" style="width: 15%;">&nbsp;&nbsp;Assign User</li> -->
	    </ul>
	</div>


	
</body>

 <!-- html code -->
 <script type="text/javascript" >
	var jqUserTaskData = jQuery.noConflict();
	jqUserTaskData(document).ready(function() {
		getTeamData();
		getUserDetails();
		pieChart();
	});
</script>
 
 <script type="text/javascript" >
jqUserTaskData(document).ready(function() {
	
	jqUserTaskData('html').click(function() {
		jqUserTaskData(".actions_dropdown").hide(0);
	});
	
	jqUserTaskData('.actions_button').click(function(event) {		
		event.stopPropagation();
		if(jqUserTaskData(".actions_dropdown").css('display') == '') {
			jqUserTaskData(".actions_dropdown").css('display', 'block');
		} else  {
			jqUserTaskData(".actions_dropdown").css('display', '');
		}
		jqUserTaskData(".actions_dropdown").toggle(0);
	});			
});	
</script>
 
 
 <script>
 function getTeamData() {
	 
	var userId = <%=selecteduserId%>;
	
	
	try{
		var records = {};
		jqUserTaskData.ajax({
			url:'<%=userURL%>',
			dataType: "json",
			data:{
				<portlet:namespace  />CMD:'GetTaskData',
				<portlet:namespace  />userId:userId
				},
			type: "post",
			success: function(data) {
				
				
				var generaterow = function (j) {
   	                var row = {};
                    row["taskId"] = data[j].taskid;
		            row["taskName"] = data[j].taskName;
					row["EstDate"] = data[j].EstDate;
		            row["phaseName"] = data[j].phaseName;
		            row["timeLeft"] = data[j].timeLeft;
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
							{ name: 'taskId', type: 'number' },
							{ name: 'taskName', type: 'string' },
							{ name: 'EstDate', typex: 'number' },
							{ name: 'phaseName', type: 'string' },
							{ name: 'timeLeft', type: 'number' }
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
			 	        	  
			 	    var dataAdapter = new jqUserTaskData.jqx.dataAdapter(source);
			 	        								
					jqUserTaskData("#<portlet:namespace />taskGrid").jqxGrid({
						
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
						columns: [ 
    		                      { text: 'TaskName', datafield: 'taskName', filtertype: 'textbox',width: '30%'},
    		                      { text: 'EstDate', datafield: 'EstDate', filtertype: 'textbox',width: '11%',filterable: false},
    		                      { text: 'phaseName', datafield: 'phaseName', width: '11%',filterable: false},
    		                      { text: 'timeLeft', datafield: 'timeLeft',width:'11%',filterable: false},
    	   		                  { text: 'Action', cellsrenderer: workSheetButton_html, datafield: 'taskId',width:'8%', cellsalign: 'center',filterable: false}
						]
					});	 
			},
				complete: function(){
				 jqUserTaskData('#<portlet:namespace />taskGrid input[type="textarea"]'). attr("placeholder", "Search TaskName ..."); 
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
	       var taskContextMenu = jqUserTaskData("#<portlet:namespace />taskMenu").jqxMenu({ width: 160, height: 202, autoOpenPopup: false, mode: 'popup'});
	       jqUserTaskData("#<portlet:namespace />taskGrid").on('contextmenu', function () {
	           return false;
	       });
	       
	       //handle context menu clicks.
	       jqUserTaskData("#<portlet:namespace />taskMenu").on('itemclick', function (event) {
	    	   
	    	   if(i == 0) {
		    	   i = 1;
		           var args = event.args;
		           var rowindex = jqUserTaskData("#<portlet:namespace />taskGrid").jqxGrid('getselectedrowindex');
		           
		           if (jqUserTaskData.trim(jqUserTaskData(args).text().trim()) == "View Details") {
		               editrow = rowindex;
		            	jqUserTaskData("#<portlet:namespace />rowId").val(editrow);
		            	var dataRecord = jqUserTaskData("#<portlet:namespace />taskGrid").jqxGrid('getrowdata', editrow);
		            	<portlet:namespace />viewTaskDetails(dataRecord.taskId)
		           } 
	    	   }
	       });
	       
	       var buttonID = event.target.id;	    
	       jqUserTaskData("#<portlet:namespace />taskGrid").jqxGrid('selectrow', buttonID);
		   var scrollTop = jqUserTaskData(window).scrollTop();
		   var scrollLeft = jqUserTaskData(window).scrollLeft();
		   taskContextMenu.jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
		   return false;
		   
	     }catch(e) {
	     	alert('error in contextmenu: ' + e);
	     }
	}


function <portlet:namespace />viewTaskDetails(taskId){
	alert('under construction');
}

function getUserDetails() {
	
var userId = <%=selecteduserId%>;
	
	
	try{
		
		jqUserTaskData.ajax({
			url:'<%=userURL%>',
			dataType: "json",
			data:{
				<portlet:namespace  />CMD:'GetUserDetails',
				<portlet:namespace  />userId:userId
				},
			type: "post",
			success: function(data) {
			
					for(var i=0;i<=data[0].getUsersJsonData.length;i++){
					 var userId=data[0].getUsersJsonData[i].userId;
					 var userName=data[0].getUsersJsonData[i].userName; 
					 var organizationName=data[0].getUsersJsonData[i].organizationName;
					 var JoinedDate=data[0].getUsersJsonData[i].JoinedDate;
					 var emailAddress=data[0].getUsersJsonData[i].emailAddress;
					 var phoneList=data[0].getUsersJsonData[i].phoneList;
					 var roleList=data[0].getUsersJsonData[i].roleList;
					 var teamList=data[0].getUsersJsonData[i].teamList;
					 var imgPath=data[0].getUsersJsonData[i].imgPath;
					 var phoneNumber="";
					 var roles="";
					 var teamNames="";
					
					 for (var i=0; i < phoneList.length; i++) {
						 
						 phoneNumber=phoneNumber+' '+phoneList[i].phoneObject;
					 }
					 for (var i=0; i <roleList.length; i++) {
						 roles=roles+' '+roleList[i].roleObject;
					 }
					  for (var i=0; i < teamList.length; i++) {
						 teamNames=teamNames+' '+teamList[i].teamObject;
					 }
					  
					 jqUserTaskData("#userDetailsTable").find('#userNameRow').find("td").html(userName);
					 jqUserTaskData("#userDetailsTable").find('#userEmailRow').find("td").html(emailAddress);
					 jqUserTaskData("#userDetailsTable").find('#userRoleRow').find("td").html(roles);
					 jqUserTaskData("#userDetailsTable").find('#userPhoneRow').find("td").html(phoneNumber);
					 jqUserTaskData("#userDetailsTable").find('#userOrgNameRow').find("td").html(organizationName);
					 jqUserTaskData("#userDetailsTable").find('#userDOJRow').find("td").html(JoinedDate);
					 jqUserTaskData("#userDetailsTable").find('#userTeamNamesRow').find("td").html(teamNames);
					 jqUserTaskData('#userPhoto').prepend(imgPath);
					}
					 var taskId=0;
					 var taskName=""; 
					 var AssignedName="";
					 var userStoryName="";
					 var backlogName="";
					 var sprintName="";
					 var releaseName="";
					 var EstDate="";
					 var statusName="";
					 var phaseName="";
					 var timeLeft="";
					for(var i=0;i<data[0].getUserwiseTaskList.length;i++){
						 taskId=data[0].getUserwiseTaskList[i].taskId; 
						 taskName=taskName+''+data[0].getUserwiseTaskList[i].taskName; 
						 AssignedName=data[0].getUserwiseTaskList[i].AssignedName;
						 userStoryName=userStoryName+''+data[0].getUserwiseTaskList[i].userStoryName;
						 backlogName=backlogName+''+data[0].getUserwiseTaskList[i].backlogName;
						 sprintName=sprintName+''+data[0].getUserwiseTaskList[i].sprintName;
						 releaseName=releaseName+''+data[0].getUserwiseTaskList[i].releaseName;
						 EstDate=data[0].getUserwiseTaskList[i].EstDate;
						 statusName=data[0].getUserwiseTaskList[i].statusName;
						 phaseName=data[0].getUserwiseTaskList[i].phaseName;
						 timeLeft=data[0].getUserwiseTaskList[i].timeLeft;		
						 
						
						 
					
					}
					jqUserTaskData("#taskDetailsTable").find('#currentReleaseRow').find("td").html(releaseName);
					jqUserTaskData("#taskDetailsTable").find('#currentBacklogRow').find("td").html(backlogName);
					jqUserTaskData("#taskDetailsTable").find('#currentSprintRow').find("td").html(sprintName);
					 jqUserTaskData("#taskDetailsTable").find('#currentUserStoryRow').find("td").html(userStoryName);
					/*  alert('userId--'+userId);
					 alert('userName--'+userName);
					 alert('organizationName--'+organizationName);
					 alert('JoinedDate--'+JoinedDate);
					 alert('emailAddress--'+emailAddress);
					 alert('phoneNumber--'+phoneNumber);
					 alert('roles--'+roles);
					 alert('teamNames--'+teamNames);
					  */
					
			},
				complete: function(){
					
				}
				
		});
	}catch(e){
		alert('error in getResource : ' + e);
	}
}

</script>
<script>
var statusOfModules='';
function pieChart(){
	

	
	var userId = <%=selecteduserId%>;
	var dataInChart = [];
	try {
		
		jQuery.ajax({
			url:'<%=userURL%>',
			dataType: "json",
			data:{
				<portlet:namespace  />CMD:'Graph',
				<portlet:namespace  />userId:userId
				
			},
			type: "post",
			success: function(data) {
				
				var totalModules=0;
				var numberOfModules=0;
				var countOfModules=0;
				
				
				for (var j=0; j < data.length; j++) {
					numberOfModules= data[j].moduleList;
					totalModules=totalModules+numberOfModules;
				}	
				var percentageMultiple=100/totalModules;
				jqUserTaskData('#pie_container').empty();
				for (var j=0; j < data.length; j++) {
				
					countOfModules= (data[j].moduleList)*percentageMultiple;
					statusOfModules= data[j].status_;
					
					dataInChart.push({
						 statusOfModules: statusOfModules,
						 countOfModules: countOfModules
		            });
				}
			},
			 complete: function(){
				 drawPieChart(dataInChart);
		        }
		});
	} catch(e) {
		alert(e);
	}
}

function drawPieChart(dataInChart){
	
	try{
			jqUserTaskData('#pie_container').highcharts({
	        chart: {
	            plotBackgroundColor: null,
	            plotBorderWidth: null,
	            plotShadow: false
	        },
	        title: {
	            text:'Task Status'
	        },
	        subtitle: {
	            text: 'Progress Graph'
	        },
	        tooltip: {
	            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
	        },
	        plotOptions: {
	            pie: {
	                allowPointSelect: true,
	                cursor: 'pointer',
	                dataLabels: {
	                    enabled: true,
	                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
	                    style: {
	                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
	                    }
	                }
	            }
	        },
	        
	        series: [{
	            type: 'pie',
	            name: 'Task Status',
	            /* data: dataInChart */
	            data: [
	                   [dataInChart[0].statusOfModules, dataInChart[0].countOfModules],
	                   [dataInChart[1].statusOfModules, dataInChart[1].countOfModules],
	                   [dataInChart[3].statusOfModules, dataInChart[3].countOfModules],
	                   {
	                       name: dataInChart[2].statusOfModules,
	                       y: dataInChart[2].countOfModules,
	                       sliced: true,
	                       selected: true
	                   }
	               ]
	  	 	}]
	     });
	} catch(e) {
		alert(e);
	}
}





</script>

