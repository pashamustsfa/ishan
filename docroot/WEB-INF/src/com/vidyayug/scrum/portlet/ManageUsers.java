package com.vidyayug.scrum.portlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
























import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Phone;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.Team;
import com.liferay.portal.model.User;
import com.liferay.portal.service.OrganizationLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.TeamLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.vidyayug.scrum.model.ReleaseTeamResource;
import com.vidyayug.scrum.model.Task;
import com.vidyayug.scrum.service.BacklogLocalServiceUtil;
import com.vidyayug.scrum.service.ReleaseTeamResourceLocalServiceUtil;
import com.vidyayug.scrum.service.TaskLocalServiceUtil;
import com.vidyayug.scrum.service.WorkEffortDetailsLocalServiceUtil;

public class ManageUsers  extends MVCPortlet {
	SimpleDateFormat dt1 = new SimpleDateFormat("dd MMM, yyyy");
	
	@SuppressWarnings("unchecked")
	public void serveResource(ResourceRequest resourceRequest,ResourceResponse resourceResponse) throws IOException {
		String cmdValue = ParamUtil.getString(resourceRequest, "CMD");
		PrintWriter writer1 = resourceResponse.getWriter();
		ThemeDisplay themeDisplay= (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		 //long companyId=themeDisplay.getCompanyId();
		long organizationId=themeDisplay.getScopeGroup().getOrganizationId();
		if("GetUserHistory".equalsIgnoreCase(cmdValue)) {
			
			   System.out.println("Inside GetUserHistory.............");
			   
			   
			   List<User> userList= null;
				try {
					userList = UserLocalServiceUtil.getOrganizationUsers(organizationId);
					System.out.println("records size: "+ userList.size());
				} catch (SystemException e) {
					e.printStackTrace();
				}
				JSONArray jsonArray = getUsersJsonData(userList, resourceRequest, resourceResponse);
				System.out.println("jsonArray: " + jsonArray);
				writer1.print(jsonArray);
			}
		if("GetTaskData".equalsIgnoreCase(cmdValue)) {
			String userId = ParamUtil.getString(resourceRequest,"userId");
			  System.out.println("userId--->"+userId);
			  List<Task> taskRecords=null;
			  try{
			  taskRecords=TaskLocalServiceUtil.getTaskData(Long.valueOf(userId),0);
			  }catch(Exception e){
				  e.printStackTrace();  
			  }
			  
			  JSONArray jsonArray = getTasksJsonData(taskRecords);
				System.out.println("jsonArray: " + jsonArray);
				writer1.print(jsonArray);
			  
			}
		if("GetUserDetails".equalsIgnoreCase(cmdValue)) {
			System.out.println("in getUserDetails");
			String userId = ParamUtil.getString(resourceRequest,"userId");
			  System.out.println("userId--->"+userId);
			  User userObject=null;
			  try{
				  userObject=UserLocalServiceUtil.getUser(Long.valueOf(userId));
			  }catch(Exception e){
				  e.printStackTrace();  
			  }
			  List<User> userRecords=new ArrayList<User>();
			  userRecords.add(userObject);
			  List<Task> taskRecord=TaskLocalServiceUtil.findByAssignedToId(Long.valueOf(userId), 1);
			  JSONArray jsonArray1=getUsersJsonData(userRecords,resourceRequest,resourceResponse);
			  JSONArray jsonArray2 =  getUserwiseTaskList(taskRecord);
			  JSONObject jsonObject1=JSONFactoryUtil.createJSONObject();
			  jsonObject1.put("getUsersJsonData", jsonArray1);
			  jsonObject1.put("getUserwiseTaskList", jsonArray2);
			  JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
			  jsonArray.put(jsonObject1);
			  
			  
			  System.out.println("jsonArray: " + jsonArray);
				writer1.print(jsonArray);
			  
			}
		
		
if("Graph".equalsIgnoreCase(cmdValue)){
			
			System.out.println("in serveresource graph command");
			PrintWriter writer = resourceResponse.getWriter();
			List<Task> moduleCount=null;
			JSONArray jsonArray=JSONFactoryUtil.createJSONArray();
			long userId = ParamUtil.getLong(resourceRequest, "userId");
			System.out.println("userid----"+userId);
			moduleCount=TaskLocalServiceUtil.getTasksCountBasdOnUser(userId);
			System.out.println("size of modulecount-----"+moduleCount.size());
			/*moduleCount=BacklogLocalServiceUtil.getBacklogCountBasdOnProject(userId);*/
			
			for(Object obj:moduleCount) {
				
				JSONObject jsonObj=JSONFactoryUtil.createJSONObject();
				Object[] insertedObject=(Object[]) obj;
			    jsonObj.put("moduleList",(insertedObject[2]!=null?Long.valueOf(insertedObject[2].toString()):0));
				jsonObj.put("status_",(insertedObject[1].toString()!=null?insertedObject[1].toString():""));
				System.out.println("cmdValue: Graph   jsonObj----------->"+jsonObj);
				jsonArray.put(jsonObj);



			}
			System.out.println("jsonArray----"+jsonArray);
			writer.print(jsonArray);
		}
	}
	
	
	
	
	
	
	
	@SuppressWarnings("unchecked")
	public JSONArray getUserwiseTaskList(List<Task> taskRecords){
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		System.out.println("taskRecords size---"+taskRecords.size());
		for(int i=0;i<taskRecords.size();i++){
			
			
		JSONObject jsonObject=JSONFactoryUtil.createJSONObject();
		List<Task> records=TaskLocalServiceUtil.getTaskData(0 , taskRecords.get(i).getTask_id());
		System.out.println("length of the taskData---"+records.size());
		
		for(Object record:records) {
         		Object data[] = (Object[])record;
				jsonObject.put("taskId", (Validator.isNotNull(data[0].toString()) ? data[0].toString(): " "));
				jsonObject.put("taskName", (Validator.isNotNull(data[1].toString()) ? data[1].toString(): " "));
				jsonObject.put("AssignedName", (Validator.isNotNull(data[3].toString()) ? data[3].toString(): " "));
				jsonObject.put("userStoryName", (Validator.isNotNull(data[4].toString()) ? data[4].toString(): " "));
				jsonObject.put("backlogName", (Validator.isNotNull(data[5].toString()) ? data[5].toString(): " "));
				jsonObject.put("sprintName", (Validator.isNotNull(data[6].toString()) ? data[6].toString(): " "));
				jsonObject.put("releaseName", (Validator.isNotNull(data[7].toString()) ? data[7].toString(): " "));
				jsonObject.put("EstDate", ((data[9] == null) ? "" : dt1.format(data[9]) ));
				jsonObject.put("statusName", (Validator.isNotNull(data[10].toString()) ? data[10].toString(): " "));
				jsonObject.put("phaseName", (Validator.isNotNull(data[11].toString()) ? data[11].toString(): " "));
				jsonObject.put("timeLeft", (Validator.isNotNull(data[12].toString()) ? data[12].toString(): " "));
				jsonArray.put(jsonObject);
			}
		}	
		return jsonArray;
	}
public JSONArray getUsersJsonData(List<User> userList,ResourceRequest resourceRequest, ResourceResponse resourceResponse) {
	ThemeDisplay themeDisplay= (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
	 /*long companyId=themeDisplay.getCompanyId();  */
	 long organizationId=themeDisplay.getScopeGroup().getOrganizationId();
	 String organizationName="";
	 try {
		organizationName=OrganizationLocalServiceUtil.getOrganization(organizationId).getName();
	} catch (PortalException e2) {
		// TODO Auto-generated catch block
		e2.printStackTrace();
	} catch (SystemException e2) {
		// TODO Auto-generated catch block
		e2.printStackTrace();
	}
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		
		for (User users : userList) {
			
			JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
			
			jsonObject.put("userId", (Validator.isNotNull(users.getUserId()) ? users.getUserId() : 0));
			
			String imgPath = StringPool.BLANK;
			try {
				imgPath = themeDisplay.getPathImage()+"/user_portrait?screenName="
				        +users.getScreenName()
				       +"&amp;companyId="+UserLocalServiceUtil.getUser(users.getUserId()).getCompanyId();
			} catch (PortalException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			} catch (SystemException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
		imgPath = "<img class='userIcon' src='" + imgPath +"' style='width:140px;' title='" + users.getFullName() + "'/>";
			
			
			
			jsonObject.put("imgPath", imgPath == null ? "" : imgPath);
			
			jsonObject.put("emailAddress", users.getEmailAddress() == null ? "" : users.getEmailAddress());
			jsonObject.put("userName", users.getFirstName()+" "+users.getLastName() == null ? "" : users.getFirstName()+" "+users.getLastName());
			jsonObject.put("organizationName", organizationName == null ? "" : organizationName);
			jsonObject.put("JoinedDate",  users.getCreateDate()== null ? null : dt1.format(users.getCreateDate()));
			List<Phone> phoneList;
			JSONArray jsonArrayPhone=JSONFactoryUtil.createJSONArray();
			
				 
				try {
					phoneList = users.getPhones();
					if(phoneList.size()>0){
						for(int i=0;i<phoneList.size();i++){
							JSONObject jsonObject_phone = JSONFactoryUtil.createJSONObject();
							System.out.println("Phone Number................."+phoneList.get(i).getNumber());
							jsonObject_phone.put("phoneObject", phoneList.get(i).getNumber());
							jsonArrayPhone.put(jsonObject_phone);
						}
						
					
					jsonObject.put("phoneList",jsonArrayPhone);
					}
					else{
						
						JSONObject jsonObject_phone = JSONFactoryUtil.createJSONObject();
						jsonObject_phone.put("phoneObject", "....");
						jsonArrayPhone.put(jsonObject_phone);
						jsonObject.put("phoneList",jsonArrayPhone);
					}
				} catch (SystemException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
				
				
				List<ReleaseTeamResource> releaseTeamresourceList=null;
				JSONArray jsonArrayTeam=JSONFactoryUtil.createJSONArray();
				
				try {
					releaseTeamresourceList = ReleaseTeamResourceLocalServiceUtil.findByResourceId(users.getUserId());
				} catch (SystemException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				if(releaseTeamresourceList.size()>0){
				for(int i=0;i<releaseTeamresourceList.size();i++){
					JSONObject jsonObject_Team = JSONFactoryUtil.createJSONObject();
					
					try {
						System.out.println("teamObject----"+TeamLocalServiceUtil.getTeam(releaseTeamresourceList.get(i).getTeam_id()).getName());
						jsonObject_Team.put("teamObject", TeamLocalServiceUtil.getTeam(releaseTeamresourceList.get(i).getTeam_id()).getName());
					} catch (PortalException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (SystemException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					jsonArrayTeam.put(jsonObject_Team);
				}
				jsonObject.put("teamList",jsonArrayTeam);
				}		
				
				else{
					
					JSONObject jsonObject_Team = JSONFactoryUtil.createJSONObject();
					jsonObject_Team.put("teamObject", "NON");
					jsonArrayPhone.put(jsonObject_Team);
					jsonObject.put("teamList",jsonArrayTeam);
				}
					
			List<Role> roleList;
			JSONArray jsonArrayRoles=JSONFactoryUtil.createJSONArray();
				try {
					
				roleList = RoleLocalServiceUtil.getUserGroupRoles(users.getUserId(),themeDisplay.getSiteGroupId());
				Iterator<Role> it = roleList.iterator();
				String roleName="";
				while(it.hasNext()) {

					Role role = it.next();
					roleName = role.getName();
				}
				if(roleName.indexOf("_") > 0) {
						roleName = roleName.substring(0, roleName.indexOf("_"));
				}
				JSONObject jsonObject_role = JSONFactoryUtil.createJSONObject();
				jsonObject_role.put("roleObject", roleName);
				jsonArrayRoles.put(jsonObject_role);

				jsonObject.put("roleList",jsonArrayRoles);
				
				} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				}
			
			
			jsonArray.put(jsonObject);
		}

		return jsonArray;
	}




public JSONArray getTasksJsonData(List<Task> taskRecords) {
	JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
   for(Object record:taskRecords) {
 		Object data[] = (Object[])record;
 		JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
		jsonObject.put("taskId", (Validator.isNotNull(data[0].toString()) ? data[0].toString(): " "));
		jsonObject.put("taskName", (Validator.isNotNull(data[1].toString()) ? data[1].toString(): " "));
		jsonObject.put("AssignedName", (Validator.isNotNull(data[3].toString()) ? data[3].toString(): " "));
		jsonObject.put("userStoryName", (Validator.isNotNull(data[4].toString()) ? data[4].toString(): " "));
		jsonObject.put("backlogName", (Validator.isNotNull(data[5].toString()) ? data[5].toString(): " "));
		jsonObject.put("sprintName", (Validator.isNotNull(data[6].toString()) ? data[6].toString(): " "));
		jsonObject.put("releaseName", (Validator.isNotNull(data[7].toString()) ? data[7].toString(): " "));
		jsonObject.put("EstStartDate", ((data[8] == null) ? "" : dt1.format(data[8]) ));
		jsonObject.put("EstEndDate", ((data[9] == null) ? "" : dt1.format(data[9]) ));
		jsonObject.put("statusName", (Validator.isNotNull(data[10].toString()) ? data[10].toString(): " "));
		jsonObject.put("phaseName", (Validator.isNotNull(data[11].toString()) ? data[11].toString(): " "));
		jsonObject.put("timeLeft", (Validator.isNotNull(data[12].toString()) ? data[12].toString(): " "));
		
		jsonArray.put(jsonObject);
	}
    return jsonArray;
	}
}









