package com.coway.trust.web.payment.otherpayment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.otherpayment.service.BankStatementService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BankStatementController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BankStatementController.class);
	
	@Resource(name = "bankStatementService")
	private BankStatementService bankStatementService;	
		
	/******************************************************
	 *  Bank Statement List 
	 *****************************************************/	
	/**
	 *  Bank Statement List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initUploadBankStatementList.do")
	public String initUploadBankStatementList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/otherpayment/uploadBankStatementList";
	}
	
	/**
	 * Bank Statement Master List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectBankStatementMasterList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectBankStatementMasterList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestBody Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {} ", params);
        // 조회.
        List<EgovMap> resultList = bankStatementService.selectBankStatementMasterList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * Bank Statement Detail List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectBankStatementDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBankStatementDetailList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {
        // 조회.
        List<EgovMap> resultList = bankStatementService.selectBankStatementDetailList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	* BBank Statement Upload
	* @param params
	* @param model
	* @return
	*/
	@RequestMapping(value = "/uploadBankStatement.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> uploadBankStatement(@RequestBody Map<String, Object> params, ModelMap model , SessionVO sessionVO) {	
		
		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
		//Item map
		Map<String, Object> itemMap = null;
		List<Object> itemList = new ArrayList<Object>();
		
		//등록 parameter 세팅 
		if (gridList.size() > 0) {
			Map<String, Object> gridMap = null;
			
			for (int i = 0; i < gridList.size(); i++) {
				
				gridMap = (Map<String, Object>) gridList.get(i);
				
				//첫번째 값이 없으면 skip
				if(gridMap.get("0") == null || String.valueOf(gridMap.get("0")).equals("") || String.valueOf(gridMap.get("0")).trim().length() < 1 ){					
					continue;
				}
			
				itemMap = new HashMap<String, Object>();
				itemMap.put("fTrnscDt", formData.get("uploadTranDt"));			
				itemMap.put("fTrnscTellerId", String.valueOf(gridMap.get("0")));	// Teller ID -> Ref / Cheq No 으로 title 변경
				itemMap.put("fTrnscRef3", String.valueOf(gridMap.get("1")));		// Transaction Code -> Description1 으로 title 변경
				itemMap.put("fTrnscRefChqNo", String.valueOf(gridMap.get("2")));		//Ref/Cheq No -> Description 2 으로 title 변경
				itemMap.put("fTrnscRef1", String.valueOf(gridMap.get("3")));		//Description -> ref5 으로 title 변경
				itemMap.put("fTrnscRef2", String.valueOf(gridMap.get("4")));		//ref6
				itemMap.put("fTrnscRef6", String.valueOf(gridMap.get("5")));		//ref7
				itemMap.put("fTrnscRem", String.valueOf(gridMap.get("6")));		//TYPE
				String debit = CommonUtils.isEmpty(gridMap.get("7")) ? "0" : String.valueOf(gridMap.get("7")).replace(",", "");
				String credit = CommonUtils.isEmpty(gridMap.get("8")) ? "0" : String.valueOf(gridMap.get("8")).replace(",", "");
				itemMap.put("fTrnscDebtAmt", debit);	//DEBIT
				itemMap.put("fTrnscCrditAmt", credit);	//CREDIT
				itemMap.put("fTrnscRef4", String.valueOf(gridMap.get("9")));	//Deposit Slip No / EFT / MID
				itemMap.put("fTrnscNewChqNo", String.valueOf(gridMap.get("10")));		// Chq No
				itemMap.put("fTrnscRefVaNo", String.valueOf(gridMap.get("11")));	// VA number
				itemMap.put("userNm", sessionVO.getUserName());	//J
				itemMap.put("userId", sessionVO.getUserId());	
				
				itemList.add(itemMap);
			}
		}
		
		//마스터 정보 parameter 추가 세팅
		formData.put("userId", sessionVO.getUserId());		
		
		//저장처리
		Map<String, Object> returnMap = bankStatementService.uploadBankStatement(formData,itemList);				

		
		// 결과 만들기.
    	ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
    	msg.setMessage("");
        return ResponseEntity.ok(returnMap);
	}
	
	/**
	* BBank Statement Delete
	* @param params
	* @param model
	* @return
	*/
	@RequestMapping(value = "/deleteBankStatement.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteBankStatement(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model , SessionVO sessionVO) {	
		
		List<Object> deleteList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		String resultMessage = "";
		
		//저장처리
		boolean result = bankStatementService.deleteBankStatement(deleteList);
		if(result)
			resultMessage = "Completed Delete";
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(resultMessage);
        return ResponseEntity.ok(message);
	}
	
	/**
	* BBank Statement Update Detail
	* @param params
	* @param model
	* @return
	*/
	@RequestMapping(value = "/updateBankStateDetail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateBankStateDetail(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model , SessionVO sessionVO) {	
		
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); // 그리드 데이터 가져오기
		String resultMessage = "";
		
		//저장처리
		boolean result = bankStatementService.updateBankStateDetail(updateList);
		if(result)
			resultMessage = "Completed Update";
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(resultMessage);
        return ResponseEntity.ok(message);
	}
	
	/**
	 * Bank Statement Download List  조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */	
	@RequestMapping(value = "/selectBankStatementDownloadList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectBankStatementDownloadList(@RequestBody Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params : " + params);
		
        // 조회.
        List<EgovMap> resultList = bankStatementService.selectBankStatementDownloadList(params);		
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
}
