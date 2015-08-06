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


<%
 try {

	MultiVMPoolUtil.clear();   
	WebCachePoolUtil.clear();

	Log log=LogFactoryUtil.getLog(getClass());
	
	long teamId = ParamUtil.getLong(renderRequest,"teamId", 0);
	long artifactId = ParamUtil.getLong(renderRequest,"artifactId");
	String artifactTypeLabel = ParamUtil.getString(renderRequest,"artifactTypeLabel");
	
%>
<portlet:resourceURL var="userURL"></portlet:resourceURL>
<liferay-portlet:renderURL var="addUserURL" windowState="<%= com.liferay.portal.kernel.portlet.LiferayWindowState.POP_UP.toString() %>" >
	<liferay-portlet:param name="jspPage" value='<%="/html/team/add_user.jsp"%>' />
</liferay-portlet:renderURL>


<script type="text/javascript" >
	var jqUserData = jQuery.noConflict();
	jqUserData(document).ready(function() {
		getUserData();
	});
</script>

<script>
function getUserData() {
	try{
		var teamId = jqUserData("#<portlet:namespace />teamId").val();
		var artifactId = jqUserData("#<portlet:namespace />artifactId").val();
		var artifactTypeLabel = jqUserData("#<portlet:namespace />artifactTypeLabel").val();
		var records = {};
		jqUserData.ajax({
			url:'<%=userURL%>',
			dataType: "json",
			data:{
				<portlet:namespace  />CMD:'GetUserData',
				<portlet:namespace  />artifactId:artifactId,
				<portlet:namespace  />artifactTypeLabel:artifactTypeLabel,
				<portlet:namespace  />teamId:teamId
				},
			type: "post",
			success: function(data) {
				
				var generaterow = function (j) {
   	                var row = {};
                    row["teamId"] = data[j].teamId;
		            row["userId"] = data[j].userId;
					row["imgPath"] = data[j].imgPath;
		            row["screenName"] = data[j].screenName;
		            row["noOfTasks"] = data[j].noOfTasks;
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
							{ name: 'teamId', type: 'number' },
							{ name: 'userId', type: 'number' },
							{ name: 'imgPath', typex: 'string' },
							{ name: 'screenName', type: 'string' },
							{ name: 'noOfTasks', type: 'number' },
							{ name: 'timeLeft', type: 'number' }
						]
					};
	 	       		
			 	        	  
			 	    var dataAdapter = new jqUserData.jqx.dataAdapter(source);
			 	        
					jqUserData("#<portlet:namespace />userGrid").jqxGrid(
		   		            {
		   		                width: '100%',
		   		                height: 345,
		   		                source: dataAdapter,
		   		                groupable: true,
		   		                sortable: true,
		   		             	selectionmode: 'checkbox',
		   		                showaggregates: true,
		   		                altrows: true,
		   		                autorowheight: true,
		   		                filterable: true,
		   		                pageable: true,
		   		                columnsresize: true,
		   		                scrollmode: 'deferred',
		   		                scrollfeedback: function(row)
		   		                {
		   		                    return '<table style="height: 80px;"><tr><td>' + row.imgPath + '</td></tr><tr><td>' + row.screenName + '</td></tr></table>';
		   		                },	                
		      		            columns: [
		   		                  { text: ' ', datafield: 'imgPath', width:'50'},
		   		                  { text: 'Screen Name', datafield: 'screenName', width:'65%'},
		   		               	  { text: 'No of Tasks', datafield: 'noOfTasks', width: '15%'},
		   		               	  { text: 'Time Left', datafield: 'timeLeft', width: '15%'}
		   		               ]
		   		            }); 
			}
		});
	}catch(e){
		alert('error in getResource : ' + e);
	}
}

</script>

<script>
function <portlet:namespace />addUser(){
	try{ 
		var teamId = jqUserData("#<portlet:namespace />teamId").val();
		var artifactId = jqUserData("#<portlet:namespace />artifactId").val();
		var artifactTypeLabel = jqUserData("#<portlet:namespace />artifactTypeLabel").val();
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
							label: '<%= UnicodeLanguageUtil.get(pageContext, "lbl.form.label.close", "Close") %>',
							on: {
								click: function() {
									dialog.hide();
									getUserData();
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


</script>


<script type="text/javascript" >
jqUserData(document).ready(function() {
	jqUserData('html').click(function() {
		jqUserData(".actions_dropdown1").hide(0);
	});
	
	jqUserData('.actions_button1').click(function(event) {	
		
		event.stopPropagation();
		if(jqUserData(".actions_dropdown1").css('display') == '') {
			jqUserData(".actions_dropdown1").css('display', 'block');
		} else  {
			jqUserData(".actions_dropdown1").css('display', '');
		}
		jqUserData(".actions_dropdown1").toggle(0);
	});		
});		
</script>

<script type="text/javascript" >
jqUserData(document).ready(function() {
	
	jqUserData('html').click(function() {
		jqUserData(".actions_dropdown").hide(0);
	});
	
	jqUserData('.actions_button').click(function(event) {		
		event.stopPropagation();
		if(jqUserData(".actions_dropdown").css('display') == '') {
			jqUserData(".actions_dropdown").css('display', 'block');
		} else  {
			jqUserData(".actions_dropdown").css('display', '');
		}
		jqUserData(".actions_dropdown").toggle(0);
	});			
});	
</script>




<script type="text/javascript">
jqUserData(document).ready(function () {
	var source = [" ",];
	// Create a jqxComboBox
	jqUserData("#jqxComboBox").jqxComboBox({ source: source, selectedIndex: 0, width: '200px', height: '25px', theme: 'shinyblack' });
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
	<div class="teamDivheights" style="height:40px;">
		<aui:input name="teamId" id="teamId" type="hidden" value="<%=teamId %>"/>
		<aui:input name="artifactId" id="artifactId" type="hidden" value="<%=artifactId %>"/>
		<aui:input name="artifactTypeLabel" id="artifactTypeLabel" type="hidden" value="<%=artifactTypeLabel %>"/>

		<%-- <div id="thirdHeader" style="height:30px;line-height:30px;">
			<div class="dropdown" style="height: 20px; margin: auto 10px; width: 10%;float: left;border-right: 1px solid gray;line-height: 20px;margin-top: 5px;">
				<span style="font-size:12px;font-weight:bold;float:left;width:35px;" onclick="<portlet:namespace />addUser();">Add</span>
				<div class="actions_button1" style="float:left;" onclick="<portlet:namespace />addUser(0);"><img src="/html/img/add (2).png" style="width:16px;height:16px;"></div>
			</div>
		
		</div> --%>
	</div>
	
	<div id="<portlet:namespace />userGrid" class="userGrid"></div>

</body>
<style>
button {
	height: 30px;
	padding: 0px;
	width: 60px;
}
</style>
<%} catch (Exception e) {
    e.printStackTrace();
%>
<h2>Service Unavailable!</h2>
<%
}
%>