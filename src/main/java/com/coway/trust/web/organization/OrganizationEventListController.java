package com.coway.trust.web.organization;

import java.util.ArrayList;
import java.util.Date;
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
import com.coway.trust.biz.organization.OrganizationEventService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization")
public class OrganizationEventListController {

	private static final Logger logger = LoggerFactory.getLogger(OrganizationEventListController.class);
	
	@Resource(name = "organizationEventService")
	private OrganizationEventService organizationEventService;

	
	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	
	@RequestMapping(value = "/organizationEvent.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "organization/organization/organizationEventList";
	}

	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	
	/**
	 * selectOrganizationEventList Statement Transaction 리스트 조회
	 * @param 
	 * @param params
	 * @param model 
	 * @return
	 */
	@RequestMapping(value = "/selectOrganizationEventList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrganizationEventList(@RequestParam Map<String, Object> params, Model model) {

		Map<String, Object> param = null;
		
		//검색 파라미터 확인.(화면 Form객체 입력값)
        logger.debug("requestStatus : {}", params.get("requestStatus"));
        logger.debug("cardAccount : {}", params.get("cardAccount"));
        logger.debug("status : {}", params.get("status"));
        logger.debug("account : {}", params.get("account"));
        logger.debug("updateDt1 : {}", params.get("updateDt1"));
        logger.debug("updateDt2 : {}", params.get("updateDt2"));
        
        // 조회.
        List<EgovMap> organizationEvent = organizationEventService.selectOrganizationEventList(params);        
		
        // 화면 단으로 전달할 데이터.
//        model.addAttribute("organizationEvent", organizationEvent);
        
        // 조회 결과 리턴.
//        return "organization/organization/organizationEventList";
        return ResponseEntity.ok(organizationEvent);
        
	}
				
}
