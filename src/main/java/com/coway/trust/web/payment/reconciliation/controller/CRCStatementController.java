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
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class CRCStatementController {

	private static final Logger logger = LoggerFactory.getLogger(CRCStatementController.class);

	@Resource(name = "crcStatementService")
	private CRCStatementService crcStatementService;

	
	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

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
		
		CRCStatementVO crcStatementVO = new CRCStatementVO();
		
		//크레딧 카드 리스트 조회
		crcStatementVO.setAccountType("CRC");		
		List<EgovMap> cardComboList  = crcStatementService.getAccountList(crcStatementVO);
		
		//은행 계좌 정보 조회
		crcStatementVO.setAccountType("CASH");
		List<EgovMap> bankComboList  = crcStatementService.getAccountList(crcStatementVO);
		
		// 화면 단으로 전달할 데이터.
		model.addAttribute("cardComboList", cardComboList);
		model.addAttribute("bankComboList", bankComboList);		
		
		return "payment/crcStatementUpload";
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
    		Model model) {
    	
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
    	
    	
    	logger.debug("crcStateRefDt : {}", crcSatementMap.get("crcStateRefDt"));
    	logger.debug("crcStateRunngNo : {}", crcSatementMap.get("crcStateRunngNo"));
    	logger.debug("crcStateAccId : {}", crcSatementMap.get("crcStateAccId"));
    	
    	
    	//CRC Transaction 정보 Map
    	Map<String, Object> crcTransactionMap = null;
    	List<Object> transactionList = new ArrayList<Object>();
    	
    	int totalTrnscAmt = 0;
    	
    	//CRC Transaction 정보
    	if (gridList.size() > 0) {
    		
    		Map hm = null;
    		
    		for (Object map : gridList) {
    			hm = (HashMap<String, Object>) map;
    			
    			logger.debug("crcTrnscDt : {}", hm.get("0"));
                logger.debug("crcTrnscNo : {}", hm.get("1"));					
                logger.debug("crcTrnscAppv : {}", hm.get("2"));
                logger.debug("crcTrnscMid : {}", hm.get("3"));
                logger.debug("crcTrnscRefNo : {}", hm.get("4"));
                logger.debug("crcTrnsAmt : {}", hm.get("5"));
                
                crcTransactionMap = new HashMap<String, Object>();
                
                crcTransactionMap.put("crcStateId", crcStateId);
                crcTransactionMap.put("crcTrnscDt", ((String)hm.get("0")).trim());
                crcTransactionMap.put("crcTrnscNo", ((String)hm.get("1")).trim());
                crcTransactionMap.put("crcTrnscAppv", ((String)hm.get("2")).trim());
                crcTransactionMap.put("crcTrnscMid", ((String)hm.get("3")).trim());
                crcTransactionMap.put("crcTrnscRefNo", ((String)hm.get("4")).trim());
                crcTransactionMap.put("crcTrnsAmt", ((Integer)hm.get("5")));
                
                totalTrnscAmt += (Integer)hm.get("5");
                
                transactionList.add(crcTransactionMap);
    		}
    	}
    		
    	//CRCStatement Total Amount 설정하기
    	crcSatementMap.put("crcStateTot", totalTrnscAmt);
		logger.debug("crcTrnsAmt : {}", totalTrnscAmt);
    	
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
		
		CRCStatementVO crcStatementVO = new CRCStatementVO();
		
		//크레딧 카드 리스트 조회
		crcStatementVO.setAccountType("CRC");		
		List<EgovMap> cardComboList  = crcStatementService.getAccountList(crcStatementVO);
		
		//은행 계좌 정보 조회
		crcStatementVO.setAccountType("CASH");
		List<EgovMap> bankComboList  = crcStatementService.getAccountList(crcStatementVO);
		
		// 화면 단으로 전달할 데이터.
		model.addAttribute("cardComboList", cardComboList);
		model.addAttribute("bankComboList", bankComboList);		
		
		return "payment/crcStatementTranList";
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
        logger.debug("refNo : {}", params.get("refNo"));
        logger.debug("cardAccount : {}", params.get("cardAccount"));
        logger.debug("status : {}", params.get("status"));
        logger.debug("account : {}", params.get("account"));
        logger.debug("updateDt1 : {}", params.get("updateDt1"));
        logger.debug("updateDt2 : {}", params.get("updateDt2"));
        
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
    
    	List<Object> updateList = params.get(AppConstants.AUIGrid_UPDATE); // 수정 리스트 얻기 : 그리드에서 수정된 row만 가져온다.
    	
    	if (updateList.size() > 0) {
    		
    		updateList.forEach(obj -> {
                Map<String, Object> map = (Map<String, Object>) obj;
                
                //수정할 데이터 확인.(그리드 값)
				logger.debug("crcTrnscId : {}", map.get("crcTrnscId"));
                logger.debug("crcTrnscDt : {}", map.get("crcTrnscDt"));					
                logger.debug("crcTrnscNo : {}", map.get("crcTrnscNo"));
                logger.debug("crcTrnscAppv : {}", map.get("crcTrnscAppv"));
                logger.debug("crcTrnscMid : {}", map.get("crcTrnscMid"));
                logger.debug("crcTrnscRefNo : {}", map.get("crcTrnscRefNo"));
                logger.debug("crcTrnscAmt : {}", map.get("crcTrnscAmt"));
                
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
}
