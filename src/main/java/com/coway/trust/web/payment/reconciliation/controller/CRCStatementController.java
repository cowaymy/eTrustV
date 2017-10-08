package com.coway.trust.web.payment.reconciliation.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.SampleApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class CRCStatementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CRCStatementController.class);

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "crcStatementService")
	private CRCStatementService crcStatementService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	
	/******************************************************
	 * CRC Statement File Upload 
	 *****************************************************/
	
	/**
	 * CRC Statement File Upload 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCRCStatementUpload.do")
	public String CRCStatementUpload(@RequestParam Map<String, Object> params, ModelMap model) {
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		//크레딧 카드 리스트 조회
		param.put("accountType","CRC");		
		List<EgovMap> cardComboList  = commonService.getAccountList(param);
		
		//은행 계좌 정보 조회
		param.put("accountType","CASH");		
		List<EgovMap> bankComboList  = commonService.getAccountList(param);
		
		// 화면 단으로 전달할 데이터.
		model.addAttribute("cardComboList", cardComboList);
		model.addAttribute("bankComboList", bankComboList);		
		
		return "payment/reconciliation/crcStatementUpload";
	}
	
	/**
     * CRC Statement Transaction 정보 수정
     * @param params
     * @param model
     * @return
     * @RequestParam Map<String, Object> params
     */
    @RequestMapping(value = "/updateCRCStatementUpload.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateCRCStatementUpload(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model, SessionVO sessionVO) {
    	
    	int userId = sessionVO.getUserId();
    	List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    	
    	//CRC Statement 정보 Map
    	Map<String, Object> crcSatementMap = new HashMap<String, Object>();
    	
    	//CRC Statement 정보 Map에 데이터 세팅
    	if (formList.size() > 0) {
    		
    		formList.forEach(obj -> {
                Map<String, Object> map = (Map<String, Object>) obj;
                crcSatementMap.put((String)map.get("name"),map.get("value"));
    		});    		
    	}
    	
    	//CRCStatement SEQ 설정하기
    	Integer crcStateId = crcStatementService.getCRCStatementSEQ();
    	crcSatementMap.put("crcStateId", crcStateId);
    	
    	
    	//CRCStatementRunningNo 설정하기
    	String runningNo = crcSatementMap.get("crcStateCardAccount") + "_" +crcStatementService.getCRCStatementRunningNo();
    	crcSatementMap.put("crcStateRunngNo", runningNo);
    	
    	
    	LOGGER.debug("crcStateRefDt : {}", crcSatementMap.get("crcStateRefDt"));
    	LOGGER.debug("crcStateRunngNo : {}", crcSatementMap.get("crcStateRunngNo"));
    	LOGGER.debug("crcStateAccId : {}", crcSatementMap.get("crcStateAccId"));
    	
    	
    	//CRC Transaction 정보 Map
    	Map<String, Object> crcTransactionMap = null;
    	List<Object> transactionList = new ArrayList<Object>();
    	
    	int totalTrnscAmt = 0;
    	
    	//CRC Transaction 정보
    	if (gridList.size() > 0) {
    		
    		Map hm = null;
    		
    		for (Object map : gridList) {
    			hm = (HashMap<String, Object>) map;
    			
    			LOGGER.debug("crcTrnscDt : {}", hm.get("0"));
    			LOGGER.debug("crcTrnscNo : {}", hm.get("1"));					
    			LOGGER.debug("crcTrnscAppv : {}", hm.get("2"));
    			LOGGER.debug("crcTrnscMid : {}", hm.get("3"));
    			LOGGER.debug("crcTrnscRefNo : {}", hm.get("4"));
    			LOGGER.debug("crcTrnsAmt : {}", hm.get("5"));
                
                crcTransactionMap = new HashMap<String, Object>();
                
                crcTransactionMap.put("crcStateId", crcStateId);
                crcTransactionMap.put("crcTrnscDt", ((String)hm.get("0")).trim());
                crcTransactionMap.put("crcTrnscNo", ((String)hm.get("1")).trim());
                crcTransactionMap.put("crcTrnscAppv", ((String)hm.get("2")).trim());
                crcTransactionMap.put("crcTrnscMid", ((String)hm.get("3")).trim());
                crcTransactionMap.put("crcTrnscRefNo", ((String)hm.get("4")).trim());
                crcTransactionMap.put("crcTrnsAmt", ((Integer)hm.get("5")));
                crcTransactionMap.put("userId", userId);
                totalTrnscAmt += (Integer)hm.get("5");
                
                transactionList.add(crcTransactionMap);
    		}
    	}
    		
    	//CRCStatement Total Amount 설정하기
    	crcSatementMap.put("crcStateTot", totalTrnscAmt);
    	crcSatementMap.put("userId", userId);
    	LOGGER.debug("crcTrnsAmt : {}", totalTrnscAmt);
    	
    	// 데이터 등록
    	crcStatementService.updateCRCStatementUpload(crcSatementMap, transactionList);	
    	
    	// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage("Saved Successfully. Generate Running No : \n" + runningNo);
    	
    	return ResponseEntity.ok(message);
    }
	
	
	/******************************************************
	 * CRC Statement Transaction List & Update 
	 *****************************************************/	
	/**
	 * CRC Statement Transaction초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initCRCStatementTranList.do")
	public String initCRCStatementTranList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		//크레딧 카드 리스트 조회
		param.put("accountType","CRC");		
		List<EgovMap> cardComboList  = commonService.getAccountList(param);
		
		//은행 계좌 정보 조회
		param.put("accountType","CASH");		
		List<EgovMap> bankComboList  = commonService.getAccountList(param);
		
		// 화면 단으로 전달할 데이터.
		model.addAttribute("cardComboList", cardComboList);
		model.addAttribute("bankComboList", bankComboList);		
		
		return "payment/reconciliation/crcStatementTranList";
	}
	
	/**
	 * CRC Statement Transaction 리스트 조회
	 * @param crcStatementVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCRCStatementTranList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCRCStatementTranList(@ModelAttribute("crcStatementVO") CRCStatementVO crcStatementVO,
				@RequestParam Map<String, Object> params, ModelMap model) {

		//검색 파라미터 확인.(화면 Form객체 입력값)
		LOGGER.debug("refNo : {}", params.get("refNo"));
		LOGGER.debug("cardAccount : {}", params.get("cardAccount"));
		LOGGER.debug("status : {}", params.get("status"));
		LOGGER.debug("account : {}", params.get("account"));
        LOGGER.debug("updateDt1 : {}", params.get("updateDt1"));
        LOGGER.debug("updateDt2 : {}", params.get("updateDt2"));
        
        // 조회.
        List<EgovMap> crcStatementList = crcStatementService.selectCRCStatementTranList(params);
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(crcStatementList);
	}
		
		
    /**
     * CRC Statement Transaction 정보 수정
     * @param params
     * @param model
     * @return
     */
    @RequestMapping(value = "/updateCRCStatementTranList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> updateCRCStatementTranList(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model) {
    
    	List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); // 수정 리스트 얻기 : 그리드에서 수정된 row만 가져온다.
    	
    	if (updateList.size() > 0) {
    		
    		updateList.forEach(obj -> {
                Map<String, Object> map = (Map<String, Object>) obj;
                
                //수정할 데이터 확인.(그리드 값)
                LOGGER.debug("crcTrnscId : {}", map.get("crcTrnscId"));
                LOGGER.debug("crcTrnscDt : {}", map.get("crcTrnscDt"));					
                LOGGER.debug("crcTrnscNo : {}", map.get("crcTrnscNo"));
                LOGGER.debug("crcTrnscAppv : {}", map.get("crcTrnscAppv"));
                LOGGER.debug("crcTrnscMid : {}", map.get("crcTrnscMid"));
                LOGGER.debug("crcTrnscRefNo : {}", map.get("crcTrnscRefNo"));
                LOGGER.debug("crcTrnscAmt : {}", map.get("crcTrnscAmt"));
                
                // 수정처리
                crcStatementService.updateCRCStatementTranList(map);
    		});
    	}
    	
    	// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
    }
    
    /**
     * CRC Statement Transaction 정보 수정
     * @param params
     * @param model
     * @return
     * @RequestParam Map<String, Object> params
     */
    @RequestMapping(value = "/testCallStoredProcedure.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> testCallStoredProcedure(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model, SessionVO sessionVO) {
    	
    	//parameter 객체를 생성한다. 프로시저에서 CURSOR 반환시 해당 paramter 객체에 리스트를 세팅한다.
    	//프로시저에서 사용하는 parameter가 없어도 객체는 생성한다.
    	Map<String, Object> param = new HashMap<String, Object>();
    	param.put("userId", sessionVO.getUserId());
    	
    	//프로시저 함수 호출
    	crcStatementService.testCallStoredProcedure(param);
    	
    	//결과 뿌려보기 : 프로시저에서 p1이란 key값으로 객체를 반환한다.
    	List<EgovMap> resultMapList = (List<EgovMap>)param.get("p1");
    	

    	LOGGER.debug("size : {}", resultMapList.size());
        
        if (resultMapList.size() > 0) {
        	
        	resultMapList.forEach(obj -> {
                Map<String, Object> map = (Map<String, Object>) obj;
                
                //수정할 데이터 확인.(그리드 값)
                LOGGER.debug("ENRL_ID : {}", map.get("enrlId"));
                LOGGER.debug("BANK_ID : {}", map.get("bankId"));					
                LOGGER.debug("DEBT_DT_FROM : {}", map.get("debtDtFrom"));
                LOGGER.debug("DEBT_DT_TO : {}", map.get("debtDtTo"));
                LOGGER.debug("CRT_USER_ID : {}", map.get("crtUserId"));
                LOGGER.debug("CRT_DT : {}", map.get("crtDt"));
                LOGGER.debug("UPD_USER_ID : {}", map.get("updUserId"));
                LOGGER.debug("UPD_DT : {}", map.get("updDt"));
                LOGGER.debug("STUS_CODE_ID : {}", map.get("stusCodeId"));
    		});
    	}
        
    	// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage("Saved Successfully. Generate Running No : \n");
    	
    	return ResponseEntity.ok(message);
    }
}
