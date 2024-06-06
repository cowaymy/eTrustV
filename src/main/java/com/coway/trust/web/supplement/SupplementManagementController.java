package com.coway.trust.web.supplement;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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
public class SupplementManagementController {

  private static final Logger LOGGER = LoggerFactory.getLogger(SupplementManagementController.class);

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

  @RequestMapping(value = "/supplementManagementList.do")
  public String selectPosList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

	List<EgovMap> supRefStus = supplementUpdateService.selectSupRefStus();
	List<EgovMap> supRefStg = supplementUpdateService.selectSupRefStg();
	List<EgovMap> submBrch = supplementUpdateService.selectSubmBrch();

	 LOGGER.debug("===========================supplementManagementList.do=====================================");
	 LOGGER.debug(" selectSupRefStus : {}", supRefStus);
	 LOGGER.debug(" selectSupRefStg : {}", supRefStg);
	 LOGGER.debug("===========================supplementManagementList.do=====================================");

	 model.addAttribute("supRefStus", supRefStus);
	 model.addAttribute("supRefStg", supRefStg);

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){

        EgovMap result =  salesCommonService.getUserInfo(params);

        model.put("orgCode", result.get("orgCode"));
        model.put("grpCode", result.get("grpCode"));
        model.put("deptCode", result.get("deptCode"));
        model.put("memCode", result.get("memCode"));
      }

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "supplement/supplementManagement";
  }

  @RequestMapping(value = "/selectWhBrnchList")
  public ResponseEntity<List<EgovMap>> selectWhBrnchList() throws Exception {

    List<EgovMap> codeList = null;

    codeList = supplementUpdateService.selectWhBrnchList();

    return ResponseEntity.ok(codeList);

  }


  @RequestMapping(value = "/selectSupplementList")
  public ResponseEntity<List<EgovMap>> selectSupplementList(@RequestParam Map<String, Object> params,
      HttpServletRequest request) throws Exception {

    List<EgovMap> listMap = null;

    LOGGER.info("############################ selectSupplementList  params.toString :    " + params.toString());

    // params
    String systemArray[] = request.getParameterValues("posTypeId");
    String statusArray[] = request.getParameterValues("posStatusId");

    params.put("systemArray", systemArray);
    params.put("statusArray", statusArray);

    listMap = supplementUpdateService.selectSupplementList(params);

    return ResponseEntity.ok(listMap);

  }

  @RequestMapping(value = "/getSupplementDetailList")
  public ResponseEntity<List<EgovMap>> getSupplementDetailList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> detailList = null;

    LOGGER.info("################################## detail Grid PARAM : " + params.toString());

    detailList = supplementUpdateService.getSupplementDetailList(params);

    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/supplementTrackNoPop.do")
  public String supplementTrackNoPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    EgovMap orderInfoMap = null;

    LOGGER.debug("!@##############################################################################");
    LOGGER.debug("!@###### supRefId : " + params.get("supRefId"));
    LOGGER.debug("!@##############################################################################");

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo(params);

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());
    model.addAttribute("orderInfo", orderInfoMap);

    return "supplement/supplementTrackNoPop";
  }

  @RequestMapping(value = "/supplementViewPop.do")
  public String supplementViewPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    EgovMap orderInfoMap = null;

    LOGGER.debug("!@##############################################################################");
    LOGGER.debug("!@###### supRefId : " + params.get("supRefId"));
    LOGGER.debug("!@##############################################################################");

    orderInfoMap = supplementUpdateService.selectOrderBasicInfo(params);

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());
    model.addAttribute("orderInfo", orderInfoMap);

    return "supplement/supplementViewPop";
  }

  @RequestMapping(value = "/orderLedgerViewPop.do")
  public String orderLedgerViewPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());

    return "supplement/orderLedgerPop";
  }

  @RequestMapping(value = "/checkDuplicatedTrackNo", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> checkDuplicatedTrackNo (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{

	List<EgovMap> itemList = null;
	Map<String, Object> transactionId = null;


	LOGGER.debug("!@###### parcelTrackNo : " + params.get("parcelTrackNo"));
	LOGGER.debug("!@###### supRefId : " + params.get("supRefId"));
	LOGGER.debug("!@###### supRefStg : " + params.get("supRefStg"));
	LOGGER.debug("!@###### inputParcelTrackNo : " + params.get("inputParcelTrackNo"));


	itemList = supplementUpdateService.checkDuplicatedTrackNo(params);


	//transactionId.put("supRefId", (params.get("supRefId")));

	//supplementUpdateService.updateRefStgStatus(transactionId);

	return ResponseEntity.ok(itemList);

}

/*  @RequestMapping(value = "/updateRefStgStatus", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> updateRefStgStatus (@RequestParam Map<String, Object> params,  HttpServletRequest request, ModelMap model) throws Exception{

	List<EgovMap> itemList = null;
	Map<String, Object> transactionId = null;

	LOGGER.debug("!@###### parcelTrackNo : " + params.get("parcelTrackNo"));
	LOGGER.debug("!@###### supRefId : " + params.get("supRefId"));
	LOGGER.debug("!@###### supRefStg : " + params.get("supRefStg"));
	LOGGER.debug("!@###### inputParcelTrackNo : " + params.get("inputParcelTrackNo"));

	transactionId.put("supRefId", (params.get("supRefId")));
	supplementUpdateService.updateRefStgStatus(transactionId);

	return ResponseEntity.ok(itemList);

}*/

  @Transactional
  @RequestMapping(value = "/updateRefStgStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateRefStgStatus(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
	  	ReturnMessage message = new ReturnMessage();
	  	String msg = "";
		params.put("userId", sessionVO.getUserId());

		try {

		LOGGER.info("############################ updateRefStgStatus - params: {}", params);

		//int result = supplementUpdateService.updateRefStgStatus(params);
		Map<String, Object> returnMap = supplementUpdateService.updateRefStgStatus(params);

		 if ("000".equals(returnMap.get("logError"))) {
		        msg += "Parcel tracking number update successfully.";
		        message.setCode(AppConstants.SUCCESS);
		      } else {
		        msg += "Parcel tracking number failed to update. <br />";
		        msg += "Errorlogs : " + returnMap.get("message") + "<br />";
		        message.setCode(AppConstants.FAIL);
		      }
		      message.setMessage(msg);
		      LOGGER.debug(" params returnMap result =======>"+returnMap);

		} catch (Exception e) {
		      LOGGER.error("Error during update Parcel Tracking Number.", e);
		      msg += "An unexpected error occurred.<br />";
		      message.setCode(AppConstants.FAIL);
		      message.setMessage(msg);
		    }

	    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectPosJsonList")
  public ResponseEntity<List<EgovMap>> selectPosJsonList(@RequestParam Map<String, Object> params,
      HttpServletRequest request) throws Exception {

    List<EgovMap> listMap = null;

    // params
    String systemArray[] = request.getParameterValues("posTypeId");
    String statusArray[] = request.getParameterValues("posStatusId");

    params.put("systemArray", systemArray);
    params.put("statusArray", statusArray);

    listMap = posService.selectPosJsonList(params);

    return ResponseEntity.ok(listMap);

  }

}
