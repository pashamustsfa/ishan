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
<liferay-theme:defineObjects />

<portlet:resourceURL var="resourceURL"></portlet:resourceURL>
<%
	long teamId = ParamUtil.getLong(request,"teamId");
%>

<style>
.userProfiles{
margin-top: 11px;
}
</style>

<aui:button class="btn" name="updateTeamUserAssociation" id="updateTeamUserAssociation" value="Update Association" label="" style="float:left;"></aui:button>

<div class="alert alert-success" id="<portlet:namespace  />successMsg" style="float:left;margin-left:10px;display:none;"> Your request completed successfully. </div>

<br/><br/>
<div class="userProfiles" id="userProfiles"></div>

<script>
	var jqMapResouce = jQuery.noConflict();
</script>

<script>
jqMapResouce(document).ready(function () {
	getUserDatails();
});
</script>

<script type="text/javascript">

jqMapResouce('#<portlet:namespace />updateTeamUserAssociation').click(function() {
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
	var teamId = record.teamId;
	jqMapResouce.ajax({
		url:'<%=resourceURL%>',
		dataType: "text",
		data:{
			<portlet:namespace  />cmd:'updateTeamUserAssociation',
			<portlet:namespace  />allSelectedVals:allSelectedVals,
			<portlet:namespace  />allUnSelectedVals:allUnSelectedVals,
			<portlet:namespace  />teamId:teamId
		},
		type: "post",
		
		success: function(data) {
			if(data == 1) {
				jqMapResouce('#<portlet:namespace  />successMsg').css('display','block');
				setTimeout(function() {
					jqMapResouce('#<portlet:namespace  />successMsg').css('display','none');
				},5000);
			} else {
				jqMapResouce('#<portlet:namespace  />successMsg').css('display','none');
			}
		}
	});
});

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
		var teamId = '<%= teamId%>';
		jqMapResouce.ajax({
			url:'<%=resourceURL%>',
			dataType: "json",
			data:{
				<portlet:namespace  />cmd:'orgranizationBasedUsersInfo',
				<portlet:namespace  />teamId:teamId
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
