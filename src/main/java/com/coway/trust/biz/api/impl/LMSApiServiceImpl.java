package com.coway.trust.biz.api.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

/**************************************
 * Author                  Date                    Remark
 * Tang Hui Ling        2021/08/19           API for LMS
 ***************************************/

import java.util.Map;
import java.util.Objects;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.LMSApiService;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.organization.memberApi.impl.MemberApiMapper;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
import com.coway.trust.biz.organization.organization.impl.MemberListServiceImpl;
import com.coway.trust.biz.organization.training.TrainingService;
import com.coway.trust.biz.organization.training.impl.TrainingMapper;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.vo.AccClaimAdtVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.EStatementReqVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.RentalSchemeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.services.as.ASManagementListController;
import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.coway.trust.AppConstants;
import com.coway.trust.api.project.LMS.AttendForm;
import com.coway.trust.api.project.LMS.LMSApiDto;
import com.coway.trust.api.project.LMS.LMSApiForm;
import com.coway.trust.api.project.LMS.LMSAttendApiForm;
import com.coway.trust.api.project.LMS.LMSResultApiForm;
import com.coway.trust.api.project.common.CommonApiController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("LMSApiService")
public class LMSApiServiceImpl extends EgovAbstractServiceImpl implements LMSApiService {

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

  @Autowired
  private AdaptorService adaptorService;

//  @Resource(name = "memberListServiceImpl")
//	private MemberListServiceImpl memberListServiceImpl;

  @Override
  public EgovMap insertCourse(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

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
        String codeId = p.getCourseType().toString();
        String coursCode = p.getCourseCode().toString();
        String coursLoc = p.getCourseLocation().toString();
        String coursStart = p.getCourseStartDt().toString();
        String coursEnd = p.getCourseEndDt().toString();
        String coursLimit = String.valueOf(p.getCourseLimit());
        String courseClsDt = p.getCourseCloseDt().toString();
        String memType = String.valueOf(p.getMemberType());

        if (!StringUtils.isBlank(courseTitle) ){
        	Map<String, Object> selectCourseId = new HashMap<String, Object>();
            selectCourseId.put("coursCode", p.getCourseCode());
            int isExist = lmsApiMapper.cntCourseCheck(selectCourseId);

        	if(isExist > 0){
        		code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
  	          	message = AppConstants.RESPONSE_DESC_DUP;
        	}
        	else{
        		if ( !StringUtils.isBlank(codeId) || !StringUtils.isBlank(coursCode) || !StringUtils.isBlank(coursLoc) || !StringUtils.isBlank(coursStart)
                		|| !StringUtils.isBlank(coursEnd) || !StringUtils.isBlank(coursLimit) || !StringUtils.isBlank(courseClsDt) || !StringUtils.isBlank(memType)){
                	//course info
                    Map<String, Object> courseInfo = new HashMap<String, Object>();
                    int coursId = trainingService.selectNextCoursId();

                    courseInfo.put("coursId", coursId);
                    courseInfo.put("coursName", courseTitle);
                    courseInfo.put("codeId", codeId);
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
                }

        		if(created > 0){
    	          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
    	          message = AppConstants.RESPONSE_DESC_CREATED;
    	        }else{
    	          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
    	          message = AppConstants.RESPONSE_DESC_INVALID;
    	        }
        	}
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
        selectCourseId.put("coursCode", p.getCourseCode());

        //validation
        String coursCode = p.getCourseCode().toString();
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

          for(int course = 0; course <p.getCourseCode().size(); course++){
        	  String coursCode = p.getCourseCode().get(course).getId();
        	  Map<String, Object> courseInfo = new HashMap<String, Object>();
        	  courseInfo.put("coursCode", coursCode);
        	  EgovMap codeId = lmsApiMapper.selectCourseId(courseInfo);
        	  for(int attend = 0; attend <p.getCourseCode().get(course).getAttendence().size(); attend++){
        		  String username = p.getCourseCode().get(course).getAttendence().get(attend).getUsername();
        		  Map<String, Object> userInfo = new HashMap<String, Object>();
        		  userInfo.put("memCode", username);

        		  EgovMap userId = new EgovMap();
        		  userId = lmsApiMapper.selectMemId(userInfo);

        		  String shirtSize = p.getCourseCode().get(course).getAttendence().get(attend).getShirtSize();
            	  //Attendee List
                  Map<String, Object> attendeeInfo = new HashMap<String, Object>();
                  attendeeInfo.put("coursId", codeId.get("coursId"));
                  attendeeInfo.put("coursMemId", userId.get("memId"));
                  attendeeInfo.put("userId", reqPrm.get("sysUserId").toString());
                  attendeeInfo.put("coursDMemName", userId.get("fullName"));
                  attendeeInfo.put("coursDMemNric", userId.get("nric"));
                  attendeeInfo.put("coursMemShirtSize", shirtSize);
                  lmsApiMapper.registerCourse(attendeeInfo);
        	  }
          }
          created = 1;
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

    return commonApiService.rtnRespMsg(request, code, message, respTm, data, null ,apiUserId);
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

	          for(int user = 0; user <p.getUserResult().size(); user++){
	        	  String coursCode = p.getUserResult().get(user).getCourseCode();
	        	  Map<String, Object> courseInfo = new HashMap<String, Object>();
	        	  courseInfo.put("coursCode", coursCode);
	        	  EgovMap codeId = lmsApiMapper.selectCourseId(courseInfo);

	        	  String username = p.getUserResult().get(user).getUsername();
        		  Map<String, Object> userInfo = new HashMap<String, Object>();
        		  userInfo.put("memCode", username);

        		  EgovMap userId = new EgovMap();
        		  userId = lmsApiMapper.selectMemId(userInfo);

            	  //Attendee List
                  Map<String, Object> attendeeInfo = new HashMap<String, Object>();
                  attendeeInfo.put("coursId", codeId.get("coursId"));
                  attendeeInfo.put("coursMemId", userId.get("memId"));
                  attendeeInfo.put("userId", reqPrm.get("sysUserId").toString());
                  attendeeInfo.put("coursTestResult", p.getUserResult().get(user).getTrainingResult());
                  if(!p.getUserResult().get(user).getCdpPoint().isEmpty()){
                	  attendeeInfo.put("coursCdpPoint", p.getUserResult().get(user).getCdpPoint());
                  }
                  if(!p.getUserResult().get(user).getAttendDay().isEmpty()){
                	  attendeeInfo.put("coursAttendDay", p.getUserResult().get(user).getAttendDay());
                  }
                  lmsApiMapper.updateAttendee(attendeeInfo);

                  //when HP, call to trigger open sales
                  if(userId.get("memType").toString().equals("1")){
                	  MemberListServiceImpl memberListServiceImpl = new MemberListServiceImpl();
                      SessionVO sessionVo = new SessionVO();
                      Map<String, Object> params = new HashMap<>();

                      params.put("MemberID", userId.get("memId"));
                      params.put("memberId", userId.get("memId"));
                      params.put("memberCode", userId.get("memCode"));
                      params.put("memberType", userId.get("memType"));
                      params.put("nric", userId.get("nric"));

                      sessionVo.setUserId(Integer.parseInt(sysUserId));
                      //sessionVo.setUserBranchId(Integer.parseInt(userId.get("collctBrnch").toString()));

                      Map<String, Object> resultValue = new HashMap<String, Object>();
                      resultValue = hpMemUpdatePay(params,sessionVo);

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
}
