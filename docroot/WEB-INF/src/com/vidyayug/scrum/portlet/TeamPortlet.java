package com.vidyayug.scrum.portlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import com.liferay.portal.kernel.cache.MultiVMPoolUtil;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.webcache.WebCachePoolUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.vidyayug.global.NoSuchApplicationParamGroupException;
import com.vidyayug.global.NoSuchApplicationParamValueException;
import com.vidyayug.global.model.ApplicationParamGroup;
import com.vidyayug.global.model.ApplicationParamValue;
import com.vidyayug.global.service.ApplicationParamGroupLocalServiceUtil;
import com.vidyayug.global.service.ApplicationParamValueLocalServiceUtil;
import com.vidyayug.scrum.service.BacklogLocalServiceUtil;
/**
 * Portlet implementation class TeamPortlet
 */
public class TeamPortlet extends MVCPortlet {
	 Log log=LogFactoryUtil.getLog(getClass());
	 SimpleDateFormat dt1 = new SimpleDateFormat("dd MMM, yyyy");
	 @Override
		public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortletException {
		System.out.println("ïnside server resource team portlet");
		MultiVMPoolUtil.clear();   
		WebCachePoolUtil.clear();
		String cmdValue =ParamUtil.getString(resourceRequest,"CMD");
		System.out.println("CMD value..."+cmdValue);
		if ("GetTeamData".equalsIgnoreCase(cmdValue)) {			
			System.out.println("Inside GetTeamData............");
			long isActive = 1;
			String artifactTypeLabel =ParamUtil.getString(resourceRequest,"artifactTypeLabel");
			System.out.println("chandan Printing artifactTypeId//////////////"+artifactTypeLabel);
			long artifactId =ParamUtil.getLong(resourceRequest,"artifactId");
			System.out.println("chandan Printing artifactId//////////////"+artifactId);
			try {
			  ApplicationParamGroup appGroup = ApplicationParamGroupLocalServiceUtil.findBygroupNameRecords("Scrum_Artifact_Team");
			  ApplicationParamValue appValue = ApplicationParamValueLocalServiceUtil.findByappParanNamesAppParamGrpId(artifactTypeLabel, appGroup.getAppParamGroupId());
			  long artifactTypeId = appValue.getAppParamValueId();
			  PrintWriter writer = resourceResponse.getWriter();
			  List records = null;		
			  records = BacklogLocalServiceUtil.getTeamData(artifactTypeId, artifactId, isActive);			
			  log.info("========= Printing records for team..............");
			  log.info("========= Result records.............."+records);
		  	  log.info("========= Printing artifactTypeId.............."+artifactTypeId);
		  	  log.info("========= Printing artifactId.............."+artifactId);
			  JSONArray jsonArray = getTeamDataJsonData(records);
			  log.info("========= getTeamDataJsonData DETAILS ::"+jsonArray);
			  writer.print(jsonArray); 	
			} catch (SystemException e) {
				e.printStackTrace();
			} catch (NoSuchApplicationParamValueException e) {
				e.printStackTrace();
			} catch (NoSuchApplicationParamGroupException e) {
				e.printStackTrace();
			}
		}	
}
	 	 
	 public JSONArray getTeamDataJsonData(List records)  {
		 System.out.println("Printing list of Records"+records);
		  JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		  for(Object teams:records) {			  
			  Object data[] = (Object[])teams;			  
			  long teamId =Long.valueOf(data[0].toString()) ;			  
			  JSONObject jsonObject = JSONFactoryUtil.createJSONObject();			  
			  jsonObject.put("teamId", Validator.isNotNull(data[0].toString())? Long.valueOf(data[0].toString()) : 0);
			  System.out.println("Printing teamId inside getTeamData........"+data[0].toString());			  
			  jsonObject.put("teamName", (Validator.isNotNull(data[1].toString()) ? data[1].toString(): " "));
			  System.out.println("Printing Name inside getTeamData........"+data[1].toString());			  
			  jsonObject.put("no_of_users", Validator.isNotNull(data[2].toString())? Long.valueOf(data[2].toString()) : 0);
			  System.out.println("Printing no_of_users inside getTeamData........"+data[2].toString());			  
			  jsonObject.put("no_of_backlogs", Validator.isNotNull(data[3].toString())? Long.valueOf(data[3].toString()) : 0);
			  System.out.println("Printing no_of_backlogs inside getTeamData........"+data[3].toString());			  
			  jsonObject.put("no_of_userstory", Validator.isNotNull(data[4].toString())? Long.valueOf(data[4].toString()) : 0);
			  System.out.println("Printing no_of_userstory inside getTeamData........"+data[4].toString());			  
			  jsonObject.put("users", getUsersTeamJsonData(teamId,1));
			  jsonArray.put(jsonObject);
			}
		  System.out.println("final result: " + jsonArray);
		     return jsonArray;
		   }
	 
	 public JSONObject getUsersTeamJsonData(long teamId,long projectId) throws NumberFormatException{
		 	JSONObject jsonObject1 = JSONFactoryUtil.createJSONObject();			
			JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
			List records = BacklogLocalServiceUtil.getUsersTeamData(teamId, 1);					
			System.out.println("Printing Records inside Userrrrr"+records);
			for(Object users:records){				
				Object data[] = (Object[])users;
				JSONObject jsonObject2 = JSONFactoryUtil.createJSONObject();
				jsonObject2.put("teamId", Validator.isNotNull(data[0].toString())? Long.valueOf(data[0].toString()) : 0);
				System.out.println("Printing teamId inside getUsersTeamJsonData........"+data[0].toString());			  
				jsonObject2.put("screenName", (Validator.isNotNull(data[2].toString()) ? data[2].toString(): " "));
				System.out.println("Printing screenName inside getUsersTeamJsonData........"+data[2].toString());				
				jsonObject2.put("noOfTasks", Validator.isNotNull(data[3].toString())? Long.valueOf(data[3].toString()) : 0);
				System.out.println("Printing noOfTasks inside getUsersTeamJsonData........"+data[3].toString());
				try{
					System.out.println("Printing noOfHoursSpent inside getUsersTeamJsonData........"+data[4]);
					jsonObject2.put("noOfHoursSpent",Validator.isNotNull(data[4]) ? data[4].toString() : "");
				}
				catch(NumberFormatException nfcs){					
					nfcs.printStackTrace();
				}
				System.out.println("Printing noOfHoursSpent inside getUsersTeamJsonData........"+data[4].toString());				
				jsonObject2.put("timeLeft", Validator.isNotNull(data[5])? data[5].toString() : "");	
				System.out.println("Printing timeLeft inside getUsersTeamJsonData........"+data[5].toString());
				jsonArray.put(jsonObject2);
			}
			jsonObject1.put("user", jsonArray);
			return jsonObject1;
		}
}