package com.coway.trust.biz.api.impl;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
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

import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.LMSApiService;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
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
import com.coway.trust.util.CommonUtils;
import com.google.common.collect.Maps;
import com.google.gson.Gson;
import com.coway.trust.AppConstants;
import com.coway.trust.api.project.LMS.LMSApiDto;
import com.coway.trust.api.project.LMS.LMSApiForm;
import com.coway.trust.api.project.LMS.LMSAttendApiForm;
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

  @Override
  public EgovMap insertCourse(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0", sysUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

//    LMSApiForm model = Gson.fromJson(jsonString, LMSApiForm.class);
//    JSONObject lmsApiObj = commonApiService.decodeJson(request,lmsApiForm);

    String data = commonApiService.decodeJson(request);
    Gson g = new Gson();
	LMSApiForm p = g.fromJson(data, LMSApiForm.class);



    EgovMap access = new EgovMap();
//    Map<String, Object> reqPrm = Maps.filterValues(LMSApiForm.createCourseMap(lmsApiObj),Objects::nonNull);
    Map<String, Object> reqPrm = new HashMap<>();
    String key = request.getHeader("key");
    reqPrm.put("key", key);
//    EgovMap custInfo = new EgovMap();

//    JSONArray companyList = (JSONArray) lmsApiObj.get("courseCode");
//    Iterator<JSONObject> iterator = companyList.iterator();
//	while (iterator.hasNext()) {
//		System.out.println(iterator.next());
//	}


    try{

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

        int created = 0;

        //course info
        Map<String, Object> courseInfo = new HashMap<String, Object>();
        int coursId = trainingService.selectNextCoursId();

        courseInfo.put("coursId", coursId);
        courseInfo.put("coursName", p.getCourseTitle());
        courseInfo.put("codeId", p.getCourseType());
        courseInfo.put("coursCode", p.getCourseCode());
        courseInfo.put("coursLoc", p.getCourseLocation());
        courseInfo.put("coursStart", p.getCourseStartDt());
        courseInfo.put("coursEnd", p.getCourseEndDt());
        courseInfo.put("coursLimit", p.getCourseLimit());
        courseInfo.put("courseClsDt", p.getCourseCloseDt());
        courseInfo.put("userId", reqPrm.get("sysUserId").toString());

        String isMem = "";
        if(("Y").equals(p.getIsMember())){
        	isMem= "2318";
        }
        else if(("N").equals(p.getIsMember())){
        	isMem= "2319";
        }
        courseInfo.put("generalCode", isMem);
        courseInfo.put("memType", p.getMemberType());
//        courseInfo.put("coursName", reqPrm.get("courseTitle").toString());
//        courseInfo.put("codeId", reqPrm.get("courseType").toString());
//        courseInfo.put("coursCode", reqPrm.get("courseCode").toString());
//        courseInfo.put("coursLoc", reqPrm.get("courseLocation").toString());
//        courseInfo.put("coursStart", reqPrm.get("courseStartDt").toString());
//        courseInfo.put("coursEnd", reqPrm.get("courseEndDt").toString());
//        courseInfo.put("coursLimit", reqPrm.get("courseLimit").toString());
//        courseInfo.put("courseClsDt", reqPrm.get("courseCloseDt").toString());
//        courseInfo.put("userId", reqPrm.get("sysUserId").toString());
//
//        courseInfo.put("generalCode", reqPrm.get("IsMember").toString());
//        courseInfo.put("memType", reqPrm.get("memberType").toString());
        courseInfo.put("attendance", "2315");//EDU team

        trainingMapper.insertCourse(courseInfo);

        created = 1;


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

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, null ,apiUserId); //need to change the method or respPrm?
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

        int created = 0;

        //course info
        Map<String, Object> courseInfo = new HashMap<String, Object>();
        int coursId = trainingService.selectNextCoursId();

        courseInfo.put("coursId", coursId);
        courseInfo.put("coursName", p.getCourseTitle());
        courseInfo.put("codeId", p.getCourseType());
        courseInfo.put("coursCode", p.getCourseCode());
        courseInfo.put("coursLoc", p.getCourseLocation());
        courseInfo.put("coursStart", p.getCourseStartDt());
        courseInfo.put("coursEnd", p.getCourseEndDt());
        courseInfo.put("coursLimit", p.getCourseLimit());
        courseInfo.put("courseClsDt", p.getCourseCloseDt());
        courseInfo.put("userId", reqPrm.get("sysUserId").toString());

        String isMem = "";
        if(("Y").equals(p.getIsMember())){
        	isMem= "2318";
        }
        else if(("N").equals(p.getIsMember())){
        	isMem= "2319";
        }
        courseInfo.put("generalCode", isMem);
        courseInfo.put("memType", p.getMemberType());
        courseInfo.put("attendance", 2315);//EDU team

        trainingMapper.updateCourse(courseInfo);

        created = 1;


        if(created > 0){
        	code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
            message = AppConstants.RESPONSE_DESC_SUCCESS;
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

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, null,apiUserId);
  }

  @Override
  public EgovMap updateCourseAttend(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception {

    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    System.out.println(">>>>>>>>>decode");
    String data = commonApiService.decodeJson(request);
    Gson g = new Gson();
    System.out.println(">>>>>>>>>start json");
	LMSApiForm p = g.fromJson(data, LMSAttendApiForm.class);
	System.out.println(">>>>>>>>>end json");

    EgovMap access = new EgovMap();
    Map<String, Object> reqPrm = new HashMap<>();
    String key = request.getHeader("key");
    reqPrm.put("key", key);

    EgovMap data1 = new EgovMap(), params = new EgovMap(), access1 = new EgovMap();
//    Map<String, Object> reqPrm = Maps.filterValues(LMSApiForm.createCourseAttendMap(lmsApiForm),Objects::nonNull);
    params.put("cardDiffNRIC", "F");

    try{

      access = commonApiMapper.checkAccess(reqPrm);

      if(access != null) apiUserId = access.get("apiUserId").toString();

      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
//      else if(CommonUtils.isEmpty(lmsApiForm.getNric())){
//        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
//        message = "NRIC not found.";
//      }
//      else if(CommonUtils.isEmpty(lmsApiForm.getCardTokenId())){
//        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
//        message = "Card Token Id not found.";
//      }
//      else {
//        data = lmsApiMapper.cardDiffNRIC(reqPrm);
//
//        if(data != null){
//          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
//          message = AppConstants.RESPONSE_DESC_SUCCESS;
//
//          if(!(data.get("custCrcToken") == null) && data.get("nric") == null )
//            params.put("cardDiffNRIC", "Y");
//          else{
//            params.put("cardDiffNRIC", "N");
//          }
//        }else{
//          code = String.valueOf(AppConstants.RESPONSE_CODE_SUCCESS);
//          message = String.valueOf(AppConstants.RESPONSE_DESC_SUCCESS);
//          params.put("cardDiffNRIC", "N");
//        }
//
//      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, params ,apiUserId);
  }

  @Override
  public EgovMap updateAttendResult(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception {
    String respTm = null, code = AppConstants.FAIL, message = AppConstants.RESPONSE_DESC_INVALID, apiUserId = "0";

    StopWatch stopWatch = new StopWatch();
    stopWatch.reset();
    stopWatch.start();

    EgovMap access = new EgovMap(), params = new EgovMap();
    int created = 0;
//    Map<String, Object> reqPrm = Maps.filterValues(LMSApiForm.createAttendResultMap(lmsApiForm),Objects::nonNull);
    Map<String, Object> reqPrm = new HashMap<>();

    try{

      access = commonApiMapper.checkAccess(reqPrm);
      if(access == null){
        code = String.valueOf(AppConstants.RESPONSE_CODE_UNAUTHORIZED);
        message = AppConstants.RESPONSE_DESC_UNAUTHORIZED;
      }
//      else if(CommonUtils.isEmpty(lmsApiForm.getState())){
//        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
//        message = "State not found.";
//      }else if(CommonUtils.isEmpty(lmsApiForm.getPostcode())){
//        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
//        message = "Postcode not found.";
//      }else if(CommonUtils.isEmpty(lmsApiForm.getArea())){
//        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
//        message = "Area not found.";
//      }else if(CommonUtils.isEmpty(lmsApiForm.getCity())){
//        code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
//        message = "City not found.";
//      }
//      else {
//        apiUserId = access.get("apiUserId").toString();
//        created = lmsApiMapper.insertNewAddr(reqPrm);
//
//        params.put("areaId", reqPrm.get("areaId").toString());
//
//        if(created > 0){
//          code = String.valueOf(AppConstants.RESPONSE_CODE_CREATED);
//          message = AppConstants.RESPONSE_DESC_CREATED;
//        }else{
//          code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
//          message = "Failed to insert address";
//        }
//      }

    }catch(Exception e){
      code = String.valueOf(AppConstants.RESPONSE_CODE_INVALID);
      message = StringUtils.substring(e.getMessage(), 0, 4000);
    } finally{
      stopWatch.stop();
      respTm = stopWatch.toString();
    }

    return commonApiService.rtnRespMsg(request, code, message, respTm, reqPrm, params ,apiUserId);
  }

}
