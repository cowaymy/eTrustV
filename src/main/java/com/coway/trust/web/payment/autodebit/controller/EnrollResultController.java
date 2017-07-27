package com.coway.trust.web.payment.autodebit.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.autodebit.service.EnrollResultService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class EnrollResultController {

	private static final Logger logger = LoggerFactory.getLogger(EnrollResultController.class);

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "enrollResultService")
	private EnrollResultService atDebtCreCrdService;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	
	/******************************************************
	 * enrollmentResultList  
	 *****************************************************//*	
	*//**
	 * enrollmentResultList초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initEnrollmentResultList.do")
	public String initEnrollmentResultList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/enrollmentResultList";
	}
	
	/**
	 * EnrollResult조회
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectResultList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSalesList(
				 @RequestParam Map<String, Object> params, ModelMap model) {

        List<EgovMap> resultList = atDebtCreCrdService.selectEnrollmentResultrList(params);
        
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * EnrollResultNew업로드
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> uploadFile(
			@RequestBody Map<String, ArrayList<Object>> params, ModelMap model) {

		String msg = "";
		List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    	
    	Map<String, Object> formInfo = new HashMap<String, Object> ();
    	if(formList.size() > 0){
    		for(Object obj : formList){
    			Map<String, Object> map = (Map<String, Object>) obj;
    			formInfo.put((String)map.get("name"), map.get("value"));
    		}
    		msg = atDebtCreCrdService.saveNewEnrollment(gridList, formInfo);
    		
    	}
    	
    	// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(msg );
    	
        return ResponseEntity.ok(message);
	}
	
	/**
	 * EnrollResultView
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectEnrollmentInfo", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectEnrollmentInfo(@RequestParam Map<String, Object> params, ModelMap model) {

		int enrollment = Integer.parseInt(params.get("enrollId").toString());
		Map<String, Object> map = new HashMap<String, Object>(); 
		map = atDebtCreCrdService.selectEnrollmentInfo(enrollment);
        
        return ResponseEntity.ok(map);
	}
	
	
}
