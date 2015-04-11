package com.vidyayug.scrum.portlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
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
import com.vidyayug.global.model.ApplicationParamGroup;
import com.vidyayug.global.model.ApplicationParamValue;
import com.vidyayug.global.service.ApplicationParamGroupLocalServiceUtil;
import com.vidyayug.global.service.ApplicationParamValueLocalServiceUtil;
import com.vidyayug.scrum.service.ArtifactTeamMappingLocalServiceUtil;

/**
 * Portlet implementation class CreateTeamPortlet
 */
public class CreateTeamPortlet extends MVCPortlet {
	Log log_=LogFactoryUtil.getLog(getClass());
	
	public void serveResource(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) throws IOException,
			PortletException {
		

		String cmd = ParamUtil.getString(resourceRequest,"cmd");
		System.out.println("cmd: " + cmd);

		ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(WebKeys.THEME_DISPLAY); 
		Group group = themeDisplay.getScopeGroup();
		long organizationId = group.getOrganizationId();
		
		if("orgranizationBasedUsersInfo".equalsIgnoreCase(cmd)) {
			
			long teamId = ParamUtil.getLong(resourceRequest,"teamId");
			List<User> usersList;
			try {
				usersList = UserLocalServiceUtil.getOrganizationUsers(organizationId);
			
				Iterator<User> usersIterator = usersList.iterator();
				JSONArray jsonArray = CreateTeamPortletUtil.getOrgAllUserJSONArray(teamId, usersIterator, themeDisplay);
				PrintWriter objWriter = PortalUtil.getHttpServletResponse(resourceResponse).getWriter();
				System.out.println("jsonArray: " + jsonArray);
				objWriter.print(jsonArray.toString());
			} catch (SystemException e) {
				e.printStackTrace();
			}
		} else if("updateTeamUserAssociation".equalsIgnoreCase(cmd)) {
			
			String allSelectedVals = ParamUtil.getString(resourceRequest,"allSelectedVals");
			String allUnSelectedVals = ParamUtil.getString(resourceRequest,"allUnSelectedVals");
			long teamId = ParamUtil.getLong(resourceRequest,"teamId");

			System.out.println("allSelectedVals: " + allSelectedVals);
			System.out.println("allUnSelectedVals: " + allUnSelectedVals);
			
			String allSelectedIds[] = allSelectedVals.split(",");
			String allUnSelectedIds[] = allUnSelectedVals.split(",");
			
			long[] addUserIds = new long[allSelectedIds.length];
			for (int i = 0; i < allSelectedIds.length; i++) {
				addUserIds[i] = Long.valueOf(allSelectedIds[i]);
			}
			
			long[] removeUserIds = new long[allUnSelectedIds.length];
			for (int i = 0; i < allUnSelectedIds.length; i++) {
				removeUserIds[i] = Long.valueOf(allUnSelectedIds[i]);
			}
			PrintWriter objWriter = PortalUtil.getHttpServletResponse(resourceResponse).getWriter();
			int status = 0;
			try {
				UserServiceUtil.addTeamUsers(teamId, addUserIds);
				UserServiceUtil.unsetTeamUsers(teamId, removeUserIds);
				status = 1;
			} catch (PortalException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("status: " + status);
			objWriter.print(status);
		}
	}
	
	public void AddVidyayugTeams(ActionRequest actionRequest,ActionResponse actionResponse) throws IOException, PortletException {
		log_.info("-----------------Inside AddVidyayugTeams() ------------------");
		String teamName = "";
		String teamDescription = "";
		long parentId = 0;
		long currentOrganizationId = 0;
		long userId = 0;
		long groupId = 0;
		long teamId = 0;
		long artifactTypeId = 0;
		long isActive = 1;
		long artifactId=0; 
		try {
			 //Get Team Name and Description from input Page 
			teamName = ParamUtil.getString(actionRequest, "teamName");
			teamDescription = ParamUtil.getString(actionRequest, "teamDes");
			
/*			artifactTypeId = ParamUtil.getLong(actionRequest, "artifactTypeId");*/
			ApplicationParamGroup appGroup = ApplicationParamGroupLocalServiceUtil.findBygroupNameRecords("Scrum_Artifact_Team");
			ApplicationParamValue appValue = ApplicationParamValueLocalServiceUtil.findByappParanNamesAppParamGrpId("Project", appGroup.getAppParamGroupId());
			long artifactTypeId1 = appValue.getAppParamValueId();
			System.out.println("Printing artifactTypeId......."+artifactTypeId1);
			artifactId = ParamUtil.getLong(actionRequest, "artifactId");
			parentId = ParamUtil.getLong(actionRequest, "orgTeams");
			
			log_.info("Team Name :" + teamName);
			
			 //Get the Current UserId and GroupId 
			ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
			Group currentGroup = themeDisplay.getLayout().getGroup();
			userId = themeDisplay.getUserId();
			groupId = currentGroup.getGroupId();
			log_.info("User ID ..." + userId);
			Team team = TeamLocalServiceUtil.addTeam(userId, groupId, teamName, teamDescription);
			
			teamId = team.getTeamId();
			
			 //Get the Current Organization 
			if (currentGroup.isOrganization()) {
				currentOrganizationId = currentGroup.getClassPK();
				log_.info("currentOrganizationId.."+ currentOrganizationId);
			}
			ArtifactTeamMappingLocalServiceUtil.addArtifactTeamMapping(artifactTypeId1, artifactId, teamId, currentOrganizationId, parentId, isActive, userId, new Date());
			
			 //Add Teams to User 
			Team teamObj = null;
			try {
				/*try {
					//teamObj = TeamLocalServiceUtil.addTeam(userId, groupId,teamName, teamDescription);
					
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					log_.info("" + e1);
					SessionMessages.add(actionRequest, "request_processed",
							"The Team Name is Already Exist ");
				}
				teamId = teamObj.getTeamId();
				
				log_.info("Team Id " + teamId);*/
				if (teamId != 0) {
					try {
						com.vidyayug.attribute.service.Team_HierarchyLocalServiceUtil.addTeam_Hierarchy(
								teamId, parentId, currentOrganizationId);
						log_.info("Team Added to User Successfully .........");
						SessionMessages.add(actionRequest, "request_processed",
								"Team Added Successfully  ");
					} catch (Exception e) {
						log_.info("Problem in Creating Team... " + e);
						SessionMessages.add(actionRequest, "request_processed",
								"Problem in Creating Team... ");
					}

				}

			} catch (Exception e) {
				// TODO: handle exception
				log_.info("The Team Name is Already Exist" + e);
				SessionMessages.add(actionRequest, "request_processed",
						"The Team Name is Already Exist ");
			}

		} catch (Exception e) {
			log_.info("Exception " + e.getMessage());
			e.printStackTrace();

		}

	}
}