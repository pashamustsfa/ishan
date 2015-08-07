package com.vidyayug.scrum.portlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import com.liferay.portal.DuplicateTeamException;
import com.liferay.portal.kernel.cache.MultiVMPoolUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.webcache.WebCachePoolUtil;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.Team;
import com.liferay.portal.model.User;
import com.liferay.portal.service.TeamLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.UserServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.test.layout.portlet.util.CreateTeamPortletUtil;
import com.vidyayug.global.NoSuchApplicationParamGroupException;
import com.vidyayug.global.NoSuchApplicationParamValueException;
import com.vidyayug.global.model.ApplicationParamGroup;
import com.vidyayug.global.model.ApplicationParamValue;
import com.vidyayug.global.service.ApplicationParamGroupLocalServiceUtil;
import com.vidyayug.global.service.ApplicationParamValueLocalServiceUtil;
import com.vidyayug.scrum.common.ScrumConstants;
import com.vidyayug.scrum.service.ArtifactTeamMappingLocalServiceUtil;
import com.vidyayug.scrum.service.BacklogLocalServiceUtil;

public class TeamPortlet extends MVCPortlet {
 Log log=LogFactoryUtil.getLog(getClass());
 SimpleDateFormat dt1 = new SimpleDateFormat("dd MMM, yyyy");
 @Override
 	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException, PortletException {
	log.info("ïnside server resource team portlet");
	MultiVMPoolUtil.clear();   
	WebCachePoolUtil.clear();
	String cmdValue =ParamUtil.getString(resourceRequest,"CMD");
	log.info("CMD value..."+cmdValue);
		ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(WebKeys.THEME_DISPLAY); 
		Group group = themeDisplay.getScopeGroup();
		long organizationId = group.getOrganizationId();
		
		if("orgranizationBasedUsersInfo".equalsIgnoreCase(cmdValue)) {
			
			long teamId = ParamUtil.getLong(resourceRequest,"teamId");
			List<User> usersList;
			try {
				usersList = UserLocalServiceUtil.getOrganizationUsers(organizationId);
			
				Iterator<User> usersIterator = usersList.iterator();
				JSONArray jsonArray = CreateTeamPortletUtil.getOrgAllUserJSONArray(teamId, usersIterator, themeDisplay);
				PrintWriter objWriter = PortalUtil.getHttpServletResponse(resourceResponse).getWriter();
				log.info("jsonArray: " + jsonArray);
				objWriter.print(jsonArray.toString());
			} catch (SystemException e) {
				e.printStackTrace();
			}
		} else if("updateTeamUserAssociation".equalsIgnoreCase(cmdValue)) {
			String allSelectedVals = ParamUtil.getString(resourceRequest,"allSelectedVals");
			String allUnSelectedVals = ParamUtil.getString(resourceRequest,"allUnSelectedVals");
			String allUnSelectedIds[]=null;
			String allSelectedIds[]=null;
			long teamId = ParamUtil.getLong(resourceRequest,"teamId");
			log.info("allSelectedVals: " + allSelectedVals);
			log.info("allUnSelectedVals: " + allUnSelectedVals);
			 
			if(!allSelectedVals.equalsIgnoreCase("")){
				allSelectedIds= allSelectedVals.split(",");
			}
			if(!allUnSelectedVals.equalsIgnoreCase("")){
				allUnSelectedIds= allUnSelectedVals.split(",");
			}
			
			PrintWriter objWriter = PortalUtil.getHttpServletResponse(resourceResponse).getWriter();
			long[] addUserIds = new long[allSelectedIds.length];
			int status = 0;
			long[] removeUserIds = new long[allUnSelectedIds.length];
			System.out.println("before for loop");
			if(!allUnSelectedVals.equalsIgnoreCase("")){
			for (int i = 0; i < allUnSelectedIds.length; i++) {
				System.out.println("Length......"+allUnSelectedIds.length);
				System.out.println("Printing Value......"+Long.valueOf(allUnSelectedIds[i]));
				removeUserIds[i] = Long.valueOf(allUnSelectedIds[i]);
			}
			try {
				UserServiceUtil.unsetTeamUsers(teamId, removeUserIds);
				status = 1;
				System.out.println("After Status.......");
			} catch (PortalException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			}	
			if(!allSelectedVals.equalsIgnoreCase("")){
			for (int i = 0; i < allSelectedIds.length; i++) {
				System.out.println("Printing Value of All Selected IDS......"+Long.valueOf(allSelectedIds[i]));
				addUserIds[i] = Long.valueOf(allSelectedIds[i]);
			}
			
			try {
				log.info("add userId........: " + addUserIds);
				log.info("add teamId........: " + teamId);
				UserServiceUtil.addTeamUsers(teamId, addUserIds);
				//
				status = 1;
			} catch (PortalException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			catch(Exception e){
				e.printStackTrace();
			}
			//log.info("status: " + status);
			//objWriter.print(status);
			}else{
				status = 2;
			}
			log.info("status: " + status);
			objWriter.print(status);
		
		} else if ("GetTeamData".equalsIgnoreCase(cmdValue)) {			
			long isActive = 1;
			String artifactTypeLabel =ParamUtil.getString(resourceRequest,"artifactTypeLabel");
			System.out.println("Printing sadasdasdasd artifactTypeLabel.........."+artifactTypeLabel);
			long artifactId =ParamUtil.getLong(resourceRequest,"artifactId");
			try {
			  ApplicationParamGroup appGroup = ApplicationParamGroupLocalServiceUtil.findBygroupNameRecords(ScrumConstants.APG_ARTIFACT_TEAM);
			  ApplicationParamValue appValue = ApplicationParamValueLocalServiceUtil.findByappParanNamesAppParamGrpId(artifactTypeLabel, appGroup.getAppParamGroupId());
			  System.out.println("Printing another artifactTypeLabel....."+artifactTypeLabel);
			  long artifactTypeId = appValue.getAppParamValueId();
			  PrintWriter writer = resourceResponse.getWriter();
			  List records = BacklogLocalServiceUtil.getTeamData(artifactTypeId, artifactId, isActive);
			  JSONArray jsonArray = getTeamDataJsonData(resourceResponse, artifactTypeLabel, artifactId, records, themeDisplay);
			  log.info("========= getTeamDataJsonData DETAILS ::"+jsonArray);
			  writer.print(jsonArray); 	
			} catch (SystemException e) {
				e.printStackTrace();
			} catch (NoSuchApplicationParamValueException e) {
				e.printStackTrace();
			} catch (NoSuchApplicationParamGroupException e) {
				e.printStackTrace();
			}
		} else if ("GetUserData".equalsIgnoreCase(cmdValue)) {		
			
			PrintWriter writer = resourceResponse.getWriter();
			String artifactTypeLabel =ParamUtil.getString(resourceRequest,"artifactTypeLabel");
			long artifactId =ParamUtil.getLong(resourceRequest,"artifactId");
			long teamId =ParamUtil.getLong(resourceRequest,"teamId");

			String artifactsList = StringPool.BLANK;
			if("project".equalsIgnoreCase(artifactTypeLabel)) {
				artifactsList= "project_id-" + artifactId + ";";
			}
			JSONArray jsonArray = getUsersTeamJsonData(artifactsList, teamId, themeDisplay);
			log.info("========= getTeamDataJsonData DETAILS ::"+jsonArray);
			writer.print(jsonArray); 
		}	
}
	 	 
	 public JSONArray getTeamDataJsonData(ResourceResponse resourceResponse, String artifactTypeLabel, long artifactId, List records, ThemeDisplay themeDisplay)  {

		 log.info(" Printing list of Records"+records);
		  JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		  for(Object teams:records) {		
			  
			  Object data[] = (Object[])teams;			  		  
			  JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
			  jsonObject.put("teamId", Validator.isNotNull(data[0].toString())? Long.valueOf(data[0].toString()) : 0);
			  jsonObject.put("teamName", Validator.isNotNull(data[1].toString())? data[1].toString() : " ");
			  jsonObject.put("no_of_users", Validator.isNotNull(data[2].toString())? Long.valueOf(data[2].toString()) : 0);
			  jsonObject.put("no_of_backlogs", Validator.isNotNull(data[3].toString())? Long.valueOf(data[3].toString()) : 0);
			  jsonObject.put("no_of_userstory", Validator.isNotNull(data[4].toString())? Long.valueOf(data[4].toString()) : 0);
			  jsonArray.put(jsonObject);
			}
		  log.info("final result: " + jsonArray);
		     return jsonArray;
		   }
	 
	 public JSONArray getUsersTeamJsonData(String artifactsList, long teamId, ThemeDisplay themeDisplay) throws NumberFormatException {
		 
			JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
			String imgPath = StringPool.BLANK;
			
			try {
				log.info("CALL Agile_teamBasedUserInfo_for_selectedArtifact(" + artifactsList + ", ';', '-',"  + teamId + ")");
				List records = ArtifactTeamMappingLocalServiceUtil.getUsersDataForSelectedTeamAndArtifacts(artifactsList, ";", "-", teamId);
							
				log.info("Printing Records inside Userrrrr"+records);
				for(Object users:records){				
					Object data[] = (Object[])users;
					JSONObject jsonObject2 = JSONFactoryUtil.createJSONObject();
					jsonObject2.put("teamId", Validator.isNotNull(data[0].toString())? Long.valueOf(data[0].toString()) : 0);
					imgPath = themeDisplay.getPathImage()+"/user_portrait?screenName="
					        +data[2].toString()
						       +"&amp;companyId="+UserLocalServiceUtil.getUser(Long.valueOf(data[1].toString())).getCompanyId();
						imgPath = "<img class='userIcon' src='" + imgPath +"' style='float:left;height: 32px;width:30px;margin-left: 5px;' title='" + data[2].toString() + "'/>";
						System.out.println("chandan-------------imgPath: " + imgPath);
					jsonObject2.put("userId", Validator.isNotNull(data[1].toString())? Long.valueOf(data[1].toString()) : 0);
					jsonObject2.put("imgPath", (Validator.isNotNull(imgPath) ? imgPath: " "));
					jsonObject2.put("screenName", (Validator.isNotNull(data[2].toString()) ? data[2].toString(): " "));
					jsonObject2.put("noOfTasks", Validator.isNotNull(data[3].toString())? Long.valueOf(data[3].toString()) : 0);
					jsonObject2.put("noOfHoursSpent",Validator.isNotNull(data[4]) ? data[4].toString() : "0");
					jsonObject2.put("timeLeft", Validator.isNotNull(data[5])? data[5].toString() : "0");	
					jsonArray.put(jsonObject2);
				}
			} catch (SystemException e) {
				e.printStackTrace();
				return null;
			} catch (ParseException e) {
				e.printStackTrace();
				return null;
			} catch (PortalException e) {
				e.printStackTrace();
				return null;
			}
			return jsonArray;
		}
	 
	 public void AddVidyayugTeams(ActionRequest actionRequest,ActionResponse actionResponse) throws IOException, PortletException {
		 
			log.info("-----------------Inside AddVidyayugTeams() ------------------");
			String teamName = "";
			String teamDescription = "";
			long parentId = 0;
			long currentOrganizationId = 0;
			long userId = 0;
			long groupId = 0;
			long teamId = 0;
			long artifactId = 0;
			String artifactTypeLabel = StringPool.BLANK;
			long artifactTypeId = 0;
			long isActive = 1;
			try {
				 //Get Team Name and Description from input Page 
				teamName = ParamUtil.getString(actionRequest, "teamName");
				teamDescription = ParamUtil.getString(actionRequest, "teamDes");
				
				artifactTypeLabel = ParamUtil.getString(actionRequest, "artifactTypeLabel");
				artifactId = ParamUtil.getLong(actionRequest, "artifactId");
				ApplicationParamGroup appGroup = ApplicationParamGroupLocalServiceUtil.findBygroupNameRecords("Scrum_Artifact_Team");
				ApplicationParamValue appValue = ApplicationParamValueLocalServiceUtil.findByappParanNamesAppParamGrpId(artifactTypeLabel, appGroup.getAppParamGroupId());
				artifactTypeId = appValue.getAppParamValueId();
				log.info("Printing artifactTypeId......." + artifactTypeId);
				parentId = ParamUtil.getLong(actionRequest, "orgTeams");
				
				log.info("Team Name :" + teamName);
				
				 //Get the Current UserId and GroupId 
				ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
				Group currentGroup = themeDisplay.getLayout().getGroup();
				userId = themeDisplay.getUserId();
				groupId = currentGroup.getGroupId();
				log.info("User ID ..." + userId);
				Team team = TeamLocalServiceUtil.addTeam(userId, groupId, teamName, teamDescription);
				
				teamId = team.getTeamId();
				
				 //Get the Current Organization 
				if (currentGroup.isOrganization()) {
					currentOrganizationId = currentGroup.getClassPK();
					log.info("currentOrganizationId.."+ currentOrganizationId);
				}
				ArtifactTeamMappingLocalServiceUtil.addArtifactTeamMapping(artifactTypeId, artifactId, teamId, currentOrganizationId, parentId, isActive, userId, new Date());
				
				 //Add Teams to User 
				Team teamObj = null;
				try {
					/*try {
						//teamObj = TeamLocalServiceUtil.addTeam(userId, groupId,teamName, teamDescription);
						
					} catch (Exception e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
						log.info("" + e1);
						SessionMessages.add(actionRequest, "request_processed",
								"The Team Name is Already Exist ");
					}
					teamId = teamObj.getTeamId();
					
					log.info("Team Id " + teamId);*/
					if (teamId != 0) {
						try {
							com.vidyayug.attribute.service.Team_HierarchyLocalServiceUtil.addTeam_Hierarchy(teamId, parentId, currentOrganizationId);
							log.info("Team Added to User Successfully .........");
							SessionMessages.add(actionRequest, "request_processed", "Team Added Successfully  ");
							actionResponse.setRenderParameter("jspPage", "/html/team/createteam.jsp");
							actionResponse.setRenderParameter("artifactId", Long.toString(artifactId));
							actionResponse.setRenderParameter("artifactTypeLabel", artifactTypeLabel);
						} catch (Exception e) {
							log.info("Problem in Creating Team... " + e);
							SessionMessages.add(actionRequest, "request_processed", "Problem in Creating Team... ");
						}

					}

				} catch (Exception e) {
					// TODO: handle exception
					log.info("The Team Name is Already Exist" + e);
					SessionMessages.add(actionRequest, "request_processed",
							"The Team Name is Already Exist ");
				}

			}catch (DuplicateTeamException e) {
				SessionMessages.add(actionRequest, "request_processed","The Team Name is Already Exist ");
				actionResponse.setRenderParameter("jspPage", "/html/team/createteam.jsp");
				actionResponse.setRenderParameter("artifactId", Long.toString(artifactId));
				actionResponse.setRenderParameter("artifactTypeLabel", artifactTypeLabel);
				log.info("Exception " + e.getMessage());
				e.printStackTrace();
			} 
			catch (Exception e) {
				log.info("Exception " + e.getMessage());
				e.printStackTrace();
			}

		}
}