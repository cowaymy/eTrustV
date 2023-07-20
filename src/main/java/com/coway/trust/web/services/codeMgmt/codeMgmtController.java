package com.coway.trust.web.services.codeMgmt;

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
import com.coway.trust.biz.services.codeMgmt.codeMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/codeMgmt")
public class codeMgmtController {

	private static final Logger logger = LoggerFactory.getLogger(codeMgmtController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "codeMgmtService")
	private codeMgmtService codeMgmtService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "promotionService")
	private PromotionService promotionService;

	@Resource(name = "accessMonitoringService")
	private AccessMonitoringService accessMonitoringService;

	@RequestMapping(value = "/codeMgmtList.do")
	public String codeMgmtList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		params.put("selCategoryId", "32");

		logger.debug("groupCode1111 : {}", params);

		List<EgovMap> codeStatus = commonService.selectStatusCategoryCodeList(params);
		List<EgovMap> prodCatList = promotionService.selectProductCategoryList();

		model.addAttribute("codeStatus", codeStatus);
		model.addAttribute("prodCatList", prodCatList);

		return "services/codeMgmt/codeMgmtList";
	}

	@RequestMapping(value = "/selectCodeMgmtList" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeMgmtList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		//Log down user search params
    	StringBuffer requestUrl = new StringBuffer(request.getRequestURI());
    	//requestUrl.replace(requestUrl.lastIndexOf("/"), requestUrl.lastIndexOf("/") + 1, "/codeMgmt.do/");
		accessMonitoringService.insertSubAccessMonitoring(requestUrl.toString(), params, request,sessionVO);

		String[] arrSvcType   = request.getParameterValues("type"); //Service Type
		String[] arrProdCat = request.getParameterValues("productCtgry"); //Product Category
		String[] arrBusiCat   = request.getParameterValues("busiCtgry"); //Business Category
		String[] arrCodeCat = request.getParameterValues("codeCat"); //Code Category
		String[] arrCodeStus = request.getParameterValues("codeStatus"); //Code Status

		if(arrSvcType      != null && !CommonUtils.containsEmpty(arrSvcType))      params.put("arrSvcType", arrSvcType);
		if(arrProdCat    != null && !CommonUtils.containsEmpty(arrProdCat))    params.put("arrProdCat", arrProdCat);
		if(arrBusiCat      != null && !CommonUtils.containsEmpty(arrBusiCat))      params.put("arrBusiCat", arrBusiCat);
		if(arrCodeCat    != null && !CommonUtils.containsEmpty(arrCodeCat))    params.put("arrCodeCat",arrCodeCat);
		if(arrCodeStus      != null && !CommonUtils.containsEmpty(arrCodeStus))      params.put("arrCodeStus", arrCodeStus);

		//{type=7296, productCtgry=54, busiCtgry=6665, codeCat=7311, codeStatus=1}
		logger.debug(params.toString());
		List<EgovMap> codeMgmtList =null;
		codeMgmtList = codeMgmtService.selectCodeMgmtList(params);

		return ResponseEntity.ok(codeMgmtList);
	}

	@RequestMapping(value = "/addEditCodePop.do")
	  public String addNewCodePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	    logger.debug("=====================/addEditCodePop.do=========================");
	    logger.debug("params : {}", params);
	    model.put("viewType", (String) params.get("viewType"));
	    logger.debug("=====================/addEditCodePop.do=========================");

	    if(params.get("viewType").equals("2") || params.get("viewType").equals("3")) //Edit OR View
	    {
	    	EgovMap codeMgmtMap = codeMgmtService.selectCodeMgmtInfo(params);

		    model.put("defectId", (String) params.get("defectId"));
		    model.put("hidTypeId", (String) params.get("hidTypeId"));
		    model.addAttribute("codeMgmtMap", codeMgmtMap);
	    }

	    return "services/codeMgmt/addEditCodePop";
	  }

	  @RequestMapping(value = "/saveNewCode.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> saveNewCode(@RequestBody Map<String, Object> params,
	      SessionVO sessionVO) throws ParseException {

	    ReturnMessage message = new ReturnMessage();

	    logger.debug("==========================/saveNewCode.do=================================");
	    logger.debug("params : {}", params);

	    message = codeMgmtService.saveNewCode(params, sessionVO);

	    logger.debug("==========================/saveNewCode.do=================================");

	    return ResponseEntity.ok(message);
	  }

	  @RequestMapping(value = "/chkProductAvail.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> chkProductAvail(@RequestParam Map<String, Object> params, ModelMap model) {
	    logger.debug("checkDefPart.do : {}", params);

		List<EgovMap> productAvail = codeMgmtService.chkProductAvail(params);

	    logger.debug("==linkList1111 " + productAvail.toString());

	    return ResponseEntity.ok(productAvail);
	  }


	  @RequestMapping(value = "/chkDupReasons.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> chkDupReasons(@RequestParam Map<String, Object> params, ModelMap model) {
	    logger.debug("checkDefPart.do : {}", params);

		List<EgovMap> dupReasons = codeMgmtService.chkDupReasons(params);

	    logger.debug("==linkList1111 " + dupReasons.toString());

	    return ResponseEntity.ok(dupReasons);
	  }

	  @RequestMapping(value = "/chkDupDefectCode.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> chkDupDefectCode(@RequestParam Map<String, Object> params, ModelMap model) {
	    logger.debug("checkDefPart.do : {}", params);

		List<EgovMap> dupDefectCode = codeMgmtService.chkDupDefectCode(params);

	    logger.debug("==linkList1111 " + dupDefectCode.toString());

	    return ResponseEntity.ok(dupDefectCode);
	  }

	  @RequestMapping(value = "/updateCodeStus.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> updateCodeStus(@RequestBody Map<String, Object> params, Model model,
	      HttpServletRequest request, SessionVO sessionVO) {
	    logger.debug("===========================/updateCodeStus.do===============================");
	    logger.debug("==params111 " + params.toString());
	    logger.debug("===========================/updateCodeStus.do===============================");

	    params.put("updator", sessionVO.getUserId());
	    ReturnMessage message = new ReturnMessage();

	    String active = "1";
	    String deact = "8";
	    String sys0013Act = "0";
	    String stus = "";
	    String actMsg = "";

	    if(params.get("codeCatId").toString().equals("7319") || params.get("codeCatId").toString().equals("7320")){ //SYS0013M
	    	stus = params.get("stusId").toString().equals("1") ? sys0013Act : active;
	    	actMsg = stus.equals("0") ?  " activated" : " deactivated";
	    }else{
	    	stus = params.get("stusId").toString().equals("1") ? deact : active;
	    	actMsg = stus.equals("1") ? " activated" : " deactivated";
	    }
	    params.put("updStus", stus);

	    codeMgmtService.updateCodeStus(params);

	    logger.debug("==params222 " + params.toString());
	    logger.debug("================updateCodeStus - END ================");

	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage("the code is now " + actMsg);

	    return ResponseEntity.ok(message);
	  }

}
