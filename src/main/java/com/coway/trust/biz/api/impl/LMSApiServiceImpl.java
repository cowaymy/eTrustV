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
 * Tang Hui Ling        2021/08/19           API for LMS
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
import com.coway.trust.api.project.LMS.CourseForm;
import com.coway.trust.api.project.LMS.LMSApiForm;
import com.coway.trust.api.project.LMS.LMSApiRespForm;
import com.coway.trust.api.project.LMS.LMSAttendApiForm;
import com.coway.trust.api.project.LMS.LMSMemApiForm;
import com.coway.trust.api.project.LMS.LMSResultApiForm;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.LMSApiService;
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

@Service("LMSApiService")
public class LMSApiServiceImpl extends EgovAbstractServiceImpl implements LMSApiService {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Resource(name = "LMSApiMapper")
	private LMSApiMapper lmsApiMapper;

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

	@Value("${lms.api.username}")
	private String LMSApiUser;

	@Value("${lms.api.password}")
	private String LMSApiPassword;

	@Value("${lms.api.secretkey}")
	private String LMSApiSecretkey;

	@Value("${lms.api.url.domains}")
	private String LMSApiDomains;

	@Value("${lms.api.url.add}")
	private String LMSApiUrlAdd;

	@Value("${lms.api.url.update.profile}")
	private String LMSApiUrlUpdateProfile;

	@Value("${lms.api.url.update.username}")
	private String LMSApiUrlUpdateUsername;

	@Value("${lms.api.url.suspend}")
	private String LMSApiUrlSuspend;

	@Value("${lms.api.url.restore}")
	private String LMSApiUrlRestore;

	@Autowired
	private AdaptorService adaptorService;

//  @Resource(name = "memberListServiceImpl")
//	private MemberListServiceImpl memberListServiceImpl;

  @Override
  public EgovMap insertCourse(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

    // default courseCloseDt
    String currentDate = CommonUtils.getNowDate();
    String defaultCloseDt = CommonUtils.getAddDay(currentDate, 60, "YYYYMMDD"); // defaultly added 60 days to close date

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    String data = commonApiService.decodeJson(request);
    Gson g = new Gson();
	LMSApiForm p = g.fromJson(data, LMSApiForm.class);

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = new HashMap<>();
    String key = request.getHeader("key");
    reqPrm.put("key", key);

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

        //validation
        String courseTitle = p.getCourseTitle().toString();
        String courseType = p.getCourseType().toString();
        String coursCode = p.getCourseCode().toString();
        String coursLoc = p.getCourseLocation().toString();
        String coursStart = p.getCourseStartDt().toString();
        String coursEnd = p.getCourseEndDt().toString();
        String coursLimit = String.valueOf(p.getCourseLimit()) != null ? String.valueOf(p.getCourseLimit()) : "20";
        String courseClsDt = p.getCourseCloseDt().toString() != null ? p.getCourseCloseDt().toString() : defaultCloseDt;
        String memType = String.valueOf(p.getMemberType());

        Exception e1 = null;

        if (StringUtils.isBlank(courseTitle)){
        	e1 = new Exception("courseTitle is required");
        	throw e1;
        }
        if (StringUtils.isBlank(courseType)){
        	e1 = new Exception("courseType is required");
        	throw e1;
        }
        if (StringUtils.isBlank(coursCode)){
        	e1 = new Exception("courseCode is required");
        	throw e1;
        }
        if (StringUtils.isBlank(coursLoc)){
        	e1 = new Exception("courseLocation is required");
        	throw e1;
        }
        if (StringUtils.isBlank(coursStart)){
        	e1 = new Exception("courseStartDt is required");
        	throw e1;
        }
        if (StringUtils.isBlank(coursEnd)){
        	e1 = new Exception("courseEndDt is required");
        	throw e1;
        }
        if (StringUtils.isBlank(memType)){
        	e1 = new Exception("memType is required");
        	throw e1;
        }

    	Map<String, Object> selectCourseId = new HashMap<String, Object>();
        selectCourseId.put("coursCode", p.getCourseCode());
        int isExist = lmsApiMapper.cntCourseCheck(selectCourseId);

    	if(isExist > 0){
    		//code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
    		e1 = new Exception(AppConstants.RESPONSE_DESC_DUP);
    		throw e1;
    	}

    	Map<String, Object> courseTypeParam = new HashMap<String, Object>();
    	courseTypeParam.put("courseTypeId", courseType);
    	EgovMap validateCourseType = trainingMapper.selectCourseTypeById(courseTypeParam);
    	if (validateCourseType.isEmpty()) {
    		e1 = new Exception("Invalid Course Type");
        	throw e1;
    	}

		/*if ( !StringUtils.isBlank(courseType) || !StringUtils.isBlank(coursCode) || !StringUtils.isBlank(coursLoc) || !StringUtils.isBlank(coursStart)
        		|| !StringUtils.isBlank(coursEnd) || !StringUtils.isBlank(coursLimit) || !StringUtils.isBlank(courseClsDt) || !StringUtils.isBlank(memType)){*/
        	//course info
            Map<String, Object> courseInfo = new HashMap<String, Object>();
            int coursId = trainingService.selectNextCoursId();

            courseInfo.put("coursId", coursId);
            courseInfo.put("coursName", courseTitle);
            courseInfo.put("codeId", courseType);
            courseInfo.put("coursCode", coursCode);
            courseInfo.put("coursLoc", coursLoc);
            courseInfo.put("coursStart", coursStart);
            courseInfo.put("coursEnd", coursEnd);
            courseInfo.put("coursLimit", coursLimit);
            courseInfo.put("courseClsDt", courseClsDt);
            courseInfo.put("userId", reqPrm.get("sysUserId").toString());

//                    String isMem = "";
//                    if(("Y").equals(p.getIsMember())){
//                    	isMem= "2318";
//                    }
//                    else if(("N").equals(p.getIsMember())){
//                    	isMem= "2319";
//                    }
            courseInfo.put("generalCode", "2318");
            courseInfo.put("memType", memType);
            courseInfo.put("attendance", "2315");//EDU team

            trainingMapper.insertCourse(courseInfo);

            created = 1;
        //}

		if(created > 0){
          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
          message = AppConstants.RESPONSE_DESC_CREATED;
        }else{
          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
          message = AppConstants.RESPONSE_DESC_INVALID;
        }
      }

    } catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);

      System.out.println();
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, data, null ,apiUserId);
  }

  @Override
  public EgovMap updateCourse(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0",sysUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    String data = commonApiService.decodeJson(request);
    Gson g = new Gson();
	LMSApiForm p = g.fromJson(data, LMSApiForm.class);

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = new HashMap<>();
    String key = request.getHeader("key");
    reqPrm.put("key", key);

    Exception e1 = null;

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

        //course info
        Map<String, Object> courseInfo = new HashMap<String, Object>();
        Map<String, Object> selectCourseId = new HashMap<String, Object>();

        //validation
        String coursCode = p.getCourseCode().toString().trim();
        selectCourseId.put("coursCode", coursCode);
        if (!StringUtils.isBlank(coursCode) ){
        	int isExist = lmsApiMapper.cntCourseCheck(selectCourseId);

        	if(isExist > 0){
        		EgovMap codeId = lmsApiMapper.selectCourseId(selectCourseId);

                courseInfo.put("coursId", codeId.get("coursId").toString());
                if(p.getCourseTitle() !=null && !p.getCourseTitle().isEmpty()){
                	courseInfo.put("coursName", p.getCourseTitle());
                }
                if(p.getCourseType() !=null && !p.getCourseType().isEmpty()){
                	courseInfo.put("codeId", p.getCourseType());
                }
                //courseInfo.put("coursCode", p.getCourseCode());
                if(p.getCourseLocation() !=null && !p.getCourseLocation().isEmpty()){
                	courseInfo.put("coursLoc", p.getCourseLocation());
                }
                if(p.getCourseStartDt() !=null && !p.getCourseStartDt().isEmpty()){
                	courseInfo.put("coursStart", p.getCourseStartDt());
                }
                if(p.getCourseEndDt() !=null && !p.getCourseEndDt().isEmpty()){
                	courseInfo.put("coursEnd", p.getCourseEndDt());
                }
                if(String.valueOf(p.getCourseLimit()) !=null && !String.valueOf(p.getCourseLimit()).isEmpty()){
                	courseInfo.put("coursLimit", p.getCourseLimit());
                }
                if(p.getCourseCloseDt() !=null && !p.getCourseCloseDt().isEmpty()){
                	courseInfo.put("courseClsDt", p.getCourseCloseDt());
                }
                if(String.valueOf(p.getCourseStatus()) !=null && !String.valueOf(p.getCourseStatus()).isEmpty()){
                	courseInfo.put("stusCodeId", p.getCourseStatus());
                }

                courseInfo.put("userId", reqPrm.get("sysUserId").toString());

//                String isMem = "";
//                if(("Y").equals(p.getIsMember())){
//                	isMem= "2318";
//                }
//                else if(("N").equals(p.getIsMember())){
//                	isMem= "2319";
//                }
//                courseInfo.put("generalCode", "2318");

                if(String.valueOf(p.getMemberType()) !=null && !String.valueOf(p.getMemberType()).isEmpty()){
                	courseInfo.put("memType", p.getMemberType());
                }
                courseInfo.put("attendance", 2315);//EDU team

                trainingMapper.updateCourse(courseInfo);

                created = 1;
        	}
        } else {
        	e1 = new Exception("courseCode is required");
        	throw e1;
        }
      }

      if(created > 0){
      	code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = AppConstants.RESPONSE_DESC_SUCCESS;
      }else{
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = AppConstants.RESPONSE_DESC_INVALID;
      }
    } catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);

      System.out.println();
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, data, null,apiUserId);
  }

  @Override
  public EgovMap updateCourseAttend(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception {

    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0",sysUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    String data = commonApiService.decodeJson(request);
    Gson g = new Gson();
    LMSAttendApiForm p = g.fromJson(data, LMSAttendApiForm.class);

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = new HashMap<>();
    String key = request.getHeader("key");
    reqPrm.put("key", key);

    try{

      int created = 0;
      access = commonApiMapper.checkAccess(reqPrm);

      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }else{

    	  apiUserId = access.get("apiUserId").toString();
          sysUserId = access.get("sysUserId").toString();
          reqPrm.put("apiUserId", apiUserId);
          reqPrm.put("sysUserId", sysUserId);

          if (p.getAssignCourse() != null && p.getAssignCourse().size() > 0){

              for(int i = 0; i <p.getAssignCourse().size(); i++){

            	  Map<String, Object> enrollInfo = new HashMap<String, Object>();

            	  CourseForm courseForm = p.getAssignCourse().get(i);

            	  if (courseForm != null){

            		  if (StringUtil.isBlank(courseForm.getUsername())){
    					  Exception e3 = new Exception("username is required");
    					  throw e3;
    				  }

    				  if (StringUtil.isBlank(courseForm.getCourseCode())){
    					  Exception e4= new Exception("courseCode is required");
    					  throw e4;
    				  }

            		  if (!StringUtil.isBlank(courseForm.getAction())){
            			  if (courseForm.getAction().equalsIgnoreCase("1")){ // 1. enroll course

            				  enrollInfo.put("coursCode", courseForm.getCourseCode().trim());
            				  enrollInfo.put("status", 1);// active course only
            				  EgovMap codeId = lmsApiMapper.selectCourseId(enrollInfo);

            				  if (codeId != null){
            					  enrollInfo.put("memCode", courseForm.getUsername().trim());
            					  enrollInfo.put("coursStatus", 1); // active course only
            					  enrollInfo.put("coursMemStatus", 1); // active course member only
            					  enrollInfo.put("coursTestResult", 0);
            					  List<EgovMap> userInfoList = lmsApiMapper.selectMemIdByCourse(enrollInfo);

            					  if (userInfoList != null){
            						  if(userInfoList.size() == 1){
            							  EgovMap userInfo = userInfoList.get(0);

            							  if (userInfo.get("coursCode") != null){
                							  Exception e7 = new Exception("username [" + courseForm.getUsername() + "] already enrolled with course = [" + userInfo.get("coursCode") + "]");
                							  throw e7;
                						  }

                						 //assign username to course
                	                      Map<String, Object> attendeeInfo = new HashMap<String, Object>();
                	                      attendeeInfo.put("coursId", codeId.get("coursId"));
                	                      attendeeInfo.put("coursMemId", userInfo.get("memId"));
                	                      attendeeInfo.put("userId", reqPrm.get("sysUserId").toString());
                	                      attendeeInfo.put("coursDMemName", userInfo.get("fullName"));
                	                      attendeeInfo.put("coursDMemNric", userInfo.get("nric"));
                	                      //attendeeInfo.put("coursMemShirtSize", shirtSize);
                	                      lmsApiMapper.registerCourse(attendeeInfo);
            						  }else{
            							  Exception e7 = new Exception ("Please contact admistrator"); //the member enroll more than two courses, should have one active course enroll only
                            			  throw e7;
            						  }
            					  } else {
            						  Exception e6 = new Exception ("username not found [" + courseForm.getUsername() + "]");
                        			  throw e6;
            					  }


            				  } else {
            					  Exception e5 = new Exception ("course code not found [" + courseForm.getCourseCode() + "]");
                    			  throw e5;
            				  }

            			  } else if (courseForm.getAction().equalsIgnoreCase("2")) { // 2. delete enrolled course

            				  // select course info by username
            				  enrollInfo.put("coursCode", courseForm.getCourseCode().trim());
            				  enrollInfo.put("memCode", courseForm.getUsername().trim());
            				  EgovMap enrolledCourseMem = lmsApiMapper.selectCourseByMem(enrollInfo);

            				  if (enrolledCourseMem == null){
            					  Exception e5 = new Exception("Cannot not find username [" + courseForm.getUsername().trim() + "] with course = [" + courseForm.getCourseCode().trim() + " ]");
            					  throw e5;
            				  } else {
            					  // update enrolled course to inactive;
            					  Map<String, Object> attendeeInfo = new HashMap<String, Object>();
        	                      attendeeInfo.put("coursId", enrolledCourseMem.get("coursId"));
        	                      attendeeInfo.put("coursMemId", enrolledCourseMem.get("coursMemId"));
        	                      attendeeInfo.put("userId", reqPrm.get("sysUserId").toString());
        	                      attendeeInfo.put("coursMemStusId", 8); //set to inactive
        	                      lmsApiMapper.updateAttendee(attendeeInfo);

            				  }

            			  } else if (courseForm.getAction().equalsIgnoreCase("3")) { // 3. update T-shirt size

            				  if (StringUtil.isBlank(courseForm.getShirtSize())){
            					  Exception e4= new Exception("shirtSize is required");
            					  throw e4;
            				  }

            				  // select course info by username
            				  enrollInfo.put("coursCode", courseForm.getCourseCode().trim());
            				  enrollInfo.put("memCode", courseForm.getUsername().trim());
            				  EgovMap enrolledCourseMem = lmsApiMapper.selectCourseByMem(enrollInfo);

            				  if (enrolledCourseMem == null){
            					  Exception e5 = new Exception("Cannot not find username [" + courseForm.getUsername().trim() + "] with course = [" + courseForm.getCourseCode().trim() + " ]");
            					  throw e5;
            				  }

            				  // update t-shirt size to enrolled course user
            				  Map<String, Object> tshirtInfo = new HashMap<String, Object>();
            				  tshirtInfo.put("shirtSize", courseForm.getShirtSize().trim());
            				  tshirtInfo.put("coursId", enrolledCourseMem.get("coursId"));
            				  tshirtInfo.put("coursMemId", enrolledCourseMem.get("coursMemId"));

            				  lmsApiMapper.updateAttendee(tshirtInfo);

            			  }
            		  } else { // action is null

            			  Exception e2 = new Exception ("action is required");
            			  throw e2;
            		  }
            	  }
              }

              created = 1;
          } else {
        	  Exception e1 = new Exception("Assign Course is required");
        	  throw e1;
          }
      }

      if(created > 0){
      	code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
          message = AppConstants.RESPONSE_DESC_SUCCESS;
      }else{
        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
        message = AppConstants.RESPONSE_DESC_INVALID;
      }
    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
      throw e;
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    	return commonApiService.rtnRespMsg(request, code, message, respTm, data, null ,apiUserId);
    }

//    return commonApiService.rtnRespMsg(request, code, message, respTm, data, null ,apiUserId);
  }

  @Override
  public EgovMap updateAttendResult(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception {
	  String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0",sysUserId = "0";

	    StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

	    String data = commonApiService.decodeJson(request);
	    Gson g = new Gson();
	    LMSResultApiForm p = g.fromJson(data, LMSResultApiForm.class);

	    EgovMap access = new EgovMap() , respPrm = new EgovMap();
	    Map<String, Object> reqPrm = new HashMap<>();
	    String key = request.getHeader("key");
	    reqPrm.put("key", key);

	    try{

	      int created = 0;
	      access = commonApiMapper.checkAccess(reqPrm);

	      if(access == null){
	        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
	        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
	      }else{

	    	  apiUserId = access.get("apiUserId").toString();
	          sysUserId = access.get("sysUserId").toString();
	          reqPrm.put("apiUserId", apiUserId);
	          reqPrm.put("sysUserId", sysUserId);

	          if (p.getUserResult() != null || p.getUserResult().size() > 0){

    	          for(int user = 0; user <p.getUserResult().size(); user++){

    	        	  String coursCode = p.getUserResult().get(user).getCourseCode();
    	        	  if(StringUtil.isBlank(coursCode)){
    	        		  Exception e2 = new Exception("CourseCode is required");
    	        		  throw e2;
    	        	  }

    	        	  Map<String, Object> courseInfo = new HashMap<String, Object>();
    	        	  courseInfo.put("coursCode", coursCode);
    	        	  EgovMap codeId = lmsApiMapper.selectCourseId(courseInfo);

    	        	  if (codeId == null){
    	        		  Exception e3 = new Exception("courseCode [" + coursCode +"] not found");
    	        		  throw e3;
    	        	  }

    	        	  String username = p.getUserResult().get(user).getUsername();
    	        	  if(StringUtil.isBlank(username)){
    	        		  Exception e4 = new Exception("username is required");
    	        		  throw e4;
    	        	  }

            		  Map<String, Object> userInfo = new HashMap<String, Object>();
            		  userInfo.put("memCode", username);

           		   	  EgovMap userId = lmsApiMapper.selectActiveMemberByMemId(userInfo);

           		   	  if (userId == null){
           		   		  Exception e5 = new Exception("username [" + username +"] not found");
           		   		  throw e5;
           		   	  }

           		   	  String supplementInd = p.getUserResult().get(user).getTrainingResult();
               		  if(StringUtil.isBlank(supplementInd)){
     	        		  Exception e6 = new Exception("Supplement Course Indicator is required");
     	        		  throw e6;
     	        	  }

                	  //Attendee List
                      Map<String, Object> attendeeInfo = new HashMap<String, Object>();
                      attendeeInfo.put("coursId", codeId.get("coursId"));
                      attendeeInfo.put("coursMemId", userId.get("memId"));
                      attendeeInfo.put("userId", reqPrm.get("sysUserId").toString());
                      attendeeInfo.put("coursTestResult", p.getUserResult().get(user).getTrainingResult());
                      attendeeInfo.put("supplementInd", supplementInd);
                      if(!p.getUserResult().get(user).getCdpPoint().isEmpty()){
                    	  attendeeInfo.put("coursCdpPoint", p.getUserResult().get(user).getCdpPoint());
                      }
                      if(!p.getUserResult().get(user).getAttendDay().isEmpty()){
                    	  attendeeInfo.put("coursAttendDay", p.getUserResult().get(user).getAttendDay());
                      }
                      lmsApiMapper.updateAttendee(attendeeInfo);

                      if(supplementInd.equals("1")){
                    	  Map<String, Object> memInfo = new HashMap<String, Object>();
                    	  memInfo.put("MemberID", userId.get("memId"));
                          attendeeInfo.put("supplementInd", supplementInd);
                    	  lmsApiMapper.updateMemSupplimentFlag(memInfo);
                      }

                      //when HP, call to trigger open sales
                      if(userId.get("memType").toString().equals("1") && attendeeInfo.get("coursTestResult").toString().equalsIgnoreCase("P")){
                    	  MemberListServiceImpl memberListServiceImpl = new MemberListServiceImpl();
                          SessionVO sessionVo = new SessionVO();
                          Map<String, Object> params = new HashMap<>();
                          params.put("MemberID", userId.get("memId"));

                          lmsApiMapper.updateRookieForHp(params);

//                          params.put("memberId", userId.get("memId"));
//                          params.put("memberCode", userId.get("memCode"));
//                          params.put("memberType", userId.get("memType"));
//                          params.put("nric", userId.get("nric"));
//
//                          sessionVo.setUserId(Integer.parseInt(sysUserId));
                          //sessionVo.setUserBranchId(Integer.parseInt(userId.get("collctBrnch").toString()));

//                          Map<String, Object> resultValue = new HashMap<String, Object>();
                          //resultValue = hpMemUpdatePay(params,sessionVo);

    //                      if(resultValue.size() > 0){
    //              			if (resultValue.get("duplicMemCode") != null) {
    //              				respPrm.put("registered", respPrm.get("registered").toString()
    //              						+ resultValue.get("duplicMemCode").toString());
    ////              				message = "This member is already registered<br/>as member code : "
    ////              						+ resultValue.get("duplicMemCode").toString();
    //              			} else {
    //              				//Doc Update
    //              				params.put("hpMemId",  resultValue.get("memId").toString());
    //              				memberListServiceImpl.updateDocSubWhenAppr(params , sessionVo);
    //              				created = 1;
    //              			}
    //              		} else if (resultValue.size() == 0) {
    //              				respPrm.put("invalid",userId.get("memId"));
    ////              			message = "There is no address information to the HP applicant code";
    //              		}
                          //if HP pass the test, call LMS API to direct convert to StaffId
    //                      String newMemCode = (String)resultValue.get("memCode");
                      }
    	          }
    	          created = 1;
    	      } else { // empty UserResult list
    	    	  Exception e1 = new Exception("UserResult is required");
    	    	  throw e1;
    	      }
	      }

	      if(created > 0){
	      	code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
	          message = AppConstants.RESPONSE_DESC_SUCCESS;
	      }else{
	        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
	        message = AppConstants.RESPONSE_DESC_INVALID;
	      }
	    }catch(Exception e){
	      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
	      message = StringUtils.substring(e.getMessage(), 0, 4000);
	    } finally{
	      stopWatch.stop();
	      respTm = stopWatch.toString();
	    }

	    return commonApiService.rtnRespMsg(request, code, message, respTm, data, respPrm ,apiUserId);
  }

  public Map<String, Object> hpMemUpdatePay(Map<String, Object> params,SessionVO sessionVO) throws ParseException {
	  MemberListServiceImpl memberListServiceImpl = new MemberListServiceImpl();
	  Map<String, Object> resultValue = new HashMap<String, Object>();
		Map<String, Object> CodeMap = new HashMap<String, Object>();
		CodeMap.put("code", "mem");
		EgovMap selectHpBillNo = new EgovMap();
		String hpBillNo="";
		EgovMap selectInvoiceNo = null;
		//AcBilling Save (for Hp)

		int userId = sessionVO.getUserId();
		String MemberId = params.get("MemberID").toString();
		String memberCode = params.get("memberCode").toString();
		params.put("creator", userId);
		params.put("updator", userId);

		SimpleDateFormat sfd = new SimpleDateFormat("yyyy-MM-dd");
		Date currentDay = new Date();

		String startDateString = "2019-10-01";
		String endDateString   = "2019-12-31";
		Date startDay    = sfd.parse(startDateString);
		Date endDay      = sfd.parse(endDateString);

		if(currentDay.before(startDay) || currentDay.after(endDay)){
			selectHpBillNo =getDocNo("5");

			hpBillNo=(String)selectHpBillNo.get("docNo");
			int hPBillID=5;
			String nextDocNo = getNextDocNo("HPB", selectHpBillNo.get("c1").toString());
			selectHpBillNo.put("nextDocNo", nextDocNo);
			if(Integer.parseInt(selectHpBillNo.get("docNoId").toString()) == hPBillID){
				memberListMapper.updateDocNo(selectHpBillNo);
			}
			params.put("hpBillNo", hpBillNo);

			Map<String, Object> accBill = new HashMap<String, Object>();
			accBill.put("billId", 0);
			accBill.put("billINo", hpBillNo);
			accBill.put("billTypeId", 222);
			accBill.put("billSOID", 0);
			accBill.put("billMemId", MemberId);
			accBill.put("billASID", 0);
			accBill.put("billPayTypeId", 224);
			accBill.put("billMemberShipNo", "");
			accBill.put("billDate", new Date());
			accBill.put("billAmt", 120);
			accBill.put("billRemark", "");
			accBill.put("billIsPaid", false);
			accBill.put("billIsComm", true);
			accBill.put("updator", params.get("updator"));
			accBill.put("updated", new Date());
			accBill.put("syncCheck", true);
			accBill.put("courseId", 0);
			accBill.put("statusId", 1);
			memberListMapper.insertAccBill(accBill);

  			//AccOrderBill Save
  			Map<String, Object> accOrderBill = new HashMap<String, Object>();
  			accOrderBill.put("accBillTaskId", 0);
  			accOrderBill.put("accBillRefDate", new Date());
  			accOrderBill.put("accBillRefNo", "1000");
  			accOrderBill.put("accBillOrderId", 0);
  			accOrderBill.put("accBillOrderNo", "");
  			accOrderBill.put("accBillTypeId", 1159);
  			accOrderBill.put("accBillModeId", 1171);
  			accOrderBill.put("accBillScheduleId", 0);
  			accOrderBill.put("accBillSchedulePeriod", 0);
  			accOrderBill.put("accBillAdjustmentId", 0);
  			accOrderBill.put("accBillScheduleAmount", 120);
  			accOrderBill.put("accBillAdjustmentAmount", 0);
  			accOrderBill.put("accBillTaxesAmount",0);
  			accOrderBill.put("accBillNetAmount", String.format("%.2f",(double)120));
  			accOrderBill.put("accBillStatus", 1);
  			accOrderBill.put("accBillRemark",memberCode);
  			accOrderBill.put("accBillCreateAt", new Date());
  			accOrderBill.put("accBillCreateBy", params.get("creator"));
  			accOrderBill.put("accBillGroupId", 0);
  			accOrderBill.put("accBillTaxCodeId", 32);
  			accOrderBill.put("accBillTaxRate", 0);
  			accOrderBill.put("accBillAcctConversion", 0);
  			accOrderBill.put("accBillContractId", 0);

  			 memberListMapper.insertAccOrderBill(accOrderBill);

  			//GST 2015-01-06
  			selectInvoiceNo = getDocNoNumber("130");
  			updateDocNoNumber("130");

  			EgovMap org001dInfo = null;
  			org001dInfo = memberListMapper.selectORG001DInfo(MemberId) ;

			Map<String, Object> selectMiscValue = new HashMap<String, Object>();
			selectMiscValue.put("memberId", MemberId);
			selectMiscValue.put("memberName", org001dInfo.get("memberNm"));
			selectMiscValue.put("membetFullName", org001dInfo.get("fulllName"));
			selectMiscValue.put("address1", org001dInfo.get("address1"));
			selectMiscValue.put("address2", org001dInfo.get("address2"));
			selectMiscValue.put("address3", org001dInfo.get("address3"));
			selectMiscValue.put("address4", org001dInfo.get("address4"));
			selectMiscValue.put("memberNirc", org001dInfo.get("nric"));


			EgovMap selectMiscList = null;
			selectMiscList = memberListMapper.selectMiscList(selectMiscValue) ;

			if(selectMiscList != null){
				Map<String, Object>  InvMISC = new HashMap<String, Object>();

				InvMISC.put("taxInvoiceRefNo", selectInvoiceNo.get("docNo"));
				InvMISC.put("taxInvoiceRefDate", new Date());
				InvMISC.put("taxInvoiceServiceNo",memberCode);
				InvMISC.put("taxInvoiceType", 117);
				InvMISC.put("taxInvoiceCustName",selectMiscList.get("c1"));
				InvMISC.put("taxInvoiceContactPerson",selectMiscList.get("c1"));
				InvMISC.put("taxInvoiceAddress1",selectMiscList.get("c3"));
				InvMISC.put("taxInvoiceAddress2",selectMiscList.get("c4"));
				InvMISC.put("taxInvoiceAddress3",selectMiscList.get("c5"));
				InvMISC.put("taxInvoiceAddress4",selectMiscList.get("c6"));
				InvMISC.put("taxInvoicePostCode",selectMiscList.get("postCode"));
				InvMISC.put("taxInvoiceStateName",selectMiscList.get("name"));
				InvMISC.put("taxInvoiceCountry",selectMiscList.get("name1"));
				InvMISC.put("taxInvoiceTaskID",0);
				InvMISC.put("taxInvoiceRemark","");
				//InvMISC.put("taxInvoiceCharges",String.format("%.2f",(double)120.00 * 100 / 106)); -- without GST 6% edited by TPY 24/05/2018
				//InvMISC.put("taxInvoiceTaxes",String.format("%.2f",(120 - ((double)120.00 * 100 / 106)))); -- without GST 6% edited by TPY 24/05/2018
				InvMISC.put("taxInvoiceCharges",120);
				InvMISC.put("taxInvoiceTaxes",0);
				InvMISC.put("taxInvoiceAmountDue",String.format("%.2f",(double)120));
				InvMISC.put("taxInvoiceCreated",new Date());
				InvMISC.put("areaId",selectMiscList.get("areaId"));
				InvMISC.put("addrDtl",selectMiscList.get("addrDtl"));
				InvMISC.put("street",selectMiscList.get("street"));
				InvMISC.put("taxInvoiceCreator",Integer.parseInt(params.get("creator").toString()));

				memberListMapper.insertInvMISC(InvMISC);

				EgovMap selectOrganization = null;
				selectOrganization = memberListMapper.selectOrganization(params);

				CodeMap.put("code", "tax");
				String taxInvId = memberListMapper.selectMemberId(CodeMap);
				Map<String, Object>  InvMISCD = new HashMap<String, Object>();
				InvMISCD.put("taxInvoiceID",taxInvId );//위에 insert할때 값 가져와서 넣어줘야함
				InvMISCD.put("invoiceItemType",  1260);
				InvMISCD.put("invoiceItemOrderNo", "");
				InvMISCD.put("invoiceItemPONo", "");
				InvMISCD.put("invoiceItemCode", selectOrganization.get("deptCode"));
				InvMISCD.put("invoiceItemDescription1",selectMiscList.get("c1"));
				InvMISCD.put("invoiceItemDescription2",selectMiscList.get("c7"));
				InvMISCD.put("invoiceItemSerialNo","");
				InvMISCD.put("invoiceItemQuantity",1);
				//InvMISCD.put("invoiceItemGSTRate",6); -- without GST 6% edited by TPY 24/05/2018
				//InvMISCD.put("invoiceItemGSTTaxes",String.format("%.2f",(120 - ((double)120.00 * 100 / 106)))); -- without GST 6% edited by TPY 24/05/2018
				//InvMISCD.put("invoiceItemCharges",String.format("%.2f",((double)120.00) * 100 / 106)); -- without GST 6% edited by TPY 24/05/2018
				InvMISCD.put("invoiceItemGSTRate",0);
				InvMISCD.put("invoiceItemGSTTaxes",0);
				InvMISCD.put("invoiceItemCharges",120);
				InvMISCD.put("invoiceItemAmountDue",String.format("%.2f",(double)120));
				InvMISCD.put("invoiceItemAdd1","");
				InvMISCD.put("invoiceItemAdd2","");
				InvMISCD.put("invoiceItemAdd3","");
				InvMISCD.put("invoiceItemPostCode","");
				InvMISCD.put("invoiceItemStateName","");
				InvMISCD.put("invoiceItemCountry","");
				InvMISCD.put("invoiceItemBillRefNo","");
				InvMISCD.put("areaId",selectMiscList.get("areaId"));
				InvMISCD.put("addrDtl",selectMiscList.get("addrDtl"));
				InvMISCD.put("street",selectMiscList.get("street"));

				memberListMapper.insertInvMISCD(InvMISCD);

				accOrderBill.put("accBillRemark",selectInvoiceNo.get("docNo"));
				memberListMapper.updateBillRem(accOrderBill);
			}
		}

		// SP_DAY_USER_CRT 프로시저 호출
		Map<String, Object>  userPram = new HashMap<String, Object>();
		userPram.put("IN_MEMCODE", memberCode);
		memberListMapper.SP_DAY_USER_CRT(userPram);
		userPram.put("P_STATUS", userPram.get("p1"));

		//call sms
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy");
		Date currentDay1 = new Date();
		String today = sdf.format(currentDay1);

		Map<String, Object> smsInfo = new HashMap<String, Object>();
		String apprSms =  " COWAY: WELCOME to COWAY family! " +
              "Your application for COWAY HP is completed. Your COWAY HP code " + memberCode + " is ACTIVATED on " + today + ". TQ!";
		smsInfo.put("msg", apprSms);

		Map<String, Object> userInfo = new HashMap<String, Object>();
		userInfo.put("memberId", MemberId);
		userInfo.put("src", "member");
		EgovMap hpCtc = new EgovMap();
		hpCtc = memberListMapper.getHPCtc(userInfo);

		smsInfo.put("rTelNo", hpCtc.get("mobile"));

		SmsVO sms = new SmsVO(userId, 975);
	    sms.setMessage(CommonUtils.nvl(smsInfo.get("msg")));
	    sms.setMobiles(CommonUtils.nvl(smsInfo.get("rTelNo")));
		SmsResult smsResult = adaptorService.sendSMS(sms);

		return resultValue;
	}

  public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
		String prefix = "";

		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){

			if(selectDocNo.get("c2") != null){
				prefix = (String) selectDocNo.get("c2");
			}else{
				prefix = "";
			}
			docNo = prefix.trim()+(String) selectDocNo.get("c1");
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}

  public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			System.out.println("들어오면안됨");
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			System.out.println("들어와얗ㅁ");
			docNoLength = docNo.length();

			if ( prefixNo.equals("TR")) {
				docNo = docNo.replace(prefixNo, "");

				docNo.substring(2);
			}
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		return nextDocNo;
	}

  public EgovMap getDocNoNumber(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);

		if(docNoId.equals("130") && Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){
			docNo = (String) selectDocNo.get("c2")+(String) selectDocNo.get("c1");
			selectDocNo.put("docNo", docNo);
		}
		return selectDocNo;
	}
	public void updateDocNoNumber(String docNoId){//코드값에 따라 자리수 다르게
		EgovMap selectDocNoNumber = memberListMapper.selectDocNo(docNoId);
		int nextDocNoNumber = Integer.parseInt((String)selectDocNoNumber.get("c1")) + 1;
		String nextDocNo="";
		if(docNoId.equals("145") || docNoId.equals("12")){
			nextDocNo = String.format("%07d", nextDocNoNumber);
		}else{//130일때,120일때,119일때
		nextDocNo = String.format("%08d", nextDocNoNumber);
		}
		selectDocNoNumber.put("nextDocNo", nextDocNo);
		memberListMapper.updateDocNo(selectDocNoNumber);
	}

	@Override
	public Map<String, Object> lmsMemberListInsert(Map<String, Object> params){
		Map<String, Object> resultValue = new HashMap<String, Object>();
		/*if(true) return resultValue;*/
		EgovMap selectMemListlms = memberListMapper.selectMemberListView(params);
		List<EgovMap> selectcoursListlms = memberListMapper.selectTraining(params);

		LMSMemApiForm lmsMemApiForm = new LMSMemApiForm();

		lmsMemApiForm.setSecretkey(LMSApiSecretkey);
		lmsMemApiForm.setUsername(selectMemListlms.get("memCode").toString());
		lmsMemApiForm.setEmail(selectMemListlms.get("email") == null ? "" : selectMemListlms.get("email").toString());
		lmsMemApiForm.setFirstname(selectMemListlms.get("name1") == null ? "" : selectMemListlms.get("name1").toString());
		lmsMemApiForm.setLastname(".");
		lmsMemApiForm.setIdnumber(selectMemListlms.get("nric") == null ? "" : selectMemListlms.get("nric").toString());
		lmsMemApiForm.setInstitution("Coway Malaysia");
		lmsMemApiForm.setDepartment(selectMemListlms.get("c41") == null ? "" : selectMemListlms.get("c41").toString());
		lmsMemApiForm.setPhone1(selectMemListlms.get("telMobile") == null ? "" : selectMemListlms.get("telMobile").toString());
		lmsMemApiForm.setCity(selectMemListlms.get("city") == null ? "" : selectMemListlms.get("city").toString());
		lmsMemApiForm.setCountry(selectMemListlms.get("country") == null ? "" : selectMemListlms.get("country").toString());
		lmsMemApiForm.setProfile_field_postcode(selectMemListlms.get("postcode") == null ? "" : selectMemListlms.get("postcode").toString());
		//String addrdtl = "";
		//String street = "";
		String addr ="";
		if(selectMemListlms.get("addrDtl") == null){
			if(selectMemListlms.get("street") == null) {
				addr = "";
			}else{
				addr = selectMemListlms.get("street").toString();
				//addr = street;
			}
		}else{
			if(selectMemListlms.get("street") == null) {
				addr = selectMemListlms.get("addrDtl").toString();
				//street ="";
				//addr = addrdtl;
			}else{
				//addrdtl = selectMemListlms.get("addrDtl").toString();
				//street = selectMemListlms.get("street").toString();
				addr = selectMemListlms.get("addrDtl").toString() + " "+ selectMemListlms.get("street").toString();
			}
		}
		lmsMemApiForm.setProfile_field_address(addr);
		lmsMemApiForm.setProfile_field_gender(selectMemListlms.get("gender") == null ? "" : selectMemListlms.get("gender").toString());
		String formattedDate = "";
		if(selectMemListlms.get("c30") != null){
			Date date = null;
			try {
				date = new SimpleDateFormat("dd/mm/yyyy").parse(selectMemListlms.get("c30").toString());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formattedDate = new SimpleDateFormat("dd-mm-yyyy").format(date);
		}
		lmsMemApiForm.setProfile_field_dob(formattedDate);
		lmsMemApiForm.setProfile_field_position(selectMemListlms.get("c57") == null ? "" : selectMemListlms.get("c57").toString());
		lmsMemApiForm.setProfile_field_branchcode(selectMemListlms.get("c4") == null ? "" : selectMemListlms.get("c4").toString());
		lmsMemApiForm.setProfile_field_branchname(selectMemListlms.get("c5") == null ? "" : selectMemListlms.get("c5").toString());
		lmsMemApiForm.setProfile_field_region(selectMemListlms.get("state") == null ? "" : selectMemListlms.get("state").toString());
		lmsMemApiForm.setProfile_field_organizationcode(selectMemListlms.get("c43") == null ? "" : selectMemListlms.get("c43").toString());
		lmsMemApiForm.setProfile_field_groupcode(selectMemListlms.get("c42") == null ? "" : selectMemListlms.get("c42").toString());
		//lmsMemApiForm.setProfile_field_MemberStatus(selectMemListlms.get("name") == null ? "" : selectMemListlms.get("name").toString());
		lmsMemApiForm.setProfile_field_MemberType(selectMemListlms.get("codeName") == null ? "" : selectMemListlms.get("codeName").toString());
		lmsMemApiForm.setProfile_field_ManagerName(selectMemListlms.get("c23") == null ? "" : selectMemListlms.get("c23").toString());
		lmsMemApiForm.setProfile_field_ManagerID(selectMemListlms.get("c22") == null ? "" : selectMemListlms.get("c22").toString());
		lmsMemApiForm.setProfile_field_SeniorManagerName(selectMemListlms.get("c18") == null ? "" : selectMemListlms.get("c18").toString());
		lmsMemApiForm.setProfile_field_SeniorManagerID(selectMemListlms.get("c17") == null ? "" : selectMemListlms.get("c17").toString());
		lmsMemApiForm.setProfile_field_GeneralManagerName(selectMemListlms.get("c13") == null ? "" : selectMemListlms.get("c13").toString());
		lmsMemApiForm.setProfile_field_GeneralManagerID(selectMemListlms.get("c12") == null ? "" : selectMemListlms.get("c12").toString());

		// Edited to add Sleeping userstatus. Hui Ding, 2021-10-08
		String status = "NO";
		String userStatus = "";
		if (selectMemListlms.get("name") != null){
    		if(selectMemListlms.get("name").toString().equals("Active")){
    			status = "YES";
    			if(selectMemListlms.get("c59") != null && selectMemListlms.get("c59").toString().equals("1366")){
    				status = "NO";
    				userStatus = "Sleeping";
    			}
    		} else {
    			status = "NO";
    		}
		}
		lmsMemApiForm.setProfile_field_MemberStatus(status);
		String formattedDate1 = "";
		if(selectMemListlms.get("c30") != null){
			Date date = null;
			try {
				date = new SimpleDateFormat("dd/mm/yyyy").parse(selectMemListlms.get("c30").toString());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formattedDate1 = new SimpleDateFormat("dd-mm-yyyy").format(date);
		}
		lmsMemApiForm.setProfile_field_dateJoin(formattedDate1);
		lmsMemApiForm.setUserstatus(userStatus);

		//call LMS to insert user
//		System.out.println("Start Calling LMS API ...." + selectMemListlms.get("memCode") + "......\n");
		String lmsUrl = LMSApiDomains + LMSApiUrlAdd;

		Gson gson = new Gson();
		String jsonString = gson.toJson(lmsMemApiForm);

		EgovMap reqInfo = new EgovMap();
		reqInfo.put("jsonString", jsonString);
		reqInfo.put("lmsUrl", lmsUrl);
		reqInfo.put("refNo", selectMemListlms.get("nric") == null ? "" : selectMemListlms.get("nric").toString());

		resultValue = lmsReqApi(reqInfo);

		LOGGER.debug("End Calling LMS API ...." + selectMemListlms.get("memCode") + "......\n");

		return resultValue;
	}

	@Override
	public Map<String, Object> lmsMemberListUpdate(Map<String, Object> params){
		Map<String, Object> resultValue = new HashMap<String, Object>();
		/*if(true) return resultValue;*/
		EgovMap selectMemListlms = memberListMapper.selectMemberListView(params);
		List<EgovMap> selectcoursListlms = memberListMapper.selectTraining(params);

		LMSMemApiForm lmsMemApiForm = new LMSMemApiForm();

		lmsMemApiForm.setSecretkey(LMSApiSecretkey);
		lmsMemApiForm.setUsername(selectMemListlms.get("memCode") == null ? "" : selectMemListlms.get("memCode").toString());
		lmsMemApiForm.setEmail(selectMemListlms.get("email") == null ? "" : selectMemListlms.get("email").toString());
		lmsMemApiForm.setFirstname(selectMemListlms.get("name1") == null ? "" : selectMemListlms.get("name1").toString());
		lmsMemApiForm.setLastname(".");
		lmsMemApiForm.setIdnumber(selectMemListlms.get("nric") == null ? "" : selectMemListlms.get("nric").toString());
		lmsMemApiForm.setInstitution("Coway Malaysia");
		lmsMemApiForm.setDepartment(selectMemListlms.get("c41") == null ? "" : selectMemListlms.get("c41").toString());
		lmsMemApiForm.setPhone1(selectMemListlms.get("telMobile") == null ? "" : selectMemListlms.get("telMobile").toString());
		lmsMemApiForm.setCity(selectMemListlms.get("city") == null ? "" : selectMemListlms.get("city").toString());
		lmsMemApiForm.setCountry(selectMemListlms.get("country") == null ? "" : selectMemListlms.get("country").toString());
		lmsMemApiForm.setProfile_field_postcode(selectMemListlms.get("postcode") == null ? "" : selectMemListlms.get("postcode").toString());
		//String addrdtl = "";
		//String street = "";
		String addr ="";
		if(selectMemListlms.get("addrDtl") == null){
			if(selectMemListlms.get("street") == null) {
				addr = "";
			}else{
				addr = selectMemListlms.get("street").toString();
				//addr = street;
			}
		}else{
			if(selectMemListlms.get("street") == null) {
				addr = selectMemListlms.get("addrDtl").toString();
				//street ="";
				//addr = addrdtl;
			}else{
				//addrdtl = selectMemListlms.get("addrDtl").toString();
				//street = selectMemListlms.get("street").toString();
				addr = selectMemListlms.get("addrDtl").toString() + " "+ selectMemListlms.get("street").toString();
			}
		}
		lmsMemApiForm.setProfile_field_address(addr);
		lmsMemApiForm.setProfile_field_gender(selectMemListlms.get("gender") == null ?  "" : selectMemListlms.get("gender").toString());
		String formattedDate = "";
		if(selectMemListlms.get("c29") != null){
			Date date = null;
			try {
				date = new SimpleDateFormat("dd/mm/yyyy").parse(selectMemListlms.get("c29").toString());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formattedDate = new SimpleDateFormat("dd-mm-yyyy").format(date);
		}
		lmsMemApiForm.setProfile_field_dob(formattedDate);
		lmsMemApiForm.setProfile_field_position(selectMemListlms.get("c57") == null ?  "" : selectMemListlms.get("c57").toString());
		lmsMemApiForm.setProfile_field_branchcode(selectMemListlms.get("c4") == null ?  "" : selectMemListlms.get("c4").toString());
		lmsMemApiForm.setProfile_field_branchname(selectMemListlms.get("c5") == null ?  "" : selectMemListlms.get("c5").toString());
		lmsMemApiForm.setProfile_field_region(selectMemListlms.get("state") == null ? "" : selectMemListlms.get("state").toString());
		lmsMemApiForm.setProfile_field_organizationcode(selectMemListlms.get("c43") == null ?  "" : selectMemListlms.get("c43").toString());
		lmsMemApiForm.setProfile_field_groupcode(selectMemListlms.get("c42") == null ?  "" : selectMemListlms.get("c42").toString());
		//lmsMemApiForm.setProfile_field_MemberStatus(selectMemListlms.get("name") == null ?  "" : selectMemListlms.get("name").toString());
		lmsMemApiForm.setProfile_field_MemberType(selectMemListlms.get("codeName") == null ?  "" : selectMemListlms.get("codeName").toString());
		lmsMemApiForm.setProfile_field_ManagerName(selectMemListlms.get("c23") == null ?  "" : selectMemListlms.get("c23").toString());
		lmsMemApiForm.setProfile_field_ManagerID(selectMemListlms.get("c22") == null ?  "" : selectMemListlms.get("c22").toString());
		lmsMemApiForm.setProfile_field_SeniorManagerName(selectMemListlms.get("c18") == null ?  "" : selectMemListlms.get("c18").toString());
		lmsMemApiForm.setProfile_field_SeniorManagerID(selectMemListlms.get("c17") == null ?  "" : selectMemListlms.get("c17").toString());
		lmsMemApiForm.setProfile_field_GeneralManagerName(selectMemListlms.get("c13") == null ?  "" : selectMemListlms.get("c13").toString());
		lmsMemApiForm.setProfile_field_GeneralManagerID(selectMemListlms.get("c12") == null ?  "" : selectMemListlms.get("c12").toString());

		// Edited to add Sleeping userstatus. Hui Ding, 2021-10-08
		String status = "NO";
		String userStatus = "";
		if (selectMemListlms.get("name") != null){
    		if(selectMemListlms.get("name").toString().equals("Active")){
    			status = "YES";
    			if(selectMemListlms.get("c59") != null && selectMemListlms.get("c59").toString().equals("1366")){
    				status = "NO";
    				userStatus = "Sleeping";
    			}
    		} else {
    			status = "NO";
    		}
		}
		lmsMemApiForm.setProfile_field_MemberStatus(status);
		lmsMemApiForm.setUserstatus(userStatus);
//		if(!selectcoursListlms.get(0).isEmpty()){
			lmsMemApiForm.setProfile_field_trainingbatch(selectcoursListlms.get(0).get("codeName1") == null ? "" : selectcoursListlms.get(0).get("codeName1").toString());
			lmsMemApiForm.setProfile_field_TrainingVenue(selectcoursListlms.get(0).get("coursLoc") == null ? "" : selectcoursListlms.get(0).get("coursLoc").toString());
			lmsMemApiForm.setProfile_field_Tshirtsize(selectcoursListlms.get(0).get("shirtSize1") == null ? "" : selectcoursListlms.get(0).get("shirtSize1").toString());
			lmsMemApiForm.setProfile_field_TRNo(selectcoursListlms.get(0).get("traineeCode1") == null ? "" : selectcoursListlms.get(0).get("traineeCode1").toString());
//		}
//		lmsMemApiForm.setProfile_field_batch("");
		String formattedDate1 = "";
		if(selectMemListlms.get("c30") != null){
			Date date = null;
			try {
				date = new SimpleDateFormat("dd/mm/yyyy").parse(selectMemListlms.get("c30").toString());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formattedDate1 = new SimpleDateFormat("dd-mm-yyyy").format(date);
		}
		lmsMemApiForm.setProfile_field_dateJoin(formattedDate1);
		String resignDt = selectMemListlms.get("c48") == null ?  "" : selectMemListlms.get("c48").toString();
		lmsMemApiForm.setProfile_field_dateResign(resignDt);


		//call LMS to insert user
		System.out.println("Start Calling LMS API ...." + selectMemListlms.get("memCode") + "......\n");
		String lmsUrl = LMSApiDomains + LMSApiUrlUpdateProfile;

		Gson gson = new Gson();
		String jsonString = gson.toJson(lmsMemApiForm);

		EgovMap reqInfo = new EgovMap();
		reqInfo.put("jsonString", jsonString);
		reqInfo.put("lmsUrl", lmsUrl);
		reqInfo.put("refNo", selectMemListlms.get("memCode").toString());

		resultValue = lmsReqApi(reqInfo);

		LOGGER.debug("End Calling LMS API ...." + selectMemListlms.get("memCode") + "......\n");

		return resultValue;
	}

	@Override
	public Map<String, Object> lmsEHPMemberListInsert(Map<String, Object> params,String memberCode){
		Map<String, Object> resultValue = new HashMap<String, Object>();
		/*if(true) return resultValue;*/
		EgovMap selectMemListlms = memberListMapper.getHPMemberListView(params);
		List<EgovMap> selectcoursListlms = memberListMapper.selectTraining(params);

		LMSMemApiForm lmsMemApiForm = new LMSMemApiForm();

		lmsMemApiForm.setSecretkey(LMSApiSecretkey);
		lmsMemApiForm.setUsername(memberCode);
		lmsMemApiForm.setEmail(selectMemListlms.get("email") == null ? "" : selectMemListlms.get("email").toString());
		lmsMemApiForm.setFirstname(selectMemListlms.get("name1") == null ? "" : selectMemListlms.get("name1").toString());
		lmsMemApiForm.setLastname(".");
		lmsMemApiForm.setIdnumber(selectMemListlms.get("nric") == null ? "" : selectMemListlms.get("nric").toString());
		lmsMemApiForm.setInstitution("Coway Malaysia");
		lmsMemApiForm.setDepartment(selectMemListlms.get("c41") == null ? "" : selectMemListlms.get("c41").toString());
		lmsMemApiForm.setPhone1(selectMemListlms.get("telMobile") == null ? "" : selectMemListlms.get("telMobile").toString());
		lmsMemApiForm.setCity(selectMemListlms.get("city") == null ? "" : selectMemListlms.get("city").toString());
		lmsMemApiForm.setCountry(selectMemListlms.get("country") == null ? "" : selectMemListlms.get("country").toString());
		lmsMemApiForm.setProfile_field_postcode(selectMemListlms.get("postcode") == null ? "" : selectMemListlms.get("postcode").toString());
		//String addrdtl = "";
		//String street = "";
		String addr ="";
		if(selectMemListlms.get("addrDtl") == null){
			if(selectMemListlms.get("street") == null) {
				addr = "";
			}else{
				addr = selectMemListlms.get("street").toString();
				//addr = street;
			}
		}else{
			if(selectMemListlms.get("street") == null) {
				addr = selectMemListlms.get("addrDtl").toString();
				//street ="";
				//addr = addrdtl;
			}else{
				//addrdtl = selectMemListlms.get("addrDtl").toString();
				//street = selectMemListlms.get("street").toString();
				addr = selectMemListlms.get("addrDtl").toString() + " "+ selectMemListlms.get("street").toString();
			}
		}
		lmsMemApiForm.setProfile_field_address(addr);
		lmsMemApiForm.setProfile_field_gender(selectMemListlms.get("gender") == null ? "" : selectMemListlms.get("gender").toString());
		String formattedDate = "";
		if(selectMemListlms.get("c29") != null){
			Date date = null;
			try {
				date = new SimpleDateFormat("dd/mm/yyyy").parse(selectMemListlms.get("c29").toString());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formattedDate = new SimpleDateFormat("dd-mm-yyyy").format(date);
		}
		lmsMemApiForm.setProfile_field_dob(formattedDate);
		lmsMemApiForm.setProfile_field_position(selectMemListlms.get("c57") == null ? "" : selectMemListlms.get("c57").toString());
		lmsMemApiForm.setProfile_field_branchcode(selectMemListlms.get("c4") == null ? "" : selectMemListlms.get("c4").toString());
		lmsMemApiForm.setProfile_field_branchname(selectMemListlms.get("c5") == null ? "" : selectMemListlms.get("c5").toString());
		lmsMemApiForm.setProfile_field_region(selectMemListlms.get("state") == null ? "" : selectMemListlms.get("state").toString());
		lmsMemApiForm.setProfile_field_organizationcode(selectMemListlms.get("c43") == null ? "" : selectMemListlms.get("c43").toString());
		lmsMemApiForm.setProfile_field_groupcode(selectMemListlms.get("c42") == null ? "" : selectMemListlms.get("c42").toString());
		//lmsMemApiForm.setProfile_field_MemberStatus(selectMemListlms.get("name") == null ? "" : selectMemListlms.get("name").toString());
		lmsMemApiForm.setProfile_field_MemberType(selectMemListlms.get("codeName") == null ? "" : selectMemListlms.get("codeName").toString());
		lmsMemApiForm.setProfile_field_ManagerName(selectMemListlms.get("c23") == null ? "" : selectMemListlms.get("c23").toString());
		lmsMemApiForm.setProfile_field_ManagerID(selectMemListlms.get("c22") == null ? "" : selectMemListlms.get("c22").toString());
		lmsMemApiForm.setProfile_field_SeniorManagerName(selectMemListlms.get("c18") == null ? "" : selectMemListlms.get("c18").toString());
		lmsMemApiForm.setProfile_field_SeniorManagerID(selectMemListlms.get("c17") == null ? "" : selectMemListlms.get("c17").toString());
		lmsMemApiForm.setProfile_field_GeneralManagerName(selectMemListlms.get("c13") == null ? "" : selectMemListlms.get("c13").toString());
		lmsMemApiForm.setProfile_field_GeneralManagerID(selectMemListlms.get("c12") == null ? "" : selectMemListlms.get("c12").toString());

		// Edited to add Sleeping userstatus. Hui Ding, 2021-10-08
		String status = "NO";
		String userStatus = "";
		if (selectMemListlms.get("name") != null){
    		if(selectMemListlms.get("name").toString().equals("Approved")){
    			status = "YES";
    			if(selectMemListlms.get("c59") != null && selectMemListlms.get("c59").toString().equals("1366")){
    				status = "NO";
    				userStatus = "Sleeping";
    			}
    		} else {
    			status = "NO";
    		}
		}
		lmsMemApiForm.setProfile_field_MemberStatus(status);
		String formattedDate1 = "";
		if(selectMemListlms.get("c30") != null){
			Date date = null;
			try {
				date = new SimpleDateFormat("dd/mm/yyyy").parse(selectMemListlms.get("c30").toString());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			formattedDate1 = new SimpleDateFormat("dd-mm-yyyy").format(date);
		}
		lmsMemApiForm.setProfile_field_dateJoin(formattedDate1);
		lmsMemApiForm.setUserstatus(userStatus);

		//call LMS to insert user
		System.out.println("Start Calling LMS API ...." + selectMemListlms.get("memCode") + "......\n");
		String lmsUrl = LMSApiDomains + LMSApiUrlAdd;

		Gson gson = new Gson();
		String jsonString = gson.toJson(lmsMemApiForm);

		EgovMap reqInfo = new EgovMap();
		reqInfo.put("jsonString", jsonString);
		reqInfo.put("lmsUrl", lmsUrl);
		reqInfo.put("refNo", selectMemListlms.get("nric") == null ? "" : selectMemListlms.get("nric").toString());

		resultValue = lmsReqApi(reqInfo);

		LOGGER.debug("End Calling LMS API ...." + selectMemListlms.get("memCode") + "......\n");

		return resultValue;
	}

	@Override
	public Map<String, Object> lmsMemberListUpdateMemCode(Map<String, Object> params){
		Map<String, Object> resultValue = new HashMap<String, Object>();

		LMSMemApiForm lmsMemApiForm = new LMSMemApiForm();

		lmsMemApiForm.setSecretkey(LMSApiSecretkey);
		lmsMemApiForm.setUsername(params.get("username").toString());
		lmsMemApiForm.setNewusername(params.get("newusername").toString());
		lmsMemApiForm.setProfile_field_MemberType(params.get("memberType").toString());
		lmsMemApiForm.setProfile_field_dateJoin(params.get("joinDt").toString());

		//call LMS to update member code
		String lmsUrl = LMSApiDomains + LMSApiUrlUpdateUsername;

		Gson gson = new Gson();
		String jsonString = gson.toJson(lmsMemApiForm);

		EgovMap reqInfo = new EgovMap();
		reqInfo.put("jsonString", jsonString);
		reqInfo.put("lmsUrl", lmsUrl);
		reqInfo.put("refNo", params.get("username").toString());

		resultValue = lmsReqApi(reqInfo);

		return resultValue;
	}

	@Override
	public Map<String, Object> lmsMemberListDeact(Map<String, Object> params) {
		Map<String, Object> resultValue = new HashMap<String, Object>();

		LMSMemApiForm lmsMemApiForm = new LMSMemApiForm();

		lmsMemApiForm.setSecretkey(LMSApiSecretkey);
		lmsMemApiForm.setUsername(params.get("username").toString());
		lmsMemApiForm.setEmail(params.get("email").toString());
		lmsMemApiForm.setUserstatus("");

		//call LMS to deactivate member
		String lmsUrl = LMSApiDomains + LMSApiUrlSuspend;

		Gson gson = new Gson();
		String jsonString = gson.toJson(lmsMemApiForm);

		EgovMap reqInfo = new EgovMap();
		reqInfo.put("jsonString", jsonString);
		reqInfo.put("lmsUrl", lmsUrl);
		reqInfo.put("refNo", params.get("username").toString());

		resultValue = lmsReqApi(reqInfo);

		return resultValue;
	}

	@Override
	public Map<String, Object> lmsMemberListRestore(Map<String, Object> params) {
		Map<String, Object> resultValue = new HashMap<String, Object>();

		LMSMemApiForm lmsMemApiForm = new LMSMemApiForm();

		lmsMemApiForm.setSecretkey(LMSApiSecretkey);
		lmsMemApiForm.setUsername(params.get("username").toString());
		lmsMemApiForm.setEmail(params.get("email").toString());
		lmsMemApiForm.setUserstatus("");

		//call LMS to restore member
		String lmsUrl = LMSApiDomains + LMSApiUrlRestore;

		Gson gson = new Gson();
		String jsonString = gson.toJson(lmsMemApiForm);

		EgovMap reqInfo = new EgovMap();
		reqInfo.put("jsonString", jsonString);
		reqInfo.put("lmsUrl", lmsUrl);
		reqInfo.put("refNo", params.get("username").toString());

		resultValue = lmsReqApi(reqInfo);

		return resultValue;
	}

	@Override
	public Map<String, Object> lmsReqApi(Map<String, Object> params) {
		Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue.put("status", AppConstants.FAIL);
		resultValue.put("message", "LMS Failed: Please contact Administrator.");

		String respTm = null;
		String lmsApiUserId = "3";
		String auth = LMSApiUser + ":" + LMSApiPassword;
		/*byte[] encodedAuth = 	Base64.encodeBase64(auth.getBytes(StandardCharsets.UTF_8));
		String authorization = "Basic " + new String(encodedAuth);*/

		StopWatch stopWatch = new StopWatch();
	    stopWatch.reset();
	    stopWatch.start();

		String lmsUrl = params.get("lmsUrl").toString();
		String jsonString = params.get("jsonString").toString();
		String refNo = params.get("refNo").toString();
		String output1 = "";
		LMSApiRespForm p = new LMSApiRespForm();
		try{
			URL url = new URL(lmsUrl);

			//insert to api0004m
			//
			LOGGER.error("Start Calling LMS API ...." + lmsUrl + "......\n");
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setDoOutput(true);
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/json");
	        //conn.setRequestProperty("Authorization", authorization);
	        OutputStream os = conn.getOutputStream();
	        os.write(jsonString.getBytes());
	        os.flush();

	        LOGGER.error("Start Calling LMS API return......\n");
	        LOGGER.error("Start Calling LMS API return" + conn.getResponseMessage() + "......\n");

			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
		                (conn.getInputStream())));
				conn.getResponseMessage();

		        String output = "";
		        LOGGER.debug("Output from Server .... \n");
		        while ((output = br.readLine()) != null) {
		        	output1 = output;
		        	LOGGER.debug(output);
		        }

		        Gson g = new Gson();
		        p = g.fromJson(output1, LMSApiRespForm.class);
		        String msg = p.getMessage() != null ? "LMS: " + p.getMessage().toString() : "";
		        if(p.getStatus() ==null || p.getStatus().isEmpty()){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		        	resultValue.put("status", AppConstants.FAIL);
					resultValue.put("message", msg);
		        }else if(p.getStatus().equals("true")){
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS));
		        	resultValue.put("status", AppConstants.SUCCESS);
					resultValue.put("message", msg);
		        }else{
		        	resultValue.put("status", AppConstants.FAIL);
					resultValue.put("message", msg);
		        	p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
		        }
				conn.disconnect();

				br.close();
			}else{
				resultValue.put("status", AppConstants.FAIL);
				resultValue.put("message", "No Response");
				p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_INVALID));
				p.setMessage("No Response");
			}
		}catch(Exception e){
			LOGGER.error("Timeout:");
			LOGGER.error("[lmsMemberListInsertUpdate] - Caught Exception: " + e);
			resultValue.put("status", AppConstants.RESPONSE_CODE_TIMEOUT);
			p.setCode(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
			p.setStatus(String.valueOf(AppConstants.RESPONSE_CODE_TIMEOUT));
			p.setMessage("Timeout " + e.toString());
		}finally{
			stopWatch.stop();
		    respTm = stopWatch.toString();
			commonApiService.rtnRespMsg(lmsUrl, p.getCode().toString(), p.getMessage().toString(),respTm , jsonString, output1 ,lmsApiUserId, refNo);
		}

		return resultValue;
	}
}
