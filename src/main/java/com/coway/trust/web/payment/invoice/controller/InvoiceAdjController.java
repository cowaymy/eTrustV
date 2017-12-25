package com.coway.trust.web.payment.invoice.controller;

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
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.biz.payment.invoice.service.InvoiceAdjService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.common.excel.download.ExcelDownloadFormDef;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class InvoiceAdjController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InvoiceAdjController.class);
	
	@Resource(name = "invoiceAdjService")
	private InvoiceAdjService invoiceService;
	
	@Autowired
	private LargeExcelService largeExcelService;
	
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
	public ResponseEntity<List<EgovMap>> selectInvoiceList(@RequestParam Map<String, Object> params, ModelMap model) {	
		
		List<EgovMap> list = invoiceService.selectInvoiceAdj(params);		
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
	public ResponseEntity<HashMap<String,Object>> selectAdjustmentDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {	
		
		LOGGER.debug("adjId : {}", params.get("adjId"));
		
		EgovMap master = invoiceService.selectAdjDetailPopMaster(params);					//마스터 데이터 조회
		List<EgovMap> detailList = invoiceService.selectAdjDetailPopList(params);		//상세 리스트 조회
		List<EgovMap> histlList = invoiceService.selectAdjDetailPopHist(params);		//히스토리 조회
		
		HashMap <String, Object> returnValue = new HashMap<String, Object>();
		returnValue.put("master", master);		
		returnValue.put("detailList", detailList);
		returnValue.put("histlList", histlList);
		
		return ResponseEntity.ok(returnValue);
	}
	
	/**
	 * Adjustment Batch Approval Pop-up 정보조회
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectAdjustmentBatchApprovalPop.do", method = RequestMethod.GET)
	public ResponseEntity<HashMap<String,Object>> selectAdjustmentBatchApprovalPop(@RequestParam Map<String, Object> params, ModelMap model) {	
		
		LOGGER.debug("batchId : {}", params.get("batchId"));
		
		EgovMap master = invoiceService.selectAdjBatchApprovalPopMaster(params);					//마스터 데이터 조회
		List<EgovMap> detailList = invoiceService.selectAdjBatchApprovalPopDetail(params);		//상세 리스트 조회
		List<EgovMap> histlList = invoiceService.selectAdjBatchApprovalPopHist(params);		//히스토리 조회
		
		HashMap <String, Object> returnValue = new HashMap<String, Object>();
		returnValue.put("master", master);		
		returnValue.put("detailList", detailList);
		returnValue.put("histlList", histlList);
		
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

		model.addAttribute("refNo", params.get("refNo"));
		
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
		
		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
	
		//마스터 데이터 
		String memoTypeId = String.valueOf(formData.get("adjType"));
		String invoiceType = String.valueOf(formData.get("hiddenInvoiceType"));		
		String memoReason = String.valueOf(formData.get("adjReason"));
		String memoRemark = String.valueOf(formData.get("remark"));
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
		masterParamMap.put("batchId", 0);

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
						
				if (Double.parseDouble(String.valueOf(gridMap.get("billitemcharges"))) > 0){
					totalTaxes += itemAdjsutment- (itemAdjsutment * 100 / 106);
				} 
				
				totalAmount += itemAdjsutment;
				
				//리스트에 추가
				detailParamList.add(detailParamMap);
				
			}
		}
		
		masterParamMap.put("memoAdjustTaxesAmount", totalTaxes);
		masterParamMap.put("memoAdjustTotalAmount", totalAmount);
		
		//저장처리
		String returnStr = invoiceService.saveNewAdjList(false,Integer.parseInt(memoTypeId), masterParamMap, detailParamList);		

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
	
		//마스터 데이터 
		String memoTypeId = String.valueOf(formData.get("newAdjType"));
		String memoReason = String.valueOf(formData.get("newAdjReason"));
		String memoRemark = String.valueOf(formData.get("newRemark"));
				
		//파일 업로드된 grid 변수 
		String memoAdjustInvoiceNo = "";
		String memoAdjustOrderNo = "";
		String memoAdjustItemNo = "";
		double memoAdjustAmount = 0.0D;
		
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
				
				map = new HashMap<String, Object>();
				map.put("refNo", memoAdjustInvoiceNo);				
				map.put("invcItmOrdNo", memoAdjustOrderNo);
				map.put("txInvoiceItemId", memoAdjustItemNo);
				
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
								
						if (Double.parseDouble(String.valueOf(detailMap.get("billitemcharges"))) > 0){
							totalTaxes += itemAdjsutment- (itemAdjsutment * 100 / 106);
						} 
						
						totalAmount += itemAdjsutment;
						
						//리스트에 추가
						detailParamList.add(detailParamMap);
					}
				}
				
				masterParamMap.put("memoAdjustTaxesAmount", totalTaxes);
				masterParamMap.put("memoAdjustTotalAmount", totalAmount);
				
				//저장처리
				invoiceService.saveNewAdjList(true,Integer.parseInt(memoTypeId), masterParamMap, detailParamList);
				
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
		
		//세션 정보 
		params.put("userId", sessionVO.getUserId());
		
		//승인 or 반려 처리
		invoiceService.approvalAdjustment(params);

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
		
		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
		Map<String, Object> approvaParam = null;
		
		LOGGER.debug("process : {}", formData.get("process"));
		
		//Detail 데이터 세팅
		if (gridList.size() > 0) {
			for (int i = 0; i < gridList.size(); i++) {
				Map<String, Object> gridMap = (Map<String, Object>) gridList.get(i);
			           
				approvaParam = new HashMap<String, Object>();
				
				approvaParam.put("adjId", gridMap.get("memoAdjId"));
				approvaParam.put("invoiceType", gridMap.get("memoAdjInvcTypeId"));
				approvaParam.put("memoAdjTypeId", gridMap.get("memoAdjTypeId"));
				approvaParam.put("invoiceNo", gridMap.get("memoAdjInvcNo"));
				approvaParam.put("process", formData.get("process"));
				approvaParam.put("userId", sessionVO.getUserId());
				
				//승인 or 반려 처리
				invoiceService.approvalAdjustment(approvaParam);		
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
            		EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
            
            		returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
            		returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            
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
            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
            
            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}else if (invoiceItemTypeId == 1326){
            				returnParam.put("memoItemCreditAccID",46);
            				returnParam.put("memoItemDebitAccID",543);
            			}else if (invoiceItemTypeId == 1327){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
            
            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}else if (invoiceItemTypeId == 1328){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
            
            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
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
            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
            
            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}else if (invoiceItemTypeId == 1326){
            				returnParam.put("memoItemCreditAccID",543);
            				returnParam.put("memoItemDebitAccID",46);
            			}else if (invoiceItemTypeId == 1327){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
            
            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}else if (invoiceItemTypeId == 1328){
            				HashMap <String, Object> accParam = new HashMap<String, Object>();
            				accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            				accParam.put("invoiceType", Integer.parseInt(invoiceType));
            				accParam.put("invoiceItemTypeId", invoiceItemTypeId);
            				EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
            
            				returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
            				returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            			}
            		}
            	}
            } else {
            	// Settlement Account 
            	HashMap <String, Object> accParam = new HashMap<String, Object>();
            	accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
            	accParam.put("invoiceType", Integer.parseInt(invoiceType));
            	accParam.put("invoiceItemTypeId", invoiceItemTypeId);
            	EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(accParam);
            
            	returnParam.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
            	returnParam.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
            } 
            
            returnParam.put("memoItemTaxCodeID", Integer.parseInt(billItemTaxCodeId));
            returnParam.put("memoItemStatusID", 1);
            returnParam.put("memoItemRemark", "");
            returnParam.put("memoItemGSTRate", Integer.parseInt(billItemTaxRate));
            returnParam.put("memoItemAmount", itemAdjsutment);
            
            if (Double.parseDouble(billItemCharges) > 0){
            	returnParam.put("memoItemCharges", itemAdjsutment * 100 / 106);
            	returnParam.put("memoItemTaxes", itemAdjsutment- (itemAdjsutment * 100 / 106));
            
            	//totalTaxes += itemAdjsutment- (itemAdjsutment * 100 / 106);
            
            } else {
            	returnParam.put("memoItemCharges", itemAdjsutment);                
            	returnParam.put("memoItemTaxes",0);
            }
            
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
			
            columns = new String[] { "code","invcItmOrdNo","memoAdjRefNo","memoAdjInvcNo","resnDesc","memoItmAmt","userName","deptName","memoAdjCrtDt","updUserName","memoAdjUpdDt" };            
			titles = new String[] {"TYPE","ORDER NO","ADJUSTMENT NO","INVOICE NO","REASON","ADJ. AMOUNT","REQUESTOR", "DEPARTMENT", "CREATE DATE", "FINAL APPROVAL", "FINAL APPROVAL DATE" };
			
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
}