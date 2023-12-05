package com.coway.trust.biz.common.impl;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.UserManagementService;
import com.coway.trust.biz.login.SsoLoginService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("userManagementService")
public class UserManagementServiceImpl implements UserManagementService {

	@Autowired
	private UserManagementMapper userManagementMapper;
	@Autowired
	private LoginMapper loginMapper;

	@Resource(name = "ssoLoginService")
	private SsoLoginService ssoLoginService;

	@Value("${sso.use.flag}")
	private int ssoLoginFlag;

	@Override
	public List<EgovMap> selectUserList(Map<String, Object> params) {
		return userManagementMapper.selectUserList(params);
	}

	@Override
	public List<EgovMap> selectUserDetailList(Map<String, Object> params) {
		return userManagementMapper.selectUserDetailList(params);
	}

	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		return userManagementMapper.selectBranchList(params);
	}

	@Override
	public List<EgovMap> selectDeptList(Map<String, Object> params) {
		return userManagementMapper.selectDeptList(params);
	}

	@Override
	public List<EgovMap> selectUserStatusList(Map<String, Object> params) {
		return userManagementMapper.selectUserStatusList(params);
	}

	@Override
	public List<EgovMap> selectRoleList(Map<String, Object> params) {
		return userManagementMapper.selectRoleList(params);
	}

	@Override
	public List<EgovMap> selectUserTypeList(Map<String, Object> params) {
		return userManagementMapper.selectUserTypeList(params);
	}

	@Override
	public List<EgovMap> selectMemberList(Map<String, Object> params) {
		return userManagementMapper.selectMemberList(params);
	}

	@Override
	public void saveUserManagementList(Map<String,Object> params, SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}
		params.put("userUpdUserId", loginId);

		EgovMap userIdMap = userManagementMapper.createUserId();
		BigDecimal newUserId = (BigDecimal) userIdMap.get("userId");

		params.put("userId", newUserId);
		userManagementMapper.saveUserManagementList(params);

		params.put("crtUserId", loginId);
		params.put("updUserId", loginId);

		userManagementMapper.saveUserRoleList(params);

		// 20200915 - Added to auto insert temporary staff detail
		if("0".equals(params.get("userIsPartTm").toString()) && "0".equals(params.get("userIsExtrnl").toString())) {
		    if("4".equals(params.get("userTypeId").toString()) || "6".equals(params.get("userTypeId").toString())) {
	            params.put("userTypeId", userManagementMapper.getTempStaffCodeType());
	        }

	        userManagementMapper.saveMemberDetails(params); // ORG0001D insert
	        userManagementMapper.saveMemOrgDetails(params); // ORG0005D insert
		}

	}

	@Override
	public void editUserManagementList(Map<String,Object> params, SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}
		params.put("userUpdUserId", loginId);

		userManagementMapper.saveUserManagementList(params);

		try{
			//update password in keycloak
			if(ssoLoginFlag > 0){
    			if(params.get("userType") != null){
    				if(params.get("userType").toString().equals("1") || params.get("userType").toString().toString().equals("2") || params.get("userType").toString().toString().equals("3")
    						|| params.get("userType").toString().toString().equals("5") || params.get("userType").toString().toString().equals("7")  || params.get("userType").toString().toString().equals("6672")){
    					Map<String,Object> ssoParamsOldMem = new HashMap<String, Object>();
    					ssoParamsOldMem.put("memCode", params.get("username"));
    					ssoParamsOldMem.put("password", params.get("userPasswd"));
    					ssoLoginService.ssoUpdateUserPassword(ssoParamsOldMem);
    				}
    			}
			}
		}catch(Exception ex) {
			throw ex;
        }

		// Added to reset fail login attempt. Hui Ding, 18/03/2022
		loginMapper.resetLoginFailAttempt(Integer.valueOf(params.get("userId").toString()));
	}

	@Override
	public List<EgovMap> selectUserRoleList(Map<String, Object> params) {
		return userManagementMapper.selectUserRoleList(params);
	}

	@Override
	public void saveUserRoleList(Map<String,Object> params, SessionVO sessionVO) {
		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}
		params.put("crtUserId", loginId);
		params.put("updUserId", loginId);

		userManagementMapper.saveUserRoleList(params);
	}

	@Override
	public List<EgovMap> getDeptList(Map<String, Object> params) {
	    return userManagementMapper.getDeptList(params);
	}

	@Override
	public ReturnMessage checkUserNric(Map<String, Object> params) throws Exception {
	    ReturnMessage message = new ReturnMessage();

	    String msg = "";
	    String nric = params.get("nric").toString();

	    List<EgovMap> sys47 = userManagementMapper.checkSYS47(params);

	    // Check SYS0047M NRIC + User status = 1
	    if(sys47.size() == 1) {

	        // Check ORG0001D
	        List<EgovMap> org01 = userManagementMapper.checkORG01(params);
	        if(org01.size() > 0) {
	            for(int i = 0; i < org01.size(); i++) {
	                String memCode = org01.get(i).get("memCode").toString();
	                String status = org01.get(i).get("stus").toString();
	                String statusDesc = org01.get(i).get("stusDesc").toString();
	                String resignDate = org01.get(i).get("resignDt").toString();

	                if("3".equals(status)) {
	                    String terminateDate = org01.get(i).get("trmDt").toString();

	                    // Terminated Member
	                    msg = "Member : " + nric + " (" + memCode + ") is " + statusDesc + " on " + terminateDate + ".";
	                    message.setCode(AppConstants.FAIL);
	                    message.setMessage(msg);
	                    break;

	                } else if("1".equals(status)) {
	                    // Active Member
	                    msg = "Member : " + nric + " (" + memCode + ") is of " + statusDesc + " status.";
	                    message.setCode(AppConstants.FAIL);
	                    message.setMessage(msg);
                        break;

	                } else if("51".equals(status)) {
	                    // Resigned Member
	                    Date currentDate = new SimpleDateFormat("yyyyMMdd").parse(CommonUtils.getNowDate());
	                    Calendar currentCal = Calendar.getInstance();
	                    currentCal.setTime(currentDate);
	                    currentCal.add(Calendar.MONTH, -6);

	                    Date resignDt = new SimpleDateFormat("yyyyMMdd").parse(resignDate);
	                    Calendar resignCal = Calendar.getInstance();
	                    resignCal.setTime(resignDt);

	                    if(resignCal.before(currentCal)) {
	                        msg = "Member : " + nric + " (" + memCode + ") resignation within 6 months";
	                        message.setCode(AppConstants.FAIL);
	                        message.setMessage(msg);
	                        break;
	                    }
	                }
	            }
	        } else {
	            msg = nric + " has an active account.";
	            message.setCode(AppConstants.FAIL);
	            message.setMessage(msg);
	        }
	    } else if(sys47.size() > 1) {
	        msg = nric + " has multiple active accounts.";
	        message.setCode(AppConstants.FAIL);
            message.setMessage(msg);
	    } else {
	        message.setCode(AppConstants.SUCCESS);
	    }

	    return message;
	}
}

