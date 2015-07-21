<%@page import="com.vidyayug.scrum.service.BacklogLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.Team"%>
<%@page import="com.vidyayug.attribute.service.Team_HierarchyLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.Group"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ include file="/html/init.jsp" %>
<link rel="stylesheet" href="/html/css/CommonStyle.css"></link>
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
<script type="text/javascript" src="/html/js/jqx/jqxgrid.grouping.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.columnsresize.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.aggregates.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.sort.js"></script>
<script type="text/javascript" src="/html/js/jqx/demos.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxcheckbox.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.pager.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxlistbox.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxdropdownlist.js"></script>
<script type="text/javascript" src="/html/js/jqx/jqxgrid.filter.js"></script>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<liferay-theme:defineObjects />

<portlet:resourceURL var="resourceURL"></portlet:resourceURL>
<%
	long teamId = ParamUtil.getLong(request,"teamId");
	long artifactId = ParamUtil.getLong(request,"artifactId");
	String artifactTypeLabel = ParamUtil.getString(request,"artifactTypeLabel");
	System.out.println("add_user...........................teamId: " + teamId);
	
	ApplicationParamGroup appGroup = ApplicationParamGroupLocalServiceUtil.findBygroupNameRecords("Scrum_Artifact_Team");
	  ApplicationParamValue appValue = ApplicationParamValueLocalServiceUtil.findByappParanNamesAppParamGrpId(artifactTypeLabel, appGroup.getAppParamGroupId());
	  long artifactTypeId = appValue.getAppParamValueId();
	  List records = BacklogLocalServiceUtil.getTeamData(artifactTypeId, artifactId, 1);
%>

<style>
.userProfiles{
	margin-top: 11px;
}

#optionRow .labelText {
	font-size:12px;float:left;width:65px;height:25px;line-height:25px;
}

#optionRow .teamSelect {
	width:150px;
}

#optionRow select {
	font-size:12px;float:left;width:135px;margin: 0;
}

#updateTeamUserAssociation {

}
</style>
<div id="optionRow">
	<span class="labelText">Team: </span>
	<span class="labelText teamSelect">
	<select name="orgTeams" id="<portlet:namespace  />orgTeams">
		<option value="0">Select</option>
		<c:if test='<%= records!=null&&!records.isEmpty()%>'>
<%-- 			<c:forEach items="{records}" var="teams">
				<c:forEach items="{teams}" var="i">
				</c:forEach>
				<option value='<%=Long.valueOf(data[0].toString()) %>' selected="selected"><%=data[1].toString()%></option>
			</c:forEach> --%>
			<%
			for(Object teams:records) {			  
				  Object data[] = (Object[])teams;
				  if(teamId == Long.valueOf(data[0].toString())) {
			%>
			<option value='<%=Long.valueOf(data[0].toString()) %>' selected="selected"><%=data[1].toString()%></option>
			<%
											} else  {
			%>
			<option value='<%=Long.valueOf(data[0].toString()) %>'><%=data[1].toString()%></option>
			<%
											}
				}
			%>
		</c:if>
	</select>
	</span>				
	/* <aui:button name="updateTeamUserAssociation" id="updateTeamUserAssociation" value="Update Association" label="" style="float:left;width:160px;height:30px;text-shadow: 0px 0px #FFF;"></aui:button> */
	
	<div class="alert alert-success" id="<portlet:namespace  />successMsg" style="float:left;margin-left:10px;display:none;"> User assigned successfully. </div>
	<div class="alert alert-success" id="<portlet:namespace  />nosuccessMsg" style="float:left;margin-left:10px;display:none;"> Please Assign Users. </div>
	
</div>
<br/><br/>
<div class="userProfiles" id="userProfiles"></div>

<script>
	var jqMapResouce = jQuery.noConflict();
</script>

<script>
jqMapResouce(document).ready(function () {
	
	getUserDatails();
});

jqMapResouce("#<portlet:namespace  />orgTeams").change(function(event) {
	getUserDatails();
});

/* jqMapResouce('#<portlet:namespace />updateTeamUserAssociation').click(function() {  */
	function save(){
	var allSelectedVals=[];
	var rowindexes = jqMapResouce('#userProfiles').jqxGrid('getselectedrowindexes');
	for (var i = 0; i < rowindexes.length; i++) {
		var data = jqMapResouce('#userProfiles').jqxGrid('getrowdata', rowindexes[i]);
		allSelectedVals.push(data.userId);
	}
	allSelectedVals = '-' + allSelectedVals;
	allSelectedVals = allSelectedVals.substring(1);

	var allUnSelectedVals = '-' + getUnselectedIndexes();
	allUnSelectedVals = allUnSelectedVals.substring(1);

	var record = jqMapResouce('#userProfiles').jqxGrid('getrowdata', 0);
	var teamId = jqMapResouce("#<portlet:namespace  />orgTeams").val();
	if(teamId > 0) {
		jqMapResouce.ajax({
			url:'<%=resourceURL%>',
			dataType: "text",
			data:{
				<portlet:namespace  />CMD:'updateTeamUserAssociation',
				<portlet:namespace  />allSelectedVals:allSelectedVals,
				<portlet:namespace  />allUnSelectedVals:allUnSelectedVals,
				<portlet:namespace  />teamId:teamId
			},
			type: "post",
			
			success: function(data) {
				if(data == 1) {
				    var size=allSelectedVals.split(',').length;
					if(size==1){
					jqMapResouce('#<portlet:namespace  />successMsg').text('User assigned successfully.');
					}
					if(size>1){
						jqMapResouce('#<portlet:namespace  />successMsg').text('Users assigned successfully.');
					}
					jqMapResouce('#<portlet:namespace  />successMsg').css('color','#000000');
					jqMapResouce('#<portlet:namespace  />successMsg').css('display','block');
					setTimeout(function() {
						jqMapResouce('#<portlet:namespace  />successMsg').css('display','none');
					},5000);
				} 
				if(data == 2) {
						jqMapResouce('#<portlet:namespace  />nosuccessMsg').text('Please Assign Users');
						jqMapResouce('#<portlet:namespace  />nosuccessMsg').css('color','#000000');
						jqMapResouce('#<portlet:namespace  />nosuccessMsg').css('display','block');
						setTimeout(function() {
							jqMapResouce('#<portlet:namespace  />nosuccessMsg').css('display','none');
						},5000);
				}
			}
		});
	} else {
		jqMapResouce('#<portlet:namespace  />successMsg').css('display','block');
		jqMapResouce('#<portlet:namespace  />successMsg').text('Please select team 1st.');
		jqMapResouce('#<portlet:namespace  />successMsg').css('color','#ff0000');
	}
};

function getUnselectedIndexes() {
	
    var selectedIndexes = jqMapResouce('#userProfiles').jqxGrid('getselectedrowindexes');

    var meta = jqMapResouce('#userProfiles').jqxGrid('getdatainformation');
    var total = meta.rowscount;

    var allUnSelectedVals = new Array();

    for (var i=0; i < total; i++) {
    	
        if (selectedIndexes.indexOf(i) !== -1) {
        	
            continue;
        }
        var dataRecord = jqMapResouce("#userProfiles").jqxGrid('getrowdata', i);
        allUnSelectedVals.push(dataRecord.userId);
    }

    return allUnSelectedVals;
}
</script>



<script>
function getUserDatails() {
	try {
		var orgTeams = jqMapResouce("#<portlet:namespace  />orgTeams").val();

		jqMapResouce.ajax({
			url:'<%=resourceURL%>',
			dataType: "json",
			data:{
				<portlet:namespace  />CMD:'orgranizationBasedUsersInfo',
				<portlet:namespace  />teamId:orgTeams
			},
			type: "post",
			
			success: function(data) {
				printUserDatails(data);
			}
		});


	} catch(e) {
	    alert('waiting: ' + e);
	}
};
</script>


<script>
function printUserDatails(data) {
	var records = {};
	try {
		
	    var generaterow = function (j) {
 	    	var row = {};
            row["userId"] = data[j].userId;
            row["imgPath"] = data[j].imgPath;
			row["screenName"] = data[j].screenName;
            row["fullName"] = data[j].fullName;
            row["teamId"] = data[j].teamId;
            row["isMember"] = data[j].isMember;
            
            //alert(data[j].userId + ' = ' + data[j].screenName + ' = ' + data[j].fullName + ' = ' + data[j].teamId + ' = ' + data[j].isMember + ' = ' + data[j].imgPath);
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
		                    { name: 'userId', type: 'number' },
		                    { name: 'imgPath', type: 'string' },
		                    { name: 'screenName', type: 'string' },
		                    { name: 'fullName', type: 'string' },
		                    { name: 'teamId', type: 'number' },
		                    { name: 'isMember', type: 'number' }
		                ]
		            };

        	var dataAdapter = new jqMapResouce.jqx.dataAdapter(source);
        	jqMapResouce("#userProfiles").jqxGrid(
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
   		                    return '<table style="height: 80px;"><tr><td>' + row.imgPath + '</td></tr><tr><td>' + row.fullName + '</td></tr></table>';
   		                },	                
      		            columns: [
   		                  { text: ' ', datafield: 'imgPath', width:'50'},
   		                  { text: 'Screen Name', datafield: 'screenName', width:'55%'},
   		              	  { text: 'Full Name', datafield: 'fullName', width:'55%'}
   		               ]
   		            }); 
        	jqMapResouce("#userProfiles").find(".jqx-checkbox-default:first").css('display', 'none');
        	if(data.length>0) {
				var rowindexes = jqMapResouce('#userProfiles').jqxGrid('getselectedrowindexes');
				for (var i = 0; i < rowindexes.length; i++) {
				   jqMapResouce('#userProfiles').jqxGrid('unselectrow', i);
				} 
			}
        	
        	var rows = jqMapResouce('#userProfiles').jqxGrid('getrows');
            var rowsCount = rows.length;
            for (var k = 0; k < rowsCount; k++) {
                var value = jqMapResouce('#userProfiles').jqxGrid('getcellvalue', k, "isMember");
                if (value == '1') {
                    jqMapResouce('#userProfiles').jqxGrid('selectrow', k);
                };
            };

	}catch(e) {
		alert(e);
	}
}

</script>
