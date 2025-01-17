package com.coway.trust.web.services.svcCodeConfig;

import java.text.ParseException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.promotion.PromotionService;
import com.coway.trust.biz.services.svcCodeConfig.svcCodeConfigService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/svcCodeConfig")
public class svcCodeConfigController {

	private static final Logger logger = LoggerFactory.getLogger(svcCodeConfigController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "svcCodeConfigService")
	private svcCodeConfigService svcCodeConfigService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "promotionService")
	private PromotionService promotionService;

	@RequestMapping(value = "/svcCodeConfigList.do")
	public String svcCodeConfigList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		logger.debug("[svcCodeConfigController - svcCodeConfigList] params : {}", params);

		List<EgovMap> codeStatus = commonService.selectStatusCategoryCodeList(params);
		List<EgovMap> prodCatList = promotionService.selectProductCategoryList();
		logger.debug("[svcCodeConfigController - svcCodeConfigList] codeStatus : {}", codeStatus);
		logger.debug("[svcCodeConfigController - svcCodeConfigList] prodCatList : {}", prodCatList);

		model.addAttribute("codeStatus", codeStatus);
		model.addAttribute("prodCatList", prodCatList);

		return "services/svcCodeConfig/svcCodeConfigList";
	}

	@RequestMapping(value = "/selectSvcCodeConfigList.do" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeMgmtList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		String[] arrProdCat = request.getParameterValues("productCtgry"); //Product Category
		String[] arrCodeStus = request.getParameterValues("codeStatus"); //Code Status

		if(arrProdCat != null && !CommonUtils.containsEmpty(arrProdCat))
			params.put("arrProdCat", arrProdCat);
		if(arrCodeStus != null && !CommonUtils.containsEmpty(arrCodeStus))
			params.put("arrCodeStus", arrCodeStus);

		logger.debug("[svcCodeConfigController - selectSvcCodeConfigList] params :: {}", params);
		List<EgovMap> codeConfigList =null;
		codeConfigList = svcCodeConfigService.selectSvcCodeConfigList(params);

		logger.debug("[svcCodeConfigController - selectSvcCodeConfigList] codeConfigList :: {}", codeConfigList);
		return ResponseEntity.ok(codeConfigList);
	}

	//Product Category
	@RequestMapping(value = "/selectProductCategoryList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectProductCategoryList(@RequestParam Map<String, Object> params) {
    	List<EgovMap> resultList = svcCodeConfigService.selectProductCategoryList();
    	return ResponseEntity.ok(resultList);
    }

	//Status Category Code
   @RequestMapping(value = "/selectStatusCategoryCodeList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectStatusCategoryCodeList(@RequestParam Map<String, Object> params) {
	   logger.debug( "[svcCodeConfigController - selectStatusCategoryCodeList] params :: {}", params );
       List<EgovMap> codeList = svcCodeConfigService.selectStatusCategoryCodeList();
       return ResponseEntity.ok(codeList);
    }

	@RequestMapping(value = "/addEditSvcCodeConfigPop.do")
	  public String addEditSvcCodeConfigPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	    logger.debug("=====================/addEditSvcCodeConfigPop.do=========================");
	    logger.debug("[svcCodeConfigController - addEditSvcCodeConfigPop] params : {}", params);
	    model.put("viewType", (String) params.get("viewType"));
	    logger.debug("=====================/addEditSvcCodeConfigPop.do=========================");

	    if(params.get("viewType").equals("2") || params.get("viewType").equals("3")) //Edit or View
	    {
	    	EgovMap codeMgmtMap = svcCodeConfigService.selectCodeConfigList(params);
	    	logger.debug("[svcCodeConfigController - addEditSvcCodeConfigPop] codeMgmtMap :: {}", codeMgmtMap);

	    	List<EgovMap> codeList = svcCodeConfigService.selectStatusCategoryCodeList();
		    model.put("defectId", (String) params.get("defectId"));
		    model.put("hidTypeId", (String) params.get("hidTypeId"));
		    model.addAttribute("codeMgmtMap", codeMgmtMap);
	    }

	    return "services/svcCodeConfig/addEditSvcCodeConfigPop";
	  }

	  @RequestMapping(value = "/saveNewCode.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> saveNewCode(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws ParseException {

	    ReturnMessage message = new ReturnMessage();

	    logger.debug("==========================/saveNewCode.do=================================");
	    logger.debug("[svcCodeConfigController - saveNewCode] params :: {}", params);

	    Map<String, Object> newCodeMap = (Map<String, Object>) params.get("newDpCodeConfig");
	    logger.debug("[svcCodeConfigController - saveNewCode] newCodeMap ::{}" + newCodeMap.toString());

	    newCodeMap.put("dftType", "DP");
	    newCodeMap.put("creator", sessionVO.getUserId());
	    newCodeMap.put("updator", sessionVO.getUserId());

	    if(newCodeMap.get("viewType").equals("1"))//NEW
	    {
	    	newCodeMap.put("stus","1");
	    	//message = svcCodeConfigService.saveNewCode(newCodeMap, sessionVO);
	    	svcCodeConfigService.saveNewCode(newCodeMap, sessionVO);
	    	message.setCode(AppConstants.SUCCESS);
	        message.setMessage("Successfully configured code " + newCodeMap.get("dftPrtCde") + "-" + newCodeMap.get("dftPrtDesc"));

	    }
	    else //viewtype ==2 Edit, ==3 View
	    {
		    logger.debug("[svcCodeConfigController - saveNewCode] edit params ::{}" + newCodeMap);

	    	svcCodeConfigService.updateSvcCode(newCodeMap, sessionVO);
	    	message.setCode(AppConstants.SUCCESS);
	        message.setMessage("Successfully update code " + newCodeMap.get("dftPrtCde") + "-" + newCodeMap.get("dftPrtDesc"));
	    }

	    logger.debug("==========================/saveNewCode.do=================================");

	    return ResponseEntity.ok(message);
	  }
}
