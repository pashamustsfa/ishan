package com.vidyayug.scrum.portlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;






import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Phone;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.User;
import com.liferay.portal.service.OrganizationLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.util.bridges.mvc.MVCPortlet;

public class ManageUsers  extends MVCPortlet {
	public void serveResource(ResourceRequest resourceRequest,ResourceResponse resourceResponse) throws IOException {
		String cmdValue = ParamUtil.getString(resourceRequest, "CMD");
		
		ThemeDisplay themeDisplay= (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		 //long companyId=themeDisplay.getCompanyId();
		long organizationId=themeDisplay.getScopeGroup().getOrganizationId();
		if("GetUserHistory".equalsIgnoreCase(cmdValue)) {
			
			   System.out.println("Inside GetUserHistory.............");
			   PrintWriter writer1 = resourceResponse.getWriter();
			   
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
	}
public JSONArray getUsersJsonData(List<User> userList,ResourceRequest resourceRequest, ResourceResponse resourceResponse) {
	ThemeDisplay themeDisplay= (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
	 long companyId=themeDisplay.getCompanyId();   
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		
		for (User users : userList) {
			
			JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
			
			jsonObject.put("userId", (Validator.isNotNull(users.getUserId()) ? users.getUserId() : 0));
			
			jsonObject.put("emailAddress", users.getEmailAddress() == null ? "" : users.getEmailAddress());
			jsonObject.put("userName", users.getFirstName()+" "+users.getLastName() == null ? "" : users.getFirstName()+" "+users.getLastName());
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
						jsonObject_phone.put("phoneObject", " ");
						jsonArrayPhone.put(jsonObject_phone);
						jsonObject.put("phoneList",jsonArrayPhone);
					}
				} catch (SystemException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
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
}


