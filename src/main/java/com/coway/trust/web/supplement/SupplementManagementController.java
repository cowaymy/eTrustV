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

		params.put("userId", sessionVO.getUserId());

		int result = supplementUpdateService.updateRefStgStatus(params);

		LOGGER.debug(" params rejectPos result==dd=>"+result);
		ReturnMessage message = new ReturnMessage();

	    if (result > 0) {
	    	message.setMessage("ESN update successful.");
	        message.setCode(AppConstants.SUCCESS);
	    } else {
	    	message.setMessage("ESN update failed.");
	        message.setCode(AppConstants.FAIL);
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

  /*@RequestMapping(value = "/selectPosModuleCodeList")
  public ResponseEntity<List<EgovMap>> selectPosModuleCodeList(@RequestParam Map<String, Object> params,
      @RequestParam(value = "codeIn[]") List<String> arr) throws Exception {

    List<EgovMap> codeList = null;
    params.put("codeArray", arr);

    codeList = posService.selectPosModuleCodeList(params);

    return ResponseEntity.ok(codeList);

  }

  @RequestMapping(value = "/selectStatusCodeList")
  public ResponseEntity<List<EgovMap>> selectStatusCodeList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> codeList = null;

    codeList = posService.selectStatusCodeList(params);

    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/selectWhBrnchList")
  public ResponseEntity<List<EgovMap>> selectWhBrnchList() throws Exception {

    List<EgovMap> codeList = null;

    codeList = posService.selectWhBrnchList();

    return ResponseEntity.ok(codeList);

  }

  @RequestMapping(value = "/selectWarehouse")
  public ResponseEntity<EgovMap> selectWarehouse(@RequestParam Map<String, Object> params) throws Exception {

    EgovMap codeMap = null;

    codeMap = posService.selectWarehouse(params);

    return ResponseEntity.ok(codeMap);

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

  @RequestMapping(value = "/posSystemPop.do")
  public String posSystemPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());


     * EgovMap memCodeMap = null; EgovMap locMap = null; memCodeMap =
     * posService.getMemCode(params); //get Brncn ID
     *
     * if(memCodeMap != null){
     *
     * if(memCodeMap.get("brnch") != null){ //BRNCH params.put("brnchId",
     * memCodeMap.get("brnch")); locMap = posService.selectWarehouse(params); }
     *
     * }


    // model.addAttribute("memCodeMap", memCodeMap);
    // model.addAttribute("locMap", locMap);

    return "sales/pos/posSystemPop";
  }

  @RequestMapping(value = "/posItmSrchPop.do")
  public String posItmSrchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    // Params translate
    model.addAttribute("posSystemModuleType", params.get("insPosModuleType"));
    model.addAttribute("posSystemType", params.get("insPosSystemType"));
    model.addAttribute("whBrnchId", params.get("hidLocId"));
    model.addAttribute("serialRequireChkYn", params.get("hidSerialRequireChkYn"));
    // model.addAttribute("", params.get("hidLocDesc"));

    return "sales/pos/posItmSrchPop";

  }

  @RequestMapping(value = "/selectPosTypeList")
  public ResponseEntity<List<EgovMap>> selectPosTypeList(@RequestParam Map<String, Object> params,
      @RequestParam(value = "codes[]") String[] codes) throws Exception {

    List<EgovMap> codeList = null;

    params.put("codArr", codes);
    codeList = posService.selectPosTypeList(params);

    return ResponseEntity.ok(codeList);
  }


   * @RequestMapping(value = "/selectPSMItmTypeDeductionList") public
   * ResponseEntity<List<EgovMap>> selectPSMItmTypeDeductionList(@RequestParam
   * Map<String, Object> params, @RequestParam(value = "exceptCodes[]") String[]
   * exceptArr) throws Exception{
   *
   * List<EgovMap> codeList = null;
   *
   * params.put("exArr", exceptArr);
   *
   * codeList = posService.selectPosTypeList(params);
   *
   * return ResponseEntity.ok(codeList); }



   * @RequestMapping(value = "/selectPIItmTypeList") public
   * ResponseEntity<List<EgovMap>> selectPIItmTypeList() throws Exception{
   *
   * List<EgovMap> codeList = null; codeList = posService.selectPIItmTypeList();
   *
   * return ResponseEntity.ok(codeList); }



   * @RequestMapping(value = "/selectPIItmList") public
   * ResponseEntity<List<EgovMap>> selectPIItmList(@RequestParam Map<String,
   * Object> params, HttpServletRequest request) throws Exception{
   *
   * List<EgovMap> codeList = null;
   *
   * String itmIdArray [] = request.getParameterValues("itmLists");
   * params.put("itmIdArray", itmIdArray);
   *
   * codeList = posService.selectPIItmList(params); return
   * ResponseEntity.ok(codeList); }


  @RequestMapping(value = "/selectPosItmList")
  public ResponseEntity<List<EgovMap>> selectPosItmList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> codeList = null;

    params.put("stkTypeId", SalesConstants.POS_SALES_NOT_BANK); // 2687
    codeList = posService.selectPosItmList(params);
    return ResponseEntity.ok(codeList);

  }

  @RequestMapping(value = "/chkStockList")
  public ResponseEntity<List<EgovMap>> chkStockList(@RequestParam Map<String, Object> params,
      HttpServletRequest request) throws Exception {

    String stkId[] = request.getParameterValues("itmLists");
    params.put("stkId", stkId);

    List<EgovMap> stokList = null;
    stokList = posService.chkStockList(params);

    return ResponseEntity.ok(stokList);
  }

  @RequestMapping(value = "/chkStockList2")
  public ResponseEntity<List<EgovMap>> chkStockList2(@RequestParam Map<String, Object> params,
      HttpServletRequest request) throws Exception {

    String stkId[] = request.getParameterValues("itmLists");
    params.put("stkId", stkId);

    List<EgovMap> stokList = null;
    stokList = posService.chkStockList2(params);

    return ResponseEntity.ok(stokList);
  }

  @RequestMapping(value = "/getReasonCodeList")
  public ResponseEntity<List<EgovMap>> getReasonCodeList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> codeList = null;
    codeList = posService.getReasonCodeList(params);

    return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/posFilterSrchPop.do")
  public String posFilterSrchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    model.addAttribute("basketStkCode", params.get("basketStkCode"));
    model.addAttribute("tempString", params.get("tempString"));
    model.addAttribute("locId", params.get("locId"));
    model.addAttribute("serialRequireChkYn", params.get("serialRequireChkYn"));

    return "sales/pos/posFilterSerialSrchPop";
  }

  @RequestMapping(value = "/getFilterSerialNum")
  public ResponseEntity<List<EgovMap>> getFilterSerialNum(@RequestParam Map<String, Object> params) throws Exception {
    // Session
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());

    List<EgovMap> serialList = null;
    serialList = posService.getFilterSerialNum(params);

    return ResponseEntity.ok(serialList);
  }

  @RequestMapping(value = "/getFilterSerialReNum")
  public ResponseEntity<List<EgovMap>> getFilterSerialReNum(@RequestParam Map<String, Object> params,
      @RequestParam(value = "tempSerialArr[]") String[] tempSerialArr) throws Exception {
    // Session
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("serialArr", tempSerialArr);

    List<EgovMap> serialList = null;
    serialList = posService.getFilterSerialNum(params);

    return ResponseEntity.ok(serialList);
  }

  @RequestMapping(value = "/getConfirmFilterListAjax")
  public ResponseEntity<List<EgovMap>> getConfirmFilterListAjax(@RequestParam(value = "toArr[]") String[] toArr,
      @RequestParam Map<String, Object> params) throws Exception {

    // Session
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

    // param Setting
    params.put("userId", sessionVO.getUserId());
    params.put("filterArr", toArr);
    List<EgovMap> filterList = null;
    filterList = posService.getConfirmFilterListAjax(params);

    return ResponseEntity.ok(filterList);

  }

  @RequestMapping(value = "/insertPos.do", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> insertPos(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());
    Map<String, Object> retunMap = null;
    retunMap = posService.insertPos(params);

    return ResponseEntity.ok(retunMap);

  }

  @RequestMapping(value = "/posMemUploadPop.do")
  public String posMemUploadPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    model.addAttribute("mainBrnch", params.get("cmbWhBrnchIdPop"));

    return "sales/pos/posMemUploadPop";
  }

  @RequestMapping(value = "/getUploadMemList")
  public ResponseEntity<List<EgovMap>> getUploadMemList(@RequestParam Map<String, Object> params,
      @RequestParam(value = "memIdArray[]") String[] memIdArray) throws Exception {
    List<EgovMap> memList = null;

    params.put("memberIdArr", memIdArray);

    memList = posService.getUploadMemList(params);

    return ResponseEntity.ok(memList);
  }

  @RequestMapping(value = "/chkReveralBeforeReversal")
  public ResponseEntity<EgovMap> chkReveralBeforeReversal(@RequestParam Map<String, Object> params) throws Exception {

    EgovMap chkMap = null;

    LOGGER.info("############################ chkReveralBeforeReversal  params.toString :    " + params.toString());

    chkMap = posService.chkReveralBeforeReversal(params);

    return ResponseEntity.ok(chkMap);
  }

  @RequestMapping(value = "/posReversalPop.do")
  public String posReversalPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    // posId
    LOGGER.info("######################################### posID : " + params.get("posId"));
    EgovMap revDetailMap = null;
    EgovMap payDetailMap = null;

    revDetailMap = posService.posReversalDetail(params);
    params.put("posNo", revDetailMap.get("posNo"));
    payDetailMap = posService.posReversalPayDetail(params);

    // exist Pay Check
    String isPayed = "";

    if (payDetailMap != null) {
      if (Integer.parseInt(String.valueOf(payDetailMap.get("payId"))) == 0) {
        isPayed = "0";
      } else {
        isPayed = "1";
      }
    } else {
      isPayed = "0";
    }

    model.addAttribute("revDetailMap", revDetailMap);
    model.addAttribute("payDetailMap", payDetailMap);
    model.addAttribute("isPayed", isPayed);
    model.addAttribute("ind", params.get("ind"));

    return "sales/pos/posReversalPop";

  }

  @RequestMapping(value = "/getPosDetailList")
  public ResponseEntity<List<EgovMap>> getPosDetailList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> detailList = null;

    LOGGER.info("################################## detail Grid PARAM : " + params.toString());

    detailList = posService.getPosDetailList(params);

    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/insertPosReversal.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> insertPosReversal(@RequestBody Map<String, Object> params) throws Exception {

    // Session
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());

    EgovMap revMap = null;
    revMap = posService.insertPosReversal(params);
    LOGGER.info("################################################ revMap : " + revMap.toString());
    return ResponseEntity.ok(revMap);

  }

  @RequestMapping(value = "/insertPosReversalItemBank.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> insertPosReversalItemBank(@RequestBody Map<String, Object> params) throws Exception {

    // Session
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());

    EgovMap revMap = null;
    revMap = posService.insertPosReversalItemBank(params);
    LOGGER.info("################################################ revMap : " + revMap.toString());
    return ResponseEntity.ok(revMap);

  }

  @RequestMapping(value = "/getPurchMemList")
  public ResponseEntity<List<EgovMap>> getPurchMemList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> memList = null;
    LOGGER.info("################################################ 멤버 params : " + params.toString());
    memList = posService.getPurchMemList(params);

    return ResponseEntity.ok(memList);
  }

  @RequestMapping(value = "/updatePosMStatus", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePosMStatus(@RequestBody PosGridVO pgvo, SessionVO session)
      throws Exception {

    LOGGER.info("############################# pgvo : " + pgvo.toString());

    boolean isErr = posService.updatePosMStatus(pgvo, Integer.parseInt(String.valueOf(session.getUserId())));

    // Return MSG
    ReturnMessage message = new ReturnMessage();

    if (isErr == false) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updatePosDStatus", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePosDStatus(@RequestBody PosGridVO pgvo, SessionVO session)
      throws Exception {

    LOGGER.info("############################# pgvo : " + pgvo.toString());

    int userId = session.getUserId();
    boolean isErr = posService.updatePosDStatus(pgvo, userId);

    // Return MSG
    ReturnMessage message = new ReturnMessage();

    if (isErr == false) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/updatePosMemStatus", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePosMemStatus(@RequestBody PosGridVO pgvo, SessionVO session)
      throws Exception {

    LOGGER.info("############################# pgvo : " + pgvo.toString());
    int userId = session.getUserId();
    boolean isErr = posService.updatePosMemStatus(pgvo, userId);

    // Return MSG
    ReturnMessage message = new ReturnMessage();

    if (isErr == false) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/getpayBranchList")
  public ResponseEntity<List<EgovMap>> getpayBranchList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> payBrnchMap = null;

    payBrnchMap = posService.getpayBranchList(params);

    return ResponseEntity.ok(payBrnchMap);

  }

  @RequestMapping(value = "/getDebtorAccList")
  public ResponseEntity<List<EgovMap>> getDebtorAccList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> debtorMap = null;

    debtorMap = posService.getDebtorAccList(params);

    return ResponseEntity.ok(debtorMap);

  }

  @RequestMapping(value = "/getBankAccountList")
  public ResponseEntity<List<EgovMap>> getBankAccountList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> bankAccList = null;

    bankAccList = posService.getBankAccountList(params);

    return ResponseEntity.ok(bankAccList);
  }

  @RequestMapping(value = "/selectAccountIdByBranchId")
  public ResponseEntity<EgovMap> selectAccountIdByBranchId(@RequestParam Map<String, Object> params) throws Exception {

    EgovMap accMap = null;

    accMap = posService.selectAccountIdByBranchId(params);

    return ResponseEntity.ok(accMap);
  }

  @RequestMapping(value = "/isPaymentKnowOffByPOSNo")
  public ResponseEntity<Boolean> isPaymentKnowOffByPOSNo(@RequestParam Map<String, Object> params) throws Exception {

    boolean isPay = false;

    isPay = posService.isPaymentKnowOffByPOSNo(params);

    LOGGER.info("########################### check Reversal Possible Check : " + isPay);

    return ResponseEntity.ok(isPay);

  }

  @RequestMapping(value = "/getPayDetailList")
  public ResponseEntity<List<EgovMap>> getPayDetailList(@RequestParam Map<String, Object> params) throws Exception {

    List<EgovMap> payDList = null;

    payDList = posService.getPayDetailList(params);

    return ResponseEntity.ok(payDList);

  }

  @RequestMapping(value = "/getMemCode")
  public ResponseEntity<EgovMap> getMemCode(@RequestParam Map<String, Object> params) throws Exception {

    EgovMap memMap = null;
    memMap = posService.getMemCode(params);

    return ResponseEntity.ok(memMap);

  }

  @RequestMapping(value = "/posRawDataPop.do")
  public String posRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "sales/pos/posRawDataPop";
  }

  @RequestMapping(value = "/insertTransactionLog")
  public ResponseEntity<ReturnMessage> insertTransactionLog(@RequestParam Map<String, Object> params, SessionVO session)
      throws Exception {

    params.put("userId", session.getUserId());

    posService.insertTransactionLog(params);

    // Return MSG
    ReturnMessage message = new ReturnMessage();

    message.setCode(AppConstants.SUCCESS);
    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/posPaymentListingPop.do")
  public String posPaymentListingPop(@RequestParam Map<String, Object> params) throws Exception {
    return "sales/pos/posPaymentListingPop";
  }

  @RequestMapping(value = "/chkMemIdByMemCode")
  public ResponseEntity<EgovMap> chkMemIdByMemCode(@RequestParam Map<String, Object> params) throws Exception {

    EgovMap memMap = null;
    memMap = posService.chkMemIdByMemCode(params);

    return ResponseEntity.ok(memMap);
  }

  @RequestMapping(value = "/chkUserIdByUserName")
  public ResponseEntity<EgovMap> chkUserIdByUserName(@RequestParam Map<String, Object> params) throws Exception {
    EgovMap idMap = null;
    idMap = posService.chkUserIdByUserName(params);
    return ResponseEntity.ok(idMap);
  }

  @RequestMapping(value = "/selectPosBillingList")
  public ResponseEntity<List<EgovMap>> getPosBillingDetailList(@RequestParam Map<String, Object> params)
      throws Exception {

    List<EgovMap> detailList = null;

    LOGGER.info("################################## detail Grid PARAM : " + params.toString());

    detailList = posService.getPosBillingDetailList(params);

    return ResponseEntity.ok(detailList);
  }

  @RequestMapping(value = "/selectPosFlexList.do")
  public String selectPosFlexList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    // TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "sales/pos/posFlexiList";
  }

  @RequestMapping(value = "/selectPosFlexiJsonList")
  public ResponseEntity<List<EgovMap>> selectPosFlexiJsonList(@RequestParam Map<String, Object> params,
          HttpServletRequest request) throws Exception {

        List<EgovMap> listMap = null;

        // params
        String systemArray[] = request.getParameterValues("posTypeId");
        String statusArray[] = request.getParameterValues("posStatusId");

        params.put("systemArray", systemArray);
        params.put("statusArray", statusArray);

        listMap = posService.selectPosFlexiJsonList(params);

        return ResponseEntity.ok(listMap);

      }

  @RequestMapping(value = "/posFlexiSystemPop.do")
  public String posFlexiSystemPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

    params.put("userId", sessionVO.getUserId());
    model.put("userBr", sessionVO.getUserBranchId());

    return "sales/pos/posFlexiSystemPop";
  }

  @RequestMapping(value = "/insertPosFlexi.do", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> insertPosFlexi(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());
    Map<String, Object> retunMap = null;
    retunMap = posService.insertPosFlexi(params);

    return ResponseEntity.ok(retunMap);

  }

  @RequestMapping(value = "/posFlexiItmSrchPop.do")
  public String posFlexiItmSrchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    // Params translate
    model.addAttribute("posSystemModuleType", params.get("insPosModuleType"));
    model.addAttribute("posSystemType", params.get("insPosSystemType"));
    model.addAttribute("whBrnchId", params.get("hidLocId"));
    // model.addAttribute("", params.get("hidLocDesc"));

    return "sales/pos/posFlexiItmSrchPop";

  }

  @RequestMapping(value = "/selectPosFlexiItmList")
  public ResponseEntity<List<EgovMap>> selectPosFlexiItmList(@RequestParam Map<String, Object> params)
      throws Exception {

    List<EgovMap> codeList = null;

    params.put("stkTypeId", SalesConstants.POS_SALES_NOT_BANK); // 2687
    codeList = posService.selectPosFlexiItmList(params);
    return ResponseEntity.ok(codeList);

  }

  @RequestMapping(value = "/chkFlexiStockList")
  public ResponseEntity<List<EgovMap>> chkFlexiStockList(@RequestParam Map<String, Object> params,
      HttpServletRequest request) throws Exception {

    String stkId[] = request.getParameterValues("itmLists");
    params.put("stkId", stkId);

    List<EgovMap> stokList = null;
    stokList = posService.chkFlexiStockList(params);

    return ResponseEntity.ok(stokList);
  }

  @RequestMapping(value = "/posFlexiConfirmPop.do")
  public String posFlexiConfirmPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    EgovMap posDetailMap = null;

    posDetailMap = posService.posFlexiDetail(params);
    params.put("posNo", posDetailMap.get("posNo"));

    model.addAttribute("posDetailMap", posDetailMap);

    return "sales/pos/posFlexiConfirmPop";

  }

  @RequestMapping(value = "/confirmPosFlexi.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> confirmPosFlexi(@RequestBody Map<String, Object> params, SessionVO sessionVO)
      throws Exception {

    ReturnMessage message = new ReturnMessage();
    LOGGER.info("params : " + params);

    Map<String, Object> resultValue = new HashMap<String, Object>();
    params.put("posFlexiStatusCode", "4");
    resultValue = posService.updatePosFlexiStatus(params, sessionVO);

    message.setMessage("POS No. : [" + params.get("posFlexiNo") + "] successful approved.");

    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/rejectPosFlexi.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> rejectPosFlexi(@RequestBody Map<String, Object> params, SessionVO sessionVO)
      throws Exception {

    ReturnMessage message = new ReturnMessage();
    LOGGER.info("params : " + params.toString());

    Map<String, Object> resultValue = new HashMap<String, Object>();
    params.put("posFlexiStatusCode", "10");
    resultValue = posService.updatePosFlexiStatus(params, sessionVO);

    message.setMessage("POS No. : [" + params.get("posFlexiNo") + "] successful rejected.");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectWhSOBrnchList")
  public ResponseEntity<List<EgovMap>> selectWhSOBrnchList(@RequestParam Map<String, Object> params) throws Exception {
        List<EgovMap> codeList = posService.selectWhSOBrnchList(params);
        return ResponseEntity.ok(codeList);
  }

  @RequestMapping(value = "/posFlexiRawDataPop.do")
  public String posFlexiRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3,
        SalesConstants.DEFAULT_DATE_FORMAT1);
    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    model.put("bfDay", bfDay);
    model.put("toDay", toDay);

    return "sales/pos/posFlexiRawDataPop";
  }

  @RequestMapping(value = "/posFlexiAddItemPop.do")
  public String posFlexiAddItemPop(@RequestParam Map<String, Object> params, ModelMap model) {
    // 호출될 화면
    return "sales/pos/posFlexiAddItemPop";
  }

  @RequestMapping(value = "/selectPOSFlexiItem.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectPOSFlexiItem(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

    params.put("user_id", sessionVO.getUserId());
    // 조회.
    List<EgovMap> posItemList = posService.selectPOSFlexiItem(params);

    return ResponseEntity.ok(posItemList);
  }

  @RequestMapping(value = "/updatePOSFlexiItemActive.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePOSFlexiItemActive(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();

    LOGGER.debug("updatePOSFlexiItemActive - params : {}", params);

    if (null != params.get("stkId")) {
      String olist = (String) params.get("stkId");
      String[] spl = olist.split(",");
      params.put("stkIdListSp", spl);
    }

    LOGGER.debug("updatePOSFlexiItemActive - params : {}", params);

    // UPDATE LOG0092M
    int resultValue = posService.updatePOSFlexiItemActive(params, sessionVO);

    // int resultValue = 0;

    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);

  }

  @RequestMapping(value = "/updatePOSFlexiItemInactive.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> updatePOSFlexiItemInactive(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) throws ParseException {
    ReturnMessage message = new ReturnMessage();

    LOGGER.debug("updatePOSFlexiItemInactive - params : {}", params);

    if (null != params.get("stkId")) {
      String olist = (String) params.get("stkId");
      String[] spl = olist.split(",");
      params.put("stkIdListSp", spl);
    }

    LOGGER.debug("updatePOSFlexiItemInactive - params : {}", params);

    // UPDATE LOG0092M
    int resultValue = posService.updatePOSFlexiItemInactive(params, sessionVO);

    // int resultValue = 0;

    if (resultValue > 0) {
      message.setCode(AppConstants.SUCCESS);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    } else {
      message.setCode(AppConstants.FAIL);
      message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
    }
    return ResponseEntity.ok(message);

  }

  // KR-OHK Serial check add
  @RequestMapping(value = "/insertPosSerial.do", method = RequestMethod.POST)
  public ResponseEntity<Map<String, Object>> insertPosSerial(@RequestBody Map<String, Object> params) throws Exception {
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());
    params.put("userName", sessionVO.getUserName());
    Map<String, Object> retunMap = null;
    retunMap = posService.insertPosSerial(params);

    return ResponseEntity.ok(retunMap);

  }

  // KR-OHK Serial check add
  @RequestMapping(value = "/insertPosReversalSerial.do", method = RequestMethod.POST)
  public ResponseEntity<EgovMap> insertPosReversalSerial(@RequestBody Map<String, Object> params) throws Exception {

    // Session
    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
    params.put("userId", sessionVO.getUserId());
    params.put("userDeptId", sessionVO.getUserDeptId());

    EgovMap revMap = null;
    revMap = posService.insertPosReversalSerial(params);
    LOGGER.info("################################################ revMap : " + revMap.toString());
    return ResponseEntity.ok(revMap);

  }

  @RequestMapping(value = "/loyaltyRewardPointList.do")
  public String loyaltyRewardPointList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
    return "sales/pos/posLoyaltyRewardList";
  }

  @RequestMapping(value = "/selectLoyaltyRewardPointList.do")
  public ResponseEntity<List<EgovMap>> selectLoyaltyRewardPointList(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> result = posService.selectLoyaltyRewardPointList(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/selectLoyaltyRewardPointDetails.do")
  public ResponseEntity<List<EgovMap>> selectLoyaltyRewardPointDetails(@RequestParam Map<String, Object> params) throws Exception {
    List<EgovMap> result = posService.selectLoyaltyRewardPointDetails(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/getLoyaltyRewardPointByMemCode.do")
  public ResponseEntity<EgovMap> selectLoyaltyRewardPointByMemCode(@RequestParam Map<String, Object> params) throws Exception {
    EgovMap result = posService.selectLoyaltyRewardPointByMemCode(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/uploadLoyaltyRewardBulk.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> uploadLoyaltyRewardBulk(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {

      Map<String, MultipartFile> fileMap = request.getFileMap();
      MultipartFile multipartFile = fileMap.get("csvFile");

      List<EgovMap> uploadedList = null;
      List<PosLoyaltyRewardVO> vos = csvReadComponent.readCsvToList(multipartFile,true ,PosLoyaltyRewardVO::create);

      Map<String, Object> cvsParam = new HashMap<String, Object>();
      cvsParam.put("voList", vos);
      cvsParam.put("usrId", sessionVO.getUserId());
      cvsParam.put("stus", 1);

      posService.insertUploadedLoyaltyRewardList(cvsParam);

      // 결과 만들기.
      ReturnMessage message = new ReturnMessage();
      message.setCode(AppConstants.SUCCESS);
      message.setData(uploadedList);
      message.setMessage("Saved Successfully");

      return ResponseEntity.ok(message);
  }*/


}
