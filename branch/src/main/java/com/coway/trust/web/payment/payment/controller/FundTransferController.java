package com.coway.trust.web.payment.payment.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.payment.payment.service.FundTransferService;
import com.coway.trust.biz.payment.payment.service.SearchPaymentService;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class FundTransferController {

	private static final Logger LOGGER = LoggerFactory.getLogger(FundTransferController.class);
	
	@Resource(name = "searchPaymentService")
	private SearchPaymentService searchPaymentService;
	
	@Resource(name = "fundTransferService")
	private FundTransferService fundTransferService;
	
	/******************************************************
	 * Fund Transfer  
	 *****************************************************/	
	/**
	 * Fund Transfer 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initFundTransferPop.do")
	public String initFundTransferPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		//검색 파라미터 확인.(화면 Form객체 입력값)
        LOGGER.debug("popPayId : {}", params.get("popPayId"));    
        Map<String, Object> map = new HashMap<String, Object>();
		map.put("payId", params.get("popPayId"));
        
        // 조회.
        EgovMap masterInfo = searchPaymentService.selectPaymentDetailViewer(map);
        
        //HP ID가 존재하면 Member 데이터를 조회하여 hpCode/hpName을 갱신한다.
        if( Integer.parseInt(String.valueOf(masterInfo.get("hpId"))) > 0 ){
        	
        	Map<String, Object> memberIdMap = new HashMap<String, Object>();        	
        	memberIdMap.put("edit_txtCollectorId", masterInfo.get("hpId"));
			
			EgovMap resultMember = searchPaymentService.selectMemCode(memberIdMap);
			
			masterInfo.put("hpCode", resultMember.get("memCode"));
			masterInfo.put("hpName", resultMember.get("fullName"));
        }
        
        //Order ID가 존재하면 상태값을 조회한다.
        if( masterInfo.get("salesOrdId") != null){
        	
        	Map<String, Object> statusParamMap = new HashMap<String, Object>();
        	statusParamMap.put("salesOrdId", masterInfo.get("salesOrdId"));
        	
        	//주문진행상태 조회
    		EgovMap orderProgressStatus = searchPaymentService.selectOrderProgressStatus(statusParamMap);
    		
    		masterInfo.put("progressStatus", orderProgressStatus.get("name"));        	
        }	
        
        //Fund Transfer Item List 조회
        fundTransferService.selectFundTransferItemList(map);
        
        //결과 뿌려보기 : 프로시저에서 fundTransferItemList 란 key값으로 객체를 반환한다.
        List<EgovMap> fundTransferItemList = (List<EgovMap>)map.get("fundTransferItemList");
		
		model.addAttribute("masterInfo", masterInfo);
		model.addAttribute("itemList", new Gson().toJson(fundTransferItemList));
		
		return "payment/payment/fundTransferPop";
	}
	
	
}
