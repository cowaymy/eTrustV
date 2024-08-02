package com.coway.trust.web.payment.invoice.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceApplication;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.payment.invoice.service.InvoiceAdjApplication;
import com.coway.trust.biz.payment.invoice.service.InvoiceAdjService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.common.excel.download.ExcelDownloadFormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class InvoiceAdjController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InvoiceAdjController.class);

	@Value("${web.resource.upload.file}")
    private String uploadDir;

	@Resource(name = "invoiceAdjService")
	private InvoiceAdjService invoiceService;

	@Autowired
	private LargeExcelService largeExcelService;

	@Autowired
	private InvoiceAdjApplication invoiceAdjApplication;

	@Autowired
    private MessageSourceAccessor messageAccessor;

	@Resource(name = "webInvoiceService")
    private WebInvoiceService webInvoiceService;

	@Resource(name = "commonService")
	private CommonService commonService;

	/******************************************************
	 *   AdjustmentCNDN
	 *****************************************************/
	/**
	 * AdjustmentCNDN초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdjCnDn.do")
	public String initInvoiceAdj(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/adjCnDn";
	}

	@RequestMapping(value = "/selectAdjustmentList.do")
	public ResponseEntity<List<EgovMap>> selectInvoiceList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

	    LOGGER.error("selectAdjustmentList.do :: START");
	    LOGGER.error("selectAdjustmentList :: params {}", params.toString());

	    if(params.containsKey("mode") && "APPROVAL".equals(params.get("mode").toString())) {
	        String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
	        params.put("memCode", memCode);

	        EgovMap apprDtls = new EgovMap();
	        apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
	        if(apprDtls != null && "AO".equals(apprDtls.get("apprGrp").toString())) {
	            params.put("apprGrp", apprDtls.get("apprGrp"));
	        }
	    }

	    LOGGER.error("Query :: selectInvoiceAdj :: START");
		List<EgovMap> list = invoiceService.selectInvoiceAdj(params);
		LOGGER.error("Query :: selectInvoiceAdj :: END");
		return ResponseEntity.ok(list);
	}

	/**
	 * Adjustment Detail Pop-up 초기화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initAdjustmentDetailPop.do")
	public String initAdjustmentDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("adjId", params.get("adjId"));
		model.addAttribute("mode", params.get("mode"));
		model.addAttribute("invNo", params.get("invNo"));
		return "payment/invoice/adjCnDnDetailPop";
	}

	/**
	 * Adjustment Detail Pop-up (Batch Approval) 초기화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initApprovalBatchPop.do")
	public String initApprovalBatchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("batchId", params.get("batchId"));
		return "payment/invoice/adjCnDnBatchApprovalPop";
	}

	/**
	 * Adjustment Detail Pop-up 정보조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectAdjustmentDetailPop.do", method = RequestMethod.GET)
	public ResponseEntity<HashMap<String,Object>> selectAdjustmentDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("adjId : {}", params.toString());
		LOGGER.debug("adjId : {}", params.get("adjId"));
		LOGGER.debug("invNo : {}", params.get("invNo"));

		String invNo = String.valueOf(params.get("invNo"));

		//if( invNo == "" || invNo == null){
		if( invNo.contains("B")){
		    EgovMap master = invoiceService.selectAdjDetailPopMaster(params);					//마스터 데이터 조회
		    List<EgovMap> detailList = invoiceService.selectAdjDetailPopList(params);		//상세 리스트 조회
		    List<EgovMap> histlList = invoiceService.selectAdjDetailPopHist(params);		//히스토리 조회

		    String atchFileGrpId = String.valueOf(master.get("atchFileGrpId"));

		    HashMap <String, Object> returnValue = new HashMap<String, Object>();
			returnValue.put("master", master);
			returnValue.put("detailList", detailList);
			returnValue.put("histlList", histlList);
			if(atchFileGrpId != "null") {
                List<EgovMap> adjAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
                returnValue.put("attachList", adjAttachList);
            }

			EgovMap apprResult = new EgovMap();
			String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
	        params.put("memCode", memCode);
	        EgovMap apprDtls = new EgovMap();
	        apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);

	        String sessionApprGrp = "";
	        if(apprDtls != null) {
	            sessionApprGrp = apprDtls.get("apprGrp").toString();
	        }

	        List<EgovMap> apprList = invoiceService.selectAppvLineInfo(params);
	        if(!apprList.isEmpty()) {
	            EgovMap apprDetail = apprList.get(0);

	            ArrayList<String> appvPrcssStusList = new ArrayList<String>();
	            //ArrayList<Map> appvPrcssStusList = new ArrayList<Map> ();
	            HashMap<String, Object> appvHm = new HashMap<String, Object>();

	            appvPrcssStusList.add("- Requested By " + (String) apprDetail.get("memoReqstUserId") + " [" + (String) apprDetail.get("reqstDt") + "]");

	            String finalAppr = "";
	            for(int i = 0; i < apprList.size(); i++) {
	                apprDetail = apprList.get(i);

	                if("R".equals((String)apprDetail.get("memoAppvStus")) || "T".equals((String)apprDetail.get("memoAppvStus"))) {
	                    appvPrcssStusList.add("- Pending for Approval By " + apprDetail.get("appvLineUserName") + " [" + apprDetail.get("appvDt") + "] - " + apprDetail.get("memoRem"));
	                } else if("A".equals((String)apprDetail.get("memoAppvStus"))) {
	                    appvPrcssStusList.add("- Approved By " + apprDetail.get("appvLineUserName") + " [" + apprDetail.get("appvDt") + "] - " + apprDetail.get("memoRem"));
	                    finalAppr = "- Approved By " + (String) apprDetail.get("finalApprUser") + " [" + (String) apprDetail.get("finalAppvDt") + "]";
	                } else if("J".equals((String)apprDetail.get("memoAppvStus"))) {
	                    appvPrcssStusList.add("- Rejected By " + apprDetail.get("appvLineUserName") + " [" + apprDetail.get("appvDt") + "] - " + apprDetail.get("memoRem"));
	                    finalAppr = "- Rejected By " + (String) apprDetail.get("finalApprUser") + " [" + (String) apprDetail.get("finalAppvDt") + "]";
	                }
	            }

	            apprResult.put("appvPrcssStus", appvPrcssStusList);
	            returnValue.put("apprList", apprResult);
	            returnValue.put("finalAppr", finalAppr);
	        }

			return ResponseEntity.ok(returnValue);


		}
		else{

			EgovMap master = invoiceService.selectAdjDetailPopMasterOld(params);					//마스터 데이터 조회
			List<EgovMap> detailList = invoiceService.selectAdjDetailPopListOld(params);		//상세 리스트 조회
			List<EgovMap> histlList = null;		//히스토리 조회

			HashMap <String, Object> returnValue = new HashMap<String, Object>();
			returnValue.put("master", master);
			returnValue.put("detailList", detailList);
			returnValue.put("histlList", histlList);

			return ResponseEntity.ok(returnValue);

		}

	}

	/**
	 * Adjustment Batch Approval Pop-up 정보조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectAdjustmentBatchApprovalPop.do", method = RequestMethod.GET)
	public ResponseEntity<HashMap<String,Object>> selectAdjustmentBatchApprovalPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("batchId : {}", params.get("batchId"));

		EgovMap master = invoiceService.selectAdjBatchApprovalPopMaster(params);					//마스터 데이터 조회
		List<EgovMap> detailList = invoiceService.selectAdjBatchApprovalPopDetail(params);		//상세 리스트 조회
		List<EgovMap> histlList = invoiceService.selectAdjBatchApprovalPopHist(params);		//히스토리 조회

		String atchFileGrpId = String.valueOf(master.get("atchFileGrpId"));

		HashMap <String, Object> returnValue = new HashMap<String, Object>();
		returnValue.put("master", master);
		returnValue.put("detailList", detailList);
		returnValue.put("histlList", histlList);
		if(atchFileGrpId != "null") {
            List<EgovMap> batchAdjAttachList = webInvoiceService.selectAttachList(atchFileGrpId);
            returnValue.put("attachList", batchAdjAttachList);
        }

		EgovMap apprResult = new EgovMap();
		String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
        params.put("memCode", memCode);
        EgovMap apprDtls = new EgovMap();
        apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);

        String sessionApprGrp = "";
        if(apprDtls != null) {
            sessionApprGrp = apprDtls.get("apprGrp").toString();
        }

		List<EgovMap> apprList = invoiceService.selectAppvLineInfo(params);
		EgovMap apprDetail = apprList.get(0);

		ArrayList<String> appvPrcssStusList = new ArrayList<String>();
		//ArrayList<Map> appvPrcssStusList = new ArrayList<Map> ();
		HashMap<String, Object> appvHm = new HashMap<String, Object>();

		appvPrcssStusList.add("- Requested By " + (String) apprDetail.get("memoReqstUserId") + " [" + (String) apprDetail.get("reqstDt") + "]");

		String finalAppr = "";
		for(int i = 0; i < apprList.size(); i++) {
		    apprDetail = apprList.get(i);

		    if("R".equals((String)apprDetail.get("memoAppvStus")) || "T".equals((String)apprDetail.get("memoAppvStus"))) {
                appvPrcssStusList.add("- Pending for Approval By " + apprDetail.get("appvLineUserName") + " [" + apprDetail.get("appvDt") + "] - " + apprDetail.get("memoRem"));
            } else if("A".equals((String)apprDetail.get("memoAppvStus"))) {
                appvPrcssStusList.add("- Approved By " + apprDetail.get("appvLineUserName") + " [" + apprDetail.get("appvDt") + "] - " + apprDetail.get("memoRem"));
                finalAppr = "- Approved By " + (String) apprDetail.get("finalApprUser") + " [" + (String) apprDetail.get("finalAppvDt") + "]";
            } else if("J".equals((String)apprDetail.get("memoAppvStus"))) {
                appvPrcssStusList.add("- Rejected By " + apprDetail.get("appvLineUserName") + " [" + apprDetail.get("appvDt") + "] - " + apprDetail.get("memoRem"));
                finalAppr = "- Rejected By " + (String) apprDetail.get("finalApprUser") + " [" + (String) apprDetail.get("finalAppvDt") + "]";
            }
		}

		apprResult.put("appvPrcssStus", appvPrcssStusList);
		returnValue.put("apprList", apprResult);
		returnValue.put("finalAppr", finalAppr);

		return ResponseEntity.ok(returnValue);
	}



	/******************************************************
	 *   Company Statement
	 *****************************************************/
	/**
	 * AdjustmentCNDN초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initNewAdj.do")
	public String initInvoiceNewAdj(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} " , params);

		EgovMap sstInfo = commonService.getSstRelatedInfo();
		model.addAttribute("refNo", params.get("refNo"));
		model.addAttribute("taxRate", sstInfo.get("taxRate"));

		return "payment/invoice/newAdj";
	}

	@RequestMapping(value = "/selectNewAdjList.do")
	public ResponseEntity<HashMap<String,Object>> selectNewAdjList(@RequestParam Map<String, Object> params, ModelMap model) {
		HashMap <String, Object> returnValue = new HashMap<String, Object>();
		List<EgovMap> detail = null;

		LOGGER.debug("refNo : {}", params.get("refNo"));

		String refNo = String.valueOf(params.get("refNo")).trim();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("refNo", refNo);

		EgovMap master = invoiceService.selectNewAdjMaster(map).get(0);
		detail = invoiceService.selectNewAdjDetailList(map);

		for(int i=0; i<detail.size(); i++)
			LOGGER.debug("detail : {}", detail.get(i));

		returnValue.put("master", master);
		returnValue.put("detail", detail);

		return ResponseEntity.ok(returnValue);
	}


	/**
	* New CN/DN Request - Save
	* @param params
	* @param model
	* @return
	*/
	@RequestMapping(value = "/saveNewAdjList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveNewAdjList(@RequestBody Map<String, Object> params, ModelMap model , SessionVO sessionVO) {

	    LOGGER.debug("params =====================================>>  " + params);

		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		List<Object> apprGridList = (List<Object>) params.get("apprGridList"); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		//마스터 데이터
		String memoTypeId = String.valueOf(formData.get("adjType"));
		String invoiceType = String.valueOf(formData.get("hiddenInvoiceType"));
		String memoReason = String.valueOf(formData.get("adjReason"));
		String memoRemark = String.valueOf(formData.get("remark"));
		String atchFileGrpId = String.valueOf(formData.get("atchFileGrpId"));
		String adjustedTaxAmount = String.valueOf(formData.get("totalAdjustmentTax"));
		int conversion = Integer.parseInt(String.valueOf(formData.get("hiddenAccountConversion")));

		//parameter 변수 선언
		HashMap <String, Object> masterParamMap = null;
		HashMap <String, Object> detailParamMap = null;
		List<Object> detailParamList = new ArrayList<Object>();

		//마스터 데이터 세팅 : key 이름을 변경하기 위해 처리함
		masterParamMap = new HashMap<String, Object>();
		masterParamMap.put("memoAdjustTypeID", Integer.parseInt(memoTypeId));
		masterParamMap.put("memoAdjustInvoiceNo", String.valueOf(formData.get("invoiceNo")));
		masterParamMap.put("memoAdjustInvoiceTypeID", Integer.parseInt(invoiceType));
		masterParamMap.put("memoAdjustStatusID", 1);
		masterParamMap.put("memoAdjustReasonID",memoReason);
		masterParamMap.put("memoAdjustRemark", memoRemark);
		masterParamMap.put("memoAdjustCreator", sessionVO.getUserId());
		masterParamMap.put("memoAdjustCreatorName", sessionVO.getUserName());
		masterParamMap.put("batchId", 0);
		masterParamMap.put("atchFileGrpId", Integer.parseInt(atchFileGrpId));

		double totalTaxes = 0.0D;
		double totalAmount = 0.0D;


		//Detail 데이터 세팅
		if (gridList.size() > 0) {
			for (int i = 0; i < gridList.size(); i++) {
				Map<String, Object> gridMap = (Map<String, Object>) gridList.get(i);
				double itemAdjsutment = Double.parseDouble(String.valueOf(gridMap.get("totamount")));

				if(itemAdjsutment <= 0){
					continue;
				}

				EgovMap sstInfo = commonService.getSstRelatedInfo();
				detailParamMap = createAdjustmentDetailData(conversion,
																						itemAdjsutment,
																						String.valueOf(gridMap.get("txinvoiceitemtypeid")),
																						invoiceType,
																						memoTypeId,
																						String.valueOf(gridMap.get("txinvoiceitemid")),
																						String.valueOf(gridMap.get("billitemtaxcodeid")),
																						String.valueOf(gridMap.get("billitemtaxrate")),
																						String.valueOf(gridMap.get("billitemcharges")),
																						String.valueOf(gridMap.get("billitemqty")));

				//if (Double.parseDouble(String.valueOf(gridMap.get("billitemcharges"))) > 0 && Integer.parseInt(String.valueOf(gridMap.get("billitemtaxrate"))) == 6){
				//	totalTaxes += itemAdjsutment- (itemAdjsutment * 100 / 106);
				//}

				totalAmount += (itemAdjsutment * 100 / (100 + Integer.parseInt(String.valueOf(gridMap.get("billitemtaxrate")))));

				//리스트에 추가
				detailParamList.add(detailParamMap);

			}
		}

		//masterParamMap.put("memoAdjustTaxesAmount", 0);
		masterParamMap.put("memoAdjustTaxesAmount", adjustedTaxAmount);
		masterParamMap.put("memoAdjustTotalAmount", totalAmount);

		LOGGER.debug("params =====================================>>  " + masterParamMap);
		LOGGER.debug("params =====================================>>  " + detailParamList);
		LOGGER.debug("params =====================================>>  " + apprGridList);

		//저장처리
		String returnStr = invoiceService.saveNewAdjList(false,Integer.parseInt(memoTypeId), masterParamMap, detailParamList, apprGridList);

		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(returnStr);
    	message.setMessage("Adjustment successfully requested.");

    	return ResponseEntity.ok(message);
	}

	/******************************************************
	 *   AdjustmentCNDN
	 *****************************************************/
	/**
	 * AdjustmentCNDN초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initInvAdjCnDnPop.do")
	public String initInvInvoiceAdj(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/invAdjCnDnPop";
	}


	/******************************************************
	 *   Batch Adjustment CN/DN
	 *****************************************************/
	/**
	 * Batch Adjustment CN/DN 리스트 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBatchAdjCnDnListPop.do")
	public String initBatchAdjCnDn(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/batchAdjCnDnListPop";
	}

	/**
	* Batch New CN/DN Request - Save
	* @param params
	* @param model
	* @return
	*/
	@RequestMapping(value = "/saveBatchNewAdjList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveBatchNewAdjList(@RequestBody Map<String, Object> params, ModelMap model , SessionVO sessionVO) {

		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		List<Object> apprGridList = null;

		//마스터 데이터
		String memoTypeId = String.valueOf(formData.get("newAdjType"));
		String memoReason = String.valueOf(formData.get("newAdjReason"));
		String memoRemark = String.valueOf(formData.get("newRemark"));
		String atchFileGrpId = String.valueOf(formData.get("atchFileGrpId"));

		//파일 업로드된 grid 변수
		String memoAdjustInvoiceNo = "";
		String memoAdjustOrderNo = "";
		String memoAdjustItemNo = "";
		double memoAdjustAmount = 0.0D;
		String memoAdjustInstallmentMonth = "";
		String memoAdjustType = "";

		//Invoice 조회 parameter
		Map<String, Object> map = null;

		//Invoice 조회 결과
		EgovMap master = null;
		List<EgovMap> detail = null;

		//등록을 Parameter
		HashMap <String, Object> masterParamMap = null;
		HashMap <String, Object> detailParamMap = null;
		List<Object> detailParamList = null;

		//배치 아이디 생성
		int batchId = invoiceService.getAdjBatchId();

		//등록 parameter 세팅
		if (gridList.size() > 0) {
			for (int i = 0; i < gridList.size(); i++) {

				detailParamList = new ArrayList<Object>();
				Map<String, Object> gridMap = (Map<String, Object>) gridList.get(i);

				//첫번째 값이 없으면 skip
				if(gridMap.get("0") == null || String.valueOf(gridMap.get("0")).equals("") || String.valueOf(gridMap.get("0")).trim().length() < 1 ){
					continue;
				}

				memoAdjustInvoiceNo = String.valueOf(gridMap.get("0"));									//Invoice No.
				memoAdjustOrderNo = String.valueOf(gridMap.get("1"));										//Order No.
				memoAdjustItemNo = String.valueOf(gridMap.get("2"));										//Invoice Item No.
				memoAdjustAmount = Double.parseDouble(String.valueOf(gridMap.get("3")));			//Adjustment Amount
				memoAdjustInstallmentMonth = String.valueOf(gridMap.get("4"));//Installment Month
				memoAdjustType = String.valueOf(gridMap.get("5"));            //REN,RPF and etc

				map = new HashMap<String, Object>();
				map.put("refNo", memoAdjustInvoiceNo);
				map.put("invcItmOrdNo", memoAdjustOrderNo);
				map.put("txInvoiceItemId", memoAdjustItemNo);
				map.put("invcItmInstlmtNo", memoAdjustInstallmentMonth);
				map.put("billItemType", memoAdjustType);

				//그리드 데이터에 대한 adjustment 대상 마스터, 상세 데이터 조회
				master = invoiceService.selectNewAdjMaster(map).get(0);
				detail = invoiceService.selectNewAdjDetailList(map);

				double totalTaxes = 0.0D;
				double totalAmount = 0.0D;


				//마스터 데이터 세팅 : key 이름을 변경하기 위해 처리함
				masterParamMap = new HashMap<String, Object>();
				masterParamMap.put("memoAdjustTypeID", Integer.parseInt(memoTypeId));														//화면에서 입력받은 값
				masterParamMap.put("memoAdjustInvoiceNo", memoAdjustInvoiceNo);																//그리드에서 입력받은 값
				masterParamMap.put("memoAdjustInvoiceTypeID", Integer.parseInt(String.valueOf(master.get("txinvoicetypeid"))));	//조회된 Master 정보에서 추출한값
				masterParamMap.put("memoAdjustStatusID", 1);																							//고정값
				masterParamMap.put("memoAdjustReasonID",memoReason);																				//화면에서 입력받은 값
				masterParamMap.put("memoAdjustRemark", memoRemark);																				//화면에서 입력받은 값
				masterParamMap.put("memoAdjustCreator", sessionVO.getUserId());																	//세션값
				masterParamMap.put("batchId", batchId);
				masterParamMap.put("atchFileGrpId", Integer.parseInt(atchFileGrpId));

				//Detail 데이터 세팅
				if (detail.size() > 0) {
					for (int j = 0; j < detail.size(); j++) {
						Map<String, Object> detailMap = (Map<String, Object>) detail.get(j);

						double itemAdjsutment =memoAdjustAmount < Double.parseDouble(String.valueOf(detailMap.get("billitemamount"))) ?
																	memoAdjustAmount : Double.parseDouble(String.valueOf(detailMap.get("billitemamount"))) ;

						if(itemAdjsutment <= 0){
							continue;
						}

						detailParamMap = createAdjustmentDetailData(Integer.parseInt(String.valueOf(master.get("accountconversion"))),
																								itemAdjsutment,
																								String.valueOf(detailMap.get("txinvoiceitemtypeid")),
																								String.valueOf(master.get("txinvoicetypeid")),
																								memoTypeId,
																								String.valueOf(detailMap.get("txinvoiceitemid")),
																								String.valueOf(detailMap.get("billitemtaxcodeid")),
																								String.valueOf(detailMap.get("billitemtaxrate")),
																								String.valueOf(detailMap.get("billitemcharges")),
																								String.valueOf(detailMap.get("billitemqty")));

						//if (Double.parseDouble(String.valueOf(detailMap.get("billitemcharges"))) > 0 && Integer.parseInt(String.valueOf(detailMap.get("billitemtaxrate"))) == 6){
						//	totalTaxes += itemAdjsutment- (itemAdjsutment * 100 / 106);
						//}

						totalAmount += itemAdjsutment;

						//리스트에 추가
						detailParamList.add(detailParamMap);
					}
				}

				masterParamMap.put("memoAdjustTaxesAmount", 0);
				masterParamMap.put("memoAdjustTotalAmount", totalAmount);

				//저장처리
				invoiceService.saveNewAdjList(true,Integer.parseInt(memoTypeId), masterParamMap, detailParamList, apprGridList);

			}
		}

		apprGridList = (List<Object>) params.get("apprGridList");
        if(apprGridList.size() > 0) {
            HashMap<String, Object> hm = null;
            for(Object apprMap : apprGridList) {
                hm = (HashMap<String, Object>) apprMap;

                hm.put("userId", sessionVO.getUserId());
                hm.put("userName", sessionVO.getUserName());
                hm.put("memoAdjustId", "BCH" + String.valueOf(batchId));

                if("1".equals(hm.get("approveNo").toString())) {
                    hm.put("appvStus", "R");

                    String nextApprover = invoiceService.nextApprover(hm);

                    // insert notification
                    Map ntf = new HashMap<String, Object>();
                    ntf.put("code", "Batch Adj");
                    ntf.put("codeName", "CN/DN Batch Adjustment");
                    ntf.put("clmNo", "Batch Adj - " + String.valueOf(batchId));
                    ntf.put("appvStus", "R");
                    ntf.put("rejctResn", "Pending Approval.");
                    ntf.put("reqstUserId", nextApprover);
                    ntf.put("userId", sessionVO.getUserId());

                    invoiceService.insertNotification(ntf);
                } else {
                    hm.put("appvStus", "T");
                }

                invoiceService.insertAdjReqAppv(hm);
            }
        }

		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(batchId);
    	message.setMessage("Adjustment successfully requested.");

    	return ResponseEntity.ok(message);
	}

	/******************************************************
	 *   Approval Adjustment CN/DN
	 *****************************************************/
	/**
	 * Approval Adjustment CN/DN 리스트 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initApprovalAdjCnDnListPop.do")
	public String initApprovalAdjCnDnList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/approvalAdjCnDnListPop";
	}


	/**
	 * Approval Pop-up 초기화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initApprovalPop.do")
	public String initApprovalPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("adjId", params.get("adjId"));
		return "payment/invoice/approvalAdjPop";
	}


	/**
	* Approval Adjustment  - Approva / Reject
	* @param params
	* @param model
	* @return
	*/
	@RequestMapping(value = "/approvalAdjustment.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvalAdjustment(@RequestBody Map<String, Object> params, ModelMap model , SessionVO sessionVO) {

	    String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));

		//세션 정보
		params.put("userId", sessionVO.getUserId());
		params.put("memCode", memCode);
		EgovMap apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);
        if(apprDtls != null && "AO".equals(apprDtls.get("apprGrp").toString())) {
            params.put("apprGrp", apprDtls.get("apprGrp"));
        }

        params.put("appvStus", "APPROVE".equals(String.valueOf(params.get("process"))) ? "A" : "J");

        params.put("mode", "S");
        invoiceService.updateAdjApprovalLine(params);

        params.put("mode", "");
        invoiceService.updateAdjApprovalLine(params);

        invoiceService.updateAdjNextAppvLine(params);

        EgovMap apprLineList = (EgovMap) invoiceService.getAdjApprLine(params);
        String finalAppvStus = apprLineList.get("memoAppvStus").toString();

        params.put("mode", "C");
        apprLineList = (EgovMap) invoiceService.getAdjApprLine(params);
        String currentAppvStus = apprLineList.get("memoAppvStus").toString();

        if("A".equals(finalAppvStus) || "J".equals(currentAppvStus)) {
            //승인 or 반려 처리
            invoiceService.approvalAdjustment(params);
        }

        if(!"A".equals(finalAppvStus) && !"J".equals(finalAppvStus)) {
            params.put("mode", "NTF");
            apprLineList = (EgovMap) invoiceService.getAdjApprLine(params);
        }

        if(apprLineList != null) {
            Map ntf = new HashMap<String, Object>();
            ntf.put("code", "New Adj");
            ntf.put("codeName", "CN/DN Adjustment");
            ntf.put("clmNo", apprLineList.get("memoAdjRefNo"));

            if(!"J".equals(currentAppvStus)) {
                ntf.put("appvStus", "R");
                ntf.put("rejctResn", "Pending Approval.");
                ntf.put("reqstUserId", apprLineList.get("memoApprUserName"));
            } else {
                ntf.put("appvStus", "J");
                ntf.put("rejctResn", params.get("appvRem").toString());
                ntf.put("reqstUserId", apprLineList.get("memoReqstUserId"));
            }

            ntf.put("userId", sessionVO.getUserId());

            invoiceService.insertNotification(ntf);
        }

		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage("Adjustment successfully requested.");

    	return ResponseEntity.ok(message);
	}

	/**
	* Approval Adjustment  - Approva / Reject
	* @param params
	* @param model
	* @return
	*/
    @RequestMapping(value = "/approvalBatchAdjustment.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> approvalBatchAdjustment(@RequestBody Map<String, Object> params, ModelMap model , SessionVO sessionVO) {

        String memCode = webInvoiceService.selectHrCodeOfUserId(String.valueOf(sessionVO.getUserId()));
        params.put("memCode", memCode);
        EgovMap apprDtls = (EgovMap) webInvoiceService.getApprGrp(params);

        List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
        Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

        Map<String, Object> approvaParam = null;

        LOGGER.debug("process : {}", formData.get("process"));

        //Detail 데이터 세팅
        if (gridList.size() > 0) {
            Map<String, Object> apprMap = new HashMap<String, Object>();
            Map<String, Object> apprLineGridMap = (Map<String, Object>) gridList.get(0);
            String apprBatchId = "BCH" + apprLineGridMap.get("batchId").toString();
            apprMap.put("batchId", apprBatchId);
            apprMap.put("memCode", memCode);
            apprMap.put("appvStus", "APPROVE".equals(formData.get("process").toString()) ? "A" : "J");
            apprMap.put("userId", sessionVO.getUserId());
            apprMap.put("appvRem", formData.get("appvRem").toString());

            if(apprDtls != null && "AO".equals(apprDtls.get("apprGrp").toString())) {
                apprMap.put("apprGrp", apprDtls.get("apprGrp"));
            }

            apprMap.put("mode", "S");
            invoiceService.updateAdjApprovalLine(apprMap);

            apprMap.put("mode", "");
            invoiceService.updateAdjApprovalLine(apprMap);

            invoiceService.updateAdjNextAppvLine(apprMap);

            EgovMap apprLineList = (EgovMap) invoiceService.getAdjApprLine(apprMap);
            String finalAppvStus = apprLineList.get("memoAppvStus").toString();

            apprMap.put("mode", "C");
            apprLineList = (EgovMap) invoiceService.getAdjApprLine(apprMap);
            String currentAppvStus = apprLineList.get("memoAppvStus").toString();

            if("A".equals(finalAppvStus) || "J".equals(currentAppvStus)) {
                  for (int i = 0; i < gridList.size(); i++) {
                        Map<String, Object> gridMap = (Map<String, Object>) gridList.get(i);

                        approvaParam = new HashMap<String, Object>();

                        approvaParam.put("batchId", gridMap.get("batchId"));
                        approvaParam.put("adjId", gridMap.get("memoAdjId"));
                        approvaParam.put("invoiceType", gridMap.get("memoAdjInvcTypeId"));
                        approvaParam.put("memoAdjTypeId", gridMap.get("memoAdjTypeId"));
                        approvaParam.put("invoiceNo", gridMap.get("memoAdjInvcNo"));
                        approvaParam.put("process", formData.get("process"));
                        approvaParam.put("userId", sessionVO.getUserId());
                        approvaParam.put("memCode", memCode);

                        //승인 or 반려 처리
                        invoiceService.approvalAdjustment(approvaParam);
                    }
            }

            if(!"A".equals(finalAppvStus) && !"J".equals(finalAppvStus)) {
                apprMap.put("mode", "NTF");
                apprLineList = (EgovMap) invoiceService.getAdjApprLine(apprMap);
            }

            if(apprLineList != null) {
                Map ntf = new HashMap<String, Object>();
                ntf.put("code", "Batch Adj");
                ntf.put("codeName", "CN/DN Batch Adjustment");
                ntf.put("clmNo", "Batch Adj - " + apprLineGridMap.get("batchId").toString());

                if(!"J".equals(currentAppvStus)) {
                    ntf.put("appvStus", "R");
                    ntf.put("rejctResn", "Pending Approval.");
                    ntf.put("reqstUserId", apprLineList.get("memoApprUserName"));
                } else {
                    ntf.put("appvStus", "J");
                    ntf.put("rejctResn", formData.get("appvRem").toString());
                    ntf.put("reqstUserId", apprLineList.get("memoReqstUserId"));
                }

                ntf.put("userId", sessionVO.getUserId());

                invoiceService.insertNotification(ntf);
            }
        }

		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData("");
    	message.setMessage("Adjustment successfully requested.");

    	return ResponseEntity.ok(message);
	}

	/**
	 *
	 * @param conversion
	 * @param itemAdjsutment
	 * @param invoiceType
	 * @param memoTypeId
	 * @param txInvoiceItemId
	 * @param billItemTaxCodeId
	 * @param billItemTaxRate
	 * @param billItemCharges
	 * @param billItemQty
	 * @throws Exception
	 */
	public HashMap<String, Object> createAdjustmentDetailData(int conversion,
															double itemAdjsutment,
															String txInvoiceItemTypeId,
                                                			String invoiceType,
                                                			String memoTypeId,
                                                			String txInvoiceItemId,
                                                			String billItemTaxCodeId,
                                                			String billItemTaxRate,
                                                			String billItemCharges,
                                                			String billItemQty) {
		HashMap<String, Object> returnParam = new  HashMap<String, Object>();



            int invoiceItemTypeId  = Integer.parseInt(txInvoiceItemTypeId);
            //LOGGER.debug("invoiceItemTypeId : {}", gridMap.get("txinvoiceitemtypeid"));

            returnParam.put("memoAdjustID", 0);
            returnParam.put("MemoItemInvoiceItemID", Integer.parseInt(txInvoiceItemId));

            if (conversion == 0){
            	// suspend Account
            	if (Integer.parseInt(invoiceType)  == 128){
            		// MISC
            		HashMap <String, Object> accParam = new HashMap<String, Object>();
            		accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            		accParam.put("invoiceType", Integer.parseInt(invoiceType));
            		accParam.put("invoiceItemTypeId", invoiceItemTypeId);
//            		EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
//
//            		returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
//            		returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));

            	} else if (Integer.parseInt(invoiceType) == 127) {
            		//Outright
            		if (Integer.parseInt(memoTypeId)  == 1293){
            			// CN
            			returnParam.put("memoItemCreditAccID",38);
            			returnParam.put("memoItemDebitAccID",535);
            		}else {
            			//DN
            			returnParam.put("memoItemCreditAccID",535);
            			returnParam.put("memoItemDebitAccID",38);
            		}
            	} else if (Integer.parseInt(invoiceType)== 126) {
            		//Rental
            		if (Integer.parseInt(memoTypeId) == 1293) {
            			// CN
            			if (invoiceItemTypeId == 1279){
            				returnParam.put("memoItemCreditAccID",42);
            				returnParam.put("memoItemDebitAccID",534);
            			}else if (invoiceItemTypeId == 1280){
            				returnParam.put("memoItemCreditAccID",42);
            				returnParam.put("memoItemDebitAccID",536);
            			}else if (invoiceItemTypeId == 1281){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
//            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
//
//            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
//            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}else if (invoiceItemTypeId == 1326){
            				returnParam.put("memoItemCreditAccID",46);
            				returnParam.put("memoItemDebitAccID",543);
            			}else if (invoiceItemTypeId == 1327){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
//            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
//
//            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
//            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}else if (invoiceItemTypeId == 1328){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
//            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
//
//            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
//            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}
            		}else {
            			// DN
            			if (invoiceItemTypeId == 1279){
            				returnParam.put("memoItemCreditAccID",534);
            				returnParam.put("memoItemDebitAccID",42);
            			}else if (invoiceItemTypeId == 1280){
            				returnParam.put("memoItemCreditAccID",536);
            				returnParam.put("memoItemDebitAccID",42);
            			}else if (invoiceItemTypeId == 1281){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
//            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
//
//            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
//            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}else if (invoiceItemTypeId == 1326){
            				returnParam.put("memoItemCreditAccID",543);
            				returnParam.put("memoItemDebitAccID",46);
            			}else if (invoiceItemTypeId == 1327){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
//            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
//
//            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
//            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}else if (invoiceItemTypeId == 1328){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
//            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
//
//            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
//            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}
            		}
            	}
            } else {
            	// Settlement Account
            	HashMap <String, Object> accParam = new HashMap<String, Object>();
            	accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            	accParam.put("invoiceType", Integer.parseInt(invoiceType));
            	accParam.put("invoiceItemTypeId", invoiceItemTypeId);
//            	EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
//
//            	returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
//            	returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            }

            returnParam.put("memoItemTaxCodeID", Integer.parseInt(billItemTaxCodeId));
            returnParam.put("memoItemStatusID", 1);
            returnParam.put("memoItemRemark", "");
            returnParam.put("memoItemGSTRate", billItemTaxRate);
            //returnParam.put("memoItemAmount", itemAdjsutment);

           // if (Double.parseDouble(billItemCharges) > 0 && Integer.parseInt(billItemTaxRate) == 6){
           // 	returnParam.put("memoItemCharges", itemAdjsutment * 100 / 106);
           // 	returnParam.put("memoItemTaxes", itemAdjsutment- (itemAdjsutment * 100 / 106));

            	//totalTaxes += itemAdjsutment- (itemAdjsutment * 100 / 106);

            //} else {
            EgovMap sstInfo = commonService.getSstRelatedInfo();
            double totalTaxes = 0.00;
            double itemCharges = 0.00;
            itemCharges = itemAdjsutment;

            if (Integer.parseInt(billItemTaxRate) > 0 && Integer.parseInt(billItemTaxRate) == 8){
            	totalTaxes = itemAdjsutment- (itemAdjsutment * 100 / (100 + Integer.parseInt(billItemTaxRate)));
            	itemCharges = (itemAdjsutment * 100 / (100 + Integer.parseInt(billItemTaxRate)));
            	returnParam.put("memoItemTaxCodeID", sstInfo.get("codeId").toString());
            }
            returnParam.put("memoItemTaxes", totalTaxes);
            returnParam.put("memoItemCharges", itemCharges);
            //returnParam.put("memoItemCharges", (itemAdjsutment * 100 / (100 + Integer.parseInt(billItemTaxRate)))); //to run reverse calculation only when taxrate = 8
            returnParam.put("memoItemAmount", (itemAdjsutment));
        	//returnParam.put("memoItemTaxes",0);
           // }

            //totalAmount += itemAdjsutment;
            returnParam.put("memoItemInvoiceItmQty", Integer.parseInt(billItemQty));

        return returnParam;
    }



	@RequestMapping(value = "/selectAdjustmentExcelList.do")
	public void selectAdjustmentExcelList(HttpServletRequest request, HttpServletResponse response) {

		ExcelDownloadHandler downloadHandler = null;

		try {

            Map<String, Object> map = new HashMap<String, Object>();
    		map.put("status", request.getParameter("status") == null ? "4" :  request.getParameter("status"));
    		map.put("date1", request.getParameter("date1") == null ? "01/01/1900" :  request.getParameter("date1"));
    		map.put("date2", request.getParameter("date2") == null ? "01/01/1900" :  request.getParameter("date2"));

    		String[] columns;
            String[] titles;

            columns = new String[] { "code","invcItmOrdNo","memoAdjRefNo","memoAdjInvcNo","resnDesc","memoItmAmt","userName","deptName","memoAdjCrtDt","updUserName","memoAdjUpdDt","memoAdjRem" };
			titles = new String[] {"TYPE","ORDER NO","ADJUSTMENT NO","INVOICE NO","REASON","ADJ. AMOUNT","REQUESTOR", "DEPARTMENT", "CREATE DATE", "FINAL APPROVAL", "FINAL APPROVAL DATE","MEMO REMARK" };

			downloadHandler = getExcelDownloadHandler(response, "InvoiceAdjustmentSummary.xlsx", columns, titles);

			largeExcelService.downloadInvcAdjExcelList(map, downloadHandler);

		} catch (Exception ex) {
			throw new ApplicationException(ex, AppConstants.FAIL);
		} finally {
			if (downloadHandler != null) {
				try {
					downloadHandler.close();
				} catch (Exception ex) {
					LOGGER.info(ex.getMessage());
				}
			}
		}
	}

	private ExcelDownloadHandler getExcelDownloadHandler(HttpServletResponse response, String fileName,
			String[] columns, String[] titles) {
		ExcelDownloadVO excelDownloadVO = ExcelDownloadFormDef.getExcelDownloadVO(fileName, columns, titles);
		return new ExcelDownloadHandler(excelDownloadVO, response);
	}

	@RequestMapping(value = "/countAdjustmentExcelList.do")
	public ResponseEntity<Integer> countAdjustmentExcelList(@RequestParam Map<String, Object> params, ModelMap model) {

		int cnt = invoiceService.countAdjustmentExcelList(params);
		return ResponseEntity.ok(cnt);
	}

    @RequestMapping(value = "/attachmentUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> attachmentUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

        LOGGER.debug("========== attachmentUpload ==========");
        LOGGER.debug("params ==========>>  " + params);

        List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
                File.separator + "payment" + File.separator + "invoicesAdj", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

        LOGGER.debug("list.size : {}", list.size());

        params.put(CommonConstants.USER_ID, sessionVO.getUserId());

        if (list.size() > 0) {
            invoiceAdjApplication.insertInvoiceAdjAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params);
        }

        params.put("attachmentList", list);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setData(params);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        return ResponseEntity.ok(message);
    }

    @RequestMapping(value = "/checkFinAppr.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> checkFinAppr(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("params =====================================>>  " + params);

        ReturnMessage message = new ReturnMessage();

        List<Object> apprGridList = (List<Object>) params.get("apprGridList");

        if(apprGridList.size() > 0) {
            Map hm = null;
            List<String> appvLineUserId = new ArrayList<>();

            for(Object map : apprGridList) {
                hm = (HashMap<String, Object>) map;
                appvLineUserId.add(hm.get("memCode").toString());
            }

            EgovMap hm2 = invoiceService.getFinApprover();
            String memCode = hm2.get("apprMemCode").toString();

            memCode = CommonUtils.isEmpty(memCode) ? "0" : memCode;
            if(!appvLineUserId.contains(memCode)) {
                message.setCode(AppConstants.FAIL);
                message.setData(params);
                message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
            } else {
                message.setCode(AppConstants.SUCCESS);
                message.setData(params);
                message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
            }
        }

        return ResponseEntity.ok(message);
    }
}