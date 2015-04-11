package com.test.layout.portlet.util;


import java.util.Iterator;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.User;
import com.liferay.portal.service.TeamLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;


public class CreateTeamPortletUtil {

	public static JSONArray getOrgAllUserJSONArray(long teamId, Iterator<User> usersIterator, ThemeDisplay themeDisplay) {
		
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		boolean hasUserTeam = false;
		String imgPath = StringPool.BLANK;
		
		while(usersIterator.hasNext()) {
			
			User userObj = usersIterator.next();
			try {
				hasUserTeam = TeamLocalServiceUtil.hasUserTeam(userObj.getUserId(), teamId);
			} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
          	jsonObject.put("userId", (Validator.isNotNull(userObj.getUserId()) ? userObj.getUserId(): 0));
          	
          	try {
				imgPath = themeDisplay.getPathImage()+"/user_portrait?screenName="
				        +userObj.getScreenName()
				       +"&amp;companyId="+UserLocalServiceUtil.getUser(userObj.getUserId()).getCompanyId();
				imgPath = "<img class='userIcon' src='" + imgPath +"' style='float:left;height: 32px;width:30px;margin-left: 5px;' title='" + userObj.getFullName() + "'/>";
			} catch (PortalException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SystemException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

          	jsonObject.put("imgPath", (Validator.isNotNull(imgPath) ? imgPath: " "));
          	jsonObject.put("screenName", (Validator.isNotNull(userObj.getScreenName()) ? userObj.getScreenName(): " "));
          	jsonObject.put("fullName",(Validator.isNotNull(userObj.getFullName()) ? userObj.getFullName(): " "));
          	jsonObject.put("teamId",(Validator.isNotNull(teamId) ? teamId: 0));
          	jsonObject.put("isMember",((hasUserTeam) ? 1 : 0));
          	
          	jsonArray.put(jsonObject);
		}
		
		return jsonArray;
	}
}


