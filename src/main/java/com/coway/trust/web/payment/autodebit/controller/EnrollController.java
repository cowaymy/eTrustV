package com.coway.trust.web.payment.autodebit.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
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
import com.coway.trust.biz.payment.autodebit.service.EnrollService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class EnrollController {

	private static final Logger logger = LoggerFactory.getLogger(EnrollController.class);

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Resource(name = "enrollService")
	private EnrollService enrollService ;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/******************************************************
	 * EnrollmentList  
	 *****************************************************//*	
	*//**
	 * EnrollmentList초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initEnrollmentList.do")
	public String initEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/autodebit/enrollmentList";
	}
	
	/**
	 * selectEnrollmentList 조회
	 * @param searchVO
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectEnrollmentList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectEnrollmentList(@ModelAttribute("searchVO")ReconciliationSearchVO searchVO
				, @RequestParam Map<String, Object> params, ModelMap model) {
        // 조회.
        List<EgovMap> resultList = enrollService.selectEnrollmentList(params);
        
        // 조회 결과 리턴.
        return ResponseEntity.ok(resultList);
	}
	
	/**
	 * ViewEnrollment 팝업 Master
	 */
	@RequestMapping(value = "/selectViewEnrollment")
	public ResponseEntity<Map> selectViewEnrollment(@RequestParam Map<String, Object>params, ModelMap model) {
		
		params.put("enrollId", params.get("enrollId"));
		logger.debug("enrollId : {}", params.get("enrollId"));
		EgovMap enrollInfo = enrollService.selectViewEnrollment(params);
		
		Map result = new HashMap();
		result.put("enrollInfo", enrollInfo);
		
		return ResponseEntity.ok(result);
	}
		
	/**
	* ViewEnrollmentList 팝업 Detail
	*/
	@RequestMapping(value = "/selectViewEnrollmentList")
	public ResponseEntity<List<EgovMap>> selectViewEnrollmentList(@RequestParam Map<String, Object>params, ModelMap model) {
			
		params.put("enrollId", params.get("enrollId"));
		List<EgovMap> result = enrollService.selectViewEnrollmentList(params);
		
		return ResponseEntity.ok(result);
	}
	
	/**
	 * Save Enroll
	 */
	@RequestMapping(value = "/saveEnroll", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveEnroll(@RequestParam Map<String, ArrayList<Object>> params, Model model) {

		logger.debug("cmbIssueBank2 : {}", params.get("cmbIssueBank2"));
		logger.debug("rdpCreateDateFr2 : {}", params.get("rdpCreateDateFr2"));
		logger.debug("rdpCreateDateTo2 : {}", params.get("rdpCreateDateTo2"));
		
		//parameter 객체를 생성한다. 프로시저에서 CURSOR 반환시 해당 paramter 객체에 리스트를 세팅한다.
    	//프로시저에서 사용하는 parameter가 없어도 객체는 생성한다.
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("cmbIssueBank2", params.get("cmbIssueBank2"));
		param.put("rdpCreateDateFr2", params.get("rdpCreateDateFr2"));
		param.put("rdpCreateDateTo2", params.get("rdpCreateDateTo2"));
    	//프로시저 함수 호출
		enrollService.saveEnroll(param);
    	
    	//결과 뿌려보기 : 프로시저에서 p1이란 key값으로 객체를 반환한다.
    	List<EgovMap> resultMapList = (List<EgovMap>)param.get("p1");
    	
    	EgovMap map = (EgovMap) resultMapList.get(0);
		logger.debug("size : {}", resultMapList.size());
		
		if(resultMapList.size() > 0){
			
			//프로시저 반환값 implements에서 FILE WRITE
			param.put("enrlId", map.get("enrlId"));
			param.put("bankId", map.get("bankId"));
			param.put("debtDtFrom", map.get("debtDtFrom"));
			param.put("debtDtTo", map.get("debtDtTo"));
			param.put("crtUserId", map.get("crtUserId"));
			param.put("crtDt", map.get("crtDt"));
			param.put("updUserId", map.get("updUserId"));
			param.put("updDt", map.get("updDt"));
			param.put("stusCodeId", map.get("stusCodeId"));

			enrollService.selectEnrollmentDetView(param);
			
		}
		
        if (resultMapList.size() > 0) {
        	
        	resultMapList.forEach(obj -> {
                Map<String, Object> map2 = (Map<String, Object>) obj;
                
                //수정할 데이터 확인.(그리드 값)
				logger.debug("ENRL_ID : {}", map2.get("enrlId"));
                logger.debug("BANK_ID : {}", map2.get("bankId"));					
                logger.debug("DEBT_DT_FROM : {}", map2.get("debtDtFrom"));
                logger.debug("DEBT_DT_TO : {}", map2.get("debtDtTo"));
                logger.debug("CRT_USER_ID : {}", map2.get("crtUserId"));
                logger.debug("CRT_DT : {}", map2.get("crtDt"));
                logger.debug("UPD_USER_ID : {}", map2.get("updUserId"));
                logger.debug("UPD_DT : {}", map2.get("updDt"));
                logger.debug("STUS_CODE_ID : {}", map2.get("stusCodeId"));
    		});
    	}
        
        
		
		// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(map);
    	message.setMessage("Enrollment successfully saved. \n Enroll ID : ");
		
		return ResponseEntity.ok(message);
	}
}
