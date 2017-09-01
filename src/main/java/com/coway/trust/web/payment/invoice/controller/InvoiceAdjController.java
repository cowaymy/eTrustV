package com.coway.trust.web.payment.invoice.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billinggroup.service.BillingInvoiceService;
import com.coway.trust.biz.payment.invoice.service.InvoiceAdjService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class InvoiceAdjController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InvoiceAdjController.class);
	
	@Resource(name = "invoiceAdjService")
	private InvoiceAdjService invoiceService;
	
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
		List<EgovMap> list = null;
		
		LOGGER.debug("params : {}", params);
		
		String orderNo = String.valueOf(params.get("orderNo")).trim();
		String status = String.valueOf(params.get("status"));
		String invoiceNo = String.valueOf(params.get("invoiceNo")).trim();
		String adjNo = String.valueOf(params.get("adjNo")).trim();
		String reportNo = String.valueOf(params.get("reportNo")).trim();
		String creator = String.valueOf(params.get("creator"));
		String date1 = String.valueOf(params.get("date1"));
		if(date1 != "null" && date1 != ""){
			String tmp[] = date1.split("/");
			date1 = tmp[2] + "/" + tmp[1] + "/" + tmp[0] + " 00:00:00";
		}
		String date2 = String.valueOf(params.get("date2"));
		if(date2 != "null" && date2 != ""){
			String tmp[] = date2.split("/");
			date2 = tmp[2] + "/" + tmp[1] + "/" + tmp[0] + " 00:00:00";
		}
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("orderNo", orderNo);
		map.put("status", status);
		map.put("invoiceNo", invoiceNo);
		map.put("adjNo", adjNo);
		map.put("reportNo", reportNo);
		map.put("creator", creator);
		map.put("date1", date1);
		map.put("date2", date2);
		
		LOGGER.debug("map : {} ", map);
		
		list = invoiceService.selectInvoiceAdj(map);
		
		return ResponseEntity.ok(list);
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
		HashMap <String, Object> returnValue = new HashMap();
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
		HashMap <String, Object> returnValue = new HashMap<String, Object>();

		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
	
		//마스터 데이터 
		String memoTypeId = String.valueOf(formData.get("adjType"));
		String invoiceType = String.valueOf(formData.get("hiddenInvoiceType"));
		String salesOrderId = String.valueOf(formData.get("hiddenSalesOrderId"));
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


		int invoiceItemTypeId  = 0;
		double totalTaxes = 0.0D;
		double totalAmount = 0.0D;		

		//Detail 데이터 세팅
		if (gridList.size() > 0) {
			for (int i = 0; i < gridList.size(); i++) {

				Map<String, Object> gridMap = (Map<String, Object>) gridList.get(i);
				double itemAdjsutment = Double.parseDouble(String.valueOf(gridMap.get("totamount")));

				if (itemAdjsutment > 0){

					invoiceItemTypeId  = Integer.parseInt(String.valueOf(gridMap.get("txinvoiceitemtypeid")));
					
					LOGGER.debug("invoiceItemTypeId : {}", gridMap.get("txinvoiceitemtypeid"));

					detailParamMap = new  HashMap<String, Object>();
					detailParamMap.put("memoAdjustID", 0);
					detailParamMap.put("MemoItemInvoiceItemID", Integer.parseInt(String.valueOf(gridMap.get("txinvoiceitemid"))));

					if (conversion == 0){
						// suspend Account
						if (Integer.parseInt(invoiceType)  == 128){ 
							// MISC
							HashMap <String, Object> accParam = new HashMap<String, Object>();
							accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
							accParam.put("invoiceType", Integer.parseInt(invoiceType));
							accParam.put("invoiceItemTypeId", invoiceItemTypeId);
							EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(params);

							detailParamMap.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
							detailParamMap.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));

						} else if (Integer.parseInt(invoiceType) == 127) {
							//Outright
							if (Integer.parseInt(memoTypeId)  == 1293){ 
								// CN
								detailParamMap.put("memoItemCreditAccID",38);
								detailParamMap.put("memoItemDebitAccID",535);
							}else {
								//DN
								detailParamMap.put("memoItemCreditAccID",535);
								detailParamMap.put("memoItemDebitAccID",38);
							}
						} else if (Integer.parseInt(invoiceType)== 126) {
							//Rental
							if (Integer.parseInt(memoTypeId) == 1293) { 
								// CN
								if (invoiceItemTypeId == 1279){
									detailParamMap.put("memoItemCreditAccID",42);
									detailParamMap.put("memoItemDebitAccID",534);
								}else if (invoiceItemTypeId == 1280){
									detailParamMap.put("memoItemCreditAccID",42);
									detailParamMap.put("memoItemDebitAccID",536);
								}else if (invoiceItemTypeId == 1281){
									HashMap <String, Object> accParam = new HashMap<String, Object>();
									accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
									accParam.put("invoiceType", Integer.parseInt(invoiceType));
									accParam.put("invoiceItemTypeId", invoiceItemTypeId);
									EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(params);

									detailParamMap.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
									detailParamMap.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
								}else if (invoiceItemTypeId == 1326){
									detailParamMap.put("memoItemCreditAccID",46);
									detailParamMap.put("memoItemDebitAccID",543);
								}else if (invoiceItemTypeId == 1327){
									HashMap <String, Object> accParam = new HashMap<String, Object>();
									accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
									accParam.put("invoiceType", Integer.parseInt(invoiceType));
									accParam.put("invoiceItemTypeId", invoiceItemTypeId);
									EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(params);

									detailParamMap.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
									detailParamMap.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
								}else if (invoiceItemTypeId == 1328){
									HashMap <String, Object> accParam = new HashMap<String, Object>();
									accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
									accParam.put("invoiceType", Integer.parseInt(invoiceType));
									accParam.put("invoiceItemTypeId", invoiceItemTypeId);

									EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(params);


									detailParamMap.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
									detailParamMap.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
								}
							}else {
								// DN
								if (invoiceItemTypeId == 1279){
									detailParamMap.put("memoItemCreditAccID",534);
									detailParamMap.put("memoItemDebitAccID",42);
								}else if (invoiceItemTypeId == 1280){
									detailParamMap.put("memoItemCreditAccID",536);
									detailParamMap.put("memoItemDebitAccID",42);
								}else if (invoiceItemTypeId == 1281){
									HashMap <String, Object> accParam = new HashMap<String, Object>();
									accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
									accParam.put("invoiceType", Integer.parseInt(invoiceType));
									accParam.put("invoiceItemTypeId", invoiceItemTypeId);
									EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(params);

									detailParamMap.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
									detailParamMap.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
								}else if (invoiceItemTypeId == 1326){
									detailParamMap.put("memoItemCreditAccID",543);
									detailParamMap.put("memoItemDebitAccID",46);
								}else if (invoiceItemTypeId == 1327){
									HashMap <String, Object> accParam = new HashMap<String, Object>();
									accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
									accParam.put("invoiceType", Integer.parseInt(invoiceType));
									accParam.put("invoiceItemTypeId", invoiceItemTypeId);
									EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(params);

									detailParamMap.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
									detailParamMap.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
								}else if (invoiceItemTypeId == 1328){
									HashMap <String, Object> accParam = new HashMap<String, Object>();
									accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
									accParam.put("invoiceType", Integer.parseInt(invoiceType));
									accParam.put("invoiceItemTypeId", invoiceItemTypeId);
									EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(params);

									detailParamMap.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
									detailParamMap.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
								}
							}
						}
					} else {
						// Settlement Account 
						HashMap <String, Object> accParam = new HashMap<String, Object>();
						accParam.put("memoTypeId", Integer.parseInt(memoTypeId));
						accParam.put("invoiceType", Integer.parseInt(invoiceType));
						accParam.put("invoiceItemTypeId", invoiceItemTypeId);
						EgovMap accReturn = invoiceService.getAdjustmentCnDnAccId(params);

						detailParamMap.put("memoItemCreditAccID",accReturn.get("adjSetCrAccId"));
						detailParamMap.put("memoItemDebitAccID",accReturn.get("adjSetDrAccId"));
					} 

					detailParamMap.put("memoItemTaxCodeID", Integer.parseInt(String.valueOf(gridMap.get("billitemtaxcodeid"))));
					detailParamMap.put("memoItemStatusID", 1);
					detailParamMap.put("memoItemRemark", "");
					detailParamMap.put("memoItemGSTRate", Integer.parseInt(String.valueOf(gridMap.get("billitemtaxrate"))));
					detailParamMap.put("memoItemAmount", itemAdjsutment);

					if (Double.parseDouble(String.valueOf(gridMap.get("billitemcharges"))) > 0){
						detailParamMap.put("memoItemCharges", itemAdjsutment * 100 / 106);
						detailParamMap.put("memoItemTaxes", itemAdjsutment- (itemAdjsutment * 100 / 106));
						
						totalTaxes += itemAdjsutment- (itemAdjsutment * 100 / 106);

					} else {
						detailParamMap.put("memoItemCharges", itemAdjsutment);                
						detailParamMap.put("memoItemTaxes",0);
					}
					
					totalAmount += itemAdjsutment;					
					detailParamMap.put("memoItemInvoiceItmQty", Integer.parseInt(String.valueOf(gridMap.get("billitemqty"))));
					
					//리스트에 추가
					detailParamList.add(detailParamMap);
				}
			}
		}
		
		masterParamMap.put("memoAdjustTaxesAmount", totalTaxes);
		masterParamMap.put("memoAdjustTotalAmount", totalAmount);
		
		//저장처리
		String returnStr = invoiceService.saveNewAdjList(Integer.parseInt(memoTypeId), masterParamMap, detailParamList);		

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
	@RequestMapping(value = "/initInvAdjCnDn.do")
	public String initInvInvoiceAdj(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/invoice/invAdjCnDn";
	}
}

	

