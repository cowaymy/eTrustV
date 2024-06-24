package com.coway.trust.web.supplement;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.jettison.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.biz.sales.pos.vo.PosLoyaltyRewardVO;
import com.coway.trust.biz.sales.rcms.vo.uploadAssignAgentDataVO;
import com.coway.trust.biz.sales.rcms.vo.uploadAssignConvertVO;
import com.coway.trust.biz.supplement.SupplementTagManagementService;
import com.coway.trust.biz.supplement.SupplementUpdateService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/supplement")
public class SupplementTagManagementController {

  private static final Logger LOGGER = LoggerFactory.getLogger(SupplementTagManagementController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private CsvReadComponent csvReadComponent;

  @Resource(name = "posService")
  private PosService posService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Resource(name = "supplementUpdateService")
  private SupplementUpdateService supplementUpdateService;

  @Resource(name = "supplementTagManagementService")
  private SupplementTagManagementService supplementTagManagementService;

  @RequestMapping(value = "/supplementTagManagementList.do")
  public String selectSupplementTagManagementList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

	List<EgovMap> tagStus = supplementTagManagementService.selectTagStus();
	List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
	List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();
	//List<EgovMap> supDelStus = supplementUpdateService.selectSupDelStus();
	//List<EgovMap> submBrch = supplementUpdateService.selectSubmBrch();

	 LOGGER.debug("===========================supplementTagManagementList.do=====================================");
	 LOGGER.debug(" SelectTagStus : {}", tagStus);
	 LOGGER.debug(" MainTopic : {}", mainTopic);
	 LOGGER.debug(" InchgDept : {}", inchgDept);
	 LOGGER.debug("===========================supplementTagManagementList.do=====================================");

	 model.addAttribute("tagStus", tagStus);
	 model.addAttribute("mainTopic", mainTopic);
	 model.addAttribute("inchgDept", inchgDept);

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){

        EgovMap result =  salesCommonService.getUserInfo(params);

        //model.put("orgCode", result.get("orgCode"));
        //model.put("grpCode", result.get("grpCode"));
        //model.put("deptCode", result.get("deptCode"));
        //model.put("memCode", result.get("memCode"));
      }

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "supplement/supplementTagManagementList";
  }

/*  @RequestMapping(value = "/getMainTopicList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getMainTopicList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
	  LOGGER.debug("===========================/getMainTopicList.do===============================");
	  LOGGER.debug("== params " + params.toString());
	  LOGGER.debug("===========================/getMainTopicList.do===============================");

    List<EgovMap> getErrDetilList = supplementTagManagementService.getMainTopicList(params);
    return ResponseEntity.ok(getErrDetilList);
  }*/

  @RequestMapping(value = "/selectTagManagementList")
  public ResponseEntity<List<EgovMap>> selectSupplementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request) throws Exception {

    List<EgovMap> listMap = null;


    LOGGER.info("############################ selectTagManagementList  params.toString :    " + params.toString());

/*    String[] delStatArray = request.getParameterValues("supDelStus");
    String[] supRefStgArray = request.getParameterValues("supRefStg");
    String[] supSubmBrArray = request.getParameterValues("_brnchId");
    String[] supSubmRefStatArray = request.getParameterValues("supRefStus");

    params.put("delStatArray", delStatArray);
    params.put("supRefStgArray", supRefStgArray);
    params.put("supSubmBrArray", supSubmBrArray);
    params.put("supSubmRefStatArray", supSubmRefStatArray);*/

    //model.addAttribute("tagStus", tagStus);

    listMap = supplementTagManagementService.selectTagManagementList(params);

    return ResponseEntity.ok(listMap);

  }

  @RequestMapping(value = "/getSubTopicList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubTopicList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
	  LOGGER.debug("===========================/getSubTopicList.do===============================");
	  LOGGER.debug("== params heres" + params.toString());

    List<EgovMap> getSubTopicList = supplementTagManagementService.getSubTopicList(params);

    LOGGER.debug("== getSubTopicList : {}" + getSubTopicList);
    LOGGER.debug("===========================/getSubTopicList.do===============================");
    return ResponseEntity.ok(getSubTopicList);
  }

  @RequestMapping(value = "/getSubDeptList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getSubDeptList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
	  LOGGER.debug("===========================/getSubDeptList.do===============================");
	  LOGGER.debug("== params heres" + params.toString());

    List<EgovMap> getSubDeptList = supplementTagManagementService.getSubDeptList(params);

    LOGGER.debug("== getSubDeptList : {}" + getSubDeptList);
    LOGGER.debug("===========================/getSubDeptList.do===============================");
    return ResponseEntity.ok(getSubDeptList);
  }

  @RequestMapping(value = "/tagMngApprovalPop.do")
  public String supplementTagManagementApproval(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    EgovMap orderInfoMap = null;
    EgovMap tagInfoMap = null;
    List<EgovMap> tagStus = supplementTagManagementService.selectTagStus();
    List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

    LOGGER.debug("!@##############################################################################");
    LOGGER.debug("!@###### supRefId : " + params.get("supRefId"));
    LOGGER.debug(" SelectTagStus : {}", tagStus);
    LOGGER.debug(" InchgDept : {}", inchgDept);
    LOGGER.debug("!@##############################################################################");

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo(params);
    tagInfoMap = supplementTagManagementService.selectOrderBasicInfo(params);

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());
    model.addAttribute("orderInfo", orderInfoMap);
    model.addAttribute("tagInfo", tagInfoMap);
    model.addAttribute("tagStus", tagStus);
    model.addAttribute("inchgDept", inchgDept);

   // return "supplement/supplementTrackNoPop";
    return "supplement/supplementTagManagementApproval";
  }

  @RequestMapping(value = "/newTagRequestPop.do")
  public String newTagRequestPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

	List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
	List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

	 LOGGER.debug("===========================newTagRequestPop.do=====================================");
	 LOGGER.debug(" MainTopic : {}", mainTopic);
	 LOGGER.debug(" InchgDept : {}", inchgDept);
	 LOGGER.debug("===========================newTagRequestPop.do=====================================");

	 model.addAttribute("mainTopic", mainTopic);
	 model.addAttribute("inchgDept", inchgDept);
	 model.put("userBr", sessionVO.getUserBranchId());

    params.put("userId", sessionVO.getUserId());


    return "supplement/supplementTagManagementCreation";
  }

  @RequestMapping(value = "/searchOrderNo", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectOrderNo(@RequestParam Map<String, Object> params, ModelMap model) {
	  LOGGER.debug("===========================/searchOrderNo.do===============================");
	  LOGGER.debug("== params " + params.toString());
	  LOGGER.debug("===========================/searchOrderNo.do===============================");

    EgovMap basicInfo = supplementTagManagementService.searchOrderBasicInfo(params);

    model.addAttribute("orderInfo", basicInfo);



    return ResponseEntity.ok(basicInfo);
  }

  @RequestMapping(value = "/supplementViewBasicPop.do")
  public String supplementViewPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

	List<EgovMap> mainTopic = supplementTagManagementService.getMainTopicList();
	List<EgovMap> inchgDept = supplementTagManagementService.getInchgDeptList();

    EgovMap orderInfoMap = null;

    LOGGER.debug("!@##############################################################################");
    LOGGER.debug("!@###### supRefNo : " + params.get("supRefNo"));
	LOGGER.debug(" MainTopic : {}", mainTopic);
	LOGGER.debug(" InchgDept : {}", inchgDept);
    LOGGER.debug("!@##############################################################################");

    orderInfoMap = supplementTagManagementService.selectViewBasicInfo(params);

	model.addAttribute("mainTopic", mainTopic);
	model.addAttribute("inchgDept", inchgDept);

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());
    model.addAttribute("orderInfo", orderInfoMap);

    return "supplement/supplementTagManagementCreation";
  }

/*  @RequestMapping(value = "/getSupplementDetailList")
  public ResponseEntity<List<EgovMap>> getSupplementDetailList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> detailList = null;

    LOGGER.info("################################## detail Grid PARAM : " + params.toString());

    detailList = supplementUpdateService.getSupplementDetailList(params);

    return ResponseEntity.ok(detailList);
  }*/
}
