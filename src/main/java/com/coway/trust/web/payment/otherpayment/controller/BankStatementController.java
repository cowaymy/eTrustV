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
	public ResponseEntity<ReturnMessage> uploadBankStatement(@RequestBody Map<String, Object> params, ModelMap model , SessionVO sessionVO) {	
		
		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
		//Item map
		Map<String, Object> itemMap = null;
		List<Object> itemList = new ArrayList<Object>();
		
		//그리드 데이터에서 Transaction Date 한건을 가져올 변수
		String trnscDt = "01/01/1900";
		
		//등록 parameter 세팅 
		if (gridList.size() > 0) {
			Map<String, Object> gridMap = null;
			
			for (int i = 0; i < gridList.size(); i++) {
				
				gridMap = (Map<String, Object>) gridList.get(i);				
			
				itemMap = new HashMap<String, Object>();
				itemMap.put("fTrnscDt", String.valueOf(gridMap.get("0")));			//A
				itemMap.put("fTrnscRefChqNo", String.valueOf(gridMap.get("1")));	//B
				itemMap.put("fTrnscRefVaNo", String.valueOf(gridMap.get("1")));	//B
				itemMap.put("fTrnscRef3", String.valueOf(gridMap.get("2")));		//C
				itemMap.put("fTrnscRef1", String.valueOf(gridMap.get("3")));		//D
				itemMap.put("fTrnscRef4", String.valueOf(gridMap.get("4")));		//E
				itemMap.put("fTrnscRef2", String.valueOf(gridMap.get("5")));		//F
				itemMap.put("fTrnscRef6", String.valueOf(gridMap.get("6")));		//G
				itemMap.put("fTrnscRem", String.valueOf(gridMap.get("7")));		//H
				itemMap.put("fTrnscDebtAmt", String.valueOf(gridMap.get("8")));	//I
				itemMap.put("fTrnscCrditAmt", String.valueOf(gridMap.get("9")));	//J
				itemMap.put("userNm", sessionVO.getUserName());	//J
				
				if(i == 0 ){
					trnscDt = String.valueOf(gridMap.get("0"));
				}
				
				itemList.add(itemMap);
			}
		}
		
		//마스터 정보 parameter 추가 세팅
		formData.put("userId", sessionVO.getUserId());
		formData.put("trnscDt", trnscDt);
		
		//저장처리
		bankStatementService.uploadBankStatement(formData,itemList);				

		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
		
    	return ResponseEntity.ok(message);
	}
	
}
