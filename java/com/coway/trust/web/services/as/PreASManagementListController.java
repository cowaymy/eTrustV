package com.coway.trust.web.services.as;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.PreASManagementListService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.InHouseRepairService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/as")
public class PreASManagementListController {
  private static final Logger logger = LoggerFactory.getLogger(PreASManagementListController.class);

  @Resource(name = "PreASManagementListService")
  private PreASManagementListService PreASManagementListService;

  @Resource(name = "ASManagementListService")
  private ASManagementListService ASManagementListService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  @Resource(name = "hsManualService")
  private HsManualService hsManualService;

  @Resource(name = "InHouseRepairService")
  private InHouseRepairService inHouseRepairService;

  @Resource(name = "servicesLogisticsPFCService")
  private ServicesLogisticsPFCService servicesLogisticsPFCService;

  @Resource(name = "salesCommonService")
  private SalesCommonService salesCommonService;

  @Autowired
  private AdaptorService adaptorService;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/initPreASManagementList.do")
  public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

    // GET SEARCH DATE RANGE
    String range = ASManagementListService.getSearchDtRange();

    List<EgovMap> asTyp = ASManagementListService.selectAsTyp();
    List<EgovMap> asStat = PreASManagementListService.selectPreAsStat();
    List<EgovMap> asProduct = PreASManagementListService.asProd(params);
    List<EgovMap> branchList = hsManualService.selectBranchList(params);

    model.put("DT_RANGE", CommonUtils.nvl(range));
    model.put("asTyp", asTyp);
    model.put("asStat", asStat);
    model.put("asProduct", asProduct);
    model.put("branchList", branchList);

    return "services/as/preASManagementList";
  }

  @RequestMapping(value = "/searchPreASManagementList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPreASManagementList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    String[] asProductList = request.getParameterValues("asProduct");
    String[] asStatusList = request.getParameterValues("asStatus");
    String[] cmbbranchIdList = request.getParameterValues("cmbbranchId");
    String[] cmbInsBranchIdList = request.getParameterValues("cmbInsBranchId");
    String[] areaList = request.getParameterValues("ordArea");

    params.put("asStatusList", asStatusList);
    params.put("cmbbranchIdList", cmbbranchIdList); //as branch list
    params.put("cmbInsBranchIdList", cmbInsBranchIdList); //ins branch list
    params.put("asProductList", asProductList);
    params.put("areaList", areaList);

    logger.debug("searchPreASManagementList params"+params);

    List<EgovMap> PreASMList = PreASManagementListService.selectPreASManagementList(params);

    return ResponseEntity.ok(PreASMList);
  }

  @RequestMapping(value = "/rejectPreASOrder.do")
	public String rejectPreASOrder(@RequestParam Map<String, Object> params, ModelMap model) {

	  	model.put("salesOrdNo", params.get("preAsSalesOrderNo").toString());
	  	model.put("branchCode",  params.get("preAsBranch").toString());
	  	model.put("creator",  params.get("preAsCreator").toString());
		return "services/as/rejectPreASOrderPop";
	}

  @RequestMapping(value = "/updPreASOrder.do")
	public String updPreASOrder(@RequestParam Map<String, Object> params, ModelMap model) {
	  	if("".equals(params.get("orderNum"))  || params.get("orderNum")==null){
	  		params.put("orderNum", params.get("preAsSalesOrderNo"));
	  	}

	    List<EgovMap> preasStat = PreASManagementListService.selectPreAsUpd();
	    List<EgovMap> preAsList = PreASManagementListService.selectPreASManagementList(params);
	    params.put("prodCat", preAsList.get(0).get("prodCat").toString());
	 	List<EgovMap> errorCodeList = PreASManagementListService.getErrorCodeList(params);

	    model.put("preasStat", preasStat);
	    model.put("errorCodeList", errorCodeList);
	  	model.put("salesOrdNo", preAsList.get(0).get("salesOrderNo").toString());
	  	model.put("branchCode",  preAsList.get(0).get("insBrnchCode").toString());
	  	model.put("creator",   preAsList.get(0).get("creator").toString());
	  	model.put("recallDt",   preAsList.get(0).get("recallDt").toString() == "-" ? null :preAsList.get(0).get("recallDt").toString());
	  	model.put("creator",   preAsList.get(0).get("creator").toString());
	  	model.put("defectCode",   preAsList.get(0).get("defectCode").toString());
	  	model.put("defectDesc",   preAsList.get(0).get("defectDesc").toString());

		return "services/as/updPreASOrderPop";
	}


  @Transactional
  @RequestMapping(value = "/updatePreAsStatus.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePreAsStatus(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());


    int result = PreASManagementListService.updatePreAsStatus(params);

    ReturnMessage message = new ReturnMessage();

    if(result > 0){
    	 message.setCode(AppConstants.SUCCESS);
    	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    }else{
    	message.setCode(AppConstants.FAIL);
   	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/preAsRawDataPop.do")
	public String preAsRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("ind", params.get("ind"));
		return "services/as/preAsRawDataPop";
	}


  @RequestMapping(value = "/getCityList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getCityList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

     List<EgovMap> cityList = PreASManagementListService.getCityList(params);
     return ResponseEntity.ok(cityList);
  }

  @RequestMapping(value = "/getAreaList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getAreaList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	String searchcity = (String) params.get("cityCode");
	String[] searchcityvalue = searchcity.split("∈");
	logger.debug("cityCode"+searchcityvalue);
	params.put("cityList", searchcityvalue);

	 List<EgovMap> areaList = PreASManagementListService.getAreaList(params);
     return ResponseEntity.ok(areaList);
  }


  @RequestMapping(value = "/initPreAsSubmissionList.do")
	public String initPreAsSubmissionList(@RequestParam Map<String, Object> params, ModelMap model) {

	  	SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
			logger.info("memType ##### " + getUserInfo.get("memType"));
		}


    	List<EgovMap> asStat = PreASManagementListService.selectPreAsStat();
    	params.put("errorType", "HA");
    	List<EgovMap> haErrorCodeList = PreASManagementListService.getErrorCodeList(params);
    	model.put("asStat", asStat);
    	model.put("haErrorCodeList", haErrorCodeList);
		return "services/as/preAsSubmissionList";
	}

  @RequestMapping(value = "/preAsSubmissionRegister.do")
	public String preAsSubmissionRegister(@RequestParam Map<String, Object> params, ModelMap model) {
		return "services/as/preAsSubmissionRegister";
	}

  @RequestMapping(value = "/checkOrder.do")
  public ResponseEntity<ReturnMessage> checkOrder(@RequestParam Map<String, Object> params, SessionVO sessionVO) throws Exception{

	    ReturnMessage message = new ReturnMessage();

	    String orderType = params.get("orderType").toString();

	    int flag=0;

		params.put("memLvl", sessionVO.getMemberLevel());
		params.put("memId", sessionVO.getMemId());
		params.put("memType", sessionVO.getUserTypeId());

		EgovMap checkOrder = PreASManagementListService.checkOrder(params);
		EgovMap checkSubmissionRecords = PreASManagementListService.checkSubmissionRecords(params);
		EgovMap checkOutstanding = PreASManagementListService.selectOrderInfo(params);

		if(checkOrder == null){
			params.put("prodCat", "0");
		}
		else{
			params.put("prodCat", checkOrder.get("prodCat").toString() ==null ? "0":checkOrder.get("prodCat").toString());
		}

		message.setData(params);

		if(checkOrder == null){
			flag=1;
			message.setCode(AppConstants.FAIL);
			message.setMessage("This Order Number is not belong to you. Please key in your own sales order number.");
			return ResponseEntity.ok(message);
		}

		if(checkOrder != null){

			if(Integer.parseInt(checkOrder.get("stusCodeId").toString()) !=4){
				flag=1;
				message.setCode(AppConstants.FAIL);
				message.setMessage("Thos order is not under Completed status therefore it not allowed to register. Please key in others sales order number.");
				return ResponseEntity.ok(message);
			}

			if(orderType=="HA" && (checkOrder.get("stkCtgryId").toString() == "5706" || checkOrder.get("stkCtgryId").toString() == "5707")){
				flag=1;
				message.setCode(AppConstants.FAIL);
				message.setMessage("This Order Number is under Home Appliance. Please proceed to HA Module for this action");
				return ResponseEntity.ok(message);
			}

			if(orderType=="HC" && (checkOrder.get("stkCtgryId").toString() != "5706" || checkOrder.get("stkCtgryId").toString() != "5707")){
				flag=1;
				message.setCode(AppConstants.FAIL);
				message.setMessage("This Order Number is under Homecare. Please proceed to HC Module for this action");
				return ResponseEntity.ok(message);
			}
		}


		if(checkSubmissionRecords != null){
			flag=1;
			message.setCode(AppConstants.FAIL);
			message.setMessage("This Order Number has been submitted. It is not allowed to register again.");
			return ResponseEntity.ok(message);
		}

		if(checkOutstanding !=null){

			if(Integer.parseInt(checkOutstanding.get("membershipExpiry").toString()) == 1){
				flag=1;
				message.setCode(AppConstants.FAIL);
		   	    message.setMessage("Membership is expired. It is not allowed to register.");
		   		return ResponseEntity.ok(message);
			}

			if(Integer.parseInt(checkOutstanding.get("outstanding").toString()) > 3){
				flag=1;
				message.setCode(AppConstants.FAIL);
		   	    message.setMessage("This order consist of outstanding payment. Please check with Finance Dept before proceed to register.");
		   	    return ResponseEntity.ok(message);
			}
		}


		if(flag==0){
			message.setCode(AppConstants.SUCCESS);
	    	message.setMessage("This Order Number is allow to be registered. Please proceed to choose Error Code for register.");
	    	return ResponseEntity.ok(message);
		}

		return ResponseEntity.ok(message);

	}


  @RequestMapping(value = "/getErrorCodeList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getErrorCodeList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
	  logger.info("getErrorCodeList" + params);
	 params.put("prodCat",params.get("groupCode[prodCat]"));
     List<EgovMap> errorCodeList = PreASManagementListService.getErrorCodeList(params);
     return ResponseEntity.ok(errorCodeList);
  }

  @Transactional
  @RequestMapping(value = "/submitPreAsSubmission.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> submitPreAsSubmission(@RequestBody Map<String, Object> params) throws Exception {

	  try{
		    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		    params.put("userId", sessionVO.getUserId());
		    params.put("userDeptId", sessionVO.getUserDeptId());
		    params.put("regId", sessionVO.getUserName());

		    int result = PreASManagementListService.submitPreAsSubmission(params);

		    ReturnMessage message = new ReturnMessage();

		    if(result > 0){
		    	 message.setCode(AppConstants.SUCCESS);
		    	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		    }else{
		    	message.setCode(AppConstants.FAIL);
		   	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		    }

		    return ResponseEntity.ok(message);
	  }
	  catch(Exception e){
		  	throw e;
	  }
  }


  @RequestMapping(value = "/searchPreAsSubmissionList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> searchPreAsSubmissionList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    String[] statusList = request.getParameterValues("preAsSubmissionStatus");
    String[] errorCodeList = request.getParameterValues("preAsErrorCode");

    params.put("statusList", statusList);
    params.put("errorCodeList", errorCodeList);

    List<EgovMap> preAsSubmissionList = PreASManagementListService.searchPreAsSubmissionList(params);

    return ResponseEntity.ok(preAsSubmissionList);
  }

  @RequestMapping(value = "/searchBranchList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> searchBranchList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	 params.put("orderType",params.get("groupCode"));

	 List<EgovMap> branchList = PreASManagementListService.searchBranchList(params);
     return ResponseEntity.ok(branchList);
  }

}
