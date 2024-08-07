package com.coway.trust.biz.api.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**************************************
 * Author                  Date                    Remark
 * Tang Hui Ling        2021/10/27           API for Coway world
 ***************************************/

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.jsoup.helper.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import org.apache.commons.codec.binary.Base64;
import java.nio.charset.StandardCharsets;
import com.coway.trust.AppConstants;
import com.coway.trust.api.callcenter.common.CommonConstants;
import com.coway.trust.api.project.CowayWorld.CWGetMemApiForm;
import com.coway.trust.api.project.CowayWorld.CWMemDetApiDto;
//import com.coway.trust.api.project.CW.CourseForm;
//import com.coway.trust.api.project.CW.CWApiRespForm;
//import com.coway.trust.api.project.CW.CWAttendApiForm;
//import com.coway.trust.api.project.CW.CWMemApiForm;
//import com.coway.trust.api.project.CW.CWResultApiForm;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.CWApiService;
import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
import com.coway.trust.biz.organization.organization.impl.MemberListServiceImpl;
import com.coway.trust.biz.organization.training.TrainingService;
import com.coway.trust.biz.organization.training.impl.TrainingMapper;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("CWApiService")
public class CWApiServiceImpl extends EgovAbstractServiceImpl implements CWApiService {

    private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

    @Resource(name = "CWApiMapper")
    private CWApiMapper cwApiMapper;

    @Resource(name = "CommonApiMapper")
    private CommonApiMapper commonApiMapper;

    @Resource(name = "commonApiService")
    private CommonApiService commonApiService;

    @Resource(name = "trainingService")
    private TrainingService trainingService;

    @Resource(name = "trainingMapper")
    private TrainingMapper trainingMapper;

    @Resource(name = "memberListMapper")
    private MemberListMapper memberListMapper;

    /*@Value("${cw.api.username}")
    private String CWApiUser;

    @Value("${cw.api.password}")
    private String CWApiPassword;

    @Value("${cw.api.secretkey}")
    private String CWApiSecretkey;

    @Value("${cw.api.url.domains}")
    private String CWApiDomains;

    @Value("${cw.api.url.add}")
    private String CWApiUrlAdd;

    @Value("${cw.api.url.update.profile}")
    private String CWApiUrlUpdateProfile;

    @Value("${cw.api.url.update.username}")
    private String CWApiUrlUpdateUsername;

    @Value("${cw.api.url.suspend}")
    private String CWApiUrlSuspend;

    @Value("${cw.api.url.restore}")
    private String CWApiUrlRestore;*/

    @Autowired
    private AdaptorService adaptorService;

//  @Resource(name = "memberListServiceImpl")
//	private MemberListServiceImpl memberListServiceImpl;

  @Override
  public EgovMap memDetailsInfo(HttpServletRequest request, Map<String, Object> cwApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

    // default courseCloseDt
    String currentDate = CommonUtils.getNowDate();
    //String defaultCloseDt = CommonUtils.getAddDay(currentDate, 60, "YYYYMMDD"); // defaultly added 60 days to close date

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    String usernameParam = request.getParameter("username").toString();
    String data = commonApiService.decodeJson(request);
    System.out.println("data :" + data);
    System.out.println("data :" + cwApiForm.toString());
    Gson g = new Gson();
    CWGetMemApiForm p = g.fromJson(data, CWGetMemApiForm.class);

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = new HashMap<>();
    String key = request.getHeader("key");
    reqPrm.put("key", key);

    CWMemDetApiDto memDetails = new CWMemDetApiDto();
    EgovMap memDetailsMap = new EgovMap();
    try{
      int created = 0;
      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
      else {
        apiUserId = access.get("apiUserId").toString();
        sysUserId = access.get("sysUserId").toString();
        reqPrm.put("apiUserId", apiUserId);
        reqPrm.put("sysUserId", sysUserId);

        System.out.println("apiUserId :" + apiUserId);
        //validation
        System.out.println("data :" + data);
        //System.out.println("p.getUsername().toString() :" + p.getUsername().toString());
        //String username = p.getUsername().toString();

        Exception e1 = null;

        //System.out.println("username :" + username);
        if (StringUtils.isBlank(usernameParam)){
            e1 = new Exception("username is required");
            throw e1;
        }

        System.out.println("selectMemDetails :");
        Map<String, Object> selectMemDetails = new HashMap<String, Object>();
        selectMemDetails.put("memCode", usernameParam);
        int isExist = cwApiMapper.cntMemberCheck(selectMemDetails);

        if(isExist == 0){
            e1 = new Exception(AppConstants.RESPONSE_DESC_NOT_FOUND);
            throw e1;
        }

        System.out.println("isExist :" + isExist);

        Map<String, Object> userInfo = new HashMap<String, Object>();
        userInfo.put("memCode", usernameParam);
        EgovMap userId = cwApiMapper.selectActiveMemberByMemId(userInfo);
        Map<String, Object> memMap = new HashMap<String, Object>();
        memMap.put("MemberID", userId.get("memId"));
        System.out.println("memMap :" + memMap.toString());
        EgovMap selectMemListlms = memberListMapper.selectMemberListView(memMap);
        if (selectMemListlms.isEmpty()) {
            e1 = new Exception("Invalid Member");
            throw e1;
        }

        System.out.println("memDetails");
        memDetails.setStaffCode(selectMemListlms.get("memCode").toString());
        memDetails.setStaffName(selectMemListlms.get("name1").toString());
        memDetails.setNric(selectMemListlms.get("nric").toString());
        memDetails.setEmail(selectMemListlms.get("email").toString());
        memDetails.setMobileNum(selectMemListlms.get("telMobile").toString());
        memDetails.setBranch(selectMemListlms.get("c4").toString() + " - " + selectMemListlms.get("c5").toString());
        memDetails.setDepartment(selectMemListlms.get("c41") == null ? "" : selectMemListlms.get("c41").toString());
        String addr ="";
  		if(selectMemListlms.get("addrDtl") == null){
  			if(selectMemListlms.get("street") == null) {
  				addr = "";
  			}else{
  				addr = selectMemListlms.get("street").toString();
  			}
  		}else{
  			if(selectMemListlms.get("street") == null) {
  				addr = selectMemListlms.get("addrDtl").toString();
  			}else{
  				addr = selectMemListlms.get("addrDtl").toString() + " "+ selectMemListlms.get("street").toString();
  			}
  		}
        memDetails.setAddress(addr);

        System.out.println("memDetailsMap");
        memDetailsMap.put("memCode", selectMemListlms.get("memCode").toString());
        memDetailsMap.put("memName",selectMemListlms.get("name1").toString());
        memDetailsMap.put("nric",selectMemListlms.get("nric").toString());
        memDetailsMap.put("email",selectMemListlms.get("email").toString());
        memDetailsMap.put("mobileNumber",selectMemListlms.get("telMobile").toString());
        memDetailsMap.put("branch",selectMemListlms.get("c4").toString() + " - " + selectMemListlms.get("c5").toString());
        memDetailsMap.put("department",selectMemListlms.get("c41") == null ? "" : selectMemListlms.get("c41").toString());
        String address ="";
  		if(selectMemListlms.get("addrDtl") == null){
  			if(selectMemListlms.get("street") == null) {
  				address = "";
  			}else{
  				address = selectMemListlms.get("street").toString();
  			}
  		}else{
  			if(selectMemListlms.get("street") == null) {
  				address = selectMemListlms.get("addrDtl").toString();
  			}else{
  				address = selectMemListlms.get("addrDtl").toString() + " "+ selectMemListlms.get("street").toString();
  			}
  		}
        memDetailsMap.put("address",address);

        code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
        message = AppConstants.RESPONSE_DESC_SUCCESS;
      }

    } catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);

      System.out.println("exception");
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
      request.setAttribute("Status", code);
    }


    System.out.println(memDetails.toString());
    System.out.println(memDetailsMap.toString());

    /*if(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS).equals(code)){
    	return memDetails;
    }else{
    	return commonApiService.rtnRespMsg(request, code, message, respTm, data, null ,apiUserId);
    }*/
    return commonApiService.rtnRespMsg(request, code, message, respTm, data, memDetailsMap ,apiUserId);
  }

}
