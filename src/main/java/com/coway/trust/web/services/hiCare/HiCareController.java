package com.coway.trust.web.services.hiCare;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.biz.services.hiCare.HiCareService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.exception.PreconditionException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.web.commission.CommissionConstants;
import com.coway.trust.web.commission.csv.NonIncentiveDataVO;
import com.coway.trust.web.sales.SalesConstants;
import com.coway.trust.web.services.csv.HiCareDataVO;
import com.coway.trust.web.services.servicePlanning.MileageCalculationController;
import com.google.gson.Gson;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 10/01/2022    HLTANG      1.0.0       - Initial creation. HiCareController. Systemize and easier monitor Hi-Care SPS-02
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/hiCare")
public class HiCareController {

	private static final Logger logger = LoggerFactory.getLogger(MileageCalculationController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Resource(name = "hiCareService")
	HiCareService hiCareService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "hsManualService")
	private HsManualService hsManualService;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Autowired
	private SessionHandler sessionHandler;

 	@Autowired
	private FileApplication fileApplication;

 	@RequestMapping(value = "/hiCareList.do")
	public String hiCareList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO,HttpServletRequest request) throws Exception{
    //model.addAttribute("params", params);

    List<EgovMap> modelList = hiCareService.selectModelCode();
    List<EgovMap> cdbCodeList = hiCareService.selectCdbCode();
    //params.put("userId", sessionVO.getUserId());
	//EgovMap result =  salesCommonService.getUserInfo(params);
    params.put("memberLevel", sessionVO.getMemberLevel());
    params.put("userName", sessionVO.getUserName());
    params.put("userType", sessionVO.getUserTypeId());
	List<EgovMap> branchList = hsManualService.selectBranchList(params);

	logger.debug("============== hiCareList params{} ", params);

    logger.debug("===========================hiCareList.do=====================================");
    logger.debug(" MODEL LIST : {}", modelList);
    logger.debug(" CDB CODE LIST : {}", cdbCodeList);
    //logger.debug(" brnch : {}", result.get("brnch"));
    logger.debug("===========================hiCareList.do=====================================");

    model.addAttribute("modelList", modelList);
    model.addAttribute("cdbCodeList", cdbCodeList);
    //model.put("brnch", result.get("brnch"));
    model.addAttribute("branchList", branchList);

    return "services/hiCare/hiCareList";
	}

  @RequestMapping(value = "/getBch.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> getBch(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model) {
    logger.debug("===========================/getBch.do===============================");
    logger.debug("== params " + params.toString());
    logger.debug("===========================/getBch.do===============================");

    List<EgovMap> bch = hiCareService.getBch(params);
    logger.debug("BRANCH {}", bch);
    return ResponseEntity.ok(bch);
  }

 	@RequestMapping(value = "/selectHiCareList")
	public ResponseEntity<List<EgovMap>> getHiCareList(@RequestParam Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws Exception{

 		logger.debug("#############################################");
 		logger.debug("#############getHiCareList Start");
 		logger.debug("############# params : " + params.toString());
 		logger.debug("#############################################");

 		String modelList[] = request.getParameterValues("cmbModel");
 		String statusList[] = request.getParameterValues("cmbStatus");
 		String conditionList[] = request.getParameterValues("cmbCondition");
 		String branchList[] = null ;
 		int userType = sessionVO.getUserTypeId();
 		String branchId = params.get("cmdBranchCode").toString();
 		if(sessionVO.getUserBranchId() == 42 || sessionVO.getRoleId() == 179 || sessionVO.getRoleId() == 180 || sessionVO.getRoleId() == 250){
 			if(branchId.equals("")){
 				request.setAttribute("cmdBranchCode", null);
 			}else{
 				branchList= request.getParameterValues("cmdBranchCode");
 				branchId = "0";
 			}
 		}else{
 			if(branchId.equals("")){
 				branchList = new String[]{"0"};
 			}else{
 				branchList= request.getParameterValues("cmdBranchCode");
 			}
 			branchId = "0";
 		}
 		/*if(!(userType == 4 || userType == 6) && branchId.equals("")){
 			branchList = new String[]{"0"};
 			branchId = "0";
 		}else if((userType == 4 || userType == 6) && branchId.equals("")){
 			request.setAttribute("cmdBranchCode", null);
 		}else{
 			branchList= request.getParameterValues("cmdBranchCode");
 			branchId = "0";
 		}*/
 		String memberList[] = request.getParameterValues("cmdMemberCode");
 		String holderList[] = request.getParameterValues("cmbHolder");

 	    params.put("modelList", modelList);
 	    params.put("statusList", statusList);
 	    params.put("conditionList", conditionList);
 	    params.put("branchId", branchId);
 	    if(branchList != null){
 	    	params.put("branchList", branchList);
 	    }
 	    if(memberList != null){
 	    	params.put("memberList", memberList);
 	    }
 	    params.put("holderList", holderList);

 	    List<EgovMap> hiCareList = hiCareService.selectHiCareList(params);
 	    return ResponseEntity.ok(hiCareList);
	}

 	@RequestMapping(value = "/hiCareNewPop.do")
	public String hiCareNewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		params.put("memberLevel", sessionVO.getMemberLevel());
 	    params.put("userName", sessionVO.getUserName());
 	    params.put("userType", sessionVO.getUserTypeId());
 		List<EgovMap> branchList = hsManualService.selectBranchList(params);
 		List<EgovMap> modelList = hiCareService.selectModelCode();

 	    logger.debug("===========================hiCareNewPop.do=====================================");
 	    logger.debug(" MODEL LIST : {}", modelList);
 	    logger.debug(" BRANCH LIST : {}", branchList);
 	    logger.debug("===========================hiCareNewPop.do=====================================");

 		model.addAttribute("branchList", branchList);
 		model.addAttribute("modelList", modelList);
 		params.put("groupCode", "512");
 		model.addAttribute("stockCodeList", commonService.selectCodeList(params));

 	    return "services/hiCare/hiCareNewPop";
	}

 	@RequestMapping(value = "/saveHiCareBarcode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHiCareBarcode(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		List<Object> list = hiCareService.saveHiCareBarcode(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);

		return ResponseEntity.ok(result);
	}

 	@RequestMapping(value = "/deleteHiCareSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteHiCareSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

 		hiCareService.deleteHiCareSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

 	@RequestMapping(value = "/saveHiCareNew.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHiCareNew(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) throws Exception {
		int userId = sessionVo.getUserId();
		String scanNo = "";

		ReturnMessage message = new ReturnMessage();
		//logger.debug("gtype @@@@@@@: {}", gtype);

		scanNo = (String)params.get("scanNo");

		if(StringUtils.isEmpty(scanNo)){
			throw new PreconditionException(AppConstants.FAIL, "Kindly refresh the page and retry.");
		}

		//params.put("reqstNo", params.get("zDelvryNo"));
		//update status 'D' to 'A'
		params.put("userId", userId);
		hiCareService.saveSerialNo(params, sessionVo);

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


		return ResponseEntity.ok(message);
	}

 	@RequestMapping(value = "/hiCareEditPop.do")
	public String hiCareEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		EgovMap headerDetail = hiCareService.selectHiCareDetail(params);

 		model.addAttribute("headerDetail", headerDetail);
 		model.addAttribute("movementType", params.get("movementType"));

 	    return "services/hiCare/hiCareEditPop";
	}

 	@RequestMapping(value = "/saveHiCareEdit.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHiCareEdit(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

 		int userId = sessionVO.getUserId();
 		params.put("userId", userId);

 		Map<String, Object> list = hiCareService.updateHiCareDetail(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		//result.setDataList(list);

		return ResponseEntity.ok(result);
	}

 	@RequestMapping(value = "/attachHiCareFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachHiCareFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

 		logger.debug("params =====================================>>  " + params);
		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

			int fileGroupId = params.get("atchFileGrpId") != null ? params.get("atchFileGrpId").toString().equals("") ? 0 : (Integer.parseInt(params.get("atchFileGrpId").toString())) : 0 ;

			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "sales" + File.separator + "membership", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			logger.debug("list.size : {}", list.size());
			params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			hiCareService.insertPreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

			params.put("attachFiles", list);
			int fileGroupIdNew = (int) params.get("fileGroupKey");
			params.put("atchFileGrpIdNew", fileGroupIdNew);
			hiCareService.updateHiCareAttach(params);
			code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

 	@RequestMapping(value = "/hiCareDetailPop.do")
	public String hiCareDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		EgovMap headerDetail = hiCareService.selectHiCareDetail(params);
 		String holderCode = headerDetail.get("locId") == null ? "" : headerDetail.get("locId").toString();
 		EgovMap codyDetail = new EgovMap();
 		if(!holderCode.equals("")){
 			params.put("memCode", holderCode);
 			codyDetail = hiCareService.selectHiCareHolderDetail(params);
 		}else{
 			codyDetail.put("memCode", headerDetail.get("code"));
 			codyDetail.put("memName", headerDetail.get("name"));
 		}
 		List<EgovMap> historyDetailList = hiCareService.selectHiCareHistory(params);
 		List<EgovMap> filterDetailList = hiCareService.selectHiCareFilterHistory(params);

 		model.addAttribute("headerDetail", headerDetail);
 		model.addAttribute("codyDetail", codyDetail);
 		model.addAttribute("historyDetailList", new Gson().toJson(historyDetailList));
 		model.addAttribute("filterDetailList", new Gson().toJson(filterDetailList));

 	    return "services/hiCare/hiCareDetailPop";
	}

 	@RequestMapping(value = "/hiCareFilterPop.do")
	public String hiCareFilterPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		EgovMap headerDetail = hiCareService.selectHiCareDetail(params);

 		model.addAttribute("headerDetail", headerDetail);

 	    return "services/hiCare/hiCareFilterPop";
	}

 	@RequestMapping(value = "/saveHiCareFilter.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHiCareFilter(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

 		int userId = sessionVO.getUserId();
 		params.put("userId", userId);

 		Map<String, Object> list = hiCareService.updateHiCareFilter(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		//result.setDataList(list);

		return ResponseEntity.ok(result);
	}

 	@RequestMapping(value = "/hiCareStockListingPop.do")
	public String hiCareStockListingPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		params.put("memberLevel", sessionVO.getMemberLevel());
 	    params.put("userName", sessionVO.getUserName());
 	    params.put("userType", sessionVO.getUserTypeId());
 	   List<EgovMap> modelList = hiCareService.selectModelCode();
 		List<EgovMap> branchList = hsManualService.selectBranchList(params);

 		model.addAttribute("branchList", branchList);
 		model.addAttribute("modelList", modelList);

 	    return "services/hiCare/stockListingPop";
	}

 	@RequestMapping(value = "/hiCareFilterListingPop.do")
	public String hiCareFilterListingPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		params.put("memberLevel", sessionVO.getMemberLevel());
 	    params.put("userName", sessionVO.getUserName());
 	    params.put("userType", sessionVO.getUserTypeId());
 	   List<EgovMap> modelList = hiCareService.selectModelCode();
 		List<EgovMap> branchList = hsManualService.selectBranchList(params);

 		model.addAttribute("branchList", branchList);
 		model.addAttribute("modelList", modelList);

 	    return "services/hiCare/filterListingPop";
	}

 	@RequestMapping(value = "/hiCareTransferPop.do")
	public String hiCareTransferPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		List<EgovMap> modelList = hiCareService.selectModelCode();
 		List<EgovMap> toBranchList = hsManualService.selectBranchList(params);
 		params.put("memberLevel", sessionVO.getMemberLevel());
 	    params.put("userName", sessionVO.getUserName());
 	    params.put("userType", sessionVO.getUserTypeId());
 		List<EgovMap> fromBranchList = hsManualService.selectBranchList(params);

 		model.addAttribute("modelList", modelList);
 		model.addAttribute("fromBranchList", fromBranchList);
 		model.addAttribute("toBranchList", toBranchList);

 	    return "services/hiCare/hiCareTransferPop";
	}

 	@RequestMapping(value = "/saveHiCareTransfer.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHiCareTransfer(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

 		int userId = sessionVO.getUserId();
 		params.put("userId", userId);

 		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
 	    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
 	    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

 	   Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

 	   Map<String, Object> param = new HashMap();
       param.put("add", insList);
       param.put("form", formMap);
       param.put("userId", userId);

       Map<String, Object> list = hiCareService.insertHiCareTransfer(params, sessionVO);

       ReturnMessage result = new ReturnMessage();
       result.setCode(AppConstants.SUCCESS);
       result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setData(list);

       return ResponseEntity.ok(result);
	}

 	@RequestMapping(value = "/selectHiCareItemList")
	public ResponseEntity<List<EgovMap>> selectHiCareItemList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

 		logger.debug("#############################################");
 		logger.debug("#############getHiCareList Start");
 		logger.debug("############# params : " + params.toString());
 		logger.debug("#############################################");

 		String modelList[] = request.getParameterValues("tcmbModel");
 		String statusList[] = request.getParameterValues("tstatus");
 		String conditionList[] = request.getParameterValues("tcondition");
 		String branchList[]= request.getParameterValues("sLocation");

 	    params.put("modelList", modelList);
 	    params.put("statusList", statusList);
 	    params.put("conditionList", conditionList);
 	    params.put("branchList", branchList);

 	    List<EgovMap> hiCareList = hiCareService.selectHiCareItemList(params);
 	    return ResponseEntity.ok(hiCareList);
	}

 	@RequestMapping(value = "/hiCareDelivery.do")
	public String hiCareDelivery(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO,HttpServletRequest request) throws Exception{
    //model.addAttribute("params", params);

    List<EgovMap> modelList = hiCareService.selectModelCode();
    //params.put("userId", sessionVO.getUserId());
	//EgovMap result =  salesCommonService.getUserInfo(params);
    List<EgovMap> fromBranchList = hsManualService.selectBranchList(params);
    params.put("memberLevel", sessionVO.getMemberLevel());
    params.put("userName", sessionVO.getUserName());
    params.put("userType", sessionVO.getUserTypeId());
	List<EgovMap> toBranchList = hsManualService.selectBranchList(params);

	logger.debug("============== hiCareList params{} ", params);

    logger.debug("===========================hiCareList.do=====================================");
    logger.debug(" MODEL LIST : {}", modelList);
    //logger.debug(" brnch : {}", result.get("brnch"));
    logger.debug("===========================hiCareList.do=====================================");

    model.addAttribute("modelList", modelList);
    //model.put("brnch", result.get("brnch"));
    model.addAttribute("toBranchList", toBranchList);
    model.addAttribute("fromBranchList", fromBranchList);

    return "services/hiCare/hiCareDeliveryList";
	}

 	@RequestMapping(value = "/selectHiCareDeliveryList")
	public ResponseEntity<List<EgovMap>> selectHiCareDeliveryList(@RequestParam Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws Exception{

 		logger.debug("#############################################");
 		logger.debug("#############selectHiCareDeliveryList Start");
 		logger.debug("############# params : " + params.toString());
 		logger.debug("#############################################");

 		int userType = sessionVO.getUserTypeId();
 		String branchId = params.get("cmbToBranch").toString();
 		if(!(sessionVO.getUserBranchId() == 42 || sessionVO.getRoleId() == 179 || sessionVO.getRoleId() == 180 || sessionVO.getRoleId() == 250) && branchId.equals("")){
 			params.put("cmbToBranch", "0");
 		}

 		if(params.get("status").toString() != "0"){
 			if(params.get("status").toString().equals("1")){
 				params.put("delvryStatus", "N");
 			}
 			else if(params.get("status").toString().equals("4")){
 				params.put("delvryStatus", "Y");
 			}

 		}

 	    List<EgovMap> hiCareList = hiCareService.selectHiCareDeliveryList(params);
 	    return ResponseEntity.ok(hiCareList);
	}

 	@RequestMapping(value = "/hiCareDeliveryDetailPop.do")
	public String hiCareDeliveryDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		List<EgovMap> headerDetailList = hiCareService.selectHiCareDeliveryList(params);
 		List<EgovMap> bodyDetail = hiCareService.selectHiCareDeliveryDetail(params);

 		EgovMap headerDetail = headerDetailList.get(0);

 		model.addAttribute("headerDetail", headerDetail);
 		model.addAttribute("bodyDetail", new Gson().toJson(bodyDetail));

 	    return "services/hiCare/hiCareDeliveryDetailPop";
	}

 	@RequestMapping(value = "/hiCareDeliveryReceivePop.do")
	public String hiCareDeliveryReceivePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		List<EgovMap> headerDetailList = hiCareService.selectHiCareDeliveryList(params);
 		List<EgovMap> bodyDetail = hiCareService.selectHiCareDeliveryDetail(params);

 		EgovMap headerDetail = headerDetailList.get(0);

 		model.addAttribute("headerDetail", headerDetail);
 		model.addAttribute("bodyDetail", new Gson().toJson(bodyDetail));

 	    return "services/hiCare/hiCareDeliveryReceivePop";
	}

 	@RequestMapping(value = "/hiCareSerialScanPop.do")
	public String hiCareSerialScanPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("url", params);

		return "services/hiCare/hiCareSerialScanPop";
	}

 	@RequestMapping(value = "/selectHiCareDeliveryDetail")
	public ResponseEntity<List<EgovMap>> selectHiCareDeliveryDetail(@RequestParam Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws Exception{

 		logger.debug("#############################################");
 		logger.debug("#############selectHiCareDeliveryDetail Start");
 		logger.debug("############# params : " + params.toString());
 		logger.debug("#############################################");
 		List<EgovMap> bodyDetail = hiCareService.selectHiCareDeliveryDetail(params);
 	    return ResponseEntity.ok(bodyDetail);
	}

 	@RequestMapping(value = "/saveHiCareDeliveryBarcode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHiCareDeliveryBarcode(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		List<Object> list = hiCareService.saveHiCareDeliveryBarcode(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);

		return ResponseEntity.ok(result);
	}

 	@RequestMapping(value = "/deleteHiCareDeliverySerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteHiCareDeliverySerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

 		hiCareService.deleteHiCareDeliverySerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

 	@RequestMapping(value = "/saveHiCareDelivery.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHiCareDelivery(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

 		params.put("userId", sessionVO.getUserId());
 		params.put("transitNo", params.get("ztransitNo").toString());

		Map<String, Object> list = hiCareService.saveHiCareDelivery(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setData(list);

		return ResponseEntity.ok(result);
	}

 	/*@RequestMapping(value = "/selectModelCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectModelCode(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

 		List<EgovMap> modelList = hiCareService.selectModelCode();

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setData(modelList);

		return ResponseEntity.ok(result);
	}*/

 	@RequestMapping(value = "/selectModelCode.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectModelCode(@RequestParam Map<String, Object> params,
	      HttpServletRequest request, ModelMap model) {

	    List<EgovMap> modelCode = hiCareService.selectModelCode();

	    return ResponseEntity.ok(modelCode);
	  }

 	@RequestMapping(value = "/hiCareModelUpdatePop.do")
	public String hiCareModelUpdatePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		EgovMap headerDetail = hiCareService.selectHiCareDetail(params);

 		model.addAttribute("headerDetail", headerDetail);
 		model.addAttribute("movementType", params.get("movementType"));

 	    return "services/hiCare/hiCareModelUpdatePop";
	}

 	@RequestMapping(value = "/uploadModelCsv", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> uploadModelCsv(MultipartHttpServletRequest request) throws Exception,IOException, InvalidFormatException {
		//ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<HiCareDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, HiCareDataVO::create);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		for (HiCareDataVO vo : vos) {
			/*det.Updated = DateTime.Now;*/
			Map map = new HashMap();
			map.put("serialNo",vo.getSerialNo());
			map.put("modelCode",vo.getModel());
			map.put("userId",loginId);
			map.put("reason","6834");

			hiCareService.updateHiCareDetailMapper(map);
		}
		//commissionCalculationService.callNonIncentiveDetail(Integer.parseInt(uploadId));

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

 	@RequestMapping(value = "/hiCareUpdateSamplePop.do")
	public String hiCareUpdateSamplePop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "commission/commissionNonIncentiveUploadSamplePop";
	}

 	@RequestMapping(value = "/hiCareFilterForecastListPop.do")
	public String hiCareFilterForecastListPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		params.put("memberLevel", sessionVO.getMemberLevel());
 	    params.put("userName", sessionVO.getUserName());
 	    params.put("userType", sessionVO.getUserTypeId());
 	    List<EgovMap> modelList = hiCareService.selectModelCode();
 		List<EgovMap> branchList = hsManualService.selectBranchList(params);

 		model.addAttribute("branchList", branchList);
 		model.addAttribute("modelList", modelList);

 	    return "services/hiCare/filterForecastListingPop";
	}

 	@RequestMapping(value = "/hiCareRawDataPop.do")
	public String hiCareRawDataPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
 		model.addAttribute("params", params);

 		params.put("memberLevel", sessionVO.getMemberLevel());
 	    params.put("userName", sessionVO.getUserName());
 	    params.put("userType", sessionVO.getUserTypeId());
 	    List<EgovMap> modelList = hiCareService.selectModelCode();
 		List<EgovMap> branchList = hsManualService.selectBranchList(params);

 		model.addAttribute("branchList", branchList);
 		model.addAttribute("modelList", modelList);

 	    return "services/hiCare/hiCareRawDataPop";
	}
}
